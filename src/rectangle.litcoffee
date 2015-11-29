Everyone's favorite shape! The rectangle, so much more than merely a square...
- runs the cutter directly along the rectangle edge
- make sure the cutter is safe height
- move to the target
- the trailing blank line separates the cut blocks

    {SAFE_TRAVEL, FEEDRATE, PLUNGERATE} = require './lines.litcoffee'

    module.exports = (x, y, width, height, zstart, zend, stepheight=3, tab=0) ->
      steps = Math.ceil Math.abs(zstart-zend)/stepheight
      ret = """
      G0Z#{SAFE_TRAVEL}
      G0X#{x}Y#{y}
      G1F#{FEEDRATE}X#{x}Y#{y}
      G1Z#{zstart}

      """
      ({z: zstart + s*((zend-zstart)/steps), step: s} for s in [1..steps]).forEach (s) ->
        z = s.z
        ret += "G1X#{x}Y#{y}\n"
        ret += "G1Z#{z}\n"
        if tab and s.step >= steps-1
          ret += "G1X#{x+width/2-tab}\n"
          ret += "G0Z#{SAFE_TRAVEL}\n"
          ret += "G0X#{x+width/2+tab}\n"
          ret += "G1Z#{z}\n"
          ret += "G1X#{x+width}\n"
        else
          ret += "G1X#{x+width}\n"
        ret += "G1Y#{y+height}\n"
        if tab and s.step >= steps-1
          ret += "G1X#{x+width/2+tab}\n"
          ret += "G0Z#{SAFE_TRAVEL}\n"
          ret += "G0X#{x+width/2-tab}\n"
          ret += "G1Z#{z}\n"
          ret += "G1X#{x}\n"
        else
          ret += "G1X#{x}\n"
        ret += "Y#{y}\n"
        
      ret
