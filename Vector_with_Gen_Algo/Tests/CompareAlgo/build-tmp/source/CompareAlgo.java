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

public class CompareAlgo extends PApplet {



PImage canny, src;

public void setup() {
    src = loadImage("test.png");
    

    OpenCV opencv = new OpenCV(this, src);
    // opencv.blur(6);
    opencv.findCannyEdges(PApplet.parseInt(0xFF * 0.30f), PApplet.parseInt(0xFF * 0.50f));
    canny = opencv.getSnapshot();
}

public void draw() {
    image(canny, 0, 0);
}
  public void settings() {  size(200, 200); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "CompareAlgo" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
