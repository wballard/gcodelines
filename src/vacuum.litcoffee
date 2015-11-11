    doc = """
    Usage:
      resurface <width-mm> <height-mm>

    Options:
      -h --help                show this help message and exit
      --version                show version and exit

    Generates the gcode to vacuum sweep the table. Assumes no cutter.

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
    vacuumSweep = 200

Prefix. Set up the spindle.


This is a simple matter of figuring the 'step' size based on the cutter width,
stepping up the height axis, with a 50% overlap.

    step = vacuumSweep
    at = 0
    console.log "G1F#{PLUNGERATE}Z0"
    while true
      console.log "G0F#{FEEDRATE}Y#{at}"
      console.log "G0F#{FEEDRATE}X#{width}"
      at += step
      if at > height
        break
      console.log "G0F#{FEEDRATE}Y#{at}"
      console.log "G0F#{FEEDRATE}X0"
      at += step
      if at > height
        break


Suffix

    console.log "G0X0Y0\n"
