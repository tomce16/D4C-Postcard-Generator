// !!! In this version it is not used !!! 

// Class to controls the insides of SVG
class Children 
{
  PShape child;
  PVector pos;
  color c;
  float size;
 
  Children(PShape child, PVector pos, color c, float size) 
  {
    println("Initialization of children");
    this.pos = new PVector(pos.x, pos.y);
    this.c = c;
    this.child = child;
    this.size = size;
  }
 
  void draw(PGraphics pg) {
    println("Child disableStyle");
    child.disableStyle();
    pg.fill(c);
    pg.shape(child, pos.x, pos.y, size, size);
  }
 
  void colourChange() {
    c = color(random(255), random(255), random(255));
  }
}
