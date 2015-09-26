    doc = """
    Usage:
      vactrack

    Options:
      -h --help                show this help message and exit
      --version                show version and exit

    Follow-up program to `vactrack`. This prepares drill through mounting holes
    and dog bones for final rail installation.

    The top of the sheet is assumed to be Z0, effectively treating the tabletop
    as Z0 and cutting into it.

    Run this with a 1/4" cutter.

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
    cutterDiameter = 6.35
    trackWidth = 40.0
    trackDepth = 22.0
    startY = -15.0

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

And drill holes all the way through to bolt up through the base board and into the
aluminum rails.

        [200, 400, 800, 1000, 1400, 1600, 2000].forEach (mountAt) ->
          console.log plunge zoneCenter + zoneWidth / 2 - 10.0, mountAt, cutterDiameter, -1 * (thickness*2+2), 0, cutterDiameter, 1
          console.log plunge zoneCenter + zoneWidth / 2 + 10.0, mountAt, cutterDiameter, -1 * (thickness*2+2), 0, cutterDiameter, 1

The end dogbone to flush mount aluminum rails in the surface.

        console.log pocket zoneCenter + zoneWidth / 2 - trackWidth/2, length-20, trackWidth, 25, -1 * trackDepth, 0, cutterDiameter, 4, true
        console.log plunge zoneCenter + zoneWidth / 2 - trackWidth/2, length + 5, cutterDiameter, -1 * trackDepth, 0, cutterDiameter
        console.log plunge zoneCenter + zoneWidth / 2 + trackWidth/2, length + 5, cutterDiameter, -1 * trackDepth, 0, cutterDiameter

      console.log "(end zone #{zone})"
      zoneCenter += zoneWidth
      zone += 1

Suffix

    console.log suffix()
