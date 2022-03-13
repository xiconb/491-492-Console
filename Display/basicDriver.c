#include <simpletools.h>

#define ncs 0
#define nrs 1
#define sdio 2
#define scl 3
#define led 15

void command(unsigned char c) {
    low(ncs);
    low(sdio);
    low(scl);
    high(scl);
    low(scl);

    for(int i=0; i < 8; i++) {
        if((c & 0x80) == 0x80) {
            high(sdio);
        }else{
            low(sdio);
        }
        c = (c << 1);
        low(scl);
        high(scl);
        low(scl);
    }
    high(ncs);
}

void data(unsigned char d) {
    low(ncs);
    high(sdio);
    low(scl);
    high(scl);
    low(scl);

    for(int i=0; i < 8; i++) {
        if((d & 0x80) == 0x80) {
            high(sdio);
        }else{
            low(sdio);
        }
        d = (d << 1);
        low(scl);
        high(scl);
        low(scl);
    }
    high(ncs);
}

int main() {
    clkset(XTAL1 + PLL16X, 6250000);
    high(led);
    waitcnt(CLKFREQ + CNT);
    low(led);

    // set pins as outputs
    set_directions(0, 3, 0b1111);

    high(sdio);
    high(scl);
    low(nrs);
    waitcnt(CLKFREQ + CNT);
    high(nrs);
    waitcnt(CLKFREQ + CNT);
    command(0x11);
    waitcnt(CLKFREQ + CNT);
    command(0x28);
    command(0x26);
    data(0x04);

    command(0xb1);
    data(0x0a);
    data(0x14);

    command(0xc0);
    data(0x0a);
    data(0x00);

    command(0xc1);
    data(0x02);

    command(0xc5);
    data(0x2f);
    data(0x3e);

    command(0xc7);
    data(0x40);

    command(0x2a);
    data(0x00);

    data(0x00);
    data(0x00);

    data(0x7f);
    command(0x2b);
    data(0x00);
    data(0x00);
    data(0x00);
    data(0x9f);

    command(0x36);
    data(0xc0);
    command(0x3a);
    data(0x06);

    command(0x29);
    waitcnt(CLKFREQ + CNT);   
    
    command(0x2C);
    while(1){
    int i = 0;
    
    for(i = 0; i < 128*160; i++){
            data(0xFF);
            data(0x00);
            data(0xFF);
    }
    }
}
