#include <simpletools.h>
#include <math.h>

#define NCS 16
#define SCK 17
#define SDI 18
#define LED 15

//struct __using("WavFileReader.spin");

int prop_init() {
    clkset(XTAL1 + PLL16X, 6250000);

    high(NCS);
    waitcnt(CLKFREQ + CNT);
}

void loadBit(short bit) {
    low(SCK);
    waitcnt(5 + CNT);
 
    if(bit) {
        high(SDI);
    }else{
        low(SDI);
    }
    high(SCK);
    waitcnt(5 + CNT);
}

void loadData(short val) {
    short i;
    short mask = 0x0800;

    // bit depth of 12
    for(i = 0; i < 12; i++) {
        short bit = val & mask;
        loadBit(bit);
        mask = mask >> 1;
    }
}

// 0 to 1 maps to 0 to Vref for the DAC
void runDemo() {
    short i, j;

	/*
	high(LED);
    waitcnt(CLKFREQ / 2 + CNT);
	low(LED);
	waitcnt(CLKFREQ / 2 + CNT);
	*/
	   		
	while(1) {
	    
        //high(LED);
        //waitcnt(CLKFREQ / 2 + CNT);
        //low(LED);

        low(NCS);
        waitcnt(5 + CNT);

        // config bits
        loadBit(0);
        loadBit(0);
        loadBit(1);
        loadBit(1);

        high(LED);
        waitcnt(CLKFREQ / 2 + CNT);
        low(LED);
        loadData(0x0EFF);

        high(NCS);
        waitcnt(5 + CNT);
	
	}
}

int main() {
	prop_init();

    high(LED);
    waitcnt(CLKFREQ / 2 + CNT);
    low(LED);
    waitcnt(CLKFREQ / 2 + CNT);
    
    // DEMO stuff
    runDemo();

	/* WIP
    short data = 0xFFF;

    gen_wavetable();

    while(1) {
        // low(NCS);

        // // config bits
        // loadBit(0);
        // loadBit(0);
        // loadBit(1);
        // loadBit(1);

        // loadData(0xEFF);
        // data = data >> 1;
        wavegen(400);

        // high(NCS);
	}
*/
	return 0;
    
}
