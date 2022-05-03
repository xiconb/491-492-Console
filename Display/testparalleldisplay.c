#include <propeller.h>
#include "simpletools.h"


#define ncs 12
#define nrst 11
#define dnc 10
#define nwr 9
#define nrd 8
#define led 15

void init(void)
{        
	OUTA &= ~(1 << ncs);
	OUTA |= (1 << nrd);
	OUTA &= ~(1 << nwr);
	OUTA &= ~(1 << nrst);
	
	waitcnt(CLKFREQ + CNT);
	OUTA |= (1 << nrst);
	waitcnt(CLKFREQ + CNT);
	
	command(0x11);
	
	waitcnt(CLKFREQ + CNT);

        OUTA |= (1 << led);
        waitcnt(CLKFREQ + CNT);
        OUTA &= ~(1 << led);

	command(0x26);data(0x04);
	command(0xF2);data(0x00);
	command(0xB1);data(0x0A);data(0x14);
	command(0xC0);data(0x0A);data(0x00);
	command(0xC1);data(0x02);
	command(0xC5);data(0x2F);data(0x3E);
	command(0xC7);data(0x40);
	command(0x2A);
	data(0x00);
	data(0x00);
	data(0x00);
	data(0x7F);
	command(0x2B);
	data(0x00);
	data(0x00);
	data(0x00);
	data(0x9F);
	command(0x36);data(0xc8);
	command(0x3A);data(0x06);
	command(0x29);
	command(0x2C);
}
/***************************************************************************************/
void command(unsigned char command)
{
	OUTA &= ~(1 << dnc);
	//OUTA |= command;
	unsigned int andMask = -1;
  	andMask <<= (24);
  	andMask >>= (24);
  	andMask = ~andMask;
  	unsigned int orMask = command;
	//OUTA |= data1;
	OUTA = (OUTA & andMask) | orMask;
	OUTA &= ~(1 << nwr);
	OUTA |= (1 << nwr);
}
/***************************************************************************************/
void data(unsigned char data1)
{
	OUTA |= (1 << dnc);
	unsigned int andMask = -1;
  	andMask <<= (24);
  	andMask >>= (24);
  	andMask = ~andMask;
  	unsigned int orMask = data1;
	//OUTA |= data1;
	OUTA = (OUTA & andMask) | orMask;
	OUTA &= ~(1 << nwr);
	OUTA |= (1 << nwr);
}

void window_set(unsigned s_x, unsigned e_x, unsigned s_y, unsigned e_y)
{
  command(0x2a);      //SET column address
  OUTA |= (1 << nrst);;
  data((s_x)>>8);     //SET start column address
  data(s_x);
  data((e_x)>>8);     //SET end column address
  data(e_x);
  
  command(0x2b);      //SET page address
  OUTA |= (1 << nrst);;
  data((s_y)>>8);     //SET start page address
  data(s_y);
  data((e_y)>>8);     //SET end page address
  data(e_y);
}
//--------------------------------------------------------------------------


//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//  Border + Fill Interior (Full Screen)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
void disp2()
{
  unsigned int i,j;
  window_set(0,127,0,0);      //Border on Bottom 
  command(0x2C);              //command to begin writing to frame memory
  OUTA |= (1 << nrst);;
  for(i=0;i<128;i++)                
  {
    for (j=0;j<1;j++)                
    {
    data(0xFF);
    data(0xFF);
    data(0xFF);
    }
  }
  waitcnt(CLKFREQ + CNT);
  window_set(0,0,0,159);      //Border on Left side
  command(0x2C);
  OUTA |= (1 << nrst);;
  for(i=0;i<1;i++)                 
  {
    for (j=0;j<160;j++)                
    {
    data(0xFF);
    data(0xFF);
    data(0xFF);
    }
  }
  waitcnt(CLKFREQ + CNT);
  window_set(0,127,159,159);  //Border on Top
  command(0x2C);
  OUTA |= (1 << nrst);;
  for(i=0;i<128;i++)               
  {
    for (j=0;j<1;j++)                
    {
    data(0xFF);
    data(0xFF);
    data(0xFF);
    }
  }
  waitcnt(CLKFREQ + CNT);
  window_set(127,127,0,159);  //Border on Right side
  command(0x2C);
  OUTA |= (1 << nrst);;
  for(i=0;i<1;i++)
  {
    for (j=0;j<160;j++)                
    {
    data(0xFF);
    data(0xFF);
    data(0xFF);
    }
  }
  waitcnt(CLKFREQ + CNT);
  window_set(1,126,1,158);    //Fill Interior Section of Display with Gray Pixels
  command(0x2C);
  OUTA |= (1 << nrst);;
  for(i=0;i<126;i++)
  {
    for (j=0;j<158;j++)                
    {
    data(0x80);
    data(0x80);
    data(0x80);
    }
  }
   waitcnt(CLKFREQ + CNT);
}
//--------------------------------------------------------------------------

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//  Fill Screen (Full Screen)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
void disp3()
{
  unsigned int i; 
  window_set(0,127,0,159);
  command(0x2C);              //command to begin writing to frame memory
  OUTA |= (1 << nrst);;
        for(i=0;i<20480;i++)  //fill screen with black pixels
  {
            data(0x00);
            data(0x00);
            data(0x00);
  }
  window_set(0,127,0,159);
  command(0x2C);
  OUTA |= (1 << nrst);;
        for(i=0;i<20480;i++)   //fill screen with red pixels
  {
            data(0x00);
            data(0x00);
            data(0xFF);
  }
  waitcnt(CLKFREQ + CNT);
  window_set(0,127,0,159);
  command(0x2C);
  OUTA |= (1 << nrst);;
        for(i=0;i<20480;i++)   //fill screen with green pixels
  {
            data(0x00);
            data(0xFF);
            data(0x00);
  }
  waitcnt(CLKFREQ + CNT);
  window_set(0,127,0,159);
  command(0x2C);
  OUTA |= (1 << nrst);;
        for(i=0;i<20480;i++)   //fill screen with blue pixels
  {
            data(0xFF);
            data(0x00);
            data(0x00);
  }
  waitcnt(CLKFREQ + CNT);
}

int main()
{
        clkset(XTAL1 + PLL16X, 6250000);
        DIRA |= 0xFFFF;
        OUTA |= (1 << led);
        waitcnt(CLKFREQ + CNT);
        OUTA &= ~(1 << led);
        init();
        
        
        command(0x2C);
        
        while(1){
    		disp3();
    		disp2();
    	}
}
