//Custom Slider class

class Slider {
  int sliderW = 600; // Width of slider
  float x, y, sw, sh;
  int index;
  int type; //Type 1 - for ordinal values, Type 0 - for scales . In this version type 0 is not used
  String[] labels;
  int categories = 4; // Number of categories
  int currentCat = 0;
  float min, max; //For type

  float hX; //Handle position
  float hS = 40; // Handle size

  boolean active =  false;
  boolean visible = true;
  boolean pressed = false;

  //Slider with categories (Ordinal)
  Slider(float x, float y, int index, int type, int cat, String[] labels) {
    //Position
    this.x = x;
    this.y= y;

    //Slider index
    this.index = index;

    //Slider type
    this.type = type;
    //categories = cat;
    //Slider label;
    this.labels = labels;
    hX = x;
  }

  //Slider without categories (Scales)
  Slider(float x, float y, int index, int type, int min, int max) {
    //Position
    this.x = x;
    this.y= y;

    //Slider index
    this.index = index;

    //Slider type
    this.type = type;

    this.min = (float) min;
    this.max = (float) max;
    hX = x;
  }


  void display() {

    if (visible) {

      textAlign(CENTER);
      strokeCap(ROUND);
      strokeWeight(6);
      stroke(239, 68, 35);
      line(x, y, x+ sliderW, y);

      if (type == 1) {
        displayCategories();
        if (pressed) jumpToCategory();
      }

      displayHandle(hX);
      displayToolbox(hX);
    }
  }

  void displayHandle(float q) {
    if (type == 1) {
      if (pressed) {
        fill(#B3B5B8);
        ellipse(q, y, hS, hS);
        fill(#999999);
        ellipse(q-(hS/3), y, hS/6, hS/6);
        ellipse(q, y, hS/6, hS/6);
        ellipse(q+(hS/3), y, hS/6, hS/6);
      } else {
        fill(#CFD1D3);
        ellipse(q, y, hS, hS);
        fill(#B3B5B8);
        ellipse(q-(hS/3), y, hS/6, hS/6);
        ellipse(q, y, hS/6, hS/6);
        ellipse(q+(hS/3), y, hS/6, hS/6);
      }
    } else {
      noStroke();
      ellipseMode(CENTER); 
      if (isMouseOverHandle()) {
        fill(#B3B5B8);
        ellipse(q, y, hS, hS);
        fill(#999999);
        ellipse(q-(hS/3), y, hS/6, hS/6);
        ellipse(q, y, hS/6, hS/6);
        ellipse(q+(hS/3), y, hS/6, hS/6);
      } else {
        fill(#CFD1D3);
        ellipse(q, y, hS, hS);
        fill(#B3B5B8);
        ellipse(q-(hS/3), y, hS/6, hS/6);
        ellipse(q, y, hS/6, hS/6);
        ellipse(q+(hS/3), y, hS/6, hS/6);
      }
    }
  }


  void displayToolbox(float q) {
    String text = "";
    int textSize = 25;
    int offsetY = 45;

    if (type == 0) {  // without categories (scale)
      int t =(int)map(hX, x, x+sliderW, min, max);
      text = "Size: " + t;
    } else if (type == 1) { // with categories (ordinal)
      text = labels[currentCat];
    }

    textSize(textSize);
    
    // Adapting the toolbox to the length of text
    float tWidth = text.length()*0.6 * textSize*0.85;
    
    //Making a toolbox rounded box
    strokeWeight(35); 
    noFill();
    stroke(#F05223);
    line(q - tWidth/2, y -  offsetY, q + tWidth/2, y -  offsetY);
    fill(255);
    textAlign(CENTER);
    text(text, q, y- offsetY+textSize/3);
  }

  void displayCategories() {
    noStroke();
    ellipseMode(CENTER); 
    fill(#CA451C);
    for (int i = 0; i < categories; i++) {
      ellipse( x + sliderW/(categories-1)*i, y, hS/4, hS/4);
    }
  }

  void setVisible(boolean v) {
    visible = v;
  }

  void setActive(boolean a) {
    active = a;
  }

  boolean isMouseOverHandle() {
    PVector handle = new PVector(hX, y);
    if ( handle.dist(new PVector(mouseX, mouseY)) < hS) {
      return true;
    } else return false;
  }

  void setHandleX(float a) {
    if (type == 1) {
      jumpToCategory();
    } else {
      if (a >= x && a <= x+sliderW) hX = a;
    }
  }

  void jumpToCategory() {
    float dist = 10000;
    int q = 0;
    for (int i = 0; i < categories; i++) {
      if (abs(mouseX - (x + sliderW/(categories-1)*i)) < dist) {
        dist =  abs(mouseX - (x + sliderW/(categories-1)*i));
        q = i;
      }
    }

    hX =(x + sliderW/(categories-1)*q);
    if (currentCat != q)   currentCat= changeCat(q, index);
  }

  int getCategoryIndex() {
    return currentCat;
  }
}//End of Slider class


// FUNCTIONS THAT IS CONNECTED TO Slider

//Change the category of the slider
int changeCat(int i, int index) {
  if ( index == 0 ) { 
    c = i;
    cards.changeElementsColor(i);
  } else if ( index == 1 ) {
    e = i;
    cards.changeElementsSymbol(i);
  } else if ( index == 3 ) { 
    s = i;
    cards = new Card(width/2-1.2*card_w, height/6, card_w, card_h, c, e, s);
  }
  return i;
}
