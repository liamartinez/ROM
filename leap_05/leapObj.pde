class leapObj {

  String message; 
  float pitch, roll, yaw; 

  leapObj() {
  }

  void display() {

    if (leap.getHandList().size() < 1) {
      message = "No hand detected.";
    } 
    else if (leap.getHandList().size() > 1) {
      message = "More than 1 hand detected.";
    } 
    else {
      for (Finger finger : leap.getFingerList()) {
        PVector fingerPos = leap.getTip(finger);
        fill (255, 0, 0); 
        ellipse(fingerPos.x, fingerPos.y, 10, 10);
      }

      for (Hand hand : leap.getHandList()) {
        PVector handPos = leap.getPosition(hand);
        fill (255, 0, 0); 
        ellipse(handPos.x, handPos.y, 30, 30);
        pitch = leap.getPitch (hand); 
        roll = leap.getRoll(hand); 
        yaw = leap.getYaw (hand);
      }

      message = "Hand detected";
    }
  }

  float getPitch () {
    return pitch; 
  }
  
  float getYaw() {
    return yaw; 
  }
  
  float getRoll() {
    return roll; 
  }

  void showMsg(int xLoc, int yLoc) {
    fill (255); 
    text (message, xLoc, yLoc);
  }

  void stop () {
    leap.stop();
  }
}

