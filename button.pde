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

