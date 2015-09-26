Run the cutter to produce a circle.

    {SAFE_TRAVEL} = require './lines.litcoffee'

    module.exports = (x, y, diameter, depth, start, cutterDiameter=0, steps=2) ->
      cutterDiameter = cutterDiameter or diameter
      step = depth / steps
      ret = """
      G0Z#{SAFE_TRAVEL}
      G0X#{x}Y#{y}
      G0Z#{start}

      """
      atDepth = start
      while atDepth > depth
        atDepth += step
        ret += """
        G1F1000Z#{atDepth}
        G0Z#{start}

        """

Multiple spirals as grbl has no P word to subdivide helix.

      if diameter > cutterDiameter
        atDepth = start
        while atDepth >= depth
          ret += """
          G17
          G0X#{x-diameter/2.0+cutterDiameter/2.0}Y#{y}
          G2F1000X#{x-diameter/2.0+cutterDiameter/2.0}Y#{y}Z#{atDepth}I#{diameter/2.0-cutterDiameter/2.0}

          """
          atDepth += step

And a final arc at the bottom depth to finish off.

        ret +=   """
        G2F1000X#{x-diameter/2.0+cutterDiameter/2.0}Y#{y}I#{diameter/2.0-cutterDiameter/2.0}

        """

All done.

      ret += """
      G0Z#{SAFE_TRAVEL}
      (end plunge #{x}, #{y}, #{depth}, #{steps})

      """
      ret
