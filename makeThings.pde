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


void makePage(int index) {


  if (fromJSON) {
    String js=join(loadStrings("patinaUserScrapes/pages/"+index+"pages.txt"), "");
    PrintWriter output;
    output=createWriter("pages"+str(index)+".txt");

    //println(js);
    JSONObject myData;

    //JSONArray myData;
    try {
      myData = new JSONObject(js);
      // myData = new JSONObject(js);
      //println(myData.length());

      JSONObject query = myData.getJSONObject("query");
      //println(query.getValue("usercontribs"));

      JSONObject pages = query.getJSONObject("pages");
      String []names1=pages.getNames(pages);

      JSONObject one = pages.getJSONObject(names1[0]);
      //println("names "+one.getJSONArray("title"));
      // println(one.getJSONObject("title"));
      //println(one);
      JSONArray revisions = one.getJSONArray("revisions");
      // println(one.getNames(one));
      //   JSONObject titles = one.getJSONObject("title");
      // println(one.get("title"));
      int [] pageId= new int[revisions.length()];
      String [] cmts= new String[revisions.length()];
      String [] usrs= new String[revisions.length()];
      Date [] tims = new Date[revisions.length()];
      String [] myDates= new String[revisions.length()];


      for (int i=0;i<revisions.length();i++) {

        JSONObject entry = revisions.getJSONObject(i);
        try {
          cmts[i]=entry.getString("comment");
        }
        catch(Exception e) {

          cmts[i]="";
        }
        String thisDate=entry.getString("timestamp");
        myDates[i]=thisDate;
        //println(thisDate);
        String replaceDate ="";
        ////////////////////DATE REPLACEMENT START////////////////////////////////////////
        DateFormat formatter ;
        for (int m=0;m<thisDate.length();m++) {

          if (thisDate.charAt(m)=='T') {
            replaceDate+=' ';
          } 
          else if (thisDate.charAt(m)=='Z') {
            replaceDate+="";
          } 
          else {
            replaceDate+=thisDate.charAt(m);
          }
        }

        formatter = new SimpleDateFormat("yyyy-MM-dd H:mm:ss");
        //  println("exploded[] "+exploded[2]);
        tims[i] = (Date)formatter.parse(replaceDate); 




        ////////////////////DATE REPLACEMENT END////////////////////////////////////////

        usrs[i]=entry.getString("user");
      }
      //println(usrs);

      output.println((String)one.get("title"));
      //output.println(index);
      for (int i=0;i<usrs.length;i++) {
        output.println(usrs[i]);
        output.println(cmts[i]);
        output.println(myDates[i]);
      }


      Page tempPage = new Page(index, usrs, cmts, tims, (String)one.get("title"));
      allPages[index]=tempPage;
      output.flush();
      output.close();
    }
    catch(Exception e) {
      // println(e);
    }
  }
  //load from txts
  else {
    String title="";
    ArrayList usrs=new ArrayList();
    ArrayList cmts=new ArrayList();
    ArrayList tims=new ArrayList();
    try {
      String [] fromFile=loadStrings(sketchPath("pages"+str(index)+".txt"));
      //println(sketchPath("pages"+str(index)+".txt")+ " "+fromFile.length);
      if (fromFile.length>0) {
        title=fromFile[0];

        int counter=0;
        for (int i=1;i<fromFile.length-1;i++) {
          // println(i);

          if (counter==0) {
            usrs.add(fromFile[i]);
          }
          if (counter==1) {
            cmts.add(fromFile[i]);
          }
          if (counter==2) {
            //println("times "+fromFile[i]);
            String thisDate=fromFile[i];//entry.getString("timestamp");
            String replaceDate ="";
            ////////////////////DATE REPLACEMENT START////////////////////////////////////////
            DateFormat formatter ;
            for (int m=0;m<thisDate.length();m++) {

              if (thisDate.charAt(m)=='T') {
                replaceDate+=' ';
              } 
              else if (thisDate.charAt(m)=='Z') {
                replaceDate+="";
              } 
              else {
                replaceDate+=thisDate.charAt(m);
              }
            }

            formatter = new SimpleDateFormat("yyyy-MM-dd H:mm:ss");
            //  println("exploded[] "+exploded[2]);
            //tims[i] = (Date)formatter.parse(replaceDate); 



            tims.add((Date)formatter.parse(replaceDate));
          }
          counter++;
          if (counter>=3) {
            counter=0;
          }
        }
      }
    }
    catch(Exception e) {
      println (e);
    }
    Page tempPage = new Page(index, returnStringArray(usrs), returnStringArray(cmts), returnDateArray(tims), title);
    allPages[index]=tempPage;
  }
}

void makeUser(String whichUser, int index) {

  if (fromJSON) {
    String js=join(loadStrings("patinaUserScrapes/apiResult_"+whichUser+".txt"), "");
    PrintWriter output;

    JSONObject myData;

    try {
      output=createWriter("users"+str(index)+".txt");

      myData = new JSONObject(js);

      JSONObject query = myData.getJSONObject("query");

      String []names=query.getNames(query);
      //  println(whichUser);
      //  println(names);

      JSONArray usercontribs = query.getJSONArray("usercontribs");

      JSONObject temp = usercontribs.getJSONObject(0);
      JSONArray insideNames = temp.names();
      // println(insideNames);
      /*int [] pageId= new int[usercontribs.length()];
       String [] cmts= new String[usercontribs.length()];
       String [] ttls= new String[usercontribs.length()];
       Date [] tims = new Date[usercontribs.length()];*/

      ArrayList pageId = new ArrayList();
      ArrayList cmts = new ArrayList();
      ArrayList ttls = new ArrayList();      
      ArrayList tims = new ArrayList();

      ArrayList myDates = new ArrayList();

      for (int i = 0; i < usercontribs.length(); i++) {
        JSONObject entry = usercontribs.getJSONObject(i);
        //println("size is " + entry.getInt("size") + " here is a comment: " + entry.getString("comment"));
        // println(i+" "+entry);
        String thisDate=entry.getString("timestamp");
        myDates.add(thisDate);
        Date date;
        DateFormat formatter ; 
        //example date 2011-06-25 15:10:43
        //2011-01-24T15:46:45Z
        //reformat date to suit
        String replaceDate ="";

        for (int m=0;m<thisDate.length();m++) {

          if (thisDate.charAt(m)=='T') {
            replaceDate+=' ';
          } 
          else if (thisDate.charAt(m)=='Z') {
            replaceDate+="";
          } 
          else {
            replaceDate+=thisDate.charAt(m);
          }
        }


        formatter = new SimpleDateFormat("yyyy-MM-dd H:mm:ss");
        date = (Date)formatter.parse(replaceDate); 

        //tims[i]=date;
        //  println("INCLUDED");
        //    println( usercontribs.length()+" "+i+" "+whichUser+" "+ date+" "+date.compareTo(lastWeek)+" "+lastWeek );

        tims.add(date);
        cmts.add(entry.getString("comment"));
        // cmts[i]= entry.getString("comment") ;
        pageId.add(entry.getInt("pageid"));
        //pageId[i] = entry.getInt("pageid");
        // ttls[i] = entry.getString("title");
        ttls.add(entry.getString("title"));
      }

      //make the user object here
      float rad = innerRad;
      float theta = TWO_PI/numUsers;
      int tempX =int( rad * cos(theta*index));
      int tempY= int(rad * sin(theta*index));
      User tempU = new User(whichUser, returnIntArray(pageId), returnStringArray(cmts), returnStringArray(ttls), returnDateArray(tims), width/2 + tempX, height/2 + tempY, index, outerRad, int(innerRad));
      users[index]= tempU;
      println("size "+pageId.size());
      for (int i=0;i<pageId.size();i++) {
        output.println(pageId.get(i));
        output.println(cmts.get(i));
        output.println(ttls.get(i));
        output.println(myDates.get(i));
        //println("printintl");
      }
      output.flush();
      output.close();
    }
    catch(Exception e) {
      // println(e);
    }
  }
  else {

    String title="";
    ArrayList pageId = new ArrayList();
    ArrayList cmts = new ArrayList();
    ArrayList ttls = new ArrayList();      
    ArrayList tims = new ArrayList();
     try {
      String [] fromFile=loadStrings(sketchPath("users"+str(index)+".txt"));
      //println(sketchPath("pages"+str(index)+".txt")+ " "+fromFile.length);
      if (fromFile.length>0) {
      //  title=fromFile[0];
        int counter=0;
        for (int i=0 ;i<fromFile.length-1;i++) {

         // println(i);

          if (counter==0) {
            pageId.add(int(fromFile[i]));
            
                        println(index + " pageID "+fromFile[i]);

          }
          if (counter==1) {
            cmts.add(fromFile[i]);
          }
          if (counter==2) {
            ttls.add(fromFile[i]);
          }
          if (counter==3) {
            println(index + " date "+fromFile[i]);
            //println("times "+fromFile[i]);
            String thisDate=fromFile[i];//entry.getString("timestamp");
            String replaceDate ="";
            ////////////////////DATE REPLACEMENT START////////////////////////////////////////
            DateFormat formatter ;
            for (int m=0;m<thisDate.length();m++) {

              if (thisDate.charAt(m)=='T') {
                replaceDate+=' ';
              } 
              else if (thisDate.charAt(m)=='Z') {
                replaceDate+="";
              } 
              else {
                replaceDate+=thisDate.charAt(m);
              }
            }

            formatter = new SimpleDateFormat("yyyy-MM-dd H:mm:ss");
            //  println("exploded[] "+exploded[2]);
            //tims[i] = (Date)formatter.parse(replaceDate); 



            tims.add((Date)formatter.parse(replaceDate));
          }
          counter++;
          if (counter>=4) {
            counter=0;
          }
        }
      }
    }
    catch(Exception e) {
      println (e);
    }
       //make the user object here
      float rad = innerRad;
      float theta = TWO_PI/numUsers;
      int tempX =int( rad * cos(theta*index));
      int tempY= int(rad * sin(theta*index));
        User tempU = new User(whichUser, returnIntArray(pageId), returnStringArray(cmts), returnStringArray(ttls), returnDateArray(tims), width/2 + tempX, height/2 + tempY, index, outerRad, int(innerRad));
      users[index]= tempU;
  }

}
