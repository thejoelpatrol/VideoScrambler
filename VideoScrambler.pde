/* This is a quick script I threw together as a proof of concept, and ended up using a handful of times. 
  With some cleaning up, it can be a useful thing to share. For now, here's the version that exists, 
  but it would be hard to use. 
  
  To do: 
  decompose draw() 
  Add parameter-setting interface
  Add file chooser
  */
  
import processing.video.*;
import processing.opengl.PGraphicsOpenGL;

//int samples = 10;
//int max_sample_size = 150;
int samples = 40;
int max_sample_size = 50;
float horizontal_warp = 5;
float glitchProbability = 0.5;
int frame_rate = 30;
Movie input_movie;
boolean saveFrames = false;
String filename ="FILE0023.m4v";

void setup() {
    //size(640,352);
    input_movie = new Movie(this, filename); 
    frameRate(frame_rate);
    input_movie.loop();
    frame.setResizable(true);
}

void draw () { 
    input_movie.read();
    frame.setSize(input_movie.width, input_movie.height);
    image(input_movie,0,0);
      
    loadPixels();
  
    if (glitchFrame()) {  
        for(int i = 1; i <= samples; i++) {
            int selection_width = randomWidth();   
            int selection_height = randomHeight();
            PImage temp_image = createSample(selection_width, selection_height); 
            
            /*
            int new_x = int(random(width)) - width/4;
            if (new_x < 0) 
                new_x = 0;
            int new_y = int(random(height)) - height/4 + 50;
            if (new_y < 0) 
                new_y = 0;*/
            
            int new_x = int(random(width - selection_width/2));
            int new_y = int(random(height - selection_height/2));

            image(temp_image,new_x,new_y);
        } 
    } 
    
    if (saveFrames)
        saveFrame(filename + "-####" + ".png");  
} 

boolean glitchFrame() {
    if (random(1) > glitchProbability)
        return true;
    return false;
}

int randomWidth() {
    int selection_width = int(random(horizontal_warp*max_sample_size));
    if (selection_width > width) 
        return width;      
    return selection_width;
}

int randomHeight() {
    int selection_height = int(random(max_sample_size));
    if (selection_height > height)
        return height;
    return selection_height;
}

PImage createSample(int selection_width, int selection_height) {
    PImage sample = new PImage(selection_width,selection_height);
    int start_x = int(random(width-selection_width));
    int start_y = int(random(height-selection_height));
    int temp_image_loc = 0;
    
    sample.loadPixels();
    for (int y = start_y; y < (start_y + selection_height); y++) {
        for (int x = start_x; x < (start_x + selection_width); x++) {
            int loc = x + y * width;
            sample.pixels[temp_image_loc] = pixels[loc];                    
            temp_image_loc++;
        } 
    }   
    return sample;
}


void mousePressed() {
    exit();
}

