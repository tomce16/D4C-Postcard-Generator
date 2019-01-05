
/*
 * Eindhoven Musuem scanner (alternative, using RC522 RFID scanner)
 *                                              
 * This code only imitates wokring scanner. It can read the token, 
 * but it cannot write to it or send data to the Processing app.
 *                                              
 * It was made for demo purposes and because we didn't got PN532 on time.
 *                                              
 * 
 * 
 * Some parts of code is taken from example codes made by GARGANTUA from RoboCreators.com & paradoxalabs.com
 *  
 * 
 */


#include <SPI.h>
#include <MFRC522.h>

//Pins for the RC522 board
#define RST_PIN    9   
#define SS_PIN    10    

#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
  #include <avr/power.h>
#endif

//Pins for the LEDS
#define PIN 6
#define NUM_LEDS 15
#define BRIGHTNESS 100

// Variables for token reading.
long falseTime = 0;
long threashold = 2000;
boolean status = false;

long TokenTime = 0;
long TokenDone = 4000;

//Variables for controlling the LEDs
uint32_t c1;
uint32_t c2 ;
uint8_t wait = 50;
uint8_t whiteSpeed = 100;
uint8_t whiteLength = 5 ;
  int head = whiteLength - 1;
  int tail = 0;
  int loopNum = 0;

MFRC522 mfrc522(SS_PIN, RST_PIN); // Create MFRC522 instance
Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUM_LEDS, PIN, NEO_GRBW + NEO_KHZ800); //Create instance to control LEDs

void setup() {
  Serial.begin(9600);   // Initialize serial communications with the PC
  while (!Serial);    // Do nothing if no serial port is opened (added for Arduinos based on ATMEGA32U4)
  SPI.begin();      // Init SPI bus
  mfrc522.PCD_Init();   // Init MFRC522

  strip.setBrightness(BRIGHTNESS);
  strip.begin();
  strip.show(); // Initialize all pixels to 'off'
  c1 = strip.Color(244, 65 , 0);
  c2 = strip.Color(0, 0 , 0);
  Serial.println(F("Scan PICC to see UID, type, and data blocks..."));
}

void loop() {

   boolean CardReader = mfrc522.PICC_IsNewCardPresent();
   
  if ( !CardReader  &&( millis() - falseTime > threashold ) ) {
    if(status == false){
    fullColor(strip.Color(244, 65 , 0), 10);
    loopNum= 0;
    }else status = false;
    return;
  }else  if ( ! CardReader &&( millis() - falseTime < threashold ) ) { // It is neccessary to remove the Led lighting glitch between the scans
    Serial.println("Phantom token is here");
  }

  if(CardReader && status == false){  //When it is the first time the token is read
    falseTime = millis();
     TokenTime = millis();
   
    Serial.println("Status = false");
  }

  // If the code gets to this point it means that the token is on the scanner
  status = true;
  Serial.println("CARD IS HERE ");


 if(millis() - TokenTime > TokenDone){
  //Show green colour
  Serial.println("Token Done");
 fullColor(strip.Color(20, 255 , 20), 10); 
 }else{
  
  //Show "running" lights
  if(whiteLength >= strip.numPixels()) whiteLength = strip.numPixels() - 1;
  int loops = 2;
  static unsigned long lastTime = 0;
       
        head++;
        tail++;
        if(head == strip.numPixels()){
          loopNum++;
        }
        if(loopNum>= 8){
        fullColor(strip.Color(20, 255 , 20), 10); 
        }else{
      for(uint16_t i=0; i<strip.numPixels(); i++) {
        if((i >= tail && i <= head) || (tail > head && i >= tail) || (tail > head && i <= head) ){
          strip.setPixelColor(i, c1);
        }
        else{
          strip.setPixelColor(i, c2);
        }        
      }
        head%=strip.numPixels();
        tail%=strip.numPixels();
        strip.show();
        }
 }

    delay(wait); 
} // End of loop


//Function to set all LEDs to one colour.
void fullColor(uint32_t c, uint8_t wait) {
    for(uint16_t i=0; i<strip.numPixels(); i++) {
        strip.setPixelColor(i, c );
    }
      strip.show();
      delay(wait);
}

// Function to make "running" lights
void ColorOnColor(uint32_t c1,uint32_t c2,uint8_t wait, uint8_t whiteSpeed, uint8_t whiteLength ) {
  
  if(whiteLength >= strip.numPixels()) whiteLength = strip.numPixels() - 1;
  int head = whiteLength - 1;
  int tail = 0;

  int loops = 2;
  int loopNum = 0;

  static unsigned long lastTime = 0;

  while(true){
      for(uint16_t i=0; i<strip.numPixels(); i++) {
        if((i >= tail && i <= head) || (tail > head && i >= tail) || (tail > head && i <= head) ){
          strip.setPixelColor(i, c1);
        }
        else{
          strip.setPixelColor(i, c2);
        }
        
      }

      if(millis() - lastTime > whiteSpeed) {
        head++;
        tail++;
        if(head == strip.numPixels()){
          loopNum++;
        }
        lastTime = millis();
      }

      if(loopNum == loops) return;
      head%=strip.numPixels();
      tail%=strip.numPixels();
        strip.show();
        delay(wait);
  }
}


