CON
    _clkmode = xtal1 + pll16x
    _xinfreq = 6_250_000

    LED = 15

OBJ
        pst : "Parallax Serial Terminal"
        fat : "Fat16DriverSpin"

VAR
    byte buffer[512]
    byte error

PUB Start : i

    dira[LED]~~
    outa[LED]~

    pst.Start(115200)
    error := fat.Start

    pst.Str(error)

    pst.CharIn

    fat.OpenFile(string("test.wav"))
    pst.Str(@msg)
    pst.newline

    fat.ReadBlockFromFile(@buffer)
    pst.Str(string("read block..."))
    pst.newline
    'DumpBlock(@buffer)

    outa[LED]~~


    'fat.ReadBlockFromFile(@buffer)

    repeat i from 0 to 512
      pst.hex(byte[buffer][i], 2)
      pst.newline

DAT
        msg byte "opened file...", 0