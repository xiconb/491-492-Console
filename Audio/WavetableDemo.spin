CON 'wavetable constants'

  _CLKMODE = XTAL1 + PLL16X
  _XINFREQ = 6_250_000
  sampleRate = 1000
  time = 1
  length = 64

DAT
'putting sine table in this block

        wavetable
              word %000000000

OBJ
  term: "Parallax Serial Terminal"
  math: "Float32Full" 'use this for slow operations for the demo lol

VAR 'wavetable vars

  long output[sampleRate * time]
  byte i

PUB genWavetable | index
  term.start(115200)
  math.start
  waitcnt(clkfreq*3 + cnt)

  term.str(string("starting table assignment:"))
  term.newline
  repeat i from 0 to 64 'this doesn't work because we need a floating-point input
    wavetable[i] := math.sin(index)

  repeat i from 0 to length
    term.bin(wavetable[i], 32)
    term.newline
    waitcnt(clkfreq/4 + cnt)

  math.stop
  return wavetable

PUB wavegen(f) | i_inc 'don't use this for now

  genWavetable

  i := 0
  i_inc := math.fmul(f, math.fdiv(length,sampleRate))

  repeat i from 0 to sampleRate*time
    output[i] := wavetable[math.ftrunc(i)]
    i += i_inc
    i += math.fmod(i, length)

  return output

