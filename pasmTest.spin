{{ assembly test }}

CON
    _clkmode = xtal1 + pll16x
    _xinfreq = 6_250_000

PUB Main
{ launch cog }

    cognew(@Toggle, 0)  'Lanches cog

DAT
{ toggle P16 }
            org     0   'Begin at cog RAM addr 0
Toggle      mov     dira, Pin   'Set pin as output
            mov     Time, cnt   'Calculate delay time
            add     Time, #9    'Set min delay
:loop       waitcnt Time, Delay 'Wait
            xor     outa, Pin   'Toggle pin
            jmp     #:loop      'Loop forever

Pin     long        1 << 15      'Pin number
Delay   long        30_000_000   'Num cycles to delay
Time    res 1       'System counter workspace