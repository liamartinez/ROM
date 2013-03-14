class Debug {
  
  float pitch, yaw, roll; 
  
  Debug() {

  }
  
  void showAxes(float p, float y, float r) {
    pitch = radians(p); 
    yaw = radians(y); 
    roll = radians(r); 
    pushMatrix(); 
    noFill();
    stroke(255);
    translate (width/5, height/2); 
    text ("pitch", 0, - 30); 
    text (pitch, 0, 30); 
    rotate (pitch); 
    rect (0,0,30, 30); 
    popMatrix(); 
    
    pushMatrix(); 
    noFill();
    stroke(255);
    translate (width/5*2, height/2); 
    text ("yaw", 0, - 30); 
    rotate (yaw); 
    rect (0,0,30, 30); 
    popMatrix(); 
    
    pushMatrix(); 
    noFill();
    stroke(255);
    translate (width/5*3, height/2); 
    text ("roll", 0, - 30); 
    rotate (roll); 
    rect (0,0,30, 30); 
    popMatrix(); 
    
    
  }
  
  
}
