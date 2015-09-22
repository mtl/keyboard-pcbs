#!/usr/bin/python

from __future__ import absolute_import

#if __name__ == "__main__" and __package__ is None:
    #__package__ = "svg2mod"

import svg

import argparse
import datetime
import itertools
from pprint import pformat, pprint
import re
import sys
import xml.etree.ElementTree as ET

# To-do:
# Command-line arguments
# silkscreen, edge cuts, other layers?
# support lines, arcs, and circles

#----------------------------------------------------------------------------

#----------------------------------------------------------------------------

def main():

    # Need at least input and output file names:
    args, parser = get_arguments()
    if (
        args.input_file_name is None or
        args.output_file_name is None
    ):
        parser.print_help()
        sys.exit( 0 )

    svg2mod = Svg2Mod(
        args.input_file_name,
        args.module_name,
        args.module_value
    )

    svg2mod.write(
        args.output_file_name,
        # Inkscape uses 90 DPI, PCBNew uses "decimil" (10K DPI):
        args.scale_factor * 10000.0 / 90.0,
        include_reverse = not args.front_only
    )


#----------------------------------------------------------------------------

class Svg2Mod( object ):

    layer_map = {
        #'name' : [ front, back ],
        'copper' : [ 15, 0 ],
        'solder mask' : [ 23, 22 ],
        'silkscreen' : [ 21, 20 ],
        'glue' : [ 17, 16 ],
        'edge cuts' : [ 28, 28 ],
        'comments' : [ 25, 25 ],
    }


    #------------------------------------------------------------------------

    def __init__( self, input_file_name, module_name, module_value ):

        self.input_file_name = input_file_name
        self.module_name = module_name
        self.module_value = module_value

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

    def _write_items( self, f, items, scale_factor, precision, flip, layer ):

        for item in items:

            if isinstance( item, svg.Group ):
                self._write_items( f, item.items, scale_factor, precision, flip, layer )
                continue

            elif isinstance( item, svg.Path ):

                segments = item.segments( precision = precision )

                print( "    Writing path with {} segments".format( len( segments ) ) )

                if len( segments ) > 2:
                    print(
                        "Warning: " +
                        "Not sure if Pcbnew supports more than 2 segments per path."
                    )

                total_points = 0
                for points in segments:
                    num_points = len( points )
                    if num_points < 3:
                        print(
                            "Warning: " +
                            "Segment has only {} points (not a polygon?)".format( num_points )
                        )
                    total_points += num_points

                f.write( "DP 0 0 0 0 {} 1 {}\n".format(
                    total_points, layer
                ) )

                for points in segments:
                    self._write_segment( f, points, scale_factor, flip, layer )

            else:
                print( "Unsupported SVG element: {}".format(
                    item.__class__.__name__
                ) )


    #------------------------------------------------------------------------

    def _write_module( self, f, scale_factor, precision, front = True ):

        min_point, max_point = self.svg.bbox()

        if front:
            module_name = "{}{}".format( self.module_name, "-Front" )
        else:
            module_name = "{}{}".format( self.module_name, "-Back" )

        f.write( """$MODULE {0}
Po 0 0 0 {4} 00000000 00000000 ~~
Li {0}
T0 0 {1} 600 600 0 120 N I 21 "{0}"
T1 0 {3} 600 600 0 120 N I 21 "{2}"
""".format(
    module_name,
    ( min_point.y + self.translation.y ) * scale_factor - 1200,
    self.module_value,
    ( max_point.y + self.translation.y ) * scale_factor + 1400,
    15, # Seems necessary
)
        )

        for name, group in self.layers.iteritems():

            if group is None: continue

            layer = self.layer_map[ name ][ 0 ]
            if not front:
                layer = self.layer_map[ name ][ 1 ]

            print( "  Writing layer: {}".format( name ) )
            self._write_items( f, group.items, scale_factor, precision, not front, layer )

        f.write( "$EndMODULE {0}\n".format( module_name ) )


    #------------------------------------------------------------------------

    def _write_segment( self, f, points, scale_factor, flip, layer ):

        print( "      Writing segment with {} points".format( len( points ) ) )

        for point in points:

            #print( "        {}, {}".format( point.x, point.y ) )

            x = ( point.x + self.translation.x ) * scale_factor
            y = ( point.y + self.translation.y ) * scale_factor

            if flip: x *= -1

            f.write( "Dl {} {}\n".format(
                int( x ), int( y )
            ) )


    #------------------------------------------------------------------------

    def center( self ):

        min_point, max_point = self.svg.bbox()

        adjust_x = min_point.x + ( max_point.x - min_point.x ) / 2.0
        adjust_y = min_point.y + ( max_point.y - min_point.y ) / 2.0

        self.svg.translate(
            svg.Point(
                0.0 - adjust_x,
                0.0 - adjust_y,
            )
        )


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
        include_reverse = True
    ):
        f = open( output_file_name, 'w' )
        f.write( """PCBNEW-LibModule-V1  {0}
$INDEX
{1}-Front
{1}-Back
$EndINDEX
#
# {2}
#
""".format(
    datetime.datetime.now().strftime( "%a %d %b %Y %I:%M:%S %p %Z" ),
    self.module_name,
    self.input_file_name,
)
        )

        print( "Writing front module..." )
        self._write_module( f, scale_factor, precision, front = True )

        if include_reverse:
            print( "Writing back module..." )
            self._write_module( f, scale_factor, precision, front = False )

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


    #------------------------------------------------------------------------

    return parser.parse_args(), parser


#----------------------------------------------------------------------------

main()


