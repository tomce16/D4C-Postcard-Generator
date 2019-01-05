/**************************************************************************/

/*!              Eindhoven Musuem Scanner code
 
 * Some parts of the code are taken from Adafruit example codes.
 *  @author   KTOWN (Adafruit Industries)
 *  @license  BSD (see license.txt)

    This code reads the token (NFC chip) using the Arduino and PN532 boards,
    writes data to it and sends the data to plugged in computer via serial port.
    In addition, when LED strip is plugged in, scanner will show current working
    status via LEDs.


*/
/**************************************************************************/
#include <Wire.h>
#include <SPI.h>
#include <Adafruit_PN532.h>
#include <Adafruit_NeoPixel.h>

#define PIN 6
#define NUM_LEDS 16
#define BRIGHTNESS 50

//Adafruit Neo Pixel class for controlling the LEDS
Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUM_LEDS, PIN, NEO_GRBW + NEO_KHZ800);


//Configuring pins for the Arduino
#define PN532_SCK  (13)
#define PN532_MOSI (11)
#define PN532_SS   (10)
#define PN532_MISO (12)


// Use this line for a breakout with a software SPI connection :
Adafruit_PN532 nfc(PN532_SCK, PN532_MISO, PN532_MOSI, PN532_SS);


char rc[300]; //Array where all the data will be gathered
int q = 0; //Current position of the rc array ↑
String inputString = "";         // a String to hold incoming data
boolean stringComplete = false;  // check whether the string ↑ is complete
int TokenStatus = 0; // 0 - Waiting to read
                     // 1 - Reading
                     // 2 - Done

  // Variables for controlling the Leds
  uint8_t whiteLength = 5;
  int head = whiteLength - 1;
  int tail = 0;

void setup(void) {
  delay(500);
  
  //Connecting the Arduino to the Processing
  Serial.begin(9600);
  Serial.println("Hello!");
  
  inputString.reserve(200);
  delay(50);

  //Starting up the NFC scanner
  nfc.begin();
  uint32_t versiondata = nfc.getFirmwareVersion();
  
  if (! versiondata) {
    Serial.print("Didn't find PN53x board");
    while (1);
  }
  // Got ok data, print it out!
  Serial.print("Found chip PN5");Serial.println((versiondata>>24) & 0xFF, HEX); 
  Serial.print("Firmware ver."); Serial.print((versiondata>>16) & 0xFF, DEC); 
  Serial.print('.'); Serial.println((versiondata>>8) & 0xFF, DEC);
  
  // configure board to read RFID tags
  nfc.SAMConfig();
 
  strip.setBrightness(BRIGHTNESS);
  strip.begin();
  strip.show(); // Initialize all pixels to 'off'
  Serial.println("Everything is okay! Waiting for a command!");
 fullColor(strip.Color(244, 65 , 0), 10);
}

void loop(void) {

// Getting the commands from the Proccessing
  if (stringComplete) { //Check if text from Serial is complete
       Serial.print("Command is - "); Serial.println(inputString);

      if(inputString.equals("Read")){ 
      fullColor(strip.Color(244, 65 , 0), 10);
      deleteRcData();
      TokenStatus = 0;
      ReadTag();
      }
       
      else if(inputString.substring(0,5).equals("Write")){

      // Command "Write" comes with additional data. We are extracting it
      String write_data = extractData(inputString);
      Serial.println(" ");
      Serial.print("Got data to write - ");

           // Adding data to the end of the token data.
           write_data = addData(write_data);

           //Converting String to char*
           int nr = write_data.length()+1;
           char copy[nr];
           write_data.toCharArray(copy, nr);

          //FOR DEBUGGING - See what kind of data we are sending
          Serial.println(" ");
          Serial.println("Copy");
          for(int i = 0; i < nr; i++){
            Serial.print(copy[i]);
          }
          Serial.println(" ");
          Serial.println(" ");
           TokenStatus = 1;
          //Writing the data that was gathered before and a new data altogether
          WriteTag(copy);
      }
      
      else if(inputString.equals("Reset")){
      // Cleaning rc array
      deleteRcData();
      Serial.println("We are reseting data");
      TokenStatus = 1;
      //Reseting token
      ResetTag(); 
      }

      else if(inputString.equals("Done")){
      Serial.println("We are done");
      TokenStatus = 2;
      }

      else if(inputString.equals("Send")){ //Sending data from Arduino to the Processing
         Serial.println("We are sending data");
         SendData();
      }

     //Reseting Strings to be able get new commands from the Processing
     delay(100);
     stringComplete = false;
     inputString = "";
  }
  
  if(TokenStatus == 1) ColorOnColor(strip.Color(244, 65 , 0),strip.Color(0, 0 , 0),50, 100);
  else if(TokenStatus ==2){
    fullColor(strip.Color(80, 255 , 40), 10);
  }else{
     fullColor(strip.Color(244, 65 , 0), 10);
  }
}


//Getting data from one NFC tag page 
void Response(uint8_t * data, const uint32_t numBytes){
    uint32_t szPos;
  for (szPos=0; szPos < numBytes; szPos++)
  {
    if (data[szPos] <= 0x1F) ;
    else{
       rc[q] = (char)data[szPos];
       q++;
    }
  }
}


//Communication between the Arduino and Processing app
void serialEvent() {
  while (Serial.available()) {
    // get the new byte:
    char inChar = (char)Serial.read();
    if (inChar == '\n') {
    stringComplete = true;
    }else  inputString += inChar;
  }
}


