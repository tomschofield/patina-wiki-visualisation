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
class Page
{
  int iD;

  //all users who have ever edited this page
  String[] userNames;
  //comments on each revision
  String[] comments;
  //dates of each revision
  Date[] dates;
  long oldestDate;
  int count;
  int [] indices;
  int thisX;
  int thisY;
  int xPos;
  int yPos;
  int pageRad=7;
  //title of this page
  String thisTitle;
  //highlight flag if this page has been edited only by a specific user. Set in user class
  boolean highlight;
  //highlight flag if this page has been edited only by more than one users. Set in user class

  boolean highlightShared;
  //highlight flag if this page title maches entered search term

  boolean highlightInSearch;

  Page(int id, String[] usrs, String[] cmts, Date[] dts, String tt) {
    iD=id;
    userNames=usrs;
    comments=cmts;
    dates= dts;
    count = dts.length;
    getUserIndices( );
    getConnectedUsers( );
    thisTitle=tt;
    oldestDate=getOldestRevisionDate();

    //this x and y is later overwritten anyway TODO fix this
    float rad= map(indices.length, 0, 16, 0, innerRad-(0.1*innerRad));
    float angle=random(0, TWO_PI);

    xPos=width/2+ int(rad * sin(angle));
    yPos =height/2+int( rad *cos(angle));

    highlight=false;
    highlightShared=false;
    highlightInSearch=false;
  }
  void drawPage() {
    pushStyle();
    pageRad = indices.length*3;

    noStroke();
    ellipseMode(CENTER);

    if (highlight) {
      noFill();
      stroke(ownColor); 
      strokeWeight(5);
      ellipse(xPos, yPos, pageRad*3, pageRad*3);
      noStroke();
      fill(255, 0, 0, 120); 
      ellipse(xPos, yPos, pageRad, pageRad);
    }
    if (highlightShared) {
      noFill();
      strokeWeight(5);

      stroke(sharedColor);
      ellipse(xPos, yPos, pageRad*2, pageRad*2);
      noStroke();
      fill(255, 0, 0, 120); 
      ellipse(xPos, yPos, pageRad, pageRad);
    }
    if (highlightInSearch) {
      noFill();
      strokeWeight(5);

      stroke(searchColour);
      ellipse(xPos, yPos, pageRad*3, pageRad*3);
      noStroke();
      fill(255, 0, 0, 120); 
      ellipse(xPos, yPos, pageRad, pageRad);
      textFont(font, 12);
      text(thisTitle, xPos+(0.5*pageRad)+2, yPos);
      if (mouseOver()) {
        getConnectedUsers( );
        drawPageConnections();
      }
    }
    else {
      if (!mouseOver()) {
        fill(100, 120);
        ellipse(xPos, yPos, pageRad, pageRad);
      }
      else {
        fill(255, 0, 0, 120); 
        getConnectedUsers( );
        drawPageConnections();
        textFont(font, 12);
        text(thisTitle, xPos+(0.5*pageRad)+2, yPos);
        ellipse(xPos, yPos, pageRad, pageRad);
      }
    }
    popStyle();
  }
  boolean mouseOver() {
    boolean isOver=false;
    
    int tol=2;
    if (mouseX>xPos - tol && mouseX < xPos+ tol && mouseY>yPos - tol && mouseY < yPos+ tol) {
      isOver=true;
    }

    else {
      isOver=false;
    }
    return isOver;
  }

//called on mouser over - draws lines to all users who have ever edited this page
  void drawPageConnections() {
    pushStyle();
   
    for (int i=0;i<indices.length;i++) {
      // println("indices "+indices[i]);
      float thatX= users[indices[i]].x;
      float thatY= users[indices[i]].y;
      stroke(100);
      strokeWeight(1);
      noFill();
      line(xPos, yPos, thatX, thatY);
      strokeWeight(1);
    }
    popStyle();
  }
  
  //list of all array positions in users array of all users who have ever edited this page 
  int [] getConnectedUsers() {
    ArrayList uniqueList = new ArrayList(); 


    for (int i=0;i<userNames.length;i++) {
      if (!uniqueList.contains(userNames[i])) {
        uniqueList.add( userNames[i] );
      }
    }
    int []  connectedUsers = new int[uniqueList.size()];
    String [] allUserNames = {
      "AngelikiC", "AnneB", "DanieleS", "DannyW", "EmmaT", "EnricoC", "GraemeE", "LucM", "MadelineB", "MartynD", "MattJ", "MikeF", "MikeJ", "PeterB", "RosamundD", "TomF", "TomS"
    };
    int count=0;
    for (int i=0;i<allUserNames.length;i++) {
      if (uniqueList.contains(allUserNames[i])) {
        connectedUsers[count]=i;

        // println ( "this page was edited by "+allUserNames[i]);
        count++;
      }
    }
    return connectedUsers;
  }

  void getUserIndices( ) {

    //make array of names unique
    String [] localuserNames = {
      "AngelikiC", "AnneB", "DanieleS", "DannyW", "EmmaT", "EnricoC", "GraemeE", "LucM", "MadelineB", "MartynD", "MattJ", "MikeF", "MikeJ", "PeterB", "RosamundD", "TomF", "TomS"
    };

    HashMap hm = new HashMap();


    for (int i=0;i<userNames.length;i++) {
      hm.put(userNames[i], "");
    }  
    int count=0;

    // println(hm.size()+ " SZIE COMPARE "+ localuserNames.length);

    indices = new int[hm.size()];
    String [] uniqueUsers = new String[hm.size()];

    Iterator i = hm.entrySet().iterator();  // Get an iterator

      while (i.hasNext ()) {
      Map.Entry me = (Map.Entry)i.next();
      uniqueUsers [count]=(String) me.getKey();
      count++;
    }

    for (int j=0;j<uniqueUsers.length;j++) {
      for (int k=0;k<localuserNames.length;k++) {
        if (uniqueUsers[j].equals(localuserNames[k])) {
          indices[j]=k;
        }
      }
    }
    //check against array of users
    for (int j=0;j<indices.length;j++) {
      // println("index at "+j+ " is "+indices[j]);
      //make an array of unique indices
    }
  }

  long getOldestRevisionDate() {
    Date today = new Date();
    long currentOldest=today.getTime();

    for (int i=0;i<dates.length;i++) {
      if (dates[i].getTime()<currentOldest) {
        currentOldest=dates[i].getTime();
        //println(currentOldest+" current oldest");
      }
    }
    Date oldest = new Date();
    oldest.setTime(currentOldest);
    println(oldest);
    return currentOldest;
  }
}

