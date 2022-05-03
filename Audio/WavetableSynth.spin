CON 'wavetable constants'

  _CLKMODE = XTAL1 + PLL16X
  _XINFREQ = 6_250_000
  sampleRate = 44100
  time = 3

'as is right now, this is printing 64 sine values from the Prop's table
'need to extend this to work with the driver to be mega fast

OBJ
  term: "Parallax Serial Terminal"
  math: "FloatMath" 'use floatmath for fast operations; will need to use this
  'when porting to assembly if Spin is too slow?

VAR 'wavetable vars

  long wavetable[64]
  byte i

PUB genWavetable | angle, sine
  term.start(115200)
  waitcnt(clkfreq*3+cnt)
  i := 0

  repeat angle from 0 to 8064 step 128  ' step through the angles represnting circle, 360 degrees
    sine:=fullsine0(angle)   ' this does the lookup in the hub sine table and adjust for quadrant

    ' show results...
    term.dec(angle)
    term.chars(32,5)

    term.dec(angle>>11)   ' quadrant
    term.chars(32,5)
    term.dec(sine)         ' returned sine value, range -65535 to 65535

    sine := 20000 ** (sine << 15)  ' convert to decimal, 4 digits
    term.chars(32,5)
    term.dec(sine/10000)
    term.char(".")
    term.dec(sine//10000)

    term.newline
    waitcnt(clkfreq/2+cnt)

PUB fullsine0(angle) | q                                ' angle is 13 bits, 0 to 360 degrees
  q := angle >> 11                                      ' quadrant, 0 to 3
  angle := (angle & $7ff) << 1                          ' 0 to 90- degrees, adjust to 11 bits
  case q                                                ' by quadrant, shift for word address
    0 : result := word[$E000 + angle]                       '
    1 : result := word[$F000 - angle]
    2 : result := -word[$E000 + angle]
    3 : result := -word[$F000 - angle]