    doc = """
    Usage:
      resurface <width-mm> <height-mm>

    Options:
      -h --help                show this help message and exit
      --version                show version and exit

    Generates the gcode to resurface a spoilboard. This will shave of .2mm.
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
    {SAFE_TRAVEL, suffix } = require './lines.litcoffee'

    width = Number(options['<width-mm>'])
    height = Number(options['<height-mm>'])
    cutterDiameter = 31.75

Prefix. Set up the spindle.

    console.log """
    G0Z#{SAFE_TRAVEL}
    M3S24000
    G04P10
    G0X0Y0

    """


This is a simple matter of figuring the 'step' size based on the cutter width, 
stepping up the height axis, with a 50% overlap.

    step = cutterDiameter / 2
    at = 0
    while true
      console.log "G1F3000Y#{at}"
      console.log "G1F3000X#{width}"
      at += step
      if at > height
        break
      console.log "G1F3000Y#{at}"
      console.log "G1F3000X0"
      at += step
      if at > height
        break


Suffix

    console.log suffix()
