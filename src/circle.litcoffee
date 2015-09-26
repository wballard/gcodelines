Run the cutter to produce a circle.

    {SAFE_TRAVEL} = require './lines.litcoffee'

    module.exports = (x, y, diameter, depth, start, cutterDiameter=0) ->
       """

       G0Z#{SAFE_TRAVEL}
       G0X#{x}Y#{y}
       G0Z#{start}
       G0X#{x-diameter/2.0+cutterDiameter/2.0}Y#{y}
       G1F1000Z#{depth}
       G2F3000I#{diameter/2.0-cutterDiameter/2.0}
       G0Z#{SAFE_TRAVEL}

       """
