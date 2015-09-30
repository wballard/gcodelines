    doc = """
    Usage:
      vacsurface

    Options:
      -h --help                show this help message and exit
      --version                show version and exit


    Generates a vacuum table surface board from a 4x8x3/4 MDF sheet. This
    assumes the 4' edge is the width/X and the 8' edge is the length/Y.

    Generates a vacuum table surface built out of a series of 120mmx120mm
    air handling tiles with 10mm boundaries.

    This will divide the 1200mm effective width into 6 longitudinal zones
    and then vertically add tiles that are 140mm x 140mm. This provides
    room for 40mm t-rail slots for hold down.

    The top of the sheet is assumed to be Z0, effectively treating the tabletop
    as Z0 and cutting into it.

    Best to run this with a 6mm or 1/4" cutter.

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
    tileSize = 140.0
    tileYSeparation = 40.0
    channelInset = 40.0
    cutterDiameter = 6.35

Prefix. Set up the spindle.

    console.log prefix(cutterDiameter)

Each zone, then work up the Y axis making tiles.

    zoneWidth = width / zones
    console.error 'Zone Width:', "#{zoneWidth}"
    zoneCenter = zoneWidth / 2.0
    zone = 1
    while zoneCenter < width

Work up the Y axis until the tiles fill the space. Each tile is a 3x3 grid
with each cell subdivided to create a deep 3x3 and a shallow 9x9.

      atY = channelInset
      while atY < length-2*channelInset

The major grid.

        console.log rectangle zoneCenter-tileSize/2.0, atY, tileSize, tileSize, -1 * thickness / 2.0, 0
        [atY+tileSize/3.0, atY+2*tileSize/3.0].forEach (stepY) ->
          console.log line zoneCenter-tileSize/2.0, stepY, zoneCenter+tileSize/2.0, stepY, -1 * thickness / 2.0, 0
        [zoneCenter-tileSize/6.0, zoneCenter+tileSize/6.0].forEach (stepX) ->
          console.log line stepX, atY, stepX, atY+tileSize, -1 * thickness / 2.0, 0

The minor grid, crossing X and Y to bisect the 3x3 grid.

        [atY+tileSize/6.0, atY+3*tileSize/6.0, atY+5*tileSize/6.0].forEach (stepY) ->
          console.log line zoneCenter-tileSize/2.0, stepY, zoneCenter+tileSize/2.0, stepY, -1 * thickness / 6.0, 0
        [zoneCenter-2*tileSize/6.0, zoneCenter, zoneCenter+2*tileSize/6.0].forEach (stepX) ->
          console.log line stepX, atY, stepX, atY+tileSize, -1 * thickness / 6.0, 0

The air hole.

        console.log plunge zoneCenter, atY+tileSize/2, 10.0, -1 * (thickness+2), 0, cutterDiameter

        atY += tileSize + tileYSeparation

      console.log "(end zone #{zone})"
      zoneCenter += zoneWidth
      zone += 1

Suffix

    console.log suffix()
