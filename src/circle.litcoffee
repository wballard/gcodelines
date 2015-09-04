Run the cutter to produce a circle.

    {SAFE_TRAVEL} = require './lines.litcoffee'

    module.exports = (x, y, diameter, depth, cutterDiameter=0) ->
       """

       G0Z#{SAFE_TRAVEL}
       G0X#{x}Y#{y}
       G0X#{x-diameter/2.0+cutterDiameter/2.0}Y#{y}
       G1F1000Z#{depth}
       G2F4000I#{diameter/2.0-cutterDiameter/2.0}
       G0Z#{SAFE_TRAVEL}

       """
