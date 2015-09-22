SVG parser library
==================

This is a SVG parser library written in Python.

Capabilities:
 - Parse SVG XML
 - apply any transformation (svg transform)
 - Explode SVG Path into basic elements (Line, Bezier, ...)
 - Interpolate SVG Path as a series of segments
 - Able to simplify segments given a precision using Ramer-Douglas-Peucker algorithm

Not (yet) supported:
 - SVG Path Arc ('A')
 - Non-linear transformation drawing (SkewX, ...)

License: GPLv2+
