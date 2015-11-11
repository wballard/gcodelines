    doc = """
    Usage:
      caul <width-mm> <height-mm> <groove-depth-mm>

    Options:
      -h --help                show this help message and exit
      --version                show version and exit

    Generates the gcode to create a caul with a groove. Ideally the groove is
    deep enough to stand above your spoilboard and get a good grip on the
    surface medium.

    Assumes a 1.25"(31.75mm) cutter.

    Assumes the top of the caul stock is 0.

    This will 'cut large', as the width and height represent the cutter motion,
    not the diamater cut net the cutter diamater, so watch your clamps.

    """

    {docopt} = require 'docopt'
    require 'colors'
    _ = require 'lodash'
    options = docopt doc
    {suffix, prefix, SAFE_TRAVEL, RPM, FEEDRATE, PLUNGERATE} = require './lines.litcoffee'
    line = require './line.litcoffee'

    width = Number(options['<width-mm>'])
    height = Number(options['<height-mm>'])
    grovedepth = Number(options['<groove-depth-mm>'])
    cutterDiameter = 31.75

Prefix. Set up the spindle.

    console.log prefix()

This is a simple matter of figuring the 'step' size based on the cutter width,
stepping up the height axis, with a 50% overlap.

    step = cutterDiameter / 2
    at = 0
    console.log "G1F#{PLUNGERATE}Z0"
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

    console.log line 0, height, width, height, grovedepth


Suffix

    console.log suffix()
