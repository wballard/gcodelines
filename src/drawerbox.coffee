doc = """
Usage:
  drawerbox [--faceless] <width-mm> <length-mm> <height-mm> <thickness-mm>

Options:
  -h --help                show this help message and exit
  --version                show version and exit
  --faceless               draw only a box, not a facing panel

Generates the gcode to cut out the four panels of a rectangular drawerbox,
with a bottom groove and relief for underlayment. Drawer panels are
joined with a series of small dogbone finger joints.

This assumes a 6.35mm cutter.


"""

{docopt} = require 'docopt'
require 'colors'
_ = require 'lodash'
options = docopt doc
{suffix, prefix, SAFE_TRAVEL, RPM, FEEDRATE, PLUNGERATE} = require './lines.litcoffee'
rectangle = require './rectangle.litcoffee'
line = require './line.litcoffee'


###
Set up all the dimensions and math here, then it is just a matter of making
the cuts.
###
width = Number(options['<width-mm>'])
length = Number(options['<length-mm>'])
height = Number(options['<height-mm>'])
thickness = Number(options['<thickness-mm>'])
overcut = 1.2
cutter = 6.35
tab = cutter
underlayment = cutter
rabbet = thickness-underlayment
rabbetShelf = thickness-rabbet
bottomWidth = width-(rabbetShelf)*2
bottomLength = length-(rabbetShelf)*2
caseThickness = 19.0
sliderThickness = 12.0
faceWidth = width+2*caseThickness+2*sliderThickness
faceHeight = height+2*sliderThickness
step = Math.min(Number(options['<width-mm>']), Number(options['<height-mm>'])) / Number(options['<short-side-cells>'])


console.log prefix(cutter, RPM)


###
Bottom is a rabbet all the way around, this will create a tab to slide into
the groove cut on all sides.
###
console.log rectangle cutter, cutter, bottomWidth-cutter, bottomLength-cutter, 0, -1*(rabbet+overcut)
console.log rectangle 0, 0, bottomWidth+cutter, bottomLength+cutter, 0, -1*(thickness+overcut), 3, tab

###
Face, this overhangs to cover sliders as well as a case.
###
if not options['--faceless']
  console.log rectangle 0, width-faceHeight-cutter, faceWidth+cutter, faceHeight+cutter, 0, -1*(thickness+overcut), 3, tab

###
Length sides have a rabbet with an extended notch to accomodate the
width tab.
###
[0, 1].forEach (side) ->
  offset = bottomWidth+cutter + (height+cutter)*side
  sideLength = length
  sideLength = switch side
    when 0, 1 then length
    when 2, 3 then width-(rabbetShelf*2)

  console.log line offset, cutter, offset+height+cutter, cutter, 0, -1*(rabbet+overcut)

  console.log line offset, sideLength, offset+height+cutter, sideLength, 0, -1*(rabbet+overcut)

  console.log line offset+thickness, 0, offset+thickness, sideLength+cutter, 0, -1*(rabbet+overcut)
  console.log rectangle offset, 0, height+cutter, sideLength+cutter, 0, -1*(thickness+overcut), 3, tab

###
Width sides have a rabbet. These sides are shortened
as the tab will go into the notch cut on the length sides.
###
[2, 3].forEach (side) ->
  offset = bottomWidth+cutter + (height+cutter)*side
  sideLength = width-(rabbetShelf*2)

  console.log line offset, cutter, offset+height+cutter, cutter, 0, -1*(rabbet+overcut)

  console.log line offset, sideLength, offset+height+cutter, sideLength, 0, -1*(rabbet+overcut)

  console.log line offset+thickness, 0, offset+thickness, sideLength+cutter, 0, -1*(rabbet+overcut)
  console.log rectangle offset, 0, height+cutter, sideLength+cutter, 0, -1*(thickness+overcut), 3, tab


console.log suffix()
