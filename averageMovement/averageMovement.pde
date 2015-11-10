import processing.video.*;
import processing.sound.*;


PShader diff;
PImage img;
int maxFrames =2;
PImage[] frames = new PImage[maxFrames];
int inc = 0;
int texIndex = 0;
int pastIndex = 1;
boolean doShader = false;
Capture cam;

SoundFile[] file;
int numsounds = 5;

void setup(){
  size(640,360, P2D);
  diff = loadShader("sub.glsl");
  
  String[] cameras = Capture.list(); 
  cam = new Capture(this, cameras[0]);
  cam.start();
 
  file = new SoundFile[numsounds];
  
  for(int i = 0; i<numsounds; i++){
    file[i] = new SoundFile(this, (i+1) + ".aif");  
  }
   
  
}

void draw(){
if (cam.available() == true) {
    cam.read();

    frames[texIndex] = cam.copy();
    texIndex = (texIndex + 1) % frames.length;
    pastIndex = (pastIndex + 1) % frames.length;

    if (doShader) {
      diff.set("lastFrame", frames[pastIndex]);
      diff.set("srcTex", frames[texIndex]);
    } else {
      diff.set("lastFrame", cam);
      diff.set("srcTex", cam);

      for (int i = 0; i<frames.length; i++) {
        //fill array with frames from cam initially
        frames[i] = cam.copy();
      }
      doShader = true;
    }
  }
  
  shader(diff);
  rect(0, 0, width, height);
  loadPixels();
  
  //get average pixel brightness
  int sum = 0;
  for(int y = 0; y<height; y++){
   for(int x = 0; x<width; x++){
      int loc = y*width+x;
      sum+=brightness(pixels[loc]);
   }
  }
  sum /= width*height;
  println(sum);
  
  //if the sum is in a certain range play a sound
  if(sum > 1 && sum <= 5){
      file[0].play();
  }
  if(sum >5 && sum <= 10){
      file[1].play();
  }  
  if(sum > 10 && sum <= 15){
      file[2].play();
  }
  if(sum > 15 && sum <= 20){
      file[3].play();
  }
  if(sum >20 ){
      file[4].play();
  }
}