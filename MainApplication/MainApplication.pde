// Space to skip the screen
// Press q - reset 


import processing.video.*;
import processing.pdf.*;
import java.io.InputStreamReader;

import controlP5.*;
import processing.serial.*;    // Importing the serial library to communicate with the Arduino 

PFont font;

int card_n = 1; //Number of cards
int Screen = 0; //Current screen

Card cards;
Customizatron CustomizeCard;

int[][] clicks; // Click count (do not know if it is necessary)
int currentPortrait = 0; // Current persona (do not know if it is necessary)

void setup() {
  // Stamp to make a different pdf names
  stamp = ""+(int) random(0, 10000000);
  fullScreen();

  //Initiallize and change font
  font = loadFont("Montserrat-Light-48.vlw");
  textFont(font, 32);

  //Set the card size
  card_w = width / 4; // Width of card
  card_h = (int) (card_w*1.49); // Height of card in proportion of A6 size

  //start communication with the scanner
  //initiallizeComunication("COM15");  // !!! Write the correct port

  initiliazeMyButtons();
  initiliazeVideos();
  initializeCards();

  //Read data tables
  ReadTable();
  smooth();


  //Tell the scanner to read a token
  if (myPort != null)myPort.write("Read\n");

  CustomizeCard = new Customizatron(width/7*4, height/3);
} // END OF SETUP()

void draw() {
  showScreen();
}

void mouseClicked() {
  if (Screen == 2) { 
    if (Like_yes.isMouseOver()) {
      Screen++;   // Go to printing
    } else if (Like_no.isMouseOver()) {
      Screen = 10; // Go to customize screen
    }
  }
  if (Screen == 10) {  // 10 - customization screen
    if (Regenerate.isMouseOver()) {
      initializeCards(); //if the "regenerate" button is clicked, randomize the postcard
    } else if (Select.isMouseOver()) {
      Screen = 2; //if the "select" button is clicked go to second screen
    }
  }
}

void mouseReleased() {
  CustomizeCard.sColor.pressed = false;
  CustomizeCard.sElements.pressed = false;
  CustomizeCard.sSize.pressed = false;
}

void mousePressed() {
  if (CustomizeCard.sColor.isMouseOverHandle()) {
    CustomizeCard.sColor.pressed = true;
    println("sColor pressed");
  } else if (CustomizeCard.sElements.isMouseOverHandle()) {
    CustomizeCard.sElements.pressed = true;
    println("S pressed");
  } else if (CustomizeCard.sSize.isMouseOverHandle()) {
    CustomizeCard.sSize.pressed = true;
    println("S pressed");
  }
}

void keyPressed() {
  if (key == ' ') { // Go to next screen
    Screen++;
    if (Screen == 3+1) {
      Restart();
    }
  } else if (key == 'q') { // Start from begining
    Screen=0;
    Restart();
  } else if (key == 'r') {        
    if (myPort != null) myPort.write("Read\n");
  }
}
