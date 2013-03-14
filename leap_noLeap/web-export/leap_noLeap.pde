//import org.json.*;


PVector anchor; 
PVector tip; 

float angle; 
boolean recording;
int totalTime = 3000; 
int timer; 

//JSONArray data;
ArrayList <Bob> values;
PrintWriter output; 



//data
float startVal, endVal, finalVal; 
float a; //the angle.

//text
int textX = 640/3; 
int textY = 480/3 * 2; 
int textH = 20; 

void setup () {
  size (640, 480); 

  values = new ArrayList(); 

  anchor = new PVector (width/3, height/3); 
  tip = new PVector (0, 0);

}

void draw() {
  background (0); 

  tip.x = mouseX; 
  tip.y = mouseY; 

  noFill(); 
  stroke (100); 
  ellipse (anchor.x, anchor.y, 200, 200); 

  for (int i = 0; i < 360; i+=30) {
    pushMatrix(); 
    translate (anchor.x, anchor.y); 
    rotate (radians(i)); 
    line (90, 0, 110, 0); 
    //text (i, 120, 5); //??
    popMatrix();
  }

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
 // a = degrees( atan2 ( tip.y - anchor.y, tip.x - anchor.x)); 

  a = someNum; 
  text ("somenum: " + someNum, 20, 20); 

  pushMatrix(); 
  translate (anchor.x, anchor.y); 
  arc (0, 0, 200, 200, radians(startVal), radians(endVal)); 
  popMatrix(); 

  //the rotating rect thing
  textAlign (CENTER); 
  text ("angle: " + (a), width/3*2, height/3+ 40); 

  pushMatrix();
  translate (width/3*2, height/3); 
  rotate (a); 
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
    endVal = a; 
    if ((millis() - timer) > totalTime) {
      saveEndVal(); 
      recording = false;
    }
  }
}


boolean saveStartVal() {
  startVal = a; 
  finalVal = 0; 
  return true;
}

boolean saveEndVal() {
  endVal = a; 
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

/*
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
*/
  return true;
}

void keyPressed () {
}

void mousePressed() {
  if (saveStartVal()) {
    recording = true; 
    timer = millis();
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
 
 start record
 save beginning value
 begin record with timer
 when timer finishes, save endvalue
 
 compute angle difference 
 
 save that in json file. 
 
 THEN: 
 mode left/right
 couchdb
 
 */


