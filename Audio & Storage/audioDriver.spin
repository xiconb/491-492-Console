CON
    _clkmode = xtal1 + pll16x
    _xinfreq = 6_250_000
    delay = 100_000_000

    'pin selections for notCS, SCK, and SDI
    notCS = 16
    SCK = 17
    SDI = 18

OBJ
  Synth: "WavetableDemo"
  Terminal: "Parallax Serial Terminal"

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

    'loadBit(0)
    'loadBit(1)
    'loadBit(1)
    'loadBit(1)
    'loadBit(1)
    'loadBit(1)
    'loadBit(1)
    'loadBit(1)
    'loadBit(1)
    'loadBit(1)
    'loadBit(1)
    'loadBit(1)

    outa[notCS] := 1
    waitcnt(delay + cnt)

PUB setup
  dira[notCS] := 1
  dira[SCK] := 1
  dira[SDI] := 1

  outa[notCS] := 1
  waitcnt(delay / 100 + cnt)

PUB loadBit(bit)
  outa[SCK] := 0
  outa[SDI] := bit
  outa[SCK] := 1

PUB loadData(val) : success | numBits, i, mask, bit
'pass in a 3 digit hex value
'not working currently

  Terminal.start(115200)

  numBits := 12
  i := 0
  mask := $800

  repeat
    'bitmask out each bit from hex value

    bit := val & mask

    'log this to terminal
    Terminal.Str(string("bit number:"))
    Terminal.Dec(i)
    Terminal.NewLine
    Terminal.Str(string("value:"))
    Terminal.Dec(bit)
    Terminal.NewLine

    loadBit(bit)
    mask := mask >> 1

    i++
    if i == numBits
      return 1