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
 
 //hope to expand this class into a proper customisable gui class to replae controlP5 in my own projects
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

