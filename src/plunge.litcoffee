Run the cutter to produce a circle.

    {SAFE_TRAVEL} = require './lines.litcoffee'

    module.exports = (x, y, diameter, depth, cutterDiameter=0) ->
      cutterDiameter = cutterDiameter or diameter
      """
      G0Z#{SAFE_TRAVEL}
      G0X#{x}Y#{y}
      G1F1000Z#{depth}
      G0Z#{SAFE_TRAVEL}

      G0X#{x-diameter/2.0+cutterDiameter/2.0}Y#{y}
      G17
      G2F1000Z#{depth}I#{diameter/2.0-cutterDiameter/2.0}P4
      G2F1000I#{diameter/2.0-cutterDiameter/2.0}
      G0Z#{SAFE_TRAVEL}

      """
