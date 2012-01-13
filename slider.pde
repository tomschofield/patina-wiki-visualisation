/*
cc tom schofield 2011
 This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
 
 The above copyleft notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYLEFT HOLDERS BE LIABLE FOR ANY CLAIM, 
 DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
 DEALINGS IN THE SOFTWARE.
 */
class Slider
{
  color guiColor;
  float sliderPos;
  float sliderPos2;
  int sliderX;
  int sliderY;
  int sliderW;
  int whichSlider;
  boolean animate;
  Slider(color guiC, int x, int y, int w) {
    color guiColor = guiC;
    sliderX=x;
    sliderY=y;
    sliderW=w;
    sliderPos=sliderX+(w*0.8);
    sliderPos2=sliderX+sliderW;

    //set the values to refelct the gui
    startOfDateRange.setTime(getStartDateFromSlider());
    endOfDateRange.setTime(getEndDateFromSlider());

    for (int i = 0;i < numUsers;i++) {
      users[i].resetTime();
    }
    setMaxActivities();
    animate=false;
  }
  void drawSlider() {
    pushStyle();
    textFont(font, 12);
    getNearestSlider();
    updateSlider();
    stroke(0);
    fill(guiColor);
    text(startOfDateRange.toString(), sliderPos, sliderY+20);
    text(endOfDateRange.toString(), sliderPos2, sliderY-10);
    noFill();
    line (sliderX, sliderY, sliderX+sliderW, sliderY);
    strokeWeight(4);
    stroke(200);

    ellipse(sliderPos, sliderY, 10, 10);

    ellipse(sliderPos2, sliderY, 10, 10);
    stroke(0);
    strokeWeight(1);

    ellipse(sliderPos, sliderY, 10, 10);

    ellipse(sliderPos2, sliderY, 10, 10);
    popStyle();
  }

  void getNearestSlider() {
    if (mousePressed) {
      if (mouseX> sliderX && mouseX <sliderX +sliderW && mouseY > sliderY-10 &&  mouseY < sliderY+10) {
        //sliderPos=mouseX; 
        if (dist(mouseX, sliderY, sliderPos, sliderY)<dist(mouseX, sliderY, sliderPos2, sliderY)) {
          whichSlider=1;
        }
        else {
          whichSlider=2;
        }
      }
    }
  }
  void updateSlider() {
    if (mousePressed) {
      if (mouseX> sliderX && mouseX <sliderX +sliderW && mouseY > sliderY-10 &&  mouseY < sliderY+10) {
        if (whichSlider==1) {
          sliderPos=mouseX;
        }
        if (whichSlider==2) {
          sliderPos2=mouseX;
        }
        startOfDateRange.setTime(getStartDateFromSlider());
        endOfDateRange.setTime(getEndDateFromSlider());

        for (int i = 0;i < numUsers;i++) {
          users[i].resetTime();
        }
        setMaxActivities();
        //reorganiseNodesByDate();
      }
    }
    if (animate) {
      println("animating");
      int interval=50;
      int speed=1;

      if (sliderPos2<=sliderX+sliderW) {
        println(sliderPos);
        sliderPos+=speed;
        sliderPos2+=speed; 
        startOfDateRange.setTime(getStartDateFromSlider());
        endOfDateRange.setTime(getEndDateFromSlider());
        for (int i = 0;i < numUsers;i++) {
          users[i].resetTime();
        }
        setMaxActivities();
      }
      else {
        animate=false;
      }
    }
  }

  long getStartDateFromSlider() {

    return (long)map(sliderPos, sliderX, sliderX+sliderW, startRange, endRange);
  }
  long getEndDateFromSlider() {
    return (long)map(sliderPos2, sliderX, sliderX+sliderW, startRange, endRange);
  }
}

