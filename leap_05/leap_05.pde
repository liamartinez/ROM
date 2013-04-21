import com.onformative.leap.LeapMotionP5; /* https://github.com/mrzl/LeapMotionP5 */
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.Hand; 

import controlP5.*;
ControlP5 cp5;

import processing.video.*;
Capture video;

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
int curViz; 
int [] curNum = new int[vis.length]; 
boolean showCam = false; 

int totalTime = 5000; 
int timer; 

JSONArray data;

PrintWriter output; 

String textInput = ""; 

void setup () {
  size (500, 800); 
  leap = new LeapMotionP5(this);
  theLeap = new leapObj();
  cp5 = new ControlP5(this);

  video = new Capture(this, 160, 120);
  video.start();  

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
    println ("loading: " + i + "_" + vis[i].title + ".json");
    vis[i].loadValues(i + "_" + vis[i].title + ".json");     
  }
  
    PFont font = createFont("arial",20);
    color black = color (0, 0, 0); 
    color white = color (255, 255, 255); 
    cp5.addTextfield("Notes").setPosition(10, height - 180).setSize(300,30).setAutoClear(false).setColorBackground(black).setColorForeground(white).setColorActive(white).setFont(font); 
}

void draw () {

  background (0); 

  if (video.available() == true) {
    video.read();
  }

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
    if (i == curViz) {
      vis[i].setCur (true);
      pushMatrix();
      translate (0, 150*i);  
      if (showCam) image(video, vis[curViz].camLoc, 20);
      popMatrix();
    } 
    else {
      vis[i].setCur(false);
    }

    if (vis[i].recording) {
      vis[i].smoothData(); 
      if ((millis() - timer) > totalTime) {
        vis[i].saveFinalVal (i, vis[i].computeVal()); 
        vis[i].recording = false;
        showCam = false; 
      }
    }
  }
  //textInput from p5 transfer
  textInput = cp5.get(Textfield.class,"Notes").getText();
}

void keyPressed () {

  if (key == CODED) {
    showCam = false; 
    if (keyCode == DOWN) {
      curViz = (curViz + 1) % 4;
    }
    if (keyCode == UP) {
      if (curViz > 0) {
        curViz--;
      }
      else {
        curViz = 3;
      }
    }
    
    if (keyCode == LEFT) {
      
     if (curNum[curViz] < vis[curViz].valSizeMax) {
       curNum[curViz] ++;
     } else {
       curNum[curViz] = vis[curViz].valSizeMax;
     }  
     vis[curViz].setNewVal(curNum[curViz]); 
     vis[curViz].loadNewPic(curNum[curViz]); 
    }
    
   if (keyCode == RIGHT) {
    if (curNum[curViz] >1) {
      curNum[curViz] --;  
    } else {
      curNum[curViz] = 0; 
    }
    vis[curViz].setNewVal(curNum[curViz]); 
    vis[curViz].loadNewPic(curNum[curViz]); 
    }
    
  }

  if (key == ENTER) {
    if (showCam) { 
      if (theLeap.allowRecord) {
      vis[curViz].record();
      vis[curViz].setDesc(textInput);     
      } else {
        println ("check your hands, error, not recording"); 
      }
    } else {
      showCam = true; 
    }
  }   
  println (curViz); 
  timer = millis();
}

public void clear() {
  cp5.get(Textfield.class,"Notes").clear();
}

void captureEvent(Capture c) {
  c.read();
}

public void stop() {
  theLeap.stop();
}

