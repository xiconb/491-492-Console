#include <Arduino.h>

#define notCS 13
#define SCK 12
#define SDI 11

void setup() {
  // put your setup code here, to run once:
  pinMode(notCS,OUTPUT); // CS' load enable
  pinMode(SCK,OUTPUT); // SCK clock
  pinMode(SDI,OUTPUT); // SDI data

  digitalWrite(notCS,HIGH);
  delay(50);
}

void loadBit(uint8_t bit){
  digitalWrite(SCK,LOW);
  digitalWrite(SDI,bit);
  digitalWrite(SCK,HIGH);
}

// as is this is just writing a random DC value to the DAC
void loop() {
  // put your main code here, to run repeatedly:

  // begin programming
  digitalWrite(notCS,LOW);

  // config bits
  loadBit(LOW);
  loadBit(LOW);
  loadBit(HIGH);
  loadBit(HIGH);
  
  // data bits --> random value
  loadBit(LOW);
  loadBit(HIGH);
  loadBit(LOW);
  loadBit(HIGH);
  loadBit(LOW);
  loadBit(HIGH);
  loadBit(HIGH);
  loadBit(LOW);
  loadBit(HIGH);
  loadBit(LOW);
  loadBit(LOW);
  loadBit(HIGH);  

  digitalWrite(notCS,HIGH);
  delay(50);
//  exit(0);
}
