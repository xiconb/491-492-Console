CON
    _clkmode = xtal1 + pll16x
    _xinfreq = 6_250_000

    'LED = 15

OBJ
        pst : "Parallax Serial Terminal"
        fat : "Fat16DriverSpin"

VAR
    byte buffer[512]
    byte error

PUB Start : i

    'dira[LED]~~
    'outa[LED]~

    pst.Start(115200)
    error := fat.Start

    pst.Str(error)

    pst.CharIn

    fat.OpenFile(string("test.wav"))
    pst.Str(string("opened file..."))
    pst.newline

    fat.ReadBlockFromFile(@buffer)
    pst.Str(string("read block..."))
    pst.newline
    'DumpBlock(@buffer)

    fat.ReadBlockFromFile(@buffer)

    'repeat i from 0 to 512
    '  pst.hex(byte[buffer][i], 2)
    '  pst.newline

    pst.Str(string("data start: "))
    pst.hex(byte[buffer][36], 2)
    pst.hex(byte[buffer][37], 2)
    pst.hex(byte[buffer][38], 2)
    pst.hex(byte[buffer][39], 2)
