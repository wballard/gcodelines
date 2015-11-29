Run the cutter this high during moves.

    SAFE_TRAVEL = 10.0
    intersect = require 'wgs84-intersect-util'


Bound a line to a box. This clips any x or y that would be out of bounds to instead
be on the boundary.
- bounds: (x,y,width,height) style rectangle

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

Standard program suffix, safe and shutdown.

    suffix = ->
      """
      G0Z#{SAFE_TRAVEL}
      M5
      G0X0Y0

      M30

      """


Standard program prefix -- safe and power up.

    prefix = (cutterDiameter, speed)->
      speed = speed or 24000
      """
      (Cutter: #{cutterDiameter}mm)
      G0Z#{SAFE_TRAVEL}
      M3S#{speed}
      G04P#{speed/2000}
      G0X0Y0

      """

    module.exports =
      boundLineData: boundLineData
      suffix: suffix
      prefix: prefix
      SAFE_TRAVEL: SAFE_TRAVEL
      RPM: 18000
      FEEDRATE: 4000
      PLUNGERATE: 1000
