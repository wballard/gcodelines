Run the cutter this high during moves.

    SAFE_TRAVEL = 10.0


Cut a line with gcode. This will make multiple passes. A dedupe hash can help
you avoid multiple of the same line depending on your source program.
Cuts take the form:
 - assumes tabletop is Z0
 - make sure the cutter is safe height
 - move to the target
 - make multiple passes ramping in 1/4 depth each cut
 - the trailing blank line separates the cut blocks


    line = (x1, y1, x2, y2, depth, dedupe={}) ->
      if dedupe["#{x1},#{y1},#{x2},#{y2}"] or dedupe["#{x2},#{y2},#{x1},#{y1}"]
        return ""
      else
        dedupe["#{x1},#{y1},#{x2},#{y2}"]  = true
        dedupe["#{x2},#{y2},#{x1},#{y1}"] = true
        """
        G0Z#{depth+SAFE_TRAVEL}
        G0X#{x1}Y#{y1}
        G1F4000Z#{depth-1}
        G1F4000X#{x2}Y#{y2}Z#{depth-1}
        G1F4000X#{x1}Y#{y1}Z#{3*depth/4}
        G1F4000X#{x2}Y#{y2}Z#{3*depth/4}
        G1F4000X#{x1}Y#{y1}Z#{depth/2}
        G1F4000X#{x2}Y#{y2}Z#{depth/2}
        G1F4000X#{x1}Y#{y1}Z#{depth/4}
        G1F4000X#{x2}Y#{y2}Z#{depth/4}
        G1F4000X#{x1}Y#{y1}Z#{0}
        G1F4000X#{x2}Y#{y2}Z#{0}

        """


A followup line, this will make a second pass to clean up any splinters. I hope.
Similar to `line` this has an optional dedupe hash.
Cuts take the form:
 - assumes tabletop is Z0
 - make sure the cutter is safe height
 - move to the target
 - make a single pass at full depth
 - the trailing blank line separates the cut blocks

    followupLine = (x1, y1, x2, y2, depth, dedupe={}) ->
      if dedupe["#{x1},#{y1},#{x2},#{y2},followup"] or dedupe["#{x2},#{y2},#{x1},#{y1},followup"]
        return ""
      else
        dedupe["#{x1},#{y1},#{x2},#{y2},followup"] = true
        dedupe["#{x2},#{y2},#{x1},#{y1},followup"] = true
        """
        G0Z#{depth+SAFE_TRAVEL}
        G0X#{x1}Y#{y1}
        G1F4000Z#{0}
        G1F4000X#{x2}Y#{y2}Z#{0}
        G1F4000X#{x1}Y#{y1}Z#{0}

        """

    module.exports =
      line: line
      followupLine: followupLine
      SAFE_TRAVEL: SAFE_TRAVEL
