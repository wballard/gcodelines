Everyone's favorite shape! The rectangle, so much more than merely a square...
- runs the cutter directly along the rectangle edge
- make sure the cutter is safe height
- move to the target
- the trailing blank line separates the cut blocks

    {SAFE_TRAVEL} = require './lines.litcoffee'

    module.exports = (x, y, width, height, zstart, zend, steps=4) ->
      ret = """
      G0Z#{SAFE_TRAVEL}
      G0X#{x}Y#{y}
      G0Z#{zstart}
      """
      (zstart + x*((zend-zstart)/steps) for x in [1..steps]).forEach (z) ->
        ret += """
          G1F3000X#{x}Y#{y}
          G1F3000X#{x+width}Y#{y}Z#{z}
          G1F3000X#{x+width}Y#{y+height}Z#{z}
          G1F3000X#{x}Y#{y+height}Z#{z}
          G1F3000X#{x}Y#{y}Z#{z}

        """
      ret += """
        G0Z#{SAFE_TRAVEL}

      """
      ret
