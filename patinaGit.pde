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
//TODO applet sign. 
//TODO better layout algorithm
//TODO search nodes by name?   
//TODO FOCUS PLUS TIMELINE
//mediawiki applet extension doesn't support multiple applets (seemingly) so the JSON library reliance is removed in some versions

//TODO write description of visualisations and semantic - what are we seeing
//KEEP IN MIND THIS A SECTION OF A POTENTIAL PAPER! POSTING BACK TO WIKI
//KNOWN BUGS
//GIT HUB THIS SHIT!

import org.json.*;
boolean fromJSON=false;
int mainRad;
int numUsers;
Gui gui;
int maxOwnActivity;
int maxSharedActivity;
User users[];
Page[] allPages;
int numRevs=8;//number of revolutions for time line
color sharedColor=color (2, 132, 130, 150);
color ownColor=color  (180, 109, 179, 150);
color searchColour=color  (254, 131, 1, 150);

PFont font;
//a bigger font
PFont bFont;

String[] usrNms;

//circle sizes
float innerRad;
int outerRad;

boolean forWeb=false;
Date timeNow;
Date startOfDateRange;
Date endOfDateRange;

long startRange;
long endRange;
long someTimeAgo;
long xTimeAgo;

void setup() {

  size(1280,720);

  innerRad=height/3;
  outerRad=height/8;
  timeNow= new Date();
  color guiColor =  color(255, 255, 0);

  startOfDateRange = new Date();
  endOfDateRange = new Date();

  xTimeAgo=timeNow.getTime()- (1L * 24 * 60 * 60 * 1000);
  someTimeAgo= timeNow.getTime() - (60L * 24 * 60 * 60 * 1000);
  startRange = timeNow.getTime()- (365L * 24 * 60 * 60 * 1000);
  endRange = timeNow.getTime();



  startOfDateRange.setTime(someTimeAgo);
  endOfDateRange.setTime(xTimeAgo);
  //println(startOfDateRange);
  //WEB
  //size(1480 , 1480);
  font = loadFont("Helvetica-Light-16.vlw");
  //bFont = loadFont("Helvetica-Light-24.vlw");
  bFont = loadFont("Corbel-Bold-300.vlw");
  String [] userNames = {
    "AngelikiC", "AnneB", "DanieleS", "DannyW", "EmmaT", "EnricoC", "GraemeE", "LucM", "MadelineB", "MartynD", "MattJ", "MikeF", "MikeJ", "PeterB", "RosamundD", "TomF", "TomS"
  };
  usrNms=userNames;
  numUsers= userNames.length;
  users = new User[userNames.length];

  //make user objects
  for (int i=0;i<userNames.length;i++) {

    makeUser(userNames[i], i);
  }

  //the last 300 pages or so are actually empty (maybe jsut files etc) TODO remove these
  allPages= new Page[873];
  for (int i=0;i<873;i++) {
    makePage(i);
  }
  for (int i=0;i<numUsers;i++) {
    //count edits on own pages within this date range
    users[i].countOwnActivity();
  }
  //find most active users in this date period and set as maximum
  setMaxActivities();

  ///gui setup - I want to work on this class and make a proper custom gui
  gui = new Gui (guiColor);
  gui.setupSlider(guiColor, 20, height-50, width/4);
  gui.setupTextField(searchColour, 20, height-130, 100);
  gui.setupButton( 20, height-100, 20);

  //rather wastefully resets positions of page nodes 
  reorganiseNodesByDate();
}




void draw() {
  //returns list of page UDs within date range
  ArrayList activePages= getActivePages();
  background(255);

  smooth();
  pushStyle();
  textFont(bFont, 230);
  pushMatrix();
  // pushMatrix();
  translate(width-150, -25);
  rotate(0.5*PI);
  //popMatrix();


  text("PATINA", 0, 0);
  popMatrix();
  popStyle();
  if (gui.button.isPressed ) {
    if (! gui.slider.animate) {    
      // gui.slider.sliderPos=gui.slider.sliderX;
      //   gui.slider.sliderPos2=gui.slider.sliderX+50;
      gui.slider.animate=true;
    }
  }
  else {
    gui.slider.animate=false;
  }
  drawTimeLineBackground();
  gui.slider.drawSlider();
  gui.button.drawButton();
  pushStyle();
  drawUsers();
  popStyle();
  textFont(bFont, 24);
  textAlign(LEFT);
  for (int i=0;i<activePages.size();i++) {
    try {

      // if(allPages[ (Integer)activePages.get(i) ].drawStar()
      allPages[ (Integer)activePages.get(i) ].drawStar();
      //  println(i+" "+allPages[i].xPos);
    }
    catch(Exception e) {
    }
  }
  for (int i=0;i<73;i++) {
    try {
    }
    catch(Exception e) {
    }
  }
  gui.textField.drawTextField();
  if (gui.textField.searchFlag) {
    println("searching for "+gui.textField.currentText);
    for (int i=0;i<allPages.length;i++) {
      if (inTitle(gui.textField.currentText.toLowerCase(), allPages[i].thisTitle.toLowerCase())) {
        println(gui.textField.currentText + " " +   allPages[i].thisTitle); 
        allPages[i].highlightInSearch=true;
      }
      else {
        allPages[i].highlightInSearch=false;
      }
    }
    gui.textField.searchFlag=false;
    gui.textField.currentText="";
  }
}




int[] returnIntArray(ArrayList myList) {
  int[] forReturn = new int[myList.size()];
  for (int i=0;i<myList.size();i++) {
    forReturn[i]=(Integer) myList.get(i);
  }
  return forReturn;
}

int[] returnIntFromIngtegerArray(ArrayList myList) {
  int[] forReturn = new int[myList.size()];
  for (int i=0;i<myList.size();i++) {
    forReturn[i]=(Integer) myList.get(i);
  }
  return forReturn;
}

float[] returnfloatArray(ArrayList myList) {
  float[] forReturn = new float[myList.size()];
  for (int i=0;i<myList.size();i++) {
    forReturn[i]=(Float) myList.get(i);
  }
  return forReturn;
}
String[] returnStringArray(ArrayList myList) {
  String[] forReturn = new String[myList.size()];
  for (int i=0;i<myList.size();i++) {
    forReturn[i]=(String) myList.get(i);
  }
  return forReturn;
}

Date[] returnDateArray(ArrayList myList) {
  Date[] forReturn = new Date[myList.size()];
  for (int i=0;i<myList.size();i++) {
    forReturn[i]=(Date) myList.get(i);
  }
  return forReturn;
}



void keyPressed() {
  println(key);
  char thisKey=key;
  gui.textField.update(key);
}

void drawUsers() {

  for (int i=0;i<numUsers;i++) {
    users[i].drawUser();
  }
}

int getMin(int[] ints) {
  int minint=ints[0];
  for (int i=0;i<ints.length;i++) {

    if (ints[i]<minint) {
      minint=ints[i];
    }
  }
  return minint;
}

int getMax(int[] ints) {
  int maxint=ints[0];
  for (int i=0;i<ints.length;i++) {

    if (ints[i]>maxint) {
      maxint=ints[i];
    }
  }
  return maxint;
}

void setMaxActivities() {
  int []ownCounts=new int[numUsers];
  int []sharedCounts=new int[numUsers];
  for (int i=0;i<numUsers;i++) {
    ownCounts[i]=users[i].countOwn;
    sharedCounts[i]=users[i].countShared;
  }
  //println(getMax(ownCounts));
  maxOwnActivity=getMax(ownCounts);
  maxSharedActivity =getMax(sharedCounts);
}

ArrayList getActivePages() {

  ArrayList iDs= new ArrayList();

  for (int i=0;i<numUsers;i++) {
    for (int j=0;j<users[i].uniquePageIDs.size();j++) {
      if (!iDs.contains(users[i].uniquePageIDs.get(j))) {
        iDs.add( users[i].uniquePageIDs.get(j));
      }
    }
  }
  return iDs;
}

boolean inTitle(String searchTerm, String thisTitle) {

  boolean isInTitle=false;
  String[][] m = matchAll(thisTitle, "("+searchTerm+")");
  if (m!=null) {
    for (int i = 0; i < m.length; i++) {
      //  println("Found " + m[i][1] + " inside a tag.");
      if (m[i][1].length()>3) {
        isInTitle= true;
      }
      else {
        isInTitle=false;
      }
    }
  }
  else {
    // println("null");
    isInTitle= false;
  }
  return isInTitle;
}

void reorganiseNodesByDate() {
  long[] allDates= new long[allPages.length];
  ArrayList usedAngles= new ArrayList();

  for (int i=0;i<allPages.length;i++) {
    allDates[i]=allPages[i].oldestDate;
    usedAngles.add(allPages[i].oldestDate);
  }
  Collections.sort(usedAngles);
  //println(usedAngles);







  //long oldestDate=getOldestDate(allDates);
  //long newestDate=getNewestDate(allDates);
  //lets try 10 revolutions around the centre
  float maxAngle = numRevs*TWO_PI;
  float increment=innerRad/allPages.length;
  float rad=0;
  float prevAngle=0;

  for (int i=0;i<allPages.length;i++) {
    // Date time = new Date();
    // time.setTime(allPages[i].oldestDate);
    // println(i+"th date in sequence is "+time);

    int nthDate=0;
    for (int j=0;j<usedAngles.size();j++) {
      if (allPages[i].oldestDate==(Long)usedAngles.get(j)) {

        nthDate=j;
      }
    }

    float angle=(map(nthDate, 0, allPages.length, 0, maxAngle));
    //float angle=(map(sqrt(nthDate),0,allPages.length, 0, maxAngle));

    rad=nthDate*increment;
    prevAngle=angle;
    allPages[i].xPos=width/2+ int(rad * sin(angle));
    allPages[i].yPos =height/2+int( rad *cos(angle));
  }
}

long getOldestDate(long[]myDates) {
  Date today = new Date();
  long currentOldest=today.getTime();

  for (int i=0;i<myDates.length;i++) {
    if (myDates[i]<currentOldest) {
      currentOldest=myDates[i];
    }
  }
  Date time = new Date();
  time.setTime(currentOldest);
  println("oldest "+time);
  return currentOldest;
}

long getNewestDate(long[]myDates) {
  Date today = new Date();
  long currentNewest=today.getTime()-(900L*24*60*60*1000);

  for (int i=0;i<myDates.length;i++) {
    if (myDates[i]>currentNewest) {
      currentNewest=myDates[i];
    }
  }
  Date time = new Date();
  time.setTime(currentNewest);
  println("newest "+time);
  return currentNewest;
}
void drawTimeLineBackground() {
  float maxAngle = numRevs*TWO_PI;
  float increment=innerRad/allPages.length; 
  float rad=0;
  noFill();
  stroke(200, 100);
  beginShape();
  float angle=maxAngle/allPages.length;
  for (int i=0;i<0.75*allPages.length;i++) {


    //float angle=(map(sqrt(nthDate),0,allPages.length, 0, maxAngle));

    rad+=increment;

    float vX=width/2+ int(rad * sin(i*angle));
    float vY =height/2+int( rad *cos(i*angle));
    curveVertex(vX, vY);
  }
  endShape();
}

void mousePressed() {
  gui.button.update();
}

