class Val {

  int mode; 
  /* 0 - Extension; //bending up 
     1 - Flexion; //bending down
     2 - Supination; //rotate palm up 
     3 - Pronation; //rotate palm down 
 */
 
  int count; 
  int year, month, day; 
  int hour, minute;
  
  float value; 
  
  PImage pic; 
  String picName = "none"; 
  
  Val(){
  pic = createImage (160, 120, RGB);  
  }
}
