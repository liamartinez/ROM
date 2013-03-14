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
