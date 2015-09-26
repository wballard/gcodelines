Cut a line with gcode. This will make multiple passes to create a great line.
Cuts take the form:
 - make sure the cutter is safe height
 - move to the target
 - make multiple passes in 1/4 depth each cut
 - the trailing blank line separates the cut blocks
 - this takes a bounding box to clip

    {SAFE_TRAVEL} = require './lines.litcoffee'

    module.exports = (x1, y1, x2, y2, depth, start) ->
      """
      G0Z#{SAFE_TRAVEL}
      G0X#{x1}Y#{y1}
      G0Z#{start}
      G1F3000X#{x2}Y#{y2}Z#{depth/4}
      G1F3000X#{x1}Y#{y1}Z#{depth/2}
      G1F3000X#{x2}Y#{y2}Z#{3*depth/4}
      G1F3000X#{x1}Y#{y1}Z#{depth}
      G0Z#{SAFE_TRAVEL}

      """
