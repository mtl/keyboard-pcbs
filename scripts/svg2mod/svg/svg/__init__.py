#__all__ = ['geometry', 'svg']

from .svg import *

def parse(filename):
    f = svg.Svg(filename)
    return f

