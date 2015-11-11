import processing.video.*;

Capture cam;

void setup(){
  size(640,360);
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[0]);
  cam.start();
  
  noStroke();
  
}


void draw(){
  if(cam.available() == true){
    cam.read();
    image(cam,0,0, width, height);
  }
  float red = 0;
  float green = 0;
  float blue = 0;
  loadPixels();
  for(int y = 0; y<height; y++){
    for(int x = 0; x<width; x++){
      int loc = y*width+x ;
      red += ( pixels[loc] >> 16) & 0xff; 
      green +=( pixels[loc] >> 8 ) & 0xff; 
      blue += pixels[loc] & 0xff; 
    }
  }
  
  red /= width*height;
  green /= width*height;
  blue /= width*height;
  
  color c = color(red, green, blue);
  fill(c);
  rect(0,0,width, height);
  
  
  
}