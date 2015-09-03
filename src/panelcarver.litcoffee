    doc = """
    Usage:
      panel <width-mm> <height-mm> <thickness-mm> <short-side-cells>

    Options:
      -h --help                show this help message and exit
      --version                show version and exit

    Generates the gcode to carve a random panel, you should consider
    610 1220 to do a normal 2x4 quarter sheet of ply.

    The width and height also needs cells which you can vary to taste. With a
    6.35mm cutter on a 1/2" quarter sheet, start with:
    610 1220 12.7 30 60

    This treats the tabletop as 0, makes it easier to cut through with sheets that
    will warp a bit.

    """

    {docopt} = require 'docopt'
    require 'colors'
    _ = require 'lodash'
    options = docopt doc
    {SAFE_TRAVEL, line, boundLineData, followupLine, rectangle} = require './lines.litcoffee'

    thickness = Number(options['<thickness-mm>'])
    step = Math.min(Number(options['<width-mm>']), Number(options['<height-mm>'])) / Number(options['<short-side-cells>'])

Prefix. Set up the spindle.

    console.log """
    G0Z#{thickness+SAFE_TRAVEL}
    M3S24000
    G04P10
    G0X0Y0

    """


This is a simple matter of figuring the 'step' size based on the cells, then
stepping up the longest axis, 'stopping' at the panel width. Each line will
be cut into a number of random segments so as to not bisect the panel.

This is bounded with just a little slack as the panel will be outlined with a
rectangle and offset randomly bisect the edge for variety. And -- the bounds
for the cross cut lines are such that the panel will not fall apart.


    at = step
    while at < (Math.max(Number(options['<width-mm>']), Number(options['<height-mm>'])) * 2 )
      doNotFallApartBounds = {x: step, y: step, width: Number(options['<width-mm>']) - 2*step + 0.0001, height: Number(options['<height-mm>']) - 2*step + 0.0001}
      {x1, y1, x2, y2} = boundLineData at, 0, 0, at, doNotFallApartBounds
      xSlope = if x2 - x1 > 0 then 1 else -1
      ySlope = if y2 - y1 > 0 then 1 else -1
      chunks = Math.abs(Math.floor((x2 - x1) / step))
      if chunks > 2
        #step along each chunk and make a segment
        _.range(0, chunks).forEach (chunk) ->
          if Math.random() < 0.5
            console.log line(x1 + chunk*step*xSlope, y1 + chunk*step*ySlope, x1 + (1+chunk)*step*xSlope, y1 + (1+chunk)*step*ySlope, thickness)
      else
        console.log line(x1, y1, x2, y2, thickness)
      at += step


And now cut out the entire edge of the panel.

    console.log rectangle(0, 0, Number(options['<width-mm>']), Number(options['<height-mm>']), thickness)


Suffix

    console.log """
    G0Z#{thickness+SAFE_TRAVEL}
    M5
    G0X0Y0
    M30
    """
