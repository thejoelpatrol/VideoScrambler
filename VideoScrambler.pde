/* This is a quick script I threw together as a proof of concept, and ended up using a handful of times. 
  With some cleaning up, it can be a useful thing to share. For now, here's the version that exists. */
  
import processing.video.*;
import processing.opengl.PGraphicsOpenGL;

//int samples = 10;
//int max_sample_size = 150;
int samples = 40;
int max_sample_size = 50;
float horizontal_warp = 5;
int frame_rate = 30;
Movie input_movie;
boolean saveFrames = true;
boolean glitch_frame;
String filename ="insert filename here";

void setup() {
  size(480,720);
  input_movie = new Movie(this, filename); 
  frameRate(frame_rate);
  input_movie.loop(); 
}


void draw () { 
  input_movie.read();
  image(input_movie,0,0);
  
  int glitch = int(random(10));
  if (glitch > 5)
    glitch_frame = true;
  else
    glitch_frame = false;
  
  
  loadPixels();
  
  if (glitch_frame) {  
    for(int i = 1; i <= samples; i++) {
      int selection_width = int(random(horizontal_warp*max_sample_size));
      int selection_height = int(random(max_sample_size));
      int temp_image_loc = 0;
      
      if (selection_height > height) 
        selection_height = height;   
      if (selection_width > width) 
        selection_width = width;      
      
      PImage temp_image = new PImage(selection_width,selection_height);
      int start_x = int(random(width-selection_width));
      int start_y = int(random(height-selection_height));
      
      temp_image.loadPixels();
      
      for (int y = start_y; y < (start_y + selection_height); y++) {
        for (int x = start_x; x < (start_x + selection_width); x++) {
          int loc = x + y * width;
          temp_image.pixels[temp_image_loc] = pixels[loc];                    
          temp_image_loc++;
        } // for x
      } // for y   
      int new_x = int(random(width)) - width/4;
      if (new_x < 0) 
        new_x = 0;
      int new_y = int(random(height)) - height/4 + 50;
      if (new_y < 0) 
        new_y = 0;
     
      image(temp_image,new_x,new_y);
    } // for i       
  } // if glitch frame 
  
  
  
  if (saveFrames)
    saveFrame(filename + "-####" + ".png");  

}  // draw()


void mousePressed() {
  exit();
}

