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
class TextField
{
  int x, y, fieldWidth;
  String currentText="Enter text here";
  int count=1;
  color guiColor;
  Slider slider;
  boolean searchFlag=false;
  TextField(color guiC, int xPos, int yPos, int textFieldWidth) {
    guiColor=guiC;
    x=xPos;
    y=yPos;
    fieldWidth=textFieldWidth;
  }
  void update(char thisKey) {
    //if this is a shift by itself ignore it
    if (keyCode==16) {
      println("shift pressed");
    }
    else {
      if (thisKey=='\b') {
        if (currentText.length()>1) {
          println("backspace "+currentText.length()); 

          String currentText1=currentText.substring( 0, currentText.length()-2 );   
          currentText=new String("");
          currentText=currentText1;
        }
      }
      if (thisKey=='\n') {
        println("carriage return");
        searchFlag=true;
        //currentText="";
      }
      else {
        currentText+=thisKey;
        println(currentText);
      }
      println(key);
    }
  }
  void drawTextField() {
     int offset=3;
    int textHeight=12;
    textFont(font, textHeight);

    fill(255);
    strokeWeight(5);
    stroke(150);

    rect(x-offset, y-(1.5*textHeight), fieldWidth+(2*offset), textHeight*2);
    strokeWeight(1);
    stroke(0);
   
    rect(x-offset, y-(1.5*textHeight), fieldWidth+(2*offset), textHeight*2);
    
    fill(searchColour);

    text(currentText, x, y);
    fill(200);
    noStroke();
    //draw cursor
    rect(x+1+textWidth(currentText), y-(textHeight*1.2), 5, textHeight*1.5);
  }
}

