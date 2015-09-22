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

'''
This module contains all the geometric classes and functions not directly
related to SVG parsing. It can be reused outside the scope of SVG.
'''

import math
import numbers
import operator

class Point:
    def __init__(self, x=None, y=None):
        '''A Point is defined either by a tuple/list of length 2 or
           by 2 coordinates
        >>> Point(1,2)
        (1.000,2.000)
        >>> Point((1,2))
        (1.000,2.000)
        >>> Point([1,2])
        (1.000,2.000)
        >>> Point('1', '2')
        (1.000,2.000)
        >>> Point(('1', None))
        (1.000,0.000)
        '''
        if (isinstance(x, tuple) or isinstance(x, list)) and len(x) == 2:
            x,y = x

        # Handle empty parameter(s) which should be interpreted as 0
        if x is None: x = 0
        if y is None: y = 0

        try:
            self.x = float(x)
            self.y = float(y)
        except:
            raise TypeError("A Point is defined by 2 numbers or a tuple")

    def __add__(self, other):
        '''Add 2 points by adding coordinates.
        Try to convert other to Point if necessary
        >>> Point(1,2) + Point(3,2)
        (4.000,4.000)
        >>> Point(1,2) + (3,2)
        (4.000,4.000)'''
        if not isinstance(other, Point):
            try: other = Point(other)
            except: return NotImplemented
        return Point(self.x + other.x, self.y + other.y)

    def __sub__(self, other):
        '''Substract two Points.
        >>> Point(1,2) - Point(3,2)
        (-2.000,0.000)
        '''
        if not isinstance(other, Point):
            try: other = Point(other)
            except: return NotImplemented
        return Point(self.x - other.x, self.y - other.y)

    def __mul__(self, other):
        '''Multiply a Point with a constant.
        >>> 2 * Point(1,2)
        (2.000,4.000)
        >>> Point(1,2) * Point(1,2) #doctest:+IGNORE_EXCEPTION_DETAIL
        Traceback (most recent call last):
            ...
        TypeError:
        '''
        if not isinstance(other, numbers.Real):
            return NotImplemented
        return Point(self.x * other, self.y * other)
    def __rmul__(self, other):
        return self.__mul__(other)

    def __eq__(self, other):
        '''Test equality
        >>> Point(1,2) == (1,2)
        True
        >>> Point(1,2) == Point(2,1)
        False
        '''
        if not isinstance(other, Point):
            try: other = Point(other)
            except: return NotImplemented
        return (self.x == other.x) and (self.y == other.y)

    def __repr__(self):
        return '(' + format(self.x,'.3f') + ',' + format( self.y,'.3f') + ')'

    def __str__(self):
        return self.__repr__();

    def coord(self):
        '''Return the point tuple (x,y)'''
        return (self.x, self.y)

    def length(self):
        '''Vector length, Pythagoras theorem'''
        return math.sqrt(self.x ** 2 + self.y ** 2)

    def rot(self, angle):
        '''Rotate vector [Origin,self] '''
        if not isinstance(angle, Angle):
            try: angle = Angle(angle)
            except: return NotImplemented
        x = self.x * angle.cos - self.y * angle.sin
        y = self.x * angle.sin + self.y * angle.cos
        return Point(x,y)


class Angle:
    '''Define a trigonometric angle [of a vector] '''
    def __init__(self, arg):
        if isinstance(arg, numbers.Real):
        # We precompute sin and cos for rotations
            self.angle = arg
            self.cos = math.cos(self.angle)
            self.sin = math.sin(self.angle)
        elif isinstance(arg, Point):
        # Point angle is the trigonometric angle of the vector [origin, Point]
            pt = arg
            try:
                self.cos = pt.x/pt.length()
                self.sin = pt.y/pt.length()
            except ZeroDivisionError:
                self.cos = 1
                self.sin = 0

            self.angle = math.acos(self.cos)
            if self.sin < 0:
                self.angle = -self.angle
        else:
            raise TypeError("Angle is defined by a number or a Point")

    def __neg__(self):
        return Angle(Point(self.cos, -self.sin))

class Segment:
    '''A segment is an object defined by 2 points'''
    def __init__(self, start, end):
        self.start = start
        self.end = end

    def __str__(self):
        return 'Segment from ' + str(self.start) + ' to ' + str(self.end)

    def segments(self, precision=0):
        ''' Segments is simply the segment start -> end'''
        return [self.start, self.end]

    def length(self):
        '''Segment length, Pythagoras theorem'''
        s = self.end - self.start
        return math.sqrt(s.x ** 2 + s.y ** 2)

    def pdistance(self, p):
        '''Perpendicular distance between this Segment and a given Point p'''
        if not isinstance(p, Point):
            return NotImplemented

        if self.start == self.end:
        # Distance from a Point to another Point is length of a segment
            return Segment(self.start, p).length()

        s = self.end - self.start
        if s.x == 0:
        # Vertical Segment => pdistance is the difference of abscissa
            return abs(self.start.x - p.x)
        else:
        # That's 2-D perpendicular distance formulae (ref: Wikipedia)
            slope = s.y/s.x
            # intercept: Crossing with ordinate y-axis
            intercept = self.start.y - (slope * self.start.x)
            return abs(slope * p.x - p.y + intercept) / math.sqrt(slope ** 2 + 1)


    def bbox(self):
        xmin = min(self.start.x, self.end.x)
        xmax = max(self.start.x, self.end.x)
        ymin = min(self.start.y, self.end.y)
        ymax = max(self.start.y, self.end.y)

        return (Point(xmin,ymin),Point(xmax,ymax))

    def transform(self, matrix):
        self.start = matrix * self.start
        self.end = matrix * self.end

    def scale(self, ratio):
        self.start *= ratio
        self.end *= ratio
    def translate(self, offset):
        self.start += offset
        self.end += offset
    def rotate(self, angle):
        self.start = self.start.rot(angle)
        self.end = self.end.rot(angle)

class Bezier:
    '''Bezier curve class
       A Bezier curve is defined by its control points
       Its dimension is equal to the number of control points
       Note that SVG only support dimension 3 and 4 Bezier curve, respectively
       Quadratic and Cubic Bezier curve'''
    def __init__(self, pts):
        self.pts = list(pts)
        self.dimension = len(pts)

    def __str__(self):
        return 'Bezier' + str(self.dimension) + \
                ' : ' + ", ".join([str(x) for x in self.pts])

    def control_point(self, n):
        if n >= self.dimension:
            raise LookupError('Index is larger than Bezier curve dimension')
        else:
            return self.pts[n]

    def rlength(self):
        '''Rough Bezier length: length of control point segments'''
        pts = list(self.pts)
        l = 0.0
        p1 = pts.pop()
        while pts:
            p2 = pts.pop()
            l += Segment(p1, p2).length()
            p1 = p2
        return l

    def bbox(self):
        return self.rbbox()

    def rbbox(self):
        '''Rough bounding box: return the bounding box (P1,P2) of the Bezier
        _control_ points'''
        xmin = min([p.x for p in self.pts])
        xmax = max([p.x for p in self.pts])
        ymin = min([p.y for p in self.pts])
        ymax = max([p.y for p in self.pts])

        return (Point(xmin,ymin), Point(xmax,ymax))

    def segments(self, precision=0):
        '''Return a polyline approximation ("segments") of the Bezier curve
           precision is the minimum significative length of a segment'''
        segments = []
        # n is the number of Bezier points to draw according to precision
        if precision != 0:
            n = int(self.rlength() / precision) + 1
        else:
            n = 1000
        if n < 10: n = 10
        if n > 1000 : n = 1000

        for t in range(0, n+1):
            segments.append(self._bezierN(float(t)/n))
        return segments

    def _bezier1(self, p0, p1, t):
        '''Bezier curve, one dimension
        Compute the Point corresponding to a linear Bezier curve between
        p0 and p1 at "time" t '''
        pt = p0 + t * (p1 - p0)
        return pt

    def _bezierN(self, t):
        '''Bezier curve, Nth dimension
        Compute the point of the Nth dimension Bezier curve at "time" t'''
        # We reduce the N Bezier control points by computing the linear Bezier
        # point of each control point segment, creating N-1 control points
        # until we reach one single point
        res = list(self.pts)
        # We store the resulting Bezier points in res[], recursively
        for n in range(self.dimension, 1, -1):
            # For each control point of nth dimension,
            # compute linear Bezier point a t
            for i in range(0,n-1):
                res[i] = self._bezier1(res[i], res[i+1], t)
        return res[0]

    def transform(self, matrix):
        self.pts = [matrix * x for x in self.pts]

    def scale(self, ratio):
        self.pts = [x * ratio for x in self.pts]
    def translate(self, offset):
        self.pts = [x + offset for x in self.pts]
    def rotate(self, angle):
        self.pts = [x.rot(angle) for x in self.pts]

class MoveTo:
    def __init__(self, dest):
        self.dest = dest

    def bbox(self):
        return (self.dest, self.dest)

    def transform(self, matrix):
        self.dest = matrix * self.dest

    def scale(self, ratio):
        self.dest *= ratio
    def translate(self, offset):
        self.dest += offset
    def rotate(self, angle):
        self.dest = self.dest.rot(angle)


def simplify_segment(segment, epsilon):
    '''Ramer-Douglas-Peucker algorithm'''
    if len(segment) < 3 or epsilon <= 0:
        return segment[:]

    l = Segment(segment[0], segment[-1]) # Longest segment

    # Find the furthest point from the segment
    index, maxDist = max([(i, l.pdistance(p)) for i,p in enumerate(segment)],
            key=operator.itemgetter(1))

    if maxDist > epsilon:
        # Recursively call with segment splited in 2 on its furthest point
        r1 = simplify_segment(segment[:index+1], epsilon)
        r2 = simplify_segment(segment[index:], epsilon)
        # Remove redundant 'middle' Point
        return r1[:-1] + r2
    else:
        return [segment[0], segment[-1]]
