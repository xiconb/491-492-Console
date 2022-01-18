CON
        dnc = 9
        nwr = 10
        nrd = 11
        nres = 12
        db8 = 0

PUB Start

    cognew(@Main, @initializationList)

DAT

initializationList
                word $0036,$0180
                word $003a,$0166
                word $0021
                word $00b2,$010c,$010c,$0100,$0133,$0133
                word $00b7,$0135
                word $00bb,$012b
                word $00c0,$012c
                word $00c2,$0101,$01ff
                word $00c3,$0111
                word $00c4,$0120
                word $00c6,$010f
                word $00d0,$01a4,$01a1
                word $00e0,$01d0,$0100,$0105,$010e,$0115,$010d,$0137,$0143,$0147,$0109,$0115,$0112,$0116,$0119
                word $00e1,$01d0,$0100,$0105,$010d,$010c,$0106,$012d,$0144,$0140,$010e,$011c,$0118,$0116,$0119
                word $002a,$0100,$0100,$0100,$01ef
                word $002b,$0100,$0100,$0101,$013f
                word $0000

DAT
                org 0
Main
                mov     outa, outs
                mov     dira, dirs

                mov     delayCount, cnt
                add     delayCount, delay100us
                waitcnt delayCount, delay10us

                or      outa, nresMask
                waitcnt delayCount, delay100us

                movs    outa, #$011
                andn    outa, nwrMask
                or      outa, nwrMask
                waitcnt delayCount, delay100us

                mov     r0, par
:initLoop
                rdword  r1, r0  wz
        if_z    jmp     #:skip
                test    r1, #$100  wz
        if_nz   or      outa, dncMask
                movs    outa, r1
                andn    outa, nwrMask
                or      outa, nwrMask
                andn    outa, dncMask
                add     r0, #2
                jmp     #:initLoop
:skip

                mov     delayCount, delay100us
                add     delayCount, cnt
                waitcnt delayCount, delay10us
                movs    outa, #$29
                andn    outa, nwrMask
                or      outa, nwrMask

:infinity
                movs    outa, #$2C
                andn    outa, nwrMask
                or      outa, nwrMask

                or      outa, dncMask

                mov     red, #$FF
                mov     green, #$00
                mov     blue, #$00

                mov     r0, pixelCount
:pixelLoop
                movs    outa, red
                andn    outa, nwrMask
                or      outa, nwrMask
                movs    outa, green
                andn    outa, nwrMask
                or      outa, nwrMask
                movs    outa, blue
                andn    outa, nwrMask
                or      outa, nwrMask

                djnz    r0, #:pixelLoop

                xor     red, #$FF
                xor     green, #$FF
                xor     blue, #$FF

                mov     r0, pixelCount
:pixelLoop2
                movs    outa, red
                andn    outa, nwrMask
                or      outa, nwrMask
                movs    outa, green
                andn    outa, nwrMask
                or      outa, nwrMask
                movs    outa, blue
                andn    outa, nwrMask
                or      outa, nwrMask

                djnz    r0, #:pixelLoop2

                jmp     #:infinity


dirs            long    %00000000_00000000_00011111_11111111
outs            long    %00000000_00000000_00001100_00000000

dncMask         long    1 << dnc
nwrMask         long    1 << nwr
nrdMask         long    1 << nrd
nresMask        long    1 << nres

delay1us        long    100
delay10us       long    1_000
delay100us      long    10_000

pixelCount      long    240*320

delayCount      res     1
r0              res     1
r1              res     1
r2              res     1
r3              res     1

red             res     1
green           res     1
blue            res     1
