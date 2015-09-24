    doc = """
    Usage:
      vacplenum

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
    plunge = require './plunge.litcoffee'
    pocket = require './pocket.litcoffee'
    {prefix, suffix} = require './lines.litcoffee'

Thickness with a slight overstep making sure we cut all the way through.

    zones = 6
    thickness = 19.05 + 1
    width = 1220.0
    length = 2020.0
    channelInset = 40.0
    airportDiameter = 60.325
    cutterDiameter = 19

Prefix. Set up the spindle.

    console.log prefix(cutterDiameter)

Each zone, with air ports and channels cut.

    zoneWidth = width / zones
    zoneCenter = zoneWidth / 2.0
    zone = 1
    while zoneCenter < width

Carve out a half depth channel, inset a bit to make sure there is an edge to
seal for vacuum.

      if zone is 6
        console.log pocket zoneCenter - zoneWidth/4, channelInset, zoneWidth/2, length - 2*channelInset, -1 * thickness / 2.0, 0, cutterDiameter, 4

Carve out an air port.

      if zone is 6
        console.log plunge zoneCenter, length - airportDiameter/2 - 2*channelInset, airportDiameter, -1 * (thickness+2), 0, cutterDiameter
        console.log "(end zone #{zone})"

      zoneCenter += zoneWidth
      zone += 1


Suffix

    console.log suffix()
