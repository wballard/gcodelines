Run the cutter this high during moves.

    SAFE_TRAVEL = 10.0

    intersect = require 'wgs84-intersect-util'


Bound a line to a box.

    boundLineData = (x1, y1, x2, y2, bounds) ->
      if bounds
        boundingBox = [bounds.x, bounds.y, bounds.x + bounds.width, bounds.y + bounds.height]
      else
        return {
          x1: x1
          y1: y1
          x2: x2
          y2: y2
        }
      boundedLine = intersect.intersectLineBBox {geometry: {type: "LineString", coordinates: [[x1,y1],[x2, y2]]}}, boundingBox
      if boundedLine.length is 2
        return {
          x1: boundedLine[0].coordinates[0]
          y1: boundedLine[0].coordinates[1]
          x2: boundedLine[1].coordinates[0]
          y2: boundedLine[1].coordinates[1]
        }
      else if Math.min(x1, x2) >= boundingBox[0] and Math.min(y1, y2) >= boundingBox[1] and Math.max(x1, x2) <= boundingBox[2] and Math.max(y1, y2) <= boundingBox[3]
        return {
          x1: x1
          y1: y1
          x2: x2
          y2: y2
        }
      else
        return {
          x1: undefined
          y1: undefined
          x2: undefined
          y2: undefined
        }


Core line rendering function.

    coreLine = (x1, y1, x2, y2, depth, dedupe, bounds, render) ->
      {x1, y1, x2, y2} = boundLineData x1, y1, x2, y2, bounds
      if dedupe["#{x1},#{y1},#{x2},#{y2}"] or dedupe["#{x2},#{y2},#{x1},#{y1}"]
        return ""
      else
        if x1? and y1? and x2? and y2?
          return render x1, y1, x2, y2, depth
        else
          ""

Cut a line with gcode. This will make multiple passes. A dedupe hash can help
you avoid multiple of the same line depending on your source program.
Cuts take the form:
 - assumes tabletop is Z0
 - make sure the cutter is safe height
 - move to the target
 - make multiple passes ramping in 1/4 depth each cut
 - the trailing blank line separates the cut blocks
 - this takes a bounding box to clip

    line = (x1, y1, x2, y2, depth, dedupe={}, bounds) ->
      coreLine x1, y1, x2, y2, depth, dedupe, bounds, (x1, y1, x2, y2, depth) ->
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
        G0Z#{depth+SAFE_TRAVEL}

        """


A followup line, this will make a second pass to clean up any splinters. I hope.
Similar to `line` this has an optional dedupe hash.
Cuts take the form:
 - assumes tabletop is Z0
 - make sure the cutter is safe height
 - move to the target
 - make a single pass at full depth
 - the trailing blank line separates the cut blocks

    followupLine = (x1, y1, x2, y2, depth, dedupe={}, bounds) ->
      coreLine x1, y1, x2, y2, depth, dedupe, bounds, (x1, y1, x2, y2, depth) ->
        """"
        G0Z#{depth+SAFE_TRAVEL}
        G0X#{x1}Y#{y1}
        G1F4000Z#{0}
        G1F4000X#{x2}Y#{y2}Z#{0}
        G1F4000X#{x1}Y#{y1}Z#{0}
        G0Z#{depth+SAFE_TRAVEL}

        """


Everyone's favorite shape! The rectangle, so much more than merely a square...
- assumes tabletop is Z0
- make sure the cutter is safe height
- move to the target
- make multiple passes stepping in 1/4 depth each cut
- the trailing blank line separates the cut blocks

    rectangle = (x, y, width, height, depth) ->
      ret = """
      G0Z#{depth+SAFE_TRAVEL}
      G0X#{x}Y#{y}
      """
      [depth-1, 3*(depth/4), depth/2, depth/4, 0].forEach (z) ->
        ret += """
          G1F4000X#{x}Y#{y}Z#{z}
          G1F4000X#{x+width}Y#{y}Z#{z}
          G1F4000X#{x+width}Y#{y+height}Z#{z}
          G1F4000X#{x}Y#{y+height}Z#{z}
          G1F4000X#{x}Y#{y}Z#{z}
        """
      ret += """
        G0Z#{depth+SAFE_TRAVEL}

      """
      ret

    module.exports =
      line: line
      boundLineData: boundLineData
      followupLine: followupLine
      rectangle: rectangle
      SAFE_TRAVEL: SAFE_TRAVEL
