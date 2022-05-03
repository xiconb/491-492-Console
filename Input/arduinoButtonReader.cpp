#include <Arduino.h>

#define NPL 7
#define CLK 6
#define Q 5

/*
Updated to work with ports for better performance
*/

void setup() {
  // put your setup code here, to run once:
  pinMode(NPL, OUTPUT);
  pinMode(CLK, OUTPUT);
  pinMode(Q, INPUT);

  // PORTB |= 0b1 << NPL;
  // PORTB &= ~(0b1 << CLK);

  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  short reg = 0x00;

  // initial npl pulse
  PORTD &= ~(0b1 << NPL);
  delay(1);
  PORTD |= 0b1 << NPL;

  // PORTD |= 0b1 << CLK;
  // delay(1);
  // PORTD &= ~(0b1 << CLK);

  // read and pulse clk 8 times to get each value
  if(!(PIND & (0b1 << Q))) {
    reg |= 0x1;    
  } else {
    reg &= ~0x1;
  }

  PORTD |= 0b1 << CLK;
  delay(1);
  PORTD &= ~(0b1 << CLK);

  if(!(PIND & (0b1 << Q))) {
    reg |= 0x2;    
  } else {
    reg &= ~0x2;
  }

  PORTD |= 0b1 << CLK;
  delay(1);
  PORTD &= ~(0b1 << CLK);

  if(!(PIND & (0b1 << Q))) {
    reg |= 0x4;    
  } else {
    reg &= ~0x4;
  }

  PORTD |= 0b1 << CLK;
  delay(1);
  PORTD &= ~(0b1 << CLK);

  if(!(PIND & (0b1 << Q))) {
    reg |= 0x8;    
  } else {
    reg &= ~0x8;
  }

  PORTD |= 0b1 << CLK;
  delay(1);
  PORTD &= ~(0b1 << CLK);

  if(!(PIND & (0b1 << Q))) {
    reg |= 0x10;    
  } else {
    reg &= ~0x10;
  }

  PORTD |= 0b1 << CLK;
  delay(1);
  PORTD &= ~(0b1 << CLK);

  if(!(PIND & (0b1 << Q))) {
    reg |= 0x20;    
  } else {
    reg &= ~0x20;
  }

  PORTD |= 0b1 << CLK;
  delay(1);
  PORTD &= ~(0b1 << CLK);

  if(!(PIND & (0b1 << Q))) {
    reg |= 0x40;    
  } else {
    reg &= ~0x40;
  }

  PORTD |= 0b1 << CLK;
  delay(1);
  PORTD &= ~(0b1 << CLK);

  if(!(PIND & (0b1 << Q))) {
    reg |= 0x80;    
  } else {
    reg &= ~0x80;
  }

  PORTD |= 0b1 << CLK;
  delay(1);
  PORTD &= ~(0b1 << CLK);

  // Serial.printf("%x", reg);
  Serial.println(reg, BIN);
  delay(1000);

}