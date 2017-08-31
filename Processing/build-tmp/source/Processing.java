import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import gab.opencv.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Processing extends PApplet {



OpenCV opencv;
PImage src, canny, blur;

long start;
long stop;

public void setup() {
    src = loadImage("test.jpg");
    
    noLoop();
    
    start = millis();

    opencv = new OpenCV(this, src);
    opencv.blur(6);

    blur = opencv.getSnapshot();

    opencv.findCannyEdges( PApplet.parseInt(0xFF * 0.30f), PApplet.parseInt(0xFF * 0.50f));
    canny = opencv.getSnapshot();

    stop = millis();
    println("Needed "+ (stop - start) + " milliseconds.");
}


public void draw() {
    pushMatrix();
    scale(0.5f);
    image(src, 0, 0);
    image(blur, src.width, 0);
    image(canny, src.width*2, 0);
    popMatrix();

    text("Source", 10, 25); 
    text("Canny", src.width/2 * 2 + 10, 25); 
}
public class ImageProcessor {

    public ImageProcessor() {
        
    }

    public PImage getStroke() {
        return null;
    }
}
  public void settings() {  size(829, 511); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Processing" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
