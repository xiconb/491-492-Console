#include <Arduino.h>

#define NCS 13
#define SCK 12
#define SDI 11
#define OUT A0

// 40kHz sample rate
// 25us delay time
short sinTable[360];

void generateTable() {
  for(int i=0; i<360; i++) {
    sinTable[i] = (short) ((sin(i * PI / 180.0) * 2048.0) + 2048);
  }
}

void setup() {
  Serial.begin(9600);
  
  // put your setup code here, to run once:
  pinMode(NCS,OUTPUT); // CS' load enable
  pinMode(SCK,OUTPUT); // SCK clock
  pinMode(SDI,OUTPUT); // SDI data
  pinMode(OUT,INPUT);

  digitalWrite(NCS,HIGH);
  delay(1);
}

void loadBit(char bit){
  digitalWrite(SCK,LOW);
  digitalWrite(SDI,bit);
  digitalWrite(SCK,HIGH);
}

void loadData(short data) {
  short mask = 0x0800;

  for(int i=0; i<12; i++) {
    if(mask & data) {
      loadBit(HIGH);
    }else{
      loadBit(LOW);
    }

    mask = mask >> 1;
  }
}

void loop() {
  // put your main code here, to run repeatedly:
  generateTable();

  // have to convert from range 0-100 to 0-Vref (in step of 2^12)
  for(int x=0; x<360; x++) {

    // begin programming
    digitalWrite(NCS,LOW);
  
    // config bits
    loadBit(LOW);
    loadBit(LOW);
    loadBit(HIGH);
    loadBit(HIGH);
    
    // data bits --> random value
    loadData(sinTable[x]);  
  
    digitalWrite(NCS,HIGH);
  
    // view on serial plotter
    int val = analogRead(OUT);
    Serial.println(val, 1);
    delayMicroseconds(10);

//    Serial.println(sinTable[x]);
  }
  return;
}
