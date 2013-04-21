class Viz {

  //states
  boolean recording; 
  boolean isCur; 

  String title; 
  String instructions; 

  int max, min; 
  boolean isMin; 
  float value; 
  float startVal, endVal, finalVal; 
  float newEndVal; //constrained
  ArrayList <Val> values;
  String description = "TEXT!"; 

  //smoothing
  int numReadings = 10; 
  float[] readings; 
  int index = 0; 
  float total = 0; 
  float average = 0; 

  int camSize = 160; //todo make setter
  int camLoc = width - camSize;

  //history
  int valSizeMax;
  float lastVal; 
  boolean showLast = false; 
  PImage lastPic; 
  boolean hasPic = false; 
  Val lastValObj; 
  /*
  int lastYear, lastMonth, lastDay; 
   int lastHour, lastMinute;
   */

  //margins 
  int mTop = 35; 
  int mSides = 20;  

  int rX, rY; //rectangle location within Viz
  int rW = width - camSize - mSides*2;
  int rH = 30; 


  Viz(String title_) {
    title = title_;
    values = new ArrayList();

    readings = new float[numReadings];
    for (int thisReading = 0; thisReading < numReadings; thisReading++) {
      readings[thisReading] = 0;
    }
  }


void setRange(int rangeNum, String minOrMax) {
  if (minOrMax.equals ("max")) {
    max = rangeNum;
    isMin = false;
  } 
  else if (minOrMax.equals ("min")) {
    min = rangeNum; 
    isMin = true;
  }
}

void setInstructions(String inst) {
  instructions = inst;
}

void setValue (float value_) {
  value = value_; //these should be the same thing. fix.
  endVal = value_;
}

void setCur (boolean cur) {
  isCur = cur;
}

void display() {

  if (isCur) {
    fill (50);
  } 
  else {
    fill (0);
  }

  rect (0, 0, width, 150); //todo make setter
  if (hasPic) {
    image (lastPic, camLoc, 20);
  } 
  else {
    fill (255); 
    text ("< no pic >", camLoc + 50, 80); //todo fix coords
  }

  //title for the viz
  stroke (255); 
  line (0, 0, width, 0); 
  fill (255); 
  textSize (15); 
  text (title, mSides, 25); 

  //maps & constrains the range based on hard-coded values of the max of the working hand.
  //maximum for pitch, minimum for roll because 0 is the value for a flat hand.
  if (!isMin) {
    newEndVal = map (endVal, 0, max, 0, rW);
  } 
  else {
    newEndVal = map (endVal, min, 0, 0, rW);
  }   
  newEndVal = constrain(newEndVal, 0, rW); 

  //only become responsive to newEndVal when recording. otherwise, display last value
  fill (200, 0, 0); 
  if (recording) {
    rect (mSides, mTop, newEndVal, rH);
  } 
  else {
    rect (mSides, mTop, lastVal, rH); //fill in with last value
  }

  if (showLast) {
    fill (0, 255, 0, 100); 
    rect (mSides, mTop, lastVal, rH);
  }

  //this is just the border
  noFill(); 
  rect (mSides, mTop, rW, rH); 
  noStroke(); 

  //instructions
  stroke (255); 
  fill(255); 
  text (instructions, mSides, mTop+rH+mTop);

  //blinking circle 
  if (recording) {
    if (frameCount % 12 != 0) {
      fill (200, 0, 0);
    } 
    else {
      fill (255);
    }
    noStroke(); 
    ellipse (mSides*2, mTop+rH+mTop*2, 20, 20);
  }

  //timeStamps //todo lets make these separate functions
  textSize (11); 
  text (lastValObj.day + "/ " + lastValObj.month + "/ " + lastValObj.year, mSides, mTop+rH+mTop + 20); 
  text (lastValObj.hour + ": " + lastValObj.minute, mSides + 90, mTop+rH+mTop + 20);
  textSize (13); 
  text (lastValObj.desc, mSides + 90, mTop+rH+mTop + 35);
}

float showHist(float value_) {
  //lastVal = value_; 
  showLast = true; 
  return lastVal; 
  //show the history as gradients
}

boolean saveStartVal() {
  startVal = newEndVal; 
  finalVal = 0; 
  return true;
}

void record () {
  println ("recording"); 
  if (saveStartVal()) {
    recording = true;
  }
}

void smoothData() {
  total= total - readings[index];         
  readings[index] = newEndVal; 
  total= total + readings[index];       
  index = index + 1;                    

  if (index >= numReadings) index = 0;                           
  average = total / numReadings;
}

float computeVal() {
  if (!isMin) {
    finalVal = abs(average - startVal);
  } 
  else {
    finalVal = average;
  }    
  return finalVal;
}

float getLastVal() {
  Val tVal = (Val) values.get(values.size()-1);
  lastValObj = tVal; 
  return tVal.value;
}

boolean loadLastPic() {
  lastPic = new PImage(); 
  Val tVal = (Val) values.get(values.size()-1);    
  if (tVal.picName.equals("none")) {
    return false;
  } 
  else {
    lastPic = loadImage ("pics/" + tVal.picName); 
    return true;
  }
}

void setNewVal(int num) {
  valSizeMax = values.size()-1;
  // if (num == valSizeMax) num = valSizeMax; 
  Val tVal = (Val) values.get(values.size()-num-1);   
  lastVal = tVal.value; 
  lastValObj = tVal; 

  //return tVal.value;
}

boolean loadNewPic(int num) {
  lastPic = new PImage(); 
  Val tVal = (Val) values.get(values.size()-num-1);    
  if (tVal.picName.equals("none")) {
    return false;
  } 
  else {
    lastPic = loadImage ("pics/" + tVal.picName); 
    hasPic = true; 
    return true;
  }
}

void setDesc (String input_) {
  description = input_;
}

//-------------- For displaying raw values for debugging --------------------//
void displayRaw() {

  //title for the viz
  stroke (255); 
  line (0, 0, width, 0); 
  text (title, mSides, 25); 

  //maps & constrains the range based on hard-coded values of the max of the working hand.
  //maximum for pitch, minimum for roll because 0 is the value for a flat hand.
  float newVal; 
  if (!isMin) {
    newVal = map (value, 0, max, 0, rW);
  } 
  else {
    newVal = map (value, min, 0, 0, rW);
  }   
  newVal = constrain(newVal, 0, rW); 

  //always responsive
  fill (255, 10, 10); 
  rect (mSides, mTop, newEndVal, rH); 

  //this is just the border
  noFill(); 
  rect (mSides, mTop, rW, rH); 
  noStroke(); 

  stroke (255); 
  fill(255); 
  text (instructions, mSides, mTop+rH+mTop);
}



//------------------------------------- JSON -----------------------//

boolean saveFinalVal(int modeNum, float theValue) {

  //get values and time/date stamps
  Val thisVal = new Val(); 
  thisVal.count = values.size() + 1; 
  thisVal.day = day(); 
  thisVal.month = month(); 
  thisVal.year = year(); 
  thisVal.minute = minute();
  thisVal.hour = hour(); 
  thisVal.value = theValue; 
  thisVal.mode = modeNum; 
  thisVal.desc = description; 

  //save the picture
  PImage img = video.get(); 
  thisVal.pic = img; 
  thisVal.picName = thisVal.mode + "_" + thisVal.count + ".png"; 
  img.save("pics/" + thisVal.picName); 

  //save to the big Values array
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
      thisData.put ("picName", val.picName); 
      thisData.put ("desc", description); 

      lastVal =  getLastVal();
      if (loadLastPic()) hasPic = true;
      println ("new last val is: " + lastVal);
    }
    catch(JSONException e) {
      e.getCause();
    }
    data.put( thisData );
  }

  println ("************************************************");
  println( data );
  //output = createWriter ("dataFromLeap.txt"); 
  output = createWriter (modeNum + "_" + title + ".json"); 
  output.println (data); 
  output.flush(); 

  return true;
}


void loadValues(String filename) {

  try {
    String result = join (loadStrings(filename), "");
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
      thisVal.picName = thisObj.getString ("picName"); 
      println (thisVal.picName); 
      thisVal.desc = thisObj.getString("desc");
      values.add (thisVal); 
      println ("added: " + i);
    }
    lastVal =  getLastVal();
    if (loadLastPic()) hasPic = true;
  } 
  catch (JSONException e) {
    println ("error: " + e);
  }
}
}
