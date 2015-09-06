Run the cutter back and forth to create a pocket.

    {SAFE_TRAVEL} = require './lines.litcoffee'

    module.exports = (x, y, width, height, depth, cutterDiameter=1.0, steps=2.0) ->
      stepX = cutterDiameter / steps
      stepDepth = depth / steps

Safe cutter travel.

      ret = """

      G0Z#{SAFE_TRAVEL}

      """

Depth iteration loop. Take a bite at a time.

      atDepth = depth / 2.0
      while atDepth >= depth
        atBite = 0
        ret += """
        G0X#{x+cutterDiameter/2.0}Y#{y+cutterDiameter/2.0}
        G1F1000Z#{atDepth}

        """

This is the main loop, make a pocketing 'spiral', moving in toward the X
center until you cross the center point. Works becuase the cutter has some
actual width.

        while atBite <= width/2.0
          ret += """
          G1F4000X#{x+atBite+cutterDiameter/2.0}Y#{y+atBite+cutterDiameter/2.0}
          G1F4000Y#{y-atBite+height-cutterDiameter/2.0}
          G1F4000X#{x-atBite+width-cutterDiameter/2.0}
          G1F4000Y#{y+atBite+cutterDiameter/2.0}
          G1F4000X#{x+atBite+cutterDiameter/2.0}

          """
          atBite += stepX

        atDepth += stepDepth

      ret += """
      G0Z#{SAFE_TRAVEL}

      """

      ret
