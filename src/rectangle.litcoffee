Everyone's favorite shape! The rectangle, so much more than merely a square...
- runs the cutter directly along the rectangle edge
- make sure the cutter is safe height
- move to the target
- the trailing blank line separates the cut blocks

    {SAFE_TRAVEL} = require './lines.litcoffee'

    module.exports = (x, y, width, height, zstart, zend, stepheight=3, tab=false) ->
      steps = Math.ceil Math.abs(zstart-zend)/stepheight
      ret = """
      G0Z#{SAFE_TRAVEL}
      G0X#{x}Y#{y}
      G0Z#{zstart}

      """
      ({z: zstart + s*((zend-zstart)/steps), step: s} for s in [1..steps]).forEach (s) ->
        z = s.z
        ret += "G1F3000X#{x}Y#{y}\n"
        ret += "G1F3000Z#{z}\n"
        if tab and s.step is steps
          ret += "G1F3000X#{x+width/2-2*stepheight}Y#{y}Z#{z}\n"
          ret += "G0Z#{SAFE_TRAVEL}\n"
          ret += "G0X#{x+width/2+2*stepheight}Y#{y}\n"
          ret += "G1F3000Z#{z}\n"
          ret += "G1F3000X#{x+width}Y#{y}Z#{z}\n"
        else
          ret += "G1F3000X#{x+width}Y#{y}Z#{z}\n"
        ret += "G1F3000X#{x+width}Y#{y+height}Z#{z}\n"
        if tab and s.step is steps
          ret += "G1F3000X#{x+width/2+2*stepheight}Y#{y+height}Z#{z}\n"
          ret += "G0Z#{SAFE_TRAVEL}\n"
          ret += "G0X#{x+width/2-2*stepheight}Y#{y+height}\n"
          ret += "G1F3000Z#{z}\n"
          ret += "G1F3000X#{x}Y#{y+height}Z#{z}\n"
        else
          ret += "G1F3000X#{x}Y#{y+height}Z#{z}\n"
        ret += "G1F3000X#{x}Y#{y}Z#{z}\n"

      ret += "G0Z#{SAFE_TRAVEL}\n"
