CON
        _clkmode = xtal1 + pll16x
        _xinfreq = 6_250_000

        ncs = 8
        dnc = 9
        nwr = 10
        nrd = 11
        nres = 12
        db8 = 0

PUB Main
  dira := %00000000_00000000_00011111_11111111
  initDisplay
  repeat
    'writeCommand($a5)
    'writeCommand($2C)
    'repeat 320*240
      'writeData($FF)
      'writeData(0)
      'writeData($FF)

PUB writeCommand (command)
  outa[7..0] := command
  outa[dnc] := 0
  outa[nwr] := 0
  waitcnt(10000 + cnt)
  outa[nwr] := 1
  waitcnt(1000 + cnt)

PUB writeData (data)
  outa[7..0] := data
  outa[dnc] := 1
  outa[nwr] := 0
  waitcnt(1000 + cnt)
  outa[nwr] := 1
  waitcnt(1000 + cnt)

PUB initDisplay
  outa[ncs] := 0
  outa[nrd] := 1
  outa[nwr] := 1

  outa[nres] := 0
  waitcnt(100000 + cnt)
  outa[nres] := 1
  waitcnt(10000 + cnt)
  writeCommand($0011)
  waitcnt(100_000 + cnt)

  writeCommand($0036)
  writeData($0080)

  writeCommand($003a)
  writeData($0066)

  writeCommand($0021)

  writeCommand($00b2)
  writeData($000c)
  writeData($0c)
  writeData($00)
  writeData($33)
  writeData($33)

  writeCommand($00b7)
  writeData($0035)

  writeCommand($00bb)
  writeData($002b)

  writeCommand($00c0)
  writeData($002c)

  writeCommand($00c2)
  writeData($0001)
  writeData($ff)

  writeCommand($00c3)
  writeData($0011)

  writeCommand($00c4)
  writeData($0020)

  writeCommand($00c6)
  writeData($000f)

  writeCommand($00d0)
  writeData($00a4)
  writeData($a1)

  writeCommand($00e0)
  writeData($00d0)
  writeData($0000)
  writeData($0005)
  writeData($000e)
  writeData($0015)
  writeData($000d)
  writeData($0037)
  writeData($0043)
  writeData($0047)
  writeData($0009)
  writeData($0015)
  writeData($0012)
  writeData($0016)
  writeData($0019)

  writeCommand($00e1)
  writeData($00d0)
  writeData($0000)
  writeData($0005)
  writeData($000d)
  writeData($000c)
  writeData($0006)
  writeData($002d)
  writeData($0044)
  writeData($0040)
  writeData($000e)
  writeData($001c)
  writeData($0018)
  writeData($0016)
  writeData($0019)

  writeCommand($002a)
  writeData($0000)
  writeData($0000)
  writeData($0000)
  writeData($00ef)

  writeCommand($002b)
  writeData($0000)
  writeData($0000)
  writeData($0001)
  writeData($003f)

  waitcnt(100000 + cnt)

  writeCommand($0029)
