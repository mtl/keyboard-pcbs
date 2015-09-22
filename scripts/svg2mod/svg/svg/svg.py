# SVG parser in Python

# Copyright (C) 2013 -- CJlano < cjlano @ free.fr >

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

from __future__ import absolute_import
import traceback
import sys
import os
import copy
import re
import xml.etree.ElementTree as etree
import itertools
import operator
import json
from .geometry import *

svg_ns = '{http://www.w3.org/2000/svg}'

# Regex commonly used
number_re = r'[-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?'
unit_re = r'em|ex|px|in|cm|mm|pt|pc|%'

# Unit converter
unit_convert = {
        None: 1,           # Default unit (same as pixel)
        'px': 1,           # px: pixel. Default SVG unit
        'em': 10,          # 1 em = 10 px FIXME
        'ex': 5,           # 1 ex =  5 px FIXME
        'in': 96,          # 1 in = 96 px
        'cm': 96 / 2.54,   # 1 cm = 1/2.54 in
        'mm': 96 / 25.4,   # 1 mm = 1/25.4 in
        'pt': 96 / 72.0,   # 1 pt = 1/72 in
        'pc': 96 / 6.0,    # 1 pc = 1/6 in
        '%' :  1 / 100.0   # 1 percent
        }

class Transformable:
    '''Abstract class for objects that can be geometrically drawn & transformed'''
    def __init__(self, elt=None):
        # a 'Transformable' is represented as a list of Transformable items
        self.items = []
        self.id = hex(id(self))
        # Unit transformation matrix on init
        self.matrix = Matrix()
        self.viewport = Point(800, 600) # default viewport is 800x600
        if elt is not None:
            self.id = elt.get('id', self.id)
            # Parse transform attibute to update self.matrix
            self.getTransformations(elt)

    def bbox(self):
        '''Bounding box'''
        bboxes = [x.bbox() for x in self.items]
        if len( bboxes ) < 1:
            return (Point(0, 0), Point(0, 0))
        xmin = min([b[0].x for b in bboxes])
        xmax = max([b[1].x for b in bboxes])
        ymin = min([b[0].y for b in bboxes])
        ymax = max([b[1].y for b in bboxes])

        return (Point(xmin,ymin), Point(xmax,ymax))

    # Parse transform field
    def getTransformations(self, elt):
        t = elt.get('transform')
        if t is None: return

        svg_transforms = [
                'matrix', 'translate', 'scale', 'rotate', 'skewX', 'skewY']

        # match any SVG transformation with its parameter (until final parenthese)
        # [^)]*    == anything but a closing parenthese
        # '|'.join == OR-list of SVG transformations
        transforms = re.findall(
                '|'.join([x + '[^)]*\)' for x in svg_transforms]), t)

        for t in transforms:
            op, arg = t.split('(')
            op = op.strip()
            # Keep only numbers
            arg = [float(x) for x in re.findall(number_re, arg)]
            print('transform: ' + op + ' '+ str(arg))

            if op == 'matrix':
                self.matrix *= Matrix(arg)

            if op == 'translate':
                tx = arg[0]
                if len(arg) == 1: ty = 0
                else: ty = arg[1]
                self.matrix *= Matrix([1, 0, 0, 1, tx, ty])

            if op == 'scale':
                sx = arg[0]
                if len(arg) == 1: sy = sx
                else: sy = arg[1]
                self.matrix *= Matrix([sx, 0, 0, sy, 0, 0])

            if op == 'rotate':
                cosa = math.cos(math.radians(arg[0]))
                sina = math.sin(math.radians(arg[0]))
                if len(arg) != 1:
                    tx, ty = arg[1:3]
                    self.matrix *= Matrix([1, 0, 0, 1, tx, ty])
                self.matrix *= Matrix([cosa, sina, -sina, cosa, 0, 0])
                if len(arg) != 1:
                    self.matrix *= Matrix([1, 0, 0, 1, -tx, -ty])

            if op == 'skewX':
                tana = math.tan(math.radians(arg[0]))
                self.matrix *= Matrix([1, 0, tana, 1, 0, 0])

            if op == 'skewY':
                tana = math.tan(math.radians(arg[0]))
                self.matrix *= Matrix([1, tana, 0, 1, 0, 0])

    def transform(self, matrix=None):
        if matrix is None:
            matrix = self.matrix
        else:
            matrix *= self.matrix
        #print( "do transform: {}: {}".format( self.__class__.__name__, matrix ) )
        #print( "do transform: {}: {}".format( self, matrix ) )
        #traceback.print_stack()
        for x in self.items:
            x.transform(matrix)

    def length(self, v, mode='xy'):
        # Handle empty (non-existing) length element
        if v is None:
            return 0

        # Get length value
        m = re.search(number_re, v)
        if m: value = m.group(0)
        else: raise TypeError(v + 'is not a valid length')

        # Get length unit
        m = re.search(unit_re, v)
        if m: unit = m.group(0)
        else: unit = None

        if unit == '%':
            if mode == 'x':
                return float(value) * unit_convert[unit] * self.viewport.x
            if mode == 'y':
                return float(value) * unit_convert[unit] * self.viewport.y
            if mode == 'xy':
                return float(value) * unit_convert[unit] * self.viewport.x # FIXME

        return float(value) * unit_convert[unit]

    def xlength(self, x):
        return self.length(x, 'x')
    def ylength(self, y):
        return self.length(y, 'y')

    def flatten(self):
        '''Flatten the SVG objects nested list into a flat (1-D) list,
        removing Groups'''
        # http://rightfootin.blogspot.fr/2006/09/more-on-python-flatten.html
        # Assigning a slice a[i:i+1] with a list actually replaces the a[i]
        # element with the content of the assigned list
        i = 0
        flat = copy.deepcopy(self.items)
        while i < len(flat):
            while isinstance(flat[i], Group):
                flat[i:i+1] = flat[i].items
            i += 1
        return flat

    def scale(self, ratio):
        for x in self.items:
            x.scale(ratio)
        return self

    def translate(self, offset):
        for x in self.items:
            x.translate(offset)
        return self

    def rotate(self, angle):
        for x in self.items:
            x.rotate(angle)
        return self

class Svg(Transformable):
    '''SVG class: use parse to parse a file'''
    # class Svg handles the <svg> tag
    # tag = 'svg'

    def __init__(self, filename=None):
        Transformable.__init__(self)
        if filename:
            self.parse(filename)

    def parse(self, filename):
        self.filename = filename
        tree = etree.parse(filename)
        self.root = tree.getroot()
        if self.root.tag != svg_ns + 'svg':
            raise TypeError('file %s does not seem to be a valid SVG file', filename)

        # Create a top Group to group all other items (useful for viewBox elt)
        top_group = Group()
        self.items.append(top_group)

        # SVG dimension
        width = self.xlength(self.root.get('width'))
        height = self.ylength(self.root.get('height'))
        # update viewport
        top_group.viewport = Point(width, height)

        # viewBox
        if self.root.get('viewBox') is not None:
            viewBox = re.findall(number_re, self.root.get('viewBox'))
            sx = width / float(viewBox[2])
            sy = height / float(viewBox[3])
            tx = -float(viewBox[0])
            ty = -float(viewBox[1])
            top_group.matrix = Matrix([sx, 0, 0, sy, tx, ty])

        # Parse XML elements hierarchically with groups <g>
        top_group.append(self.root)

        self.transform()

    def title(self):
        t = self.root.find(svg_ns + 'title')
        if t is not None:
            return t
        else:
            return os.path.splitext(os.path.basename(self.filename))[0]

    def json(self):
        return self.items


class Group(Transformable):
    '''Handle svg <g> elements'''
    # class Group handles the <g> tag
    tag = 'g'

    def __init__(self, elt=None):
        Transformable.__init__(self, elt)
        
        self.name = ""
        if elt is not None:
            for id, value in elt.attrib.iteritems():

                id = self.parse_name( id )
                if id[ "name" ] == "label":
                    self.name = value

    @staticmethod
    def parse_name( tag ):
        m = re.match( r'({(.+)})?(.+)', tag )
        return {
            'namespace' : m.group( 2 ),
            'name' : m.group( 3 ),
        }

    def append(self, element):
        for elt in element:
            elt_class = svgClass.get(elt.tag, None)
            if elt_class is None:
                print('No handler for element %s' % elt.tag)
                continue
            # instanciate elt associated class (e.g. <path>: item = Path(elt)
            item = elt_class(elt)
            # Apply group matrix to the newly created object
            # Actually, this is effectively done in Svg.__init__() through call to
            # self.transform(), so doing it here will result in the transformations
            # being applied twice.
            #item.matrix = self.matrix * item.matrix
            item.viewport = self.viewport

            self.items.append(item)
            # Recursively append if elt is a <g> (group)
            if elt.tag == svg_ns + 'g':
                item.append(elt)

    def __repr__(self):
        return '<Group ' + self.id + " ({})".format( self.name ) + '>: ' + repr(self.items)

    def json(self):
        return {'Group ' + self.id + " ({})".format( self.name ) : self.items}

class Matrix:
    ''' SVG transformation matrix and its operations
    a SVG matrix is represented as a list of 6 values [a, b, c, d, e, f]
    (named vect hereafter) which represent the 3x3 matrix
    ((a, c, e)
     (b, d, f)
     (0, 0, 1))
    see http://www.w3.org/TR/SVG/coords.html#EstablishingANewUserSpace '''

    def __init__(self, vect=[1, 0, 0, 1, 0, 0]):
        # Unit transformation vect by default
        if len(vect) != 6:
            raise ValueError("Bad vect size %d" % len(vect))
        self.vect = list(vect)

    def __mul__(self, other):
        '''Matrix multiplication'''
        if isinstance(other, Matrix):
            a = self.vect[0] * other.vect[0] + self.vect[2] * other.vect[1]
            b = self.vect[1] * other.vect[0] + self.vect[3] * other.vect[1]
            c = self.vect[0] * other.vect[2] + self.vect[2] * other.vect[3]
            d = self.vect[1] * other.vect[2] + self.vect[3] * other.vect[3]
            e = self.vect[0] * other.vect[4] + self.vect[2] * other.vect[5] \
                    + self.vect[4]
            f = self.vect[1] * other.vect[4] + self.vect[3] * other.vect[5] \
                    + self.vect[5]
            return Matrix([a, b, c, d, e, f])

        elif isinstance(other, Point):
            x = other.x * self.vect[0] + other.y * self.vect[2] + self.vect[4]
            y = other.x * self.vect[1] + other.y * self.vect[3] + self.vect[5]
            return Point(x,y)

        else:
            return NotImplemented

    def __str__(self):
        return str(self.vect)

    def xlength(self, x):
        return x * self.vect[0]
    def ylength(self, y):
        return y * self.vect[3]


COMMANDS = 'MmZzLlHhVvCcSsQqTtAa'

class Path(Transformable):
    '''SVG <path>'''
    # class Path handles the <path> tag
    tag = 'path'

    def __init__(self, elt=None):
        Transformable.__init__(self, elt)
        if elt is not None:
            self.style = elt.get('style')
            self.parse(elt.get('d'))

    def parse(self, pathstr):
        """Parse path string and build elements list"""

        pathlst = re.findall(number_re + r"|\ *[%s]\ *" % COMMANDS, pathstr)

        pathlst.reverse()

        command = None
        current_pt = Point(0,0)
        start_pt = None

        while pathlst:
            if pathlst[-1].strip() in COMMANDS:
                last_command = command
                command = pathlst.pop().strip()
                absolute = (command == command.upper())
                command = command.upper()
            else:
                if command is None:
                    raise ValueError("No command found at %d" % len(pathlst))

            if command == 'M':
            # MoveTo
                x = pathlst.pop()
                y = pathlst.pop()
                pt = Point(x, y)
                if absolute:
                    current_pt = pt
                else:
                    current_pt += pt
                start_pt = current_pt

                self.items.append(MoveTo(current_pt))

                # MoveTo with multiple coordinates means LineTo
                command = 'L'

            elif command == 'Z':
            # Close Path
                l = Segment(current_pt, start_pt)
                self.items.append(l)


            elif command in 'LHV':
            # LineTo, Horizontal & Vertical line
                # extra coord for H,V
                if absolute:
                    x,y = current_pt.coord()
                else:
                    x,y = (0,0)

                if command in 'LH':
                    x = pathlst.pop()
                if command in 'LV':
                    y = pathlst.pop()

                pt = Point(x, y)
                if not absolute:
                    pt += current_pt

                self.items.append(Segment(current_pt, pt))
                current_pt = pt

            elif command in 'CQ':
                dimension = {'Q':3, 'C':4}
                bezier_pts = []
                bezier_pts.append(current_pt)
                for i in range(1,dimension[command]):
                    x = pathlst.pop()
                    y = pathlst.pop()
                    pt = Point(x, y)
                    if not absolute:
                        pt += current_pt
                    bezier_pts.append(pt)

                self.items.append(Bezier(bezier_pts))
                current_pt = pt

            elif command in 'TS':
                # number of points to read
                nbpts = {'T':1, 'S':2}
                # the control point, from previous Bezier to mirror
                ctrlpt = {'T':1, 'S':2}
                # last command control
                last = {'T': 'QT', 'S':'CS'}

                bezier_pts = []
                bezier_pts.append(current_pt)

                if last_command in last[command]:
                    pt0 = self.items[-1].control_point(ctrlpt[command])
                else:
                    pt0 = current_pt
                pt1 = current_pt
                # Symetrical of pt1 against pt0
                bezier_pts.append(pt1 + pt1 - pt0)

                for i in range(0,nbpts[command]):
                    x = pathlst.pop()
                    y = pathlst.pop()
                    pt = Point(x, y)
                    if not absolute:
                        pt += current_pt
                    bezier_pts.append(pt)

                self.items.append(Bezier(bezier_pts))
                current_pt = pt

            elif command == 'A':
                rx = pathlst.pop()
                ry = pathlst.pop()
                xrot = pathlst.pop()
                # Arc flags are not necesarily sepatated numbers
                flags = pathlst.pop().strip()
                large_arc_flag = flags[0]
                if large_arc_flag not in '01':
                    print('Arc parsing failure')
                    break

                if len(flags) > 1:  flags = flags[1:].strip()
                else:               flags = pathlst.pop().strip()
                sweep_flag = flags[0]
                if sweep_flag not in '01':
                    print('Arc parsing failure')
                    break

                if len(flags) > 1:  x = flags[1:]
                else:               x = pathlst.pop()
                y = pathlst.pop()
                # TODO
                print('ARC: ' +
                    ', '.join([rx, ry, xrot, large_arc_flag, sweep_flag, x, y]))
#                self.items.append(
#                    Arc(rx, ry, xrot, large_arc_flag, sweep_flag, Point(x, y)))

            else:
                pathlst.pop()

    def __str__(self):
        return '\n'.join(str(x) for x in self.items)

    def __repr__(self):
        return '<Path ' + self.id + '>'

    def segments(self, precision=0):
        '''Return a list of segments, each segment is ended by a MoveTo.
           A segment is a list of Points'''
        ret = []
        # group items separated by MoveTo
        for moveTo, group in itertools.groupby(self.items,
                lambda x: isinstance(x, MoveTo)):
            # Use only non MoveTo item
            if not moveTo:
                # Generate segments for each relevant item
                seg = [x.segments(precision) for x in group]
                # Merge all segments into one
                ret.append(list(itertools.chain.from_iterable(seg)))

        return ret

    def simplify(self, precision):
        '''Simplify segment with precision:
           Remove any point which are ~aligned'''
        ret = []
        for seg in self.segments(precision):
            ret.append(simplify_segment(seg, precision))

        return ret

class Ellipse(Transformable):
    '''SVG <ellipse>'''
    # class Ellipse handles the <ellipse> tag
    tag = 'ellipse'

    def __init__(self, elt=None):
        Transformable.__init__(self, elt)
        if elt is not None:
            self.center = Point(self.xlength(elt.get('cx')),
                                self.ylength(elt.get('cy')))
            self.rx = self.length(elt.get('rx'))
            self.ry = self.length(elt.get('ry'))
            self.style = elt.get('style')

    def __repr__(self):
        return '<Ellipse ' + self.id + '>'

    def bbox(self):
        '''Bounding box'''
        pmin = self.center - Point(self.rx, self.ry)
        pmax = self.center + Point(self.rx, self.ry)
        return (pmin, pmax)

    def transform(self, matrix):
        self.center = self.matrix * self.center
        self.rx = self.matrix.xlength(self.rx)
        self.ry = self.matrix.ylength(self.ry)

    def scale(self, ratio):
        self.center *= ratio
        self.rx *= ratio
        self.ry *= ratio
    def translate(self, offset):
        self.center += offset
    def rotate(self, angle):
        self.center = self.center.rot(angle)

    def P(self, t):
        '''Return a Point on the Ellipse for t in [0..1]'''
        x = self.center.x + self.rx * math.cos(2 * math.pi * t)
        y = self.center.y + self.ry * math.sin(2 * math.pi * t)
        return Point(x,y)

    def segments(self, precision=0):
        if max(self.rx, self.ry) < precision:
            return [[self.center]]

        p = [(0,self.P(0)), (1, self.P(1))]
        d = 2 * max(self.rx, self.ry)

        while d > precision:
            for (t1,p1),(t2,p2) in zip(p[:-1],p[1:]):
                t = t1 + (t2 - t1)/2.
                d = Segment(p1, p2).pdistance(self.P(t))
                p.append((t, self.P(t)))
            p.sort(key=operator.itemgetter(0))

        ret = [x for t,x in p]
        return [ret]

    def simplify(self, precision):
        return self

# A circle is a special type of ellipse where rx = ry = radius
class Circle(Ellipse):
    '''SVG <circle>'''
    # class Circle handles the <circle> tag
    tag = 'circle'

    def __init__(self, elt=None):
        if elt is not None:
            elt.set('rx', elt.get('r'))
            elt.set('ry', elt.get('r'))
        Ellipse.__init__(self, elt)

    def __repr__(self):
        return '<Circle ' + self.id + '>'

class Rect(Transformable):
    '''SVG <rect>'''
    # class Rect handles the <rect> tag
    tag = 'rect'

    def __init__(self, elt=None):
        Transformable.__init__(self, elt)
        if elt is not None:
            self.P1 = Point(self.xlength(elt.get('x')),
                            self.ylength(elt.get('y')))

            self.P2 = Point(self.P1.x + self.xlength(elt.get('width')),
                            self.P1.y + self.ylength(elt.get('height')))

    def __repr__(self):
        return '<Rect ' + self.id + '>'

    def bbox(self):
        '''Bounding box'''
        xmin = min([p.x for p in (self.P1, self.P2)])
        xmax = max([p.x for p in (self.P1, self.P2)])
        ymin = min([p.y for p in (self.P1, self.P2)])
        ymax = max([p.y for p in (self.P1, self.P2)])

        return (Point(xmin,ymin), Point(xmax,ymax))

    def transform(self, matrix):
        self.P1 = self.matrix * self.P1
        self.P2 = self.matrix * self.P2

    def segments(self, precision=0):
        # A rectangle is built with a segment going thru 4 points
        ret = []
        Pa = Point(self.P1.x, self.P2.y)
        Pb = Point(self.P2.x, self.P1.y)

        ret.append([self.P1, Pa, self.P2, Pb, self.P1])
        return ret

    def simplify(self, precision):
        return self.segments(precision)

class Line(Transformable):
    '''SVG <line>'''
    # class Line handles the <line> tag
    tag = 'line'

    def __init__(self, elt=None):
        Transformable.__init__(self, elt)
        if elt is not None:
            self.P1 = Point(self.xlength(elt.get('x1')),
                            self.ylength(elt.get('y1')))
            self.P2 = Point(self.xlength(elt.get('x2')),
                            self.ylength(elt.get('y2')))
            self.segment = Segment(self.P1, self.P2)

    def __repr__(self):
        return '<Line ' + self.id + '>'

    def bbox(self):
        '''Bounding box'''
        xmin = min([p.x for p in (self.P1, self.P2)])
        xmax = max([p.x for p in (self.P1, self.P2)])
        ymin = min([p.y for p in (self.P1, self.P2)])
        ymax = max([p.y for p in (self.P1, self.P2)])

        return (Point(xmin,ymin), Point(xmax,ymax))

    def transform(self, matrix):
        self.P1 = self.matrix * self.P1
        self.P2 = self.matrix * self.P2
        self.segment = Segment(self.P1, self.P2)

    def segments(self, precision=0):
        return [self.segment.segments()]

    def simplify(self, precision):
        return self.segments(precision)

# overwrite JSONEncoder for svg classes which have defined a .json() method
class JSONEncoder(json.JSONEncoder):
    def default(self, obj):
        if not isinstance(obj, tuple(svgClass.values() + [Svg])):
            return json.JSONEncoder.default(self, obj)

        if not hasattr(obj, 'json'):
            return repr(obj)

        return obj.json()

## Code executed on module load ##

# SVG tag handler classes are initialized here
# (classes must be defined before)
import inspect
svgClass = {}
# Register all classes with attribute 'tag' in svgClass dict
for name, cls in inspect.getmembers(sys.modules[__name__], inspect.isclass):
    tag = getattr(cls, 'tag', None)
    if tag:
        svgClass[svg_ns + tag] = cls

