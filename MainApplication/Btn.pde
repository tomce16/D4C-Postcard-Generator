//My custom Button class
Btn Like_yes, Like_no;

// Class that makes custom buttons
class Btn {
  float x, y, bw, bh;
  int index;
  String type;
  String label;

  boolean active = false;
  boolean visible = true;

  Btn(float x, float y, float bw, float bh, int index, String type, String label) {
    //Position
    this.x = x;
    this.y= y;

    //Button width, height
    this.bw = bw;
    this.bh = bh;

    //Button index
    this.index = index;

    //Button type
    this.type = type;

    //Button label;
    this.label = label;
  }

//Display the buttons
  void display() {

    if (visible) {
      rectMode(CENTER);
      textAlign(CENTER);

      setRightColors();
      rect(x, y, bw, bh);

      fill(255);
      text(label, x, y+bh/5);
    }
  }

  void setVisible(boolean v) {
    visible = v;
  }

  void setActive(boolean a) {
    active = a;
  }

  boolean isMouseOver() {
    if (mouseX >= x-bw/2 && mouseX <= x-bw/2 + bw && mouseY >= y - bh/2 && mouseY <= y - bh/2+ bh) {
      return true;
    } else return false;
  }


  //Set the fills and strokes of the buttons
  void setRightColors() {

    noStroke();
    //All mouse interactions
    
    // When button is clicked
    if (isMouseOver()&& mousePressed) {
      if (type == "Yes") fill(69, 145, 71);
      else if (type == "No") fill(189, 56, 38);
      else if (type == "CUSTOM") {
        fill(220, 220, 220);
        strokeWeight(0.5);
        stroke(210);
      } else if (type == "Outline") {
        noStroke();
        fill(200, 45, 15);
      }

      //When the mouse is over the button
    } else if (isMouseOver()) {
      if (type == "Yes") fill(69, 168, 72);
      else if (type == "No") fill(213, 62, 40);
      else if (type == "CUSTOM") {
        fill(230, 230, 230);
        strokeWeight(0.5);
        stroke(220);
      } else if (type == "Outline") {
        noStroke();
        fill(210, 55, 25);
      }
    } 
    // Normal button color
    else { 
      if (type == "Yes") fill(83, 185, 75);
      else if (type == "No") fill(239, 68, 35);
      else if (type == "CUSTOM") {
        fill(240, 240, 240);
        strokeWeight(0.5);
        stroke(230);
      } else if (type == "Outline") {
        noStroke();
        fill(239, 68, 35);
      }
    }

    //If button is set as Active
    if (active) {
      fill(180, 180, 180);
      strokeWeight(0.5);
      stroke(180);
    }

   textSize(bh*0.50);
 
  } // setRightColors() End
}//End of Button class


// FUNCTIONS THAT IS CONNECTED TO BUTTONS

void initiliazeMyButtons() {
  // float x, float y, float bw, float bh, int index, String type, String label
  Like_yes = new Btn(width/7*5-160, height/12*8, 290, 70, 1, "Outline", "Yes");
  Like_no = new Btn(width/7*5+ 240, height/12*8, 290, 70, 1, "Outline", "No");
}

void showButtons() {
  Like_yes.display(); 
  Like_no.display();
}
