{
    Author:  Steve

    Test/Demo program for SdDriverSpin.spin
}


CON
        _clkmode = xtal1 + pll16x
        _xinfreq = 6_250_000

        LED = 15

OBJ

    ser : "FullDuplexSerial"
    sd  : "SdDriverSpin"

VAR
    byte buffer[512]

PUB Start | r

    dira[LED]~~

    ser.Start(31, 30, 0, 115200)
    sd.Start

    ser.rx

    longfill(@buffer, 0, 128)
    bytemove(@buffer, @str1, strsize(@str1))
    buffer[strsize(@str1)] := 0

    ser.str(@strWriting)
    sd.WriteBlock($00_0000, @buffer)
    ser.str(@strDone)
    ser.tx($0D)

    longfill(@buffer, 0, 128)
    ser.str(@strReading)
    sd.ReadBlock(@buffer, $00_0000)
    ser.str(@strDone)
    ser.tx($0D)

    ser.str(@buffer)

    outa[LED]~~

    repeat

DAT

str1        byte "The quick brown fox jumped over the lazy dog.", 0
strWriting  byte "Writing...", 0
strReading  byte "Reading...", 0
strDone     byte "Done.", 0
