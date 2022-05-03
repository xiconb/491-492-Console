#include <Arduino.h>
#include <SPI.h>
#include <SD.h>

File root, test;

void printDirectory(File dir, int numTabs) {
  while (true) {

    File entry =  dir.openNextFile();
    if (! entry) {
      // no more files
      break;
    }
    for (uint8_t i = 0; i < numTabs; i++) {
      Serial.print('\t');
    }
    Serial.print(entry.name());
    if (entry.isDirectory()) {
      Serial.println("/");
      printDirectory(entry, numTabs + 1);
    } else {
      // files have sizes, directories do not
      Serial.print("\t\t");
      Serial.println(entry.size(), DEC);
    }
    entry.close();
  }
}

long charsToLong(char a, char b, char c, char d) {
  return 0;
}

void printMetadata(char* buf) {

  char riff[5] = { buf[0], buf[1], buf[2], buf[3], '\0' };
  Serial.println(riff);

  // hmmmmmm... need to convert to big Endian
  long size = buf[4] | ((long)buf[5] << 8) | ((long)buf[6] << 16) | ((long)buf[7] << 24);
  Serial.println(size);

  char fileType[5] = { buf[8], buf[9], buf[10], buf[11], '\0' };
  Serial.println(fileType);

  char fcm[4] = { buf[12], buf[13], buf[14], buf[15] };
  Serial.println(fcm);

  long formatSize = buf[16] | ((long)buf[17] << 8) | ((long)buf[18] << 16) | ((long)buf[19] << 24);
  Serial.println(formatSize);

  int type = buf[20] | ((int)buf[21] << 8);
  Serial.println(type);

  int numChannels = buf[22] | ((int)buf[23] << 8);
  Serial.println(numChannels);

  long sampleRate = buf[24] | ((long)buf[25] << 8) | ((long)buf[26] << 16) | ((long)buf[27] << 24);
  Serial.println(sampleRate);

}

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  Serial.print("Initializing SD card...");

  if (!SD.begin()) {
    Serial.println("initialization failed!");
    while (1);
  }
  Serial.println("initialization done.");

  root = SD.open("/");

  printDirectory(root, 0);

  Serial.println("done!");

  // read in .wav file data
  test = SD.open("test.wav");

  char buf[44];
  int numRead = test.readBytes(buf, sizeof(buf)/sizeof(char));

  if(numRead != 44) {
    Serial.println("size mismatch!");
  }

  printMetadata(buf);
}

void loop() {
  // nothing happens after setup finishes.
  return;
}