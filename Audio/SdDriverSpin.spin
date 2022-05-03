{
    Author:  Steve

    Beginning of an SD card driver for the sdmay22-04 project.
    Such things already exist but I needed to create one myself to better understand how it works and to optimize it.

    Work in progress.
}


CON

        CS      = 16
        MOSI    = 17
        SCLK    = 18
        MISO    = 19

PUB Start | r

    outa := 0
    outa[CS]~~
    outa[MOSI]~~
    outa[SCLK]~

    dira[CS]~~
    dira[MOSI]~~
    dira[SCLK]~~
    dira[MISO]~

    waitcnt(cnt + 10_000_000)   ' wait 100 ms

    repeat 80                   ' send 74+ clocks while CS and MOSI are high
        outa[SCLK]~~
        outa[SCLK]~

    outa[CS]~                   ' assert CS (active low)

    SendCommand(0, 0)           ' command 0 -- initialize
    repeat
        r := ReadR1
    until r == $01              ' $01 -- idle state flag set

    repeat                      ' send ACMD41 until response is $00
        SendCommand(55, 0)
        repeat
            r := ReadR1
        until r == $01          ' should still be in idle state

        SendCommand(41, $00_00_00_00)
        r := ReadR1

    until r == $00              ' $00 -- out of idle state, i.e., ready

    SendCommand(16, 512)        ' command 16 -- set block size to 512 bytes per block
    repeat
        r := ReadR1
    until r == $00

PUB SendByte(b)

    repeat 8
        outa[MOSI] := b >> 7
        outa[SCLK]~~
        b <<= 1
        outa[SCLK]~

PUB SendCommand(command, argument)

    command |= $40              ' all commands have bit 6 set
    SendByte(command)
    SendByte(argument >> 24)
    SendByte(argument >> 16)
    SendByte(argument >>  8)
    SendByte(argument >>  0)
    SendByte($95)               ' the first command (CMD0) needs a CRC of $95, afterwards it doesn't matter so just leave it here

PUB ReadByte : r

    outa[MOSI]~~
    r := 0
    repeat 8
        r <<= 1
        r |= ina[MISO]
        outa[SCLK]~~
        outa[SCLK]~

PUB ReadR1 : r

    repeat
        r := ReadByte
    while r == $FF

PUB WriteBlock(address, buffer) | r

    SendCommand(24, address)    ' command 24 -- write block
    r := ReadR1
    if r <> $00
        repeat

    SendByte($FE)               ' $FE -- data token
    repeat r from 0 to 511      ' send 512 bytes
        SendByte(byte[buffer][r])

    r := ReadR1
    r &= $1F                    ' only lower 5 bits valid
    if r == $05                 ' $05 -- data accepted
        repeat
            r := ReadByte
        while r == $00

PUB ReadBlock(buffer, address) | r

    SendCommand(17, address)    ' command 17 -- read block
    r := ReadR1
    if r <> $00
        repeat

    repeat
        r := ReadByte
    until r == $FE              ' $FE -- data token
    repeat r from 0 to 511      ' read 512 bytes
        byte[buffer][r] := ReadByte
    repeat 2                    ' read two CRC bytes and discard
        r := ReadByte