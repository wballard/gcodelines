    doc = """
    Usage:
      resurface <width-mm> <height-mm> <depth-mm>

    Options:
      -h --help                show this help message and exit
      --version                show version and exit

    Generates the gcode to resurface a spoilboard to 0.
    Assumes a 1.25"(31.75mm) cutter.

    This treats the tabletop as 0, makes it easier to cut through with sheets that
    will warp a bit.

    This will 'cut large', as the width and height represent the cutter motion,
    not the diamater cut net the cutter diamater.

    """

    {docopt} = require 'docopt'
    require 'colors'
    _ = require 'lodash'
    options = docopt doc
    {suffix, prefix, SAFE_TRAVEL, RPM, FEEDRATE, PLUNGERATE} = require './lines.litcoffee'

    width = Number(options['<width-mm>'])
    height = Number(options['<height-mm>'])
    depth = Number(options['<depth-mm>'])
    cutterDiameter = 31.75

Prefix. Set up the spindle.

    console.log prefix cutterDiameter


This is a simple matter of figuring the 'step' size based on the cutter width,
stepping up the height axis, with a 50% overlap.

    step = cutterDiameter / 2
    at = 0
    console.log "G1F#{PLUNGERATE}Z-#{depth}"
    while true
      console.log "G1F#{FEEDRATE}Y#{at}"
      console.log "G1F#{FEEDRATE}X#{width}"
      at += step
      if at > height
        break
      console.log "G1F#{FEEDRATE}Y#{at}"
      console.log "G1F#{FEEDRATE}X0"
      at += step
      if at > height
        break


Suffix

    console.log suffix()
