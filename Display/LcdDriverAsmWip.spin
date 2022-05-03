CON
        dnc = 10
        nwr = 9
        nrd = 8
        nres = 11
        db8 = 0

PUB Start

    cognew(@Main, @initializationList)

DAT

initializationList
                word $0011
				word $0026,$0204
				word $00F2,$0200
                word $00b1,$020A,$0214
				word $00C0,$020A,$0200
                word $00C1,$0202
                word $00C5,$022F,$023E
                word $00C7,$0240
                word $002A,$0200,$0200,$0200,$027F
                word $002B,$0200,$0200,$0200,$029F
                word $0036,$02c8
                word $003A,$0206
                word $0029,$01a4,$01a1
                word $002c

DAT
                org 0                      'Start at address 0
Main
                mov     outa, outs         'Set nwr and nrd according to outs
                mov     dira, dirs         'Set direction of pins according to dirs

                mov     delayCount, cnt            'Set the delayCount register to the current count
                add     delayCount, delay100us     'Add the value is delay100us to delayCount
                waitcnt delayCount, delay10us      'wait for the system counter to reach current delayCount then add delay10us to value

                or      outa, nresMask             'Set the reset bit with nresMask and get rid of rest in outa as it is bitwise
                waitcnt delayCount, delay100us     'Wait for the system counter to reach current delayCount which is 10us ahead then prep for next waitcnt

                movs    outa, #$011                'Set the first 9 bits to 000010001
                andn    outa, nwrMask              'Bitwise AND with not of nwrMask
                or      outa, nwrMask              'Bitwise OR with nwrMask
                waitcnt delayCount, delay100us     'Wait until the delayCount which is 100us and set for next waitcnt

                mov     r0, par                    'Move the address of the parameter register into r0. This contains the init list
:initLoop                                          'Setup the init loop
                rdword  r1, r0  wz                 'Read the word at r0 and set Z to 1 if the value is 0, set to 0 otherwise
        if_z    jmp     #:skip                     'If the value of Z reaches 1, jump to the skip label
                test    r1, #$100  wz              'Set Z to 1 if the value in r1 bitwise AND with 0001.0000.0000 is 0
        if_nz   or      outa, dncMask              'If the value of Z is 0, bitwise pins with dncMask to toggle dnc pin
                movs    outa, r1                   'Set the value of the pins to the value of r1 for the first 9 bits
                andn    outa, nwrMask              'Toggle nwr
                or      outa, nwrMask
                andn    outa, dncMask              'Toggle dnc pin
                add     r0, #2                     '
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
                xor	blue, #$FF


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

pixelCount      long    128*160

delayCount      res     1
r0              res     1
r1              res     1
r2              res     1
r3              res     1

red             res     1
green           res     1
blue            res     1
