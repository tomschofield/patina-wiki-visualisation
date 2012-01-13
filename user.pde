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
 
class User
{
  String name;
  //how many edits has this user made
  int numEntries;
  //what are the ids of those pages
  int [] pageIDs;
  //when were those edits made
  long [] unixTimes;
  Date [] times;
  boolean clicked;
  //what comments have they made on those edits
  String comments[];
  //titles of the pages edited by this user
  String[] titles;
  //relative strength of connections to other users
  int [] connections;
  HashMap allData;
  int gScale=height/10;
  int nearestIndex=0;
  Map<String, ArrayList> sortedMap;
  int countOwn=0;
  int countShared=0;
  float x, y;
  float[] pageLocs;
  int index;

  //true if mouse over this user's timeline
  boolean mouseOver=false;
  //
  int nearestPageId=0;
  //inner and outer Radii
  float outRad;
  int inRad;
  ArrayList uniquePageIDs;
  ArrayList pageIDsOwn;
  ArrayList pageIDsShared;
  int circleRad=70;
  String [] userNames = {
    "AngelikiC", "AnneB", "DanieleS", "DannyW", "EmmaT", "EnricoC", "GraemeE", "LucM", "MadelineB", "MartynD", "MattJ", "MikeF", "MikeJ", "PeterB", "RosamundD", "TomF", "TomS"
  };
  User(String n, int[]ps, String []cs, String [] ts, Date[] tms, float xP, float yP, int ind, int outR, int iRad) {
    name = n;
    pageIDs =ps;
    comments =cs;
    titles = ts;
    times = tms;
    x=xP;
    y=yP;
    clicked=false;
    index=ind;
    outRad=outR;
    iRad=inRad;


    uniquePageIDs=new ArrayList();
    int[] tempIDs=filterDates(startOfDateRange, endOfDateRange);
    for (int i=0;i<tempIDs.length;i++) {
      uniquePageIDs.add(tempIDs[i]);
    }
    //  uniquePageIDs= filterDates(startOfDateRange, endOfDateRange);
    pageIDsOwn = new ArrayList();
    pageIDsShared = new ArrayList();
  }
  void resetTime() {
    countOwn=0;
    countShared=0;
    uniquePageIDs=new ArrayList();
    int[] tempIDs=filterDates(startOfDateRange, endOfDateRange);
    for (int i=0;i<tempIDs.length;i++) {
      uniquePageIDs.add(tempIDs[i]);
    }
    // uniquePageIDs=getUniquePageIDs(filterDates(startOfDateRange, endOfDateRange));
    //uniquePageIDs= filterDates(startOfDateRange, endOfDateRange);
    countOwnActivity();
  }
  void drawUser() {
    fill(0);
    String shortName="";
    textAlign(CENTER);

    textFont(font, 8);
        fill(ownColor);

    text("edits on my pages "+str(countOwn), x, y+10);
        fill(sharedColor);

    text("edits on shared pages "+str(countShared), x, y+20);

    if (mouseOver()) {
      lightUpPages();
//println("mouse over"+name);

      stroke(10, 20);
      fill(220, 100);
      ellipse(x, y, circleRad*2, circleRad*2);
      noFill();
      ellipse(x, y, (circleRad*2)-40, (circleRad*2)-40);
    }
    else {
      extinguishPages() ;
      noFill();
      stroke(10, 20);
      ellipse(x, y, circleRad*2, circleRad*2);

      ellipse(x, y, (circleRad*2)-40, (circleRad*2)-40);
    }
    fill(0);
    textFont(font, 16);
    shortName+=name.charAt(0);
    shortName+=name.charAt(name.length()-1);
    text(shortName, x, y);

    drawOwnActivity();
    drawSharedActivity();
  }

  void drawOwnActivity() {
    noStroke();
    int newAlpha=10;
    color newColor = (ownColor & 0xffffff) | (newAlpha << 24); 

    fill(newColor);

    int rad=circleRad-20;
    float limitAngle = map(countOwn, 0, maxOwnActivity, 0, TWO_PI);
    float smear=0;
    float adjustAngle=-PI*0.5;
    float increment=0.01;
    for (float i=0;i< limitAngle;i+=increment) {
     if(i>=(limitAngle)-increment){
      fill(ownColor);
     }
      float x1 = rad * cos(adjustAngle+i);
      float y1= rad * sin(adjustAngle+i);

      ellipse(x+x1, y+y1, 10, 10);
    }


    float x1 = rad * sin( adjustAngle+limitAngle);
    float y1= rad * cos(adjustAngle+limitAngle);
    //text(str(countOwn), x+x1, y+y1);
  }
  void drawSharedActivity() {
    noStroke();
    int newAlpha=10;
    color newColor = (sharedColor & 0xffffff) | (newAlpha << 24); 
    fill(newColor);

    int rad=circleRad;
    float limitAngle = map(countShared, 0, maxSharedActivity, 0, TWO_PI);
    float smear=0;
    float adjustAngle=-PI*0.5;
    float increment=0.01;

    for (float i=0;i< limitAngle;i+=increment) {
      if(i>=(limitAngle)-increment){
            stroke(200);
      fill(sharedColor);
     }
      float x1 = rad * cos(adjustAngle+i);
      float y1= rad * sin(adjustAngle+i);

      ellipse(x+x1, y+y1, 10, 10);
    }
    float x1 = rad * sin( adjustAngle+limitAngle);
    float y1= rad * cos(adjustAngle+limitAngle);
    // text(str(countOwn), x+x1, y+y1);
  }

  void countOwnActivity() {

    pageIDsOwn = new ArrayList();
    pageIDsShared = new ArrayList();
    for (int i=0;i< uniquePageIDs.size();i++) {
      int thisID=(Integer)uniquePageIDs.get(i);
      //if (thisID<550) {

      if (onlyMeEditing(titles[i], thisID)) {
        countOwn++;
        pageIDsOwn.add(thisID);
      }
      else {
        countShared++;
        pageIDsShared.add(thisID);
      }
      //  }
    }
    pageIDsOwn= makeArrayListUnique(pageIDsOwn);
    pageIDsShared = makeArrayListUnique(pageIDsShared);
  }
  void countUniqueActivity() {
  }
  //returns a list of pageIDs which are within the date range

  int[] filterDates(Date rangeStart, Date rangeEnd) {
    // println(name+" FILTERING DATES FOR THIS NUMBER OF DATES "+times.length);
    ArrayList inRange = new ArrayList();
    for (int i=0;i<times.length;i++) {
      if (rangeStart.compareTo(times[i])<0 &&rangeEnd.compareTo(times[i])>=0 ) { 
        inRange.add(pageIDs[i]);
        // println(times[i]+" is newer than "+ rangeStart +"&& is older than "+ rangeEnd);
      }
      else {
      }
    }
    return returnIntArray(inRange);
  }

  boolean onlyMeEditing(String title, int pageID) {          
    boolean onlyMe=true;
    try{
    //  println(" number of indices "+allPages[pageID].indices.length);
    for (int i=0;i<allPages[pageID].indices.length;i++) {
      //if any of the user indices for this page are different then the page has been editied by others
      if (allPages[pageID].indices[i]!=index) {
        // println("also edited by "+ userNames[i]);
        onlyMe=false;
      }
      else {
      }
    }
    }
    catch(Exception e){
      println(e);
    }
    //   if(onlyMe) println(title+" "+pageID+ " is only edited by "+name);
    return onlyMe;
  }

  boolean onlyMeEditingRecently(int pageID, Date range) {
    for (int i=0;i<allPages[pageID].indices.length;i++) {
      //if any of the user indices for this page are different then the page has been editied by others
      if (allPages[pageID].indices[i]!=index) {
      }
    }
    return true;
  }

  ArrayList getUniquePageIDs(int[] myPageIDs) {
    ArrayList myList = new ArrayList();

    for (int i=0;i<myPageIDs.length;i++) {
      if (!myList.contains(myPageIDs[i])) {
        myList.add(myPageIDs[i]);
      }
    }
    return myList;
  }
  ArrayList makeArrayListUnique(ArrayList myList1) {
    ArrayList myList = new ArrayList();

    for (int i=0;i<myList1.size();i++) {
      if (!myList.contains(myList1.get(i)) ) {
        myList.add(myList1.get(i));
      }
    }
    return myList;
  }
  void lightUpPages() {

    for (int i=0;i< pageIDsOwn.size() ;i++) {
      int thisIndex=(Integer)pageIDsOwn.get(i);
      allPages[thisIndex].highlight=true;
    }
    for (int i=0;i< pageIDsShared.size() ;i++) {
      int thisIndex=(Integer)pageIDsShared.get(i);
      allPages[thisIndex].highlightShared  =true;
    }
  }
  void extinguishPages() {

    for (int i=0;i< pageIDsOwn.size() ;i++) {
      int thisIndex=(Integer)pageIDsOwn.get(i);
      allPages[thisIndex].highlight=false;
    }
    for (int i=0;i< pageIDsShared.size() ;i++) {
      int thisIndex=(Integer)pageIDsShared.get(i);
      allPages[thisIndex].highlightShared=false;
    }
  }
  boolean mouseOver() {
    if (dist(mouseX, mouseY, x, y)<=circleRad) {
      return true;
    }
    else {
      return false;
    }
  }
}

