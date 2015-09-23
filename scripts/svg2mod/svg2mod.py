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

    pretty = args.format == 'pretty'

    svg2mod = Svg2Mod(
        args.input_file_name,
        args.module_name,
        args.module_value
    )

    if args.output_file_name is None:

        args.output_file_name = os.path.splitext(
            os.path.basename( args.input_file_name )
        )[ 0 ]

        if pretty:
            args.output_file_name += ".kicad_mod"
        else:
            args.output_file_name += ".mod"

    svg2mod.write(
        args.output_file_name,
        args.scale_factor,
        args.precision,
        include_reverse = not args.front_only,
        pretty = pretty
    )


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
    def _collapse_points( self, points, pretty, scale_factor, flip ):

        new_points = []
        for point in points:

            point = self._transform_point( point, scale_factor, flip )

            if not pretty:
                point.x = int( round( point.x ) )
                point.y = int( round( point.y ) )

            if (
                len( new_points ) < 1 or
                point.x != new_points[ -1 ].x or
                point.y != new_points[ -1 ].y
            ):
                new_points.append( point )

        return new_points


    #------------------------------------------------------------------------

    def _transform_point( self, point, scale_factor, flip ):

        transformed_point = svg.Point(
            #point.x * scale_factor,
            #point.y * scale_factor,
            ( point.x + self.translation.x ) * scale_factor,
            ( point.y + self.translation.y ) * scale_factor,
        )

        if flip:
            transformed_point.x *= -1

        return transformed_point


    #------------------------------------------------------------------------

    def _write_items(
        self,
        f,
        pretty,
        items,
        scale_factor,
        precision,
        flip,
        layer,
    ):
        for item in items:

            if isinstance( item, svg.Group ):
                self._write_items(
                    f, pretty, item.items, scale_factor, precision, flip, layer
                )
                continue

            elif isinstance( item, svg.Path ):

                segments = item.segments( precision = precision )

                fill, stroke = self._get_fill_stroke( item )

                if fill:
                    self._write_polygon_filled(
                        f, pretty, segments, scale_factor, flip, layer
                    )

                if stroke:
                    self._write_polygon_outline(
                        f, pretty, segments, scale_factor, flip, layer
                    )

            else:
                print( "Unsupported SVG element: {}".format(
                    item.__class__.__name__
                ) )


    #------------------------------------------------------------------------

    def _write_module(
        self,
        f,
        pretty,
        scale_factor,
        precision,
        include_reverse,
        front,
    ):
        if front:
            module_name = self.module_name
            if include_reverse:
                module_name += "-Front"
            side = "F"
        else:
            module_name = "{}{}".format( self.module_name, "-Back" )
            side = "B"

        min_point, max_point = self.svg.bbox()
        min_point = self._transform_point( min_point, scale_factor, flip = False )
        max_point = self._transform_point( max_point, scale_factor, flip = False )
        reference_y = min_point.y - 1200
        value_y = max_point.y + 1400

        if pretty:
            if not front: f.write( "\n" )
            f.write( """(module {0} (layer F.Cu) (tedit {1:8X})
  (descr "{2}")
  (tags {3})
  (fp_text reference {4} (at 0 {5}) (layer {6}.SilkS) hide
    (effects (font (size 2.032 2.032) (thickness 0.3048)))
  )
  (fp_text value {7} (at 0 {8}) (layer {6}.SilkS) hide
    (effects (font (size 2.032 2.032) (thickness 0.3048)))
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
    self.module_value, #7
    value_y, #8
)
            )

        else:

            f.write( """$MODULE {0}
Po 0 0 0 {4} 00000000 00000000 ~~
Li {0}
T0 0 {1} 600 600 0 120 N I 21 "{0}"
T1 0 {3} 600 600 0 120 N I 21 "{2}"
""".format(
    module_name,
    int( round( reference_y ) ),
    self.module_value,
    int( round( value_y ) ),
    15, # Seems necessary
)
            )

        for name, group in self.layers.iteritems():

            if group is None: continue

            if pretty:

                if front: layer = "F."
                else: layer = "B."
                layer += self.layer_map[ name ][ 2 ]

            else:
                layer = self.layer_map[ name ][ 0 ]
                if not front:
                    layer = self.layer_map[ name ][ 1 ]

            #print( "  Writing layer: {}".format( name ) )
            self._write_items(
                f, pretty, group.items, scale_factor, precision, not front, layer
            )

        if pretty:
            f.write( "\n)" )
        else:
            f.write( "$EndMODULE {0}\n".format( module_name ) )


    #------------------------------------------------------------------------

    def _write_polygon_filled(
        self,
        f,
        pretty,
        segments,
        scale_factor,
        flip,
        layer,
    ):

        print( "    Writing filled polygon with {} segments".format( len( segments ) ) )

        if len( segments ) > 2:
            print(
                "Warning: " +
                "Not sure if Pcbnew supports more than 2 segments per path."
            )

        collapsed_segments = []

        total_points = 0
        for points in segments:

            points = self._collapse_points( points, pretty, scale_factor, flip )
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

        if pretty:
            f.write( "\n  (fp_poly (pts \n" )
        else:
            f.write( "DP 0 0 0 0 {} 1 {}\n".format(
                total_points, layer
            ) )

        for points in collapsed_segments:

            #print( "      Writing segment with {} points".format( len( points ) ) )

            if (
                points[ 0 ].x != points[ -1 ].x or
                points[ 0 ].y != points[ -1 ].y
            ):
                print( "Warning: Polygon is not closed. start={} end={}".format(
                    points[ 0 ], points[ -1 ]
                ) )

            #f.write( "Segment begin\n" )

            for point in points:

                #print( "        {}, {}".format( point.x, point.y ) )

                if pretty:
                    point_str = "    (xy {} {})\n"

                else:
                    point_str = "Dl {:d} {:d}\n"

                f.write( point_str.format( point.x, point.y ) )

            #f.write( "Segment end\n" )

        if len( collapsed_segments ) > 1:

            if pretty:
                f.write( "    (xy {} {})\n".format(
                    collapsed_segments[ 0 ][ 0 ].x,
                    collapsed_segments[ 0 ][ 0 ].y,
                ) )

            else:
                f.write( "Dl {} {}\n".format(
                    int( round( collapsed_segments[ 0 ][ 0 ].x ) ),
                    int( round( collapsed_segments[ 0 ][ 0 ].y ) ),
                ) )

        if pretty:
            f.write( "  ) )" )


    #------------------------------------------------------------------------

    def _write_polygon_outline(
        self,
        f,
        pretty,
        segments,
        scale_factor,
        flip,
        layer,
    ):
        for points in segments:

            #f.write( "Outline begin\n" )

            points = self._collapse_points( points, pretty, scale_factor, flip )

            prior_point = None
            for point in points:

                if prior_point is not None:

                    if pretty:
#(fp_line (start 3.74904 8.7503) (end -3.74904 8.7503) (layer F.SilkS) (width 0.381))
                        f.write(
                            "\n  (fp_line (start {} {}) (end {} {}) (layer {}) (width {}))".format(
                                prior_point.x, prior_point.y,
                                point.x, point.y,
                                layer,
                                0.381,
                            )
                        )

                    else:
                        f.write( "DS {} {} {} {} 1 {}\n".format(
                            int( round( prior_point.x ) ),
                            int( round( prior_point.y ) ),
                            int( round( point.x ) ),
                            int( round( point.y ) ),
                            layer
                        ) )

                prior_point = point

            #f.write( "Outline end\n" )


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
        pretty = True
    ):
        # Inkscape uses 90 DPI, PCBNew uses "decimil" (10K DPI):
        if pretty:
            scale_factor *= 25.4 / 90.0
        else:
            scale_factor *= 10000.0 / 90.0

        print( "Wriing module file: {}".format( output_file_name ) )
        f = open( output_file_name, 'w' )

        if not pretty:

            if include_reverse:
                modules_list = "{0}-Front\n{0}-Back".format( self.module_name )
            else:
                modules_list = "{0}".format( self.module_name )

            f.write( """PCBNEW-LibModule-V1  {0}
$INDEX
{1}
$EndINDEX
#
# {2}
#
""".format(
    datetime.datetime.now().strftime( "%a %d %b %Y %I:%M:%S %p %Z" ),
    modules_list,
    self.input_file_name,
)
            )

        print( "Writing front module..." )
        self._write_module(
            f, pretty, scale_factor, precision, include_reverse, front = True
        )

        if include_reverse:
            print( "Writing back module..." )
            self._write_module(
                f, pretty, scale_factor, precision, include_reverse, front = False
            )

        if not pretty:
            f.write( "$EndLIBRARY" )

        f.close()


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
        dest = 'format',
        choices = [ 'legacy', 'pretty' ],
        help = "output module file format",
        default = 'pretty',
    )


    #------------------------------------------------------------------------

    return parser.parse_args(), parser


#----------------------------------------------------------------------------

main()


