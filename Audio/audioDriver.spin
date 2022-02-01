CON
    _clkmode = xtal1 + pll16x
    _xinfreq = 6_250_000

    'pin selections for notCS, SCK, and SDI
    notCS = 13
    SCK = 12
    SDI = 11

PUB Main
'Port of our Arduino driver to Spin

  setup

  repeat

    outa[notCS] := 0

    'config bits
    loadBit(0)
    loadBit(0)
    loadBit(1)
    loadBit(1)

    'data bits
    'current val = 1/2 of max
    loadData($7ff)
    'now that we can easily send a data packet, we can
    'tidy up and send a complex signal to the dac

    outa[notCS] := 1
    waitcnt(_xinfreq / 1000 + cnt)

PUB setup
  dira[notCS] := 1
  dira[SCK] := 1
  dira[SDI] := 1

  outa[notCS] := 1
  waitcnt(_xinfreq + cnt)

PUB loadBit(bit)
  outa[SCK] := 0
  outa[SDI] := bit
  outa[SCK] := 1

PUB loadData(val) : success | numBits, i, mask, bit
'pass in a 3 digit hex value

  numBits := 12
  i := 0
  mask := $800

  repeat
    'bitmask out each bit from hex value

    bit := val & mask
    if bit == 0
      bit := 0
    else
      bit := 1

    loadBit(bit)
    mask := mask >> 1

    i := i++
    if i == numBits
      return 1

