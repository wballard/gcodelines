    doc = """
    Usage:
      vactrack

    Options:
      -h --help                show this help message and exit
      --version                show version and exit


    Generates a vacuum table surface board from a 4x8x3/4 MDF sheet. This
    assumes the 4' edge is the width/X and the 8' edge is the length/Y.

    This will divide the 1200mm effective width into 6 longitudinal zones
    and provide room for 40mm t-rail slots for hold down.

    The top of the sheet is assumed to be Z0, effectively treating the tabletop
    as Z0 and cutting into it.

    Run this with a 1.25" surfacing cutter.

    """

    {docopt} = require 'docopt'
    require 'colors'
    _ = require 'lodash'
    options = docopt doc
    plunge = require './plunge.litcoffee'
    rectangle = require './rectangle.litcoffee'
    line = require './line.litcoffee'
    pocket = require './pocket.litcoffee'
    {suffix, prefix} = require './lines.litcoffee'

Thickness with a slight overstep making sure we cut all the way through.

    zones = 6
    thickness = 19.05 + 1
    width = 1220.0
    length = 2020.0
    cutterDiameter = 31.75
    trackWidth = 40.0
    trackDepth = 22.0

Prefix. Set up the spindle.

    console.log prefix(cutterDiameter)

Each zone, then work up the Y axis making tiles.

    zoneWidth = width / zones
    console.error 'Zone Width:', "#{zoneWidth}"
    zoneCenter = zoneWidth / 2.0
    zone = 1
    while zoneCenter < width

End of each zone is separated by a t-track pocket, so don't cut it on the last one.

      if zone < zones
        console.log pocket zoneCenter + zoneWidth / 2 - trackWidth/2, 0, trackWidth, length, -1 * trackDepth, 0, cutterDiameter, 4

      console.log "(end zone #{zone})"
      zoneCenter += zoneWidth
      zone += 1

Suffix

    console.log suffix()
