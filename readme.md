```
Usage:
  mazecarver <width-mm> <height-mm> <depth-mm> <width-cells> <height-cells> [<mask>...]

Options:
  -h --help                show this help message and exit
  --version                show version and exit

Generates the gcode to carve a random maze panel, you should consider
610 1220 to do a normal 2x4 quarter sheet of ply.

The width and height also needs cells which you can vary to taste. With a
6.35mm cutter on a 1/2" quarter sheet, start with:
610 1220 12.7 30 60

Masking is specified in width/height coordinates from the lower-left
to the upper right comma separated coordinates like so:
10,10,100,100
This will treat any cells that intersect with these coordinates as unreachable
and will be held out of the maze generation. These are in cell coordinates,
not in mm.

Material top is Z0.



Usage:
  panel <width-mm> <height-mm> <thickness-mm> <width-cells>

Options:
  -h --help                show this help message and exit
  --version                show version and exit

Generates the gcode to carve a random panel, you should consider
610 1220 to do a normal 2x4 quarter sheet of ply.

The width and height also needs cells which you can vary to taste. With a
6.35mm cutter on a 1/2" quarter sheet, start with:
610 1220 12.7 30 60

This treats the tabletop as 0, makes it easier to cut through with sheets that
will warp a bit.

```
