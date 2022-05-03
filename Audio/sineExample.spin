CON
  _CLKMODE = XTAL1 + PLL16X
  _XINFREQ = 6_250_000

OBJ
  pst : "parallax serial terminal"

PUB basicSine | angle, sine
  pst.start(115200)
  waitcnt(clkfreq/10+cnt)
  pst.str(string("top",13))
  repeat angle from 0 to 8192 step 256  ' step through the angles represnting circle, 360 degrees
    sine:=fullsine0(angle)   ' this does the lookup in the hub sine table and adjust for quadrant

    ' show results...
    pst.dec(angle)
    pst.chars(32,5)
    pst.dec(angle>>11)   ' quadrant
    pst.chars(32,5)
    pst.dec(sine)         ' returned sine value, range -65535 to 65535    pst.chars(32,5)
    sine := 20000 ** (sine << 15)  ' convert to decimal, 4 digits
    pst.chars(32,5)
    pst.dec(sine/10000)
    pst.char(".")
    pst.dec(sine//10000)
    pst.char(13)
    waitcnt(clkfreq/5+cnt)

PUB fullsine0(angle) | q                                ' angle is 13 bits, 0 to 360 degrees
  q := angle >> 11                                      ' quadrant, 0 to 3
  angle := (angle & $7ff) << 1                          ' 0 to 90- degrees, adjust to 11 bits
  case q                                                ' by quadrant, shift for word address
    0 : result := word[$E000 + angle]                       '
    1 : result := word[$F000 - angle]
    2 : result := -word[$E000 + angle]
    3 : result := -word[$F000 - angle]
