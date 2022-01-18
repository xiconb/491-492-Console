{
    Author:  Steve

    Test/Demo program for Fat16DriverSpin.spin
}


CON
    _clkmode = xtal1 + pll16x
    _xinfreq = 6_250_000

    LED = 15

OBJ

    ser : "FullDuplexSerial"
    fat : "Fat16DriverSpin"
    lcd : "driver"

VAR
    byte buffer[512]

PUB Start

    dira[LED]~~
    outa[LED]~

    lcd.Start
    ser.Start(31, 30, 0, 115200)
    fat.Start

    ser.rx

    fat.OpenFile(string("WORDS_~1.TXT"))
    fat.ReadBlockFromFile(@buffer)
    DumpBlock(@buffer)

    outa[LED]~~

    repeat

PUB DumpBlock(address) | i, c

    i := 0
    repeat 32
        repeat 16
            ser.hex(byte[address][i++], 2)
        ser.str(string(" | "))
        i -= 16
        repeat 16
            if buffer[i] < $20
                ser.tx(".")
            else
                ser.tx(byte[address][i])
            i++
        ser.tx($0D)

