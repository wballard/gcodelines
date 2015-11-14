    doc = """
    Usage:
      drawerbox <width-mm> <length-mm> <height-mm> <thickness-mm>

    Options:
      -h --help                show this help message and exit
      --version                show version and exit

    Generates the gcode to cut out the four panels of a rectangular drawerbox,
    with a bottom groove and relief for underlayment. Drawer panels are
    joined with a series of small dogbone finger joints.

    This assumes a 5mm cutter.


    """

    {docopt} = require 'docopt'
    require 'colors'
    _ = require 'lodash'
    options = docopt doc
    {suffix, prefix, SAFE_TRAVEL, RPM, FEEDRATE, PLUNGERATE} = require './lines.litcoffee'
    rectangle = require './rectangle.litcoffee'
    line = require './line.litcoffee'

    width = Number(options['<width-mm>'])
    length = Number(options['<length-mm>'])
    height = Number(options['<height-mm>'])
    thickness = Number(options['<thickness-mm>'])
    overcut = 1
    cutter = 5.0
    fingerPitch = cutter
    underlayment = cutter
    step = Math.min(Number(options['<width-mm>']), Number(options['<height-mm>'])) / Number(options['<short-side-cells>'])


    console.log "(Underlayment #{width-underlayment*2-thickness*2}mm X #{length-underlayment-thickness*2})"
    console.log prefix(cutter, RPM)

Set up the finger spacing pitch array. The actual cut will make alternating
finger patterns between the front and side panels.

    fingers = []
    finger = 0
    while finger <= (height+cutter)
      fingers.push finger
      finger += fingerPitch


Cut out two, usually, longer sides, with fingers and an underlayment groove,
which is one finger up.

Outline is cut last -- part needs to stay put!

    [0, 1].forEach (step) ->
      [{from:0, to:thickness+cutter/2}, {from:length+cutter, to:length+cutter-thickness-cutter/2}].forEach (side) ->
        fingers.forEach (finger, i) ->
          if i % 2 is 1
            fingerInset = finger + step*(height+cutter)
            console.log line fingerInset, side.from, fingerInset, side.to, 0, -1*(thickness+overcut)

      underlaymentGroove =step*(height+cutter)+underlayment+cutter/2
      console.log line underlaymentGroove, 0, underlaymentGroove, length+cutter, 0, -1*underlayment

      console.log rectangle step*(height+cutter), 0, height+cutter, length+cutter, 0, -1*(thickness+overcut)


Cut out the front/rear.

    [2, 3].forEach (step) ->
      [{from:0, to:thickness+cutter/2}, {from:width+cutter, to:width+cutter-thickness-cutter/2}].forEach (side) ->
        fingers.forEach (finger, i) ->
          if i % 2 is 0
            fingerInset = finger + step*(height+cutter)
            console.log line fingerInset, side.from, fingerInset, side.to, 0, -1*(thickness+overcut)

The rear just gets sliced off at the underlayment groove to provide insert relief.
The front panel just has an underlayment groove.

      underlaymentGroove =step*(height+cutter)+underlayment+cutter/2
      underlaymentCut = if step is 2 then -1*underlayment else -1*(thickness+overcut)
      console.log line underlaymentGroove, 0, underlaymentGroove, width+cutter, 0, underlaymentCut

      console.log rectangle step*(height+cutter), 0, height+cutter, width+cutter, 0, -1*(thickness+overcut)



    console.log suffix()
