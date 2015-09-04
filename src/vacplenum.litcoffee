    doc = """
    Usage:
      vacplenum <length-mm> <air-port-diameter-mm> <cutter-diameter>

    Options:
      -h --help                show this help message and exit
      --version                show version and exit

    Generates a vacuum table plenum board to cut from a 4x8x3/4 MDF sheet. This
    assumes the 4' edge is the width/X and the 8' edge is the length/Y.

    This will divide the 1200mm effective width into 6 longitudinal zones
    each with an air port completely through the panel, and a air channel to
    distribute vacuum from the port.

    The top of the sheet is assumed to be Z0, effectively treating the tabletop
    as Z0 and cutting into it.

    """

    {docopt} = require 'docopt'
    require 'colors'
    _ = require 'lodash'
    options = docopt doc
    circle = require './circle.litcoffee'
    pocket = require './pocket.litcoffee'
    {SAFE_TRAVEL, line, boundLineData, followupLine, rectangle} = require './lines.litcoffee'

Thickness with a slight overstep making sure we cut all the way through.

    zones = 6
    thickness = 19.05 + 1
    width = 1220.0
    length = Number(options['<length-mm>'])
    channelInset = 40.0
    airPortInset = 200.0
    airportDiameter = Number(options['<air-port-diameter-mm>'])
    cutterDiameter = Number(options['<cutter-diameter>'])

Prefix. Set up the spindle.

    console.log """
    (Cutter: #{cutterDiameter}mm)
    G0Z#{thickness+SAFE_TRAVEL}
    M3S24000
    G04P10
    G0X0Y0

    """

Each zone, with air ports and channels cut.

    zoneWidth = width / zones
    console.error 'Zone Width:', "#{zoneWidth}"
    zoneCenter = zoneWidth / 2.0
    while zoneCenter < width

Carve out a half depth channel, inset a bit to make sure there is an edge to
seal for vacuum.

      console.log pocket zoneCenter - zoneWidth/4, channelInset, zoneWidth/2, length - 2*channelInset, thickness / -2.0, cutterDiameter

Carve out an air port.

      console.log circle zoneCenter, length - airPortInset, airportDiameter, thickness, cutterDiameter

      zoneCenter += zoneWidth



Suffix

    console.log """
    G0Z#{thickness+SAFE_TRAVEL}
    M5
    G0X0Y0
    M30
    """
