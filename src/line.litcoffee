Cut a line with gcode. This will make multiple passes to create a great line.
Cuts take the form:
 - make sure the cutter is safe height
 - move to the target
 - make multiple passes in 1/4 depth each cut
 - the trailing blank line separates the cut blocks
 - this takes a bounding box to clip

    {SAFE_TRAVEL, FEEDRATE, PLUNGERATE} = require './lines.litcoffee'

    module.exports = (x1, y1, x2, y2, zstart, zend, stepheight=3) ->
      steps = Math.ceil Math.abs(zstart-zend)/stepheight
      ret = """
      G0Z#{SAFE_TRAVEL}
      G0X#{x1}Y#{y1}
      G0Z#{zstart}

      """
      (zstart + s*((zend-zstart)/steps) for s in [1..steps]).forEach (z) ->
        ret += """
        G1F#{FEEDRATE}X#{x2}Y#{y2}Z#{z}
        G1F#{FEEDRATE}X#{x1}Y#{y1}Z#{z}

        """
      ret += "G1F#{FEEDRATE}X#{x2}Y#{y2}Z#{zend}\n"
      ret += "G0Z#{SAFE_TRAVEL}\n"
