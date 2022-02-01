CON

  _CLKMODE = XTAL1 + PLL16X
  _XINFREQ = 6_250_000

  delay = 100_000_000
  pin   = 15

VAR

OBJ

PUB Main

    dira[pin] := 1
    outa[pin] := 0

    repeat
        waitcnt(delay + cnt)
        !outa[pin]
        waitcnt(delay + cnt)
        !outa[pin]