import com.onformative.leap.LeapMotionP5;
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.Hand; 

import org.json.*;

LeapMotionP5 leap;
Debug debug; 

//drawing
PVector anchor; 
PVector tip; 
float angle; 

boolean recording;
int totalTime = 10000; 
int timer; 

boolean debugOn = false;
boolean noLeap = false; 

JSONArray data;
ArrayList <Bob> values;
PrintWriter output; 

//leap
float pitch, roll, yaw; 

//data
float startVal, endVal, finalVal; 
float a; //the angle.

//text
int textX = 640/3; 
int textY = 480/3 * 2; 
int textH = 20; 

void setup () {
  size (640, 480, OPENGL); 
  leap = new LeapMotionP5(this);
  debug = new Debug (); 

  values = new ArrayList(); 

  anchor = new PVector (width/3, height/3); 
  tip = new PVector (0, 0);

}

void draw() {
  background (0); 
  
  //leap 
    for (Finger finger : leap.getFingerList()) {
    PVector fingerPos = leap.getTip(finger);
    ellipse(fingerPos.x, fingerPos.y, 10, 10);
  }
  
      for (Hand hand : leap.getHandList()) {
    PVector handPos = leap.getPosition(hand);
    fill (255, 0, 0); 
    ellipse(handPos.x, handPos.y, 30, 30); 
    pitch = leap.getPitch (hand); 
    roll = leap.getRoll(hand); 
    yaw = leap.getYaw (hand); 
    
  if (debugOn) debug.showAxes(pitch, yaw, roll); 
    
  }
  
  fill (255); 
  textAlign (CORNER); 
  text ("number of hands: " + leap.getHandList().size(), 20, 20); 
  text ("mousepress to start recoding, D for debug", 20, 40); 


  noFill(); 
  stroke (100); 
  ellipse (anchor.x, anchor.y, 200, 200); 

  for (int i = 0; i < 360; i+=30) {
    pushMatrix(); 
    translate (anchor.x, anchor.y); 
    rotate (radians(i)); 
    line (90, 0, 110, 0); 
    popMatrix();
  }

  fill (100);
  pushMatrix(); 
  translate (anchor.x, anchor.y); 
  arc (0, 0, 200, 200, radians(startVal), radians(endVal)); 
  popMatrix(); 

  //the rotating rect thing
  textAlign (CENTER); 
  text ("angle: " + (pitch), width/3*2, height/3+ 40); 

  pushMatrix();
  translate (width/3*2, height/3); 
  rotate (pitch); 
  rect (-10, -10, 20, 20);  
  popMatrix();

  //text display
  if (recording) {
    if (frameCount % 60 < 5) {
      fill (200, 0, 0);
    } 
    else {
      fill (255);
    }
    text ("RECORDING", textX, textY);
  }
  fill (200, 0, 0); 
  text ("START VAL: " + startVal, textX, textY + textH*1); 
  text ("END VAL: " + endVal, textX, textY + textH*2); 
  text ("TOTALVAL: " + finalVal, textX, textY + textH*3); 

  //do stuff
  if (recording) {
    endVal = pitch; 
    if ((millis() - timer) > totalTime) {
      saveEndVal(); 
      recording = false;
    }
  }
}


boolean saveStartVal() {
  startVal = pitch; 
  finalVal = 0; 
  return true;
}

boolean saveEndVal() {
  endVal = pitch; 
  saveFinalVal(); 
  return true;
}

boolean saveFinalVal() {
  finalVal = abs(endVal - startVal);

  Bob thisVal = new Bob(); 
  thisVal.count = values.size() + 1; 
  thisVal.day = day(); 
  thisVal.month = month(); 
  thisVal.year = year(); 
  thisVal.minute = minute();
  thisVal.second = second(); 
  thisVal.hour = hour(); 
  thisVal.value = finalVal; 

  values.add(thisVal); 

  data = new JSONArray(); 
  for (int i = 0; i < values.size(); i++) {
    Bob val = (Bob) values.get(i);
    JSONObject thisData = new JSONObject();
    try {
      thisData.put ("count", val.count);
      thisData.put ("month", val.month); 
      thisData.put( "day", val.day );
      thisData.put( "year", val.year);
      thisData.put( "hour", val.hour );
      thisData.put( "minute", val.minute );
      thisData.put( "angle", val.value );
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

void keyPressed () {
  if (key == 'd') debugOn = !debugOn; 
}


void mousePressed() {
  if (saveStartVal()) {
    recording = true; 
    timer = millis();
  }
}  

float noLeap() {
   // debug
  tip.x = mouseX; 
  tip.y = mouseY; 
  
  //constrain the line
  PVector diff = PVector.sub(tip, anchor); 
  diff.normalize(); 
  diff.mult(100); 
  diff.add(anchor); 

  //draw center
  noStroke(); 
  fill (255); 
  ellipse ( anchor.x, anchor.y, 20, 20); 
  
    //draw tip
  if (recording) {
    fill (255, 0, 0);
  } 
  else {
    fill (255);
  }
  ellipse (diff.x, diff.y, 20, 20); 

  //draw line
  stroke (200);  
  line (anchor.x, anchor.y, diff.x, diff.y); 

  //compute the angle
  float angle = degrees( atan2 ( tip.y - anchor.y, tip.x - anchor.x)); 
  
  return angle; 
}


public void stop() {
  leap.stop();
}

class Debug {
  
  float pitch, yaw, roll; 
  
  Debug() {

  }
  
  void showAxes(float p, float y, float r) {
    pitch = p; 
    yaw = y; 
    roll = r; 
    pushMatrix(); 
    noFill();
    stroke(255);
    translate (width/5, height/2); 
    text ("pitch", 0, - 30); 
    text (pitch/10, 0, 30); 
    rotateX (pitch/10); 
    box ( 30); 
    popMatrix(); 
    
    pushMatrix(); 
    noFill();
    stroke(255);
    translate (width/5*2, height/2); 
    text ("yaw", 0, - 30); 
    rotateY (yaw/10); 
    box ( 30); 
    popMatrix(); 
    
    pushMatrix(); 
    noFill();
    stroke(255);
    translate (width/5*3, height/2); 
    text ("roll", 0, - 30); 
    rotateZ (roll/10); 
    box ( 30); 
    popMatrix(); 
    
    
  }
  
  
}
class Visualizer{
  
  String name; 
  PVector val; 
  
  Visualizer() {}
  
  void init (String name_, PVector theVal){
    val = theVal; 
    name = name_;  
  }
  
  void update () {
  }
  
  void display() {
  }
  
}
class Bob {
  
 // Bob(); 
  int mode; //0 is left, 1 is right
  int count; 
  int year, month, day; 
  int hour, minute, second;
  
  float value; 
}
/*
record states:
 not recording
 recording
 
 save
 
 TO DO: 
 connect leap
 upload to JS
 connect to couchDB.
 
 */


