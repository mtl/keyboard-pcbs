#!/usr/bin/python

from __future__ import absolute_import

#if __name__ == "__main__" and __package__ is None:
    #__package__ = "svg2mod"

import svg

import argparse
import datetime
import os
from pprint import pformat, pprint
import re
import sys

# To-do:
# use new kicad pretty module format, add support for line thicknesses
# auto horizontal asymmetry detection
# support lines, arcs, rects, circles, etc.
# Mark center with a circle or a group or something...
#    ...And adjust text labels accordingly

#----------------------------------------------------------------------------

#----------------------------------------------------------------------------

def main():

    args, parser = get_arguments()

    if args.input_file_name is None:
        parser.print_help()
        sys.exit( 0 )

    if args.format == 'pretty' and args.units == 'decimil':
        print( "Error: decimil units only allowed with legacy output type" )
        sys.exit( -1 )

    svg2mod = Svg2Mod(
        args.input_file_name,
        args.module_name,
        args.module_value
    )

    pretty = args.format == 'pretty'

    if args.output_file_name is None:

        args.output_file_name = os.path.splitext(
            os.path.basename( args.input_file_name )
        )[ 0 ]

        if pretty:
            args.output_file_name += ".kicad_mod"
        else:
            args.output_file_name += ".mod"

    use_mm = args.units == 'mm'

    svg2mod.write(
        args.output_file_name,
        args.scale_factor,
        args.precision,
        include_reverse = not args.front_only,
        pretty = pretty,
        use_mm = use_mm,
    )


#----------------------------------------------------------------------------

class Svg2ModWriteConfig( object ):

    def __init__(
        self,
        output_file,
        output_file_name,
        scale_factor,
        precision,
        include_reverse,
        pretty,
        use_mm,
    ):
        if use_mm:
            # 25.4 mm/in; Inkscape uses 90 DPI:
            scale_factor *= 25.4 / 90.0
        else:
            # PCBNew uses "decimil" (10K DPI); Inkscape uses 90 DPI:
            scale_factor *= 10000.0 / 90.0

        self.output_file = output_file
        self.output_file_name = output_file_name
        self.scale_factor = scale_factor
        self.precision = precision
        self.include_reverse = include_reverse
        self.pretty = pretty
        self.use_mm = use_mm


#----------------------------------------------------------------------------

class Svg2Mod( object ):

    layer_map = {
        #'name' : [ front, back, pretty-name ],
        'copper' : [ 15, 0, "Cu" ],
        'solder mask' : [ 23, 22, "Mask" ],
        'silkscreen' : [ 21, 20, "SilkS" ],
        'glue' : [ 17, 16, "Adhes" ], # or Paste?
        'edge cuts' : [ 28, 28, "??" ],
        'comments' : [ 25, 25, "??" ],
    }

    # pcbnew/pcb_parser.cpp (pretty format):
    #m_layerMasks[ "*.Cu" ]      = LSET::AllCuMask();
    #m_layerMasks[ "F&B.Cu" ]    = LSET( 2, F_Cu, B_Cu );
    #m_layerMasks[ "*.Adhes" ]   = LSET( 2, B_Adhes, F_Adhes );
    #m_layerMasks[ "*.Paste" ]   = LSET( 2, B_Paste, F_Paste );
    #m_layerMasks[ "*.Mask" ]    = LSET( 2, B_Mask,  F_Mask );
    #m_layerMasks[ "*.SilkS" ]   = LSET( 2, B_SilkS, F_SilkS );
    #m_layerMasks[ "*.Fab" ]     = LSET( 2, B_Fab,   F_Fab );
    #m_layerMasks[ "*.CrtYd" ]   = LSET( 2, B_CrtYd, F_CrtYd );


    #------------------------------------------------------------------------

    @staticmethod
    def _convert_decimil_to_mm( decimil ):
        return decimil * 0.00254


    #------------------------------------------------------------------------

    @staticmethod
    def _convert_mm_to_decimil( mm ):
        return int( round( mm * 393.700787 ) )


    #------------------------------------------------------------------------

    @staticmethod
    def _get_fill_stroke( item ):

        fill = True
        stroke = True

        for property in item.style.split( ";" ):

            nv = property.split( ":" );
            name = nv[ 0 ].strip()
            value = nv[ 1 ].strip()

            if name == "fill" and value == "none":
                fill = False

            elif name == "stroke" and value == "none":
                stroke = False

        return fill, stroke


    #------------------------------------------------------------------------

    def __init__( self, input_file_name, module_name, module_value, pretty = True ):

        self.input_file_name = input_file_name
        self.module_name = module_name
        self.module_value = module_value
        self.pretty = pretty

        self.layers = {}
        for name in self.layer_map.iterkeys():
            self.layers[ name ] = None

        print( "Parsing SVG..." )
        self.svg = svg.parse( input_file_name )

        #print( svg2mod.svg.json() )
        #print( "Pruning..." )
        self.prune()
        #print( svg2mod.svg.json() )

        # Must come after pruning:
        translation = self._calculate_translation()


    #------------------------------------------------------------------------

    def _calculate_translation( self ):

        min_point, max_point = self.svg.bbox()

        adjust_x = min_point.x + ( max_point.x - min_point.x ) / 2.0
        adjust_y = min_point.y + ( max_point.y - min_point.y ) / 2.0

        self.translation = svg.Point(
            0.0 - adjust_x,
            0.0 - adjust_y,
        )


    #------------------------------------------------------------------------

    # Apply all transformations and rounding, then remove duplicate
    # consecutive points along the path.
    def _collapse_points( self, config, points, flip ):

        new_points = []
        for point in points:

            point = self._transform_point( config, point, flip )

            if (
                len( new_points ) < 1 or
                point.x != new_points[ -1 ].x or
                point.y != new_points[ -1 ].y
            ):
                new_points.append( point )

        return new_points


    #------------------------------------------------------------------------

    def _transform_point( self, config, point, flip ):

        transformed_point = svg.Point(
            ( point.x + self.translation.x ) * config.scale_factor,
            ( point.y + self.translation.y ) * config.scale_factor,
        )

        if flip:
            transformed_point.x *= -1

        if not config.use_mm:
            transformed_point.x = int( round( transformed_point.x ) )
            transformed_point.y = int( round( transformed_point.y ) )

        return transformed_point


    #------------------------------------------------------------------------

    def _write_items( self, config, items, flip, layer ):

        for item in items:

            if isinstance( item, svg.Group ):
                self._write_items( config, item.items, flip, layer )
                continue

            elif isinstance( item, svg.Path ):

                segments = item.segments( precision = config.precision )

                fill, stroke = self._get_fill_stroke( item )

                if fill:
                    self._write_polygon_filled(
                        config, segments, flip, layer
                    )

                if stroke:
                    self._write_polygon_outline(
                        config, segments, scale_factor, flip, layer
                    )

            else:
                print( "Unsupported SVG element: {}".format(
                    item.__class__.__name__
                ) )


    #------------------------------------------------------------------------

    def _write_module( self, config, front ):

        if front:
            module_name = self.module_name
            if config.include_reverse:
                module_name += "-Front"
            side = "F"
        else:
            module_name = "{}{}".format( self.module_name, "-Back" )
            side = "B"

        min_point, max_point = self.svg.bbox()
        min_point = self._transform_point( config, min_point, flip = False )
        max_point = self._transform_point( config, max_point, flip = False )

        label_offset = 1200
        label_size = 600
        label_pen = 120

        if config.use_mm:
            label_size = self._convert_decimil_to_mm( label_size )
            label_pen = self._convert_decimil_to_mm( label_pen )
            reference_y = min_point.y - self._convert_decimil_to_mm( label_offset )
            value_y = max_point.y + self._convert_decimil_to_mm( label_offset )
        else:
            reference_y = min_point.y - label_offset
            value_y = max_point.y + label_offset

        if config.pretty:
            if not front: config.output_file.write( "\n" )
            config.output_file.write( """(module {0} (layer F.Cu) (tedit {1:8X})
  (descr "{2}")
  (tags {3})
  (fp_text reference {4} (at 0 {5}) (layer {6}.SilkS) hide
    (effects (font (size {7} {7}) (thickness {8})))
  )
  (fp_text value {9} (at 0 {10}) (layer {6}.SilkS) hide
    (effects (font (size {7} {7}) (thickness {8})))
  )""".format(
    module_name, #0
    int( round( os.path.getctime( #1
        self.input_file_name
    ) ) ),
    "Imported from {}".format( self.input_file_name ), #2
    "svg2mod", #3
    module_name, #4
    reference_y, #5
    side, #6
    label_size, #7
    label_pen, #8
    self.module_value, #9
    value_y, #10
)
            )

        else:

            config.output_file.write( """$MODULE {0}
Po 0 0 0 {6} 00000000 00000000 ~~
Li {0}
T0 0 {1} {2} {2} 0 {3} N I 21 "{0}"
T1 0 {5} {2} {2} 0 {3} N I 21 "{4}"
""".format(
    module_name,
    reference_y,
    label_size,
    label_pen,
    self.module_value,
    value_y,
    15, # Seems necessary
)
            )

        for name, group in self.layers.iteritems():

            if group is None: continue

            if config.pretty:

                if front: layer = "F."
                else: layer = "B."
                layer += self.layer_map[ name ][ 2 ]

            else:
                layer = self.layer_map[ name ][ 0 ]
                if not front:
                    layer = self.layer_map[ name ][ 1 ]

            #print( "  Writing layer: {}".format( name ) )
            self._write_items( config, group.items, not front, layer )

        if config.pretty:
            config.output_file.write( "\n)" )
        else:
            config.output_file.write( "$EndMODULE {0}\n".format( module_name ) )


    #------------------------------------------------------------------------

    def _write_polygon_filled( self, config, segments, flip, layer ):

        print( "    Writing filled polygon with {} segments".format( len( segments ) ) )

        if len( segments ) > 2:
            print(
                "Warning: " +
                "Not sure if Pcbnew supports more than 2 segments per path."
            )

        collapsed_segments = []

        total_points = 0
        for points in segments:

            points = self._collapse_points( config, points, flip )
            collapsed_segments.append( points )

            num_points = len( points )
            if num_points < 3:
                print(
                    "Warning: " +
                    "Segment has only {} points (not a polygon?)".format( num_points )
                )
            total_points += num_points

        if len( collapsed_segments ) > 1:
            total_points += 1

        if config.pretty:
            config.output_file.write( "\n  (fp_poly (pts \n" )
            point_str = "    (xy {} {})\n"

        else:
            pen = 1
            if config.use_mm:
                pen = self._convert_decimil_to_mm( pen )

            config.output_file.write( "DP 0 0 0 0 {} {} {}\n".format(
                total_points,
                pen,
                layer
            ) )
            point_str = "Dl {} {}\n"

        for points in collapsed_segments:

            #print( "      Writing segment with {} points".format( len( points ) ) )

            if (
                points[ 0 ].x != points[ -1 ].x or
                points[ 0 ].y != points[ -1 ].y
            ):
                print( "Warning: Polygon is not closed. start={} end={}".format(
                    points[ 0 ], points[ -1 ]
                ) )

            #config.output_file.write( "Segment begin\n" )

            for point in points:

                #print( "        {}, {}".format( point.x, point.y ) )

                config.output_file.write( point_str.format( point.x, point.y ) )

            #config.output_file.write( "Segment end\n" )

        if len( collapsed_segments ) > 1:

            config.output_file.write( point_str.format(
                collapsed_segments[ 0 ][ 0 ].x,
                collapsed_segments[ 0 ][ 0 ].y,
            ) )

        if config.pretty:
            config.output_file.write( "  ) )" )


    #------------------------------------------------------------------------

    def _write_polygon_outline( self, config, segments, flip, layer ):

        for points in segments:

            #config.output_file.write( "Outline begin\n" )

            points = self._collapse_points( config, points, flip )

            prior_point = None
            for point in points:

                if prior_point is not None:

                    if config.pretty:
#(fp_line (start 3.74904 8.7503) (end -3.74904 8.7503) (layer F.SilkS) (width 0.381))
                        config.output_file.write(
                            "\n  (fp_line (start {} {}) (end {} {}) (layer {}) (width {}))".format(
                                prior_point.x, prior_point.y,
                                point.x, point.y,
                                layer,
                                0.381,
                            )
                        )

                    else:
                        config.output_file.write( "DS {} {} {} {} 0.00254 {}\n".format(
                            prior_point.x,
                            prior_point.y,
                            point.x,
                            point.y,
                            layer
                        ) )

                prior_point = point

            #config.output_file.write( "Outline end\n" )


    #------------------------------------------------------------------------

    # Find and keep only the layers of interest.
    def prune( self, items = None ):

        if items is None:
            items = self.svg.items
            self.svg.items = []

        for item in items:

            if not isinstance( item, svg.Group ):
                continue

            #print( "Found a group: {}".format( item.name ) )

            for name in self.layer_map.iterkeys():
                if re.search( name, item.name, re.I ):
                    print( "Found layer: {}".format( item.name ) )
                    self.svg.items.append( item )
                    self.layers[ name ] = item
                    break
            else:
                self.prune( item.items )


    #------------------------------------------------------------------------

    def scale( self, factor ):
        self.svg.transform( svg.Matrix( [ factor, 0, 0, factor, 0, 0, ] ) )
        #self.svg.scale( factor )
        pass


    #------------------------------------------------------------------------

    def write(
        self,
        output_file_name,
        scale_factor = 1.0,
        precision = 20,
        include_reverse = True,
        pretty = True,
        use_mm = True,
    ):
        print( "Writing module file: {}".format( output_file_name ) )
        output_file = open( output_file_name, 'w' )

        config = Svg2ModWriteConfig(
            output_file,
            output_file_name,
            scale_factor,
            precision,
            include_reverse,
            pretty,
            use_mm,
        )

        if not pretty:

            if include_reverse:
                modules_list = "{0}-Front\n{0}-Back".format( self.module_name )
            else:
                modules_list = "{0}".format( self.module_name )

            units = ""
            if use_mm: units = "\nUnits mm"

            output_file.write( """PCBNEW-LibModule-V1  {0}{1}
$INDEX
{2}
$EndINDEX
#
# {3}
#
""".format(
    datetime.datetime.now().strftime( "%a %d %b %Y %I:%M:%S %p %Z" ),
    units,
    modules_list,
    self.input_file_name,
)
            )

        print( "Writing front module..." )
        self._write_module( config, front = True )

        if include_reverse:
            print( "Writing back module..." )
            self._write_module( config, front = False )

        if not pretty:
            output_file.write( "$EndLIBRARY" )

        output_file.close()


    #------------------------------------------------------------------------

#----------------------------------------------------------------------------

def get_arguments():

    parser = argparse.ArgumentParser(
        description = 'svg2mod.'
    )

    #------------------------------------------------------------------------

    parser.add_argument(
        '-i', '--input-file',
        type = str,
        dest = 'input_file_name',
        metavar = 'input-file-name',
        help = "name of the SVG file",
    )

    parser.add_argument(
        '-o', '--output-file',
        type = str,
        dest = 'output_file_name',
        metavar = 'output-file-name',
        help = "name of the module file",
    )

    parser.add_argument(
        '-f', '--factor',
        type = float,
        dest = 'scale_factor',
        metavar = 'scale-factor',
        help = "scale paths by this factor",
        default = 1.0,
    )

    parser.add_argument(
        '-p', '--precision',
        type = int,
        dest = 'precision',
        metavar = 'precision',
        help = "smoothness for approximating curves with line segments (int)",
        default = 10,
    )

    parser.add_argument(
        '-n', '--name', '--module-name',
        type = str,
        dest = 'module_name',
        metavar = 'module-name',
        help = "base name of the module",
        default = "svg2mod",
    )

    parser.add_argument(
        '--value', '--module-value',
        type = str,
        dest = 'module_value',
        metavar = 'module-value',
        help = "value of the module",
        default = "G***",
    )

    parser.add_argument(
        '--front-only',
        dest = 'front_only',
        action = 'store_const',
        const = True,
        help = "omit output of back module",
        default = False,
    )

    parser.add_argument(
        '--format',
        type = str,
        dest = 'format',
        metavar = 'format',
        choices = [ 'legacy', 'pretty' ],
        help = "output module file format",
        default = 'pretty',
    )

    parser.add_argument(
        '--units',
        type = str,
        dest = 'units',
        metavar = 'units',
        choices = [ 'decimil', 'mm' ],
        help = "Output units (if format is legacy)",
        default = 'mm',
    )


    #------------------------------------------------------------------------

    return parser.parse_args(), parser


#----------------------------------------------------------------------------

main()


