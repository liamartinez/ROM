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
      println (newEndVal); 
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
    } else {
      finalVal = newEndVal; 
    }    
    lastVal = finalVal; 
    return finalVal;
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
}

