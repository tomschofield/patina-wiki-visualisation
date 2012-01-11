
class Gui
{
  
  color guiColor;
  Slider slider;
  TextField textField;
  Button button;
  Gui(color guiC) {

    
  }
  void setupSlider(color col, int xPos,int yPos,int sliderWidth){
    
   slider=new Slider( guiColor, xPos,yPos,sliderWidth);
  }
  void setupTextField(color textC,int xPos,int yPos,int textFieldWidth) {
    textField=new TextField( textC, xPos, yPos, textFieldWidth);
  }
  void setupButton(int xPos,int yPos,int buttonSize) {
    button=new Button( guiColor, xPos, yPos, buttonSize);
  }

}

