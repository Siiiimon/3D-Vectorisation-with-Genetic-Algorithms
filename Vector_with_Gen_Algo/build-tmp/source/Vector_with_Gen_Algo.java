import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import gab.opencv.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Vector_with_Gen_Algo extends PApplet {




OpenCV opencv;
PImage src, canny, blur;
ImageProcessor imgP;

List<Gene> a = new ArrayList<Gene>();
int box_size = 400;

long start;
long stop;

public void setup() {
    src = loadImage("test.jpg");
    
    // noLoop();

    start = millis();

    imgP = new ImageProcessor(this);
    canny = imgP.getCanny(src);

    stop = millis();
    println("Needed "+ (stop - start) + " milliseconds.");


    for (int i=0; i<200; i++)
        a.add(new Gene(box_size));
}

float angle = 0;
boolean is_ani = true;

public void draw() {
    // PImage screen = get(); - stores frame
    background(200);
    camera(cos(radians(angle))*width, 0, sin(radians(angle))*width, 0, 0, 0, 0, 1, 0);
    

    for (Gene el : a)
        el.draw(this);

    pushMatrix();
    scale(0.3f);
    translate(0, 0, box_size / 2 / 0.3f);
    image(src, -width, -height/2);
    image(canny, 0, -height/2);
    popMatrix();

    text("Canny", 10, 20, box_size/2 + 1);
 

    // the animation procedure
    if (keyPressed) {
        if (keyCode == LEFT)
            angle += 0.5f;
        else if (keyCode == RIGHT)
            angle -= 0.5f;
    } else if (is_ani)
        angle += 0.5f;
}

public void keyPressed() {
    if (key == ' ') {
        is_ani = !is_ani;
    }
}
/**
 * This class represents one Gene of the DNA.
 * In this case, that's one line.
 **/
public class Gene {

    PVector v1, v2;
    int box_size;

    public Gene (int box_size) {
        this.box_size = box_size;
        v1 = new PVector(rand(), rand(), rand());
        v2 = new PVector(rand(), rand(), rand());
    }

    private float rand() {
        return random(-box_size/2, box_size/2);
    }

    public void draw(PApplet app) {
        app.line(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z);
    }

}
public class DNA {

    public DNA () {

    }
}
public class ImageProcessor {

    private OpenCV opencv;
    private PApplet app;
     

    public ImageProcessor(PApplet app) {
        this.app = app;
    }

    public PImage getCanny(PImage src) {
        if (opencv == null || src.width != opencv.width || src.height != opencv.height)
            opencv = new OpenCV(app, src);
        else
            opencv.loadImage(src);

        opencv.blur(6);
        opencv.findCannyEdges(PApplet.parseInt(0xFF * 0.30f), PApplet.parseInt(0xFF * 0.50f));
        return opencv.getSnapshot();
    }
}
  public void settings() {  size(600, 600, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Vector_with_Gen_Algo" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
