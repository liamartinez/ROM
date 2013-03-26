class Viz {

  //states
  boolean recording; 

  String title; 
  String instructions; 

  int max, min; 
  boolean isMin; 
  float value; 
  float startVal, endVal, finalVal; 
  float newEndVal; //constrained
  ArrayList <Val> values;

  //history
  float lastVal; 
  boolean showLast = false; 

  //margins 
  int mTop = 35; 
  int mSides = 20;  

  int rX, rY; //rectangle location within Viz
  int rW = width - mSides*2;
  int rH = 30; 

  Viz(String title_) {
    title = title_;
    values = new ArrayList();
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

  void display() {

    //title for the viz
    stroke (255); 
    line (0, 0, width, 0); 
    fill (255); 
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
      ellipse (width - mSides*2, mTop+rH+mTop, 20, 20);
    }
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
    //blinking lights, countdown
  }

  float computeVal() {
    if (!isMin) {
      finalVal = abs(newEndVal - startVal);
    } 
    else {
      finalVal = newEndVal;
    }    
    return finalVal;
  }

  float getLastVal() {
    Val tVal = (Val) values.get(values.size()-1);
    return tVal.value;
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

        lastVal =  getLastVal();
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
        values.add (thisVal); 
        println ("added: " + i);
      }
      lastVal =  getLastVal();
    } 
    catch (JSONException e) {
      println ("error: " + e);
    }
  }
}

