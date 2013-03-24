import com.onformative.leap.LeapMotionP5; /* https://github.com/mrzl/LeapMotionP5 */
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.Hand; 

/* //for processing 2.8
 import org.json.JSONObject;
 import org.json.JSONArray;
 import org.json.JSONException;
 */

import org.json.*;

LeapMotionP5 leap;
leapObj theLeap; 

/* 0 - Extension; //bending up 
 1 - Flexion; //bending down
 2 - Supination; //rotate palm up 
 3 - Pronation; //rotate palm down 
 */

Viz[] vis = new Viz [4]; 

int totalTime = 5000; 
int timer; 

JSONArray data;
ArrayList <Val> values;
PrintWriter output; 

void setup () {
  size (340, 800); 
  leap = new LeapMotionP5(this);
  theLeap = new leapObj();

  values = new ArrayList(); 
  loadValues(); 


  vis[0] = new Viz("Extension");
  vis[0].setRange (-30, "max"); //return to -60
  vis[0].setInstructions("Palm face up. Bend down."); 

  vis[1] = new Viz ("Flexion"); 
  vis[1].setRange (-80, "max"); 
  vis[1].setInstructions("Palm face down. Bend down."); 

  vis[2] = new Viz ("Supination"); 
  vis[2].setRange (-50, "min"); 
  vis[2].setInstructions("Rotate so palm faces up"); 

  vis[3] = new Viz ("Pronation"); 
  vis[3].setRange (20, "min"); 
  vis[3].setInstructions("Rotate so palm faces down");
}

void draw () {

  background (0); 

  vis[0].setValue(theLeap.getPitch()); 
  vis[1].setValue(theLeap.getPitch()); 
  vis[2].setValue(theLeap.getRoll()); 
  vis[3].setValue(theLeap.getRoll()); 

  for (int i = 0; i < vis.length; i++) {
    pushMatrix(); 
    translate (0, i*150); 
    vis[i].display();
    vis[i].showHist (100); 
    popMatrix();
  }

  pushMatrix();
  translate (0, 150*(vis.length-1));  
  scale (.7); 
  theLeap.display(); 
  popMatrix();
  theLeap.showMsg(50, height - 50);

  for (int i = 0; i < vis.length; i++) {
    if (vis[i].recording) {
      if ((millis() - timer) > totalTime) {
        saveFinalVal (i, vis[i].computeVal()); 
        vis[i].recording = false;
      }
    }
  }
}

void keyPressed () {
  if (key == '1') vis[0].record(); 
  if (key == '2') vis[1].record(); 
  if (key == '3') vis[2].record(); 
  if (key == '4') vis[3].record();
  timer = millis();
}

boolean saveFinalVal(int modeNum, float theValue) {

  Val thisVal = new Val(); 
  thisVal.count = values.size() + 1; 
  thisVal.day = day(); 
  thisVal.month = month(); 
  thisVal.year = year(); 
  thisVal.minute = minute();
  thisVal.hour = hour(); 
  thisVal.value = theValue; 
  thisVal.mode = modeNum; 

  values.add(thisVal); 

  data = new JSONArray(); 
  for (int i = 0; i < values.size(); i++) {
    Val val = (Val) values.get(i);
    JSONObject thisData = new JSONObject();
    try {
      thisData.put ("count", val.count);
      thisData.put ("month", val.month); 
      thisData.put( "day", val.day );
      thisData.put( "year", val.year);
      thisData.put( "hour", val.hour );
      thisData.put( "minute", val.minute );
      thisData.put( "value", val.value );
      thisData.put ("mode", val.mode);
    }
    catch(JSONException e) {
      e.getCause();
    }
    data.put( thisData );
  }

  println ("************************************************");
  println( data );
  output = createWriter ("dataFromLeap.txt"); 
  output.println (data); 
  output.flush(); 

  return true;
}
void loadValues() {

  String result = join (loadStrings("dataFromLeap.txt"), "");
  try {
    //JSONObject data = new JSONObject(result);

    //JSONArray results = data.getJSONArray("progress");
    JSONArray results = new JSONArray (result); 

    println (results.length()); 
    for (int i = 0; i < results.length(); i++) {
      JSONObject thisObj = results.getJSONObject(i);
      Val thisVal = new Val(); 
      thisVal.day = thisObj.getInt ("day"); 
      thisVal.month = thisObj.getInt ("month"); 
      thisVal.year = thisObj.getInt ("year"); 
      thisVal.minute = thisObj.getInt ("minute"); 
      thisVal.hour = thisObj.getInt ("hour"); 
      double temp = thisObj.getDouble ("value"); 
      thisVal.value = (float)temp; 
      thisVal.mode =thisObj.getInt ("mode"); 
      values.add (thisVal); 
      println ("added: " + i);
    }
  } 
  catch (JSONException e) {
    println ("error: " + e);
  }
}


public void stop() {
  theLeap.stop();
}

