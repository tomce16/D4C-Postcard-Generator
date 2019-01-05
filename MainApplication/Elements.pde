
//Class to store the data about each element
class Element{
  PVector pos;
  PShape symb;
  color c;
  float r;
  float size;
  int layer;
  
  Element(PVector p, int layer, PShape s, color c, float r, float size){
    this.pos = p;
    symb = s;
    this.layer = layer;
    this.c = c;
    this.r = r;
    this.size = size; 
    setSymbol();

  }
  
  void changeColor(int c){
    this.c= colorList[c][layer+1];
  }
  void changeSymbol(PShape[] s){
   this.symb = s[layer];
   setSymbol();
  }
  void setSymbol(){
    symb.disableStyle(); 
    symb.setFill(c);
    shapeMode(CENTER);
  }
  
  float getX(){
  return pos.x;
  }
  
  float getY(){
  return pos.y;
  }
  
  float getSize(){
  return size;
  }
  
  float getRotation(){
  return r;
  }
  
  PShape getSymbol(){
  return symb;
  }
}
