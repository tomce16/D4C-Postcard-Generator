// Everything that connected to making, choosing, generating postcards

//Some public variables connected to postcards
int card_w = width / 4; // Width of postcard
int card_h = (int) (card_w*0.7084); // Height of card
int margin = 20;  // Margin around the card
PGraphics canvasPDF; // Class which will be exported as PDF
int c, e, s;  // The main coefficients that generates the postcard. c - color, e - element, s - size



class Card {
  PGraphics canvas; //The postcard canvas
  float x, y, w, h;    // x - x coordinate, y - y coordinate, w - width, h - height
  int index;        // Index which postcard it is now

  int iC, iE, iS;

  ArrayList<Element> element; // Elements
  int elSize = 0; // count of element array
  int[] piecesOfElements; // Numbers how many of each element we have.
  PShape symb[]; //Symbols (elements)

  Card(float x, float y, float w, float h, int iC, int iE, int iS) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.iC = iC;
    this.iE =iE;
    this.iS = iS;

    piecesOfElements = new int[4]; //Because we have 4 layers;

    for (int i = 0; i < 4; i++) {
      piecesOfElements[i] = setCount(iS);
    }

    float size = setSize(iS); //Randomize the size of elements
    int selectedColorPallete = iC; //Choose the color pallete

    element = new ArrayList<Element>();

    initializeSVG(iE);

    canvas = createGraphics(card_w, card_h);
    canvas.beginDraw(); //Start drawing on the postcard
    canvas.noStroke();
    canvas.background(colorList[selectedColorPallete][0]);
    elSize = 0;
    
    //Generates elements and draws into postcard
    for (int i = 0; i < 4; i++) {       
      for (int j = 0; j < piecesOfElements[i]; j++) {
        PVector pos = new PVector(random(0, card_w ), random(0, card_h )); 
        ;

        size = setSize(iS);
        //class Element(PVector p, int layer, PShape s, color c, float r, float size)
        element.add(new Element(pos, i, symb[i], colorList[selectedColorPallete][i+1], radians(random(0, 360)), size));

        symb[i].disableStyle();  // Ignore the colors in the SVG
        canvas.fill(colorList[selectedColorPallete][i+1]);    // Set the SVG fill pallete colors

        int k = elSize;
        PShape symbol = element.get(k).getSymbol();
        symbol.resetMatrix();
        canvas.shapeMode(CENTER);
        symbol.rotate( element.get(k).getRotation());

        canvas.shape(symbol, element.get(k).getX(), element.get(k).getY(), 
        element.get(k).getSize(), element.get(k).getSize());
        elSize++;
        println(element.size()); // Now one less!
      } // for j loop end
    } // for i loop end

    canvas.dispose();
    canvas.endDraw();
  }

  void display() {
    int BleedBorder = 30; // The size of white surrounding border
    rectMode(CORNER);
    
    if (isMouseOnTop()) { // Make an outline to know if the card is clickable
      stroke(#E0E1E2);
      fill(#E0E1E2);
      strokeWeight(5);
      rect(x+BleedBorder/2, y+BleedBorder/2, w+5, h+5);
    } else {
      noStroke();
    }
    
    //Make postcard bleed border
    stroke(255);
    strokeWeight(BleedBorder);
    rect(x, y, w, h);
    image(canvas, x, y); // Display the card
  } // End of display()


  void isClicked() {
    if (mouseX >= x && mouseX <= x+ w && mouseY >= y && mouseY <= y+ h) {
      //Some code
    }
  }

// Initialize what symbol our elements will use.
  void initializeSVG(int i) { 
    symb = new PShape[4];

    switch(i) { 
    case 0: 
      symb[0] = loadShape("symbols-01.svg");
      symb[1] = loadShape("symbols-02.svg");
      symb[2] = loadShape("symbols-03.svg");
      symb[3] = loadShape("symbols-04.svg");

      break;
    case 1: 
      symb[0] = loadShape("symbols-05.svg");
      symb[1] = loadShape("symbols-06.svg");
      symb[2] = loadShape("symbols-07.svg");
      symb[3] = loadShape("symbols-08.svg");
      break;
    case 2: 
      symb[0] = loadShape("symbols-09.svg");
      symb[1] = loadShape("symbols-10.svg");
      symb[2] = loadShape("symbols-11.svg");
      symb[3] = loadShape("symbols-12.svg");
      break;
    case 3: 
      symb[0] = loadShape("symbols-13.svg");
      symb[1] = loadShape("symbols-14.svg");
      symb[2] = loadShape("symbols-15.svg");
      symb[3] = loadShape("symbols-16.svg");
      break;
    default:             // Default executes if the case labels
      println("None");   // don't match the switch parameter
      break;
    }

    println("Initialization of SVG complete");
  } // End of InitiliazeSVG()



  boolean isMouseOnTop() {
    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) {
      return true;
    } else return false;
  }

// Change the color of all elements
  void changeElementsColor(int c) {
    for (int i = 0; i < element.size(); i++) {
      element.get(i).changeColor(c);
    } 
    redrawCard();
  }

//Change the symbol of every element
  void changeElementsSymbol(int c) {
    initializeSVG(c);
    for (int i = 0; i < element.size(); i++) {
      element.get(i).changeSymbol(symb);
    } 
    redrawCard();
  }

//Redraw the postcard
  void redrawCard() {
    canvas = createGraphics(card_w, card_h);
    canvas.beginDraw(); //Start drawing on the postcard
    canvas.noStroke();
    canvas.background(colorList[c][0]);
    elSize = 0;
    for (int i = 0; i < 4; i++) {       
      for (int j = 0; j < piecesOfElements[i]; j++) {    
        canvas.shapeMode(CENTER);
        int k = elSize;

        canvas.fill(colorList[c][i+1]);    // Set the SVG fill pallete colors
        PShape symbol = element.get(k).getSymbol();
        symbol.resetMatrix();
        canvas.shapeMode(CENTER);
        symbol.rotate( element.get(k).getRotation());

        canvas.shape(symbol, element.get(k).getX(), element.get(k).getY(), 
          element.get(k).getSize(), element.get(k).getSize());
        elSize++;
        //  println(element.size()); // Now one less!
      } // for j loop end
    } // for i loop end

    canvas.endDraw();
  }

// Draw the same postcard in the right size for printing
  void DrawPDF() {
    canvasPDF = createGraphics(286, 400, PDF, "Postcard"+stamp+".pdf");
    float scale_w = (float)card_w / (float)286;

    println("card_w - ", card_w, " SCALE = ", scale_w);
    canvasPDF.beginDraw(); //Start drawing on the postcard
    canvasPDF.noStroke();
    canvasPDF.background(colorList[c][0]);
    elSize = 0;
    for (int i = 0; i < 4; i++) {       
      for (int j = 0; j < piecesOfElements[i]; j++) {    
        canvasPDF.shapeMode(CENTER);
        int k = elSize;

        canvasPDF.fill(colorList[c][i+1]);    // Set the SVG fill pallete colors
        PShape symbol = element.get(k).getSymbol();
        symbol.resetMatrix();
        canvasPDF.shapeMode(CENTER);
        symbol.rotate( element.get(k).getRotation());

        canvasPDF.shape(symbol, element.get(k).getX()/scale_w, element.get(k).getY()/scale_w, 
          element.get(k).getSize()/scale_w, element.get(k).getSize()/scale_w);
        elSize++;
  
      } // for j loop end
    } // for i loop end

    //Margin fix
    canvasPDF.fill(255);
    canvasPDF.rect(0, 390, 286, 400);
    canvasPDF.dispose();
    canvasPDF.endDraw();
  }
} //********************** END OF CLASS







//*****************************
//Functions that is connected to cards
//*****************************

//Create cards
void initializeCards() {
  clicks = new int[card_n][card_n];
  // cards = new Card(width/14+(width-width/8)/card_n*i, height/6, card_w, card_h, 1);
  cards = new Card(width/2-1.2*card_w, height/6, card_w, card_h, c, e, s);
  cards.redrawCard();
} // End of initializeCards()


//Draw Cards
void drawCards() {
  cards.display();
}

// Collects the number of clicks
int allClicks() {
  int sum = 0;
  for (int i=0; i < card_n; i++) {
    sum = sum + clicks[currentPortrait][i];
  }
  return sum;
} // End of allClicks()
