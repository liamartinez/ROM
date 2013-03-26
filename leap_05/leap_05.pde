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

PrintWriter output; 

void setup () {
  size (340, 800); 
  leap = new LeapMotionP5(this);
  theLeap = new leapObj();

  vis[0] = new Viz("Extension");
  vis[0].setRange (-60, "max"); 
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
  
    for (int i = 0; i < vis.length; i++) {
      vis[i].loadValues(i + "_" + vis[i].title + ".json"); 
      println ("loading: " + i + "_" + vis[i].title + ".json"); 
    }
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
        vis[i].saveFinalVal (i, vis[i].computeVal()); 
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

public void stop() {
  theLeap.stop();
}

