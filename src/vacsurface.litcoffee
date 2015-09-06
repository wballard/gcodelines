    doc = """
    Usage:
      vacsurface <length-mm>

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
    {SAFE_TRAVEL, line, boundLineData, followupLine, rectangle} = require './lines.litcoffee'

Thickness with a slight overstep making sure we cut all the way through.

    zones = 6
    thickness = 19.05 + 1
    width = 1220.0
    length = Number(options['<length-mm>'])
    tileSize = 140.0
    tileYSeparation = 10.0
    channelInset = 40.0

Prefix. Set up the spindle.

    console.log """
    G0Z#{thickness+SAFE_TRAVEL}
    M3S24000
    G04P10
    G0X0Y0

    """

Each zone, then work up the Y axis making tiles

    zoneWidth = width / zones
    console.error 'Zone Width:', "#{zoneWidth}"
    zoneCenter = zoneWidth / 2.0
    while zoneCenter < width

Work up the Y axis until the tiles fill the space. Each tile is a 3x3 grid
with each cell subdivided to create a deep 3x3 and a shallow 9x9.

      atY = channelInset
      while atY < length-2*channelInset

The major grid.

        console.log """
        G0X#{zoneCenter-tileSize/2.0}Y#{atY}
        G1F1000Z-#{thickness/2}
        G1F4000Y#{atY+tileSize}
        G1F40000X#{zoneCenter+tileSize/2.0}
        G1F4000Y#{atY}
        G1F40000X#{zoneCenter-tileSize/2.0}
        G1F40000X#{zoneCenter-tileSize/2.0+tileSize/3.0}
        G1F4000Y#{atY+tileSize}
        G1F40000X#{zoneCenter-tileSize/2.0+2.0*tileSize/3.0}
        G1F4000Y#{atY}
        G0Z#{thickness+SAFE_TRAVEL}
        G0X#{zoneCenter-tileSize/2.0}Y#{atY+tileSize/3.0}
        G1F1000Z-#{thickness/2}
        G1F40000X#{zoneCenter+tileSize/2.0}
        G1F40000Y#{atY+2.0*tileSize/3.0}
        G1F40000X#{zoneCenter-tileSize/2.0}
        G0Z#{thickness+SAFE_TRAVEL}

        """

The minor grid, crossing X and Y to bisect the 3x3 grid.

        [atY+tileSize/6.0, atY+3*tileSize/6.0, atY+5*tileSize/6.0].forEach (stepY) ->
          console.log """
            G0X#{zoneCenter-tileSize/2.0}Y#{stepY}
            G1F1000Z-#{thickness/6}
            G1F40000X#{zoneCenter+tileSize/2.0}
            G0Z#{thickness+SAFE_TRAVEL}

          """
        [zoneCenter-2*tileSize/6.0, zoneCenter, zoneCenter+2*tileSize/6.0].forEach (stepX) ->
          console.log """
            G0X#{stepX}Y#{atY}
            G1F1000Z-#{thickness/6}
            G1F40000Y#{atY+tileSize}
            G0Z#{thickness+SAFE_TRAVEL}

          """

The air hole.

        console.log """
        G0X#{zoneCenter}Y#{atY+tileSize/2.0}
        G1F1000Z-#{thickness}
        G0Z#{thickness+SAFE_TRAVEL}

        """


        atY += tileSize + tileYSeparation

      zoneCenter += zoneWidth

Suffix

    console.log """
    G0Z#{thickness+SAFE_TRAVEL}
    M5
    G0X0Y0
    M30
    """
