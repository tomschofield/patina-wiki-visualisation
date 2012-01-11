
class Button
{
  int x, y, buttonSize;
  boolean isPressed=false;
  Button(color guiC, int xPos, int yPos, int buttSize) {
    x=xPos;
    y=yPos;
    buttonSize=buttSize;
    //rectMode(LEFT);
  }
  void update() {

    if (mouseX >x && mouseX<x+buttonSize &&mouseY >y && mouseY<y+buttonSize) {
      isPressed=!isPressed; 
      println("button is "+isPressed);
    }
  }
  void drawButton() {
    pushStyle();
    noFill();
    strokeWeight(3);
    stroke(200);
    rect(x, y, buttonSize, buttonSize);

    if (isPressed) {
      fill(150);
    }
    else {
      fill(200);
    }
    strokeWeight(1);

    stroke(0);
    textFont(font, 12);
    rect(x, y, buttonSize, buttonSize);
    fill(0);
    text("Animate time line", x+buttonSize+5, y+buttonSize);
    popStyle();
  }
}

