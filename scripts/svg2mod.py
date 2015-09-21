#!/usr/bin/python

import argparse
import datetime
from pprint import pformat, pprint
import re
import xml.etree.ElementTree as ET


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

    svg2mod(
        input_file_name = args.input_file_name,
        output_file_name = args.output_file_name,
        module_name = args.module_name,
        module_value = args.module_value,
        factor = args.scale_factor,
    )


#----------------------------------------------------------------------------

def center_paths( layers ):

    min_x = None
    min_y = None
    max_x = None
    max_y = None

    for layer in layers.itervalues():
        for path in layer:
            for point in path:
                if min_x is None or point[ 0 ] < min_x:
                    min_x = point[ 0 ]
                if min_y is None or point[ 1 ] < min_y:
                    min_y = point[ 1 ]
                if max_x is None or point[ 0 ] > max_x:
                    max_x = point[ 0 ]
                if max_y is None or point[ 1 ] > max_y:
                    max_y = point[ 1 ]

    adjust_x = min_x + ( max_x - min_x ) / 2.0
    adjust_y = min_y + ( max_y - min_y ) / 2.0

    #print( "Min X: {}, Max X: {}, Adjust X: {}".format( min_x, max_x, adjust_x ) )
    #print( "Min Y: {}, Max Y: {}, Adjust Y: {}".format( min_y, max_y, adjust_y ) )

    for layer in layers.itervalues():
        for path in layer:
            for point in path:
                #print( "Translating point ({}, {}) to ({}, {})".format(
                    #point[ 0 ], point[ 1 ],
                    #point[ 0 ] - adjust_x,
                    #point[ 1 ] - adjust_y,
                #) )
                point[ 0 ] -= adjust_x
                point[ 1 ] -= adjust_y
                #print( "Translated point ({}, {})".format(
                    #point[ 0 ], point[ 1 ],
                #) )


#----------------------------------------------------------------------------

def flip_path( path ):

    for point in path:
        point[ 0 ] = 0.0 - point[ 0 ]


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
        type = int,
        dest = 'scale_factor',
        metavar = 'scale-factor',
        help = "scale paths by this factor",
        default = 1,
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

def get_pair( s ):

    m = re.match( r'([-\de.]+),([-\de.]+)', s )
    if m is not None:
        return [
            float( m.group( 1 ) ),
            float( m.group( 2 ) ),
        ]


#----------------------------------------------------------------------------

def get_translate( node ):

    for id, value in node.attrib.iteritems():
        id = parse_name( id )
        if id[ "name" ] == "transform":
            m = re.match( r'.*translate\(([^)]*)\).*', value )
            if m is not None:
                return get_pair( m.group( 1 ) )


#----------------------------------------------------------------------------

def get_y_domain( layers ):

    min_y = None
    max_y = None

    for layer in layers.itervalues():
        for path in layer:
            for point in path:
                if min_y is None or point[ 1 ] < min_y:
                    min_y = point[ 1 ]
                if max_y is None or point[ 1 ] > max_y:
                    max_y = point[ 1 ]

    return min_y, max_y


#----------------------------------------------------------------------------

# Returns namespace (or None) and tag/attribute name:
def parse_name( tag ):
    m = re.match( r'({(.+)})?(.+)', tag )
    return {
        'namespace' : m.group( 2 ),
        'name' : m.group( 3 ),
    }


#----------------------------------------------------------------------------

def read_group( node, translate = None ):

    if translate is None:
        translate = [ 0.0, 0.0 ]
    else:
        translate = translate[ : ]

    new_translate = get_translate( node )
    if new_translate is not None:
        translate[ 0 ] += new_translate[ 0 ]
        translate[ 1 ] += new_translate[ 1 ]

    paths = []
    for child in node:
        if parse_name( child.tag )[ 'name' ] == "g":
            paths += read_group( child, translate )
        elif parse_name( child.tag )[ 'name' ] == "path":
            paths.append( read_path( child, translate ) )
    return paths


#----------------------------------------------------------------------------

def read_path( node, translate ):

    path = []

    translate = translate[ : ]

    new_translate = get_translate( node )
    if new_translate is not None:
        translate[ 0 ] += new_translate[ 0 ]
        translate[ 1 ] += new_translate[ 1 ]

    for id, value in node.attrib.iteritems():
        id = parse_name( id )
        if id[ "name" ] != "d": continue

        current_point = translate[ : ]
        i = 0
        instructions = value.split( " " )
        polygon = []
        relative = True
        while i < len( instructions ):

            instruction = instructions[ i ].strip()
            i += 1
            if instruction == "": continue

            if instruction == "m" or instruction == "M":
                relative = instruction == "m"
                path += polygon
                polygon = []

            elif instruction == "l" or instruction == "L":
                relative = instruction == "l"

            elif instruction == "z" or instruction == "Z":
                polygon.append( polygon[ 0 ][:] )

            else:
                next_point = get_pair( instruction )
                if next_point is None:
                    next_point = [
                        float( instruction ),
                        float( instructions[ i ] ),
                    ]
                    i += 1

                if relative:
                    next_point[ 0 ] += current_point[ 0 ]
                    next_point[ 1 ] += current_point[ 1 ]
                else:
                    next_point[ 0 ] += translate[ 0 ]
                    next_point[ 1 ] += translate[ 1 ]
                current_point = next_point
                polygon.append( current_point )
                #print( "Next point: {}, {}".format( current_point[ 0 ], current_point[ 1 ] ) )
        path += polygon

    return path


#----------------------------------------------------------------------------

def scale_path( path, factor ):

    for point in path:
        point[ 0 ] *= factor
        point[ 1 ] *= factor


#----------------------------------------------------------------------------

def svg2mod(
    input_file_name,
    output_file_name,
    module_name,
    module_value,
    factor,
):
    # Inkscape uses 90 DPI.  PCBNew uses "decimil" (10K DPI)
    factor *= 10000.0 / 90.0

    layers = {
        'copper' : [],
        'mask' : [],
    }

    # Parse the SVG XML, first looking for layers of interest:
    tree = ET.parse( input_file_name )
    for child in tree.getroot():

        if parse_name( child.tag )[ 'name' ] == "g":

            for id, value in child.attrib.iteritems():

                id = parse_name( id )
                if id[ "name" ] == "label":

                    if re.search( r'copper', value, re.I ):
                        print( "Reading copper layer: {}".format( value ) )
                        layers[ 'copper' ] += read_group( child )

                    if re.search( r'mask', value, re.I ):
                        print( "Reading mask layer: {}".format( value ) )
                        layers[ 'mask' ] += read_group( child )

    # Output a summary of paths found:
    print( "Copper has {} path(s):".format( len( layers[ "copper" ] ) ) )
    for path in layers[ "copper" ]:
        print( "    Path has {} vertices.".format( len( path ) ) )
    print( "Mask has {} path(s):".format( len( layers[ "mask" ] ) ) )
    for path in layers[ "mask" ]:
        print( "    Path has {} vertices.".format( len( path ) ) )

    # Center and scale paths:
    center_paths( layers )
    for path in layers[ "copper" ]:
        scale_path( path, factor )
    for path in layers[ "mask" ]:
        scale_path( path, factor )

    # Write the module file:
    f = open( output_file_name, 'w' )
    f.write( """PCBNEW-LibModule-V1  {0}
$INDEX
{1}-F.Cu
{1}-B.Cu
$EndINDEX
#
# {2}
#
""".format(
    datetime.datetime.now().strftime( "%a %d %b %Y %I:%M:%S %p %Z" ),
    module_name,
    input_file_name,
)
    )

    write_module(
        f, module_name, module_value, layers,
        front = True
    )

    write_module(
        f, module_name, module_value, layers,
        front = False
    )

    f.write( "$EndLIBRARY" )
    f.close()


#----------------------------------------------------------------------------

def write_module(
    f,
    module_name,
    module_value,
    layers,
    front = True
):
    min_y, max_y = get_y_domain( layers )

    if front:
        copper_layer_id = 15
        mask_layer_id = 23
        module_name += "-F.Cu"
    else:
        copper_layer_id = 0
        mask_layer_id = 22
        module_name += "-B.Cu"

    f.write( """$MODULE {0}
Po 0 0 0 {4} 00000000 00000000 ~~
Li {0}
T0 0 {1} 600 600 0 120 N I 21 "{0}"
T1 0 {3} 600 600 0 120 N I 21 "{2}"
""".format(
    module_name,
    min_y - 1200,
    module_value,
    max_y + 1400,
    #copper_layer_id,
    15,
)
    )

    for path in layers[ "copper" ]:
        if not front:
            path = path[ : ]
            flip_path( path )
        write_path( f, path, copper_layer_id )
    for path in layers[ "mask" ]:
        if not front:
            path = path[ : ]
            flip_path( path )
        write_path( f, path, mask_layer_id )

    f.write( "$EndMODULE {0}\n".format( module_name ) )


#----------------------------------------------------------------------------

def write_path( f, path, layer ):

    f.write( "DP 0 0 0 0 {} 1 {}\n".format( len( path ), layer ) )
    for point in path:
        f.write( "Dl {} {}\n".format(
            float( point[ 0 ] ),
            float( point[ 1 ] )
        ) )


#----------------------------------------------------------------------------

main()


