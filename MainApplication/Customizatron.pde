Btn Regenerate, Select;

//The sliders and buttons combination
class Customizatron {
  float x;
  float y;

  boolean visible = true;

  Slider sColor, sElements, sSize;

  Customizatron(float x, float y) {
    this.x = x;
    this.y = y;

    initializeSlider();
    initializeButtons();
  }

  void display() {
    if (visible) {
      displayButtons();
      displaySlider();
    }
  }

  void setVisible(boolean v) {
    visible = v;
  }

  void displayButtons() {
    Regenerate.display();
    Select.display();
  }
  void setRowActive(int i, int btn) {
  }

  void initializeButtons() {
    Regenerate = new Btn(x+290, y+650, 200, 50, 1, "Outline", "Generate"); 
    Select = new Btn(x - 470, y+650, 200, 50, 1, "Outline", "Finish");
  }

  void  initializeSlider() {
    float s_v_gap = 180; //Gap between the sliders
    // Slider(float x, float y, int index, String type, int cat, String[] labels){
    String[] labels = {"Color 1", "Color 2", "Color 3", "Color 4"};
    sColor = new Slider(x, y + s_v_gap*0, 0, 1, 4, labels);

    String[] labels2 =  {"Element 1", "Element 2", "Element 3", "Element 4"};
    sElements = new Slider(x, y + s_v_gap*1, 1, 1, 4, labels2 );

    String[] labels4 =  {"Size 1", "Size 2", "Size 3", "Size 4"};
    sSize = new Slider(x, y + s_v_gap*2, 3, 1, 4, labels4 );
  }

  void  displaySlider() {
    sColor.display();
    sElements.display();
    sSize.display();
  }
}//End of Customizatron class
