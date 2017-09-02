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
PImage src, canny, acanny, blur;
ImageProcessor imgP;
DNA indi;  // one individual [testing]

short box_size = 400;
long start, stop;
double score;

public void setup() {
    src = loadImage("test_03.jpg");
    
    
    // surface.setResizable(true);
    // noLoop();


    start = millis();  // starts measure timer for canny

    imgP = new ImageProcessor(this);
    canny = imgP.getCanny(src, box_size);  // calculates edge detected image

    stop = millis();  // stops timer
    println("Canny calc.: "+ (stop - start) + " ms.");

    indi = new DNA(box_size);  // initalizes one individual [testing]

    ScoreMaker sm = new ScoreMaker();  // creates the score maker class

    start = millis();  // timer for score calculation
    try {
        score = sm.calcScore(indi, canny);  // calcs score 
    } catch (Exception e) {  // because I throw an exception, this is needed\u2026
        e.printStackTrace();
    }
    stop = millis();  // stops timer
    println("Score calc.: "+ (stop - start) + " ms.");
}

/* The view can be controlled with space, left and right arrow.
space   Toggle viewing rotation
left    Rotates the view clockwise
right   Rotates the view counterclockwise

There's also 'q', it stops the execution of the program
*/
float angle = 90;  // the initial viewing angle
boolean is_ani = false;  // if the camera should rotate around the center

public void draw() {
    background(0);  // black background
    camera(cos(radians(angle))*width, 0, sin(radians(angle))*width, 
        0, 0, 0, 0, 1, 0);  // for rotation
    
    /**** The block down here is [testing] ****/
    stroke(150);  // lines, that look like transparent
    indi.draw(g);  // drawing my current individual

    translate(0, 0, 199);  
    hint(DISABLE_DEPTH_TEST);  // so that I can see the lines through my image
    image(canny, -200, -200);  // the cannyed result I want to get to
    text(String.format("Score: %.3f", score) , -180, -170, 1);  // the current score

    // the animation procedure and controls
    if (keyPressed) {
        if (keyCode == LEFT)
            angle += 1;
        else if (keyCode == RIGHT)
            angle -= 1;
    } else if (is_ani)
        angle += 0.5f;
}

public void keyPressed() {
    if (key == 'q')
        exit();
    else if (key == ' ') {
        is_ani = !is_ani;
    }
}
/**
 * This class represents one DNA with many Genes. It's 
 * one individual
 **/
public class DNA {

    public static final int DEFAULT_AMOUNT = 100;
    public static final short DEFAULT_BOX_SIZE = 400;

    final int amount;
    final int box_size;
    List<Gene> genes = new ArrayList<Gene>();

    public DNA (short box_size, int amount) {
        this.amount = amount;
        this.box_size = box_size;

        for (int i=0; i<amount; i++)
            genes.add(new Gene(box_size));
    }

    public DNA(int amount) {
        this(DEFAULT_BOX_SIZE, amount);
    }

    public DNA (short box_size) {
        this(box_size, DEFAULT_AMOUNT);
    }

    public DNA() {
        this(DEFAULT_BOX_SIZE, DEFAULT_AMOUNT);
    }

    public void draw(PGraphics pg) {
        for (Gene gene : genes)
            gene.draw(pg);
    }

    public List<Gene> getGenes() {
        return genes;
    }
}
/**
 * This class represents one Gene of the DNA.
 * In this case, that's one line in the 3D space.
 **/
public class Gene {

    public PVector v1, v2;
    public final int box_size;

    public Gene (int box_size) {
        this.box_size = box_size;
        v1 = new PVector(rand(), rand(), rand());
        v2 = new PVector(rand(), rand(), rand());
    }

    private float rand() {
        return random(-box_size/2, box_size/2);
    }

    /**
     * Draws the image on a PGraphics object.
     **/
    public void draw(PGraphics pg) {
        pg.line(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z);
    }

}
/**
 * This class has function to process images. The most famous is presumably
 * the getCanny function.
 **/
public class ImageProcessor {

    private OpenCV opencv;
    private PApplet app;
     

    public ImageProcessor(PApplet app) {
        this.app = app;
    }

    private PImage addBorder(PImage in) {
        PImage img = createImage(box_size, box_size, RGB);

        in.loadPixels();  // otherwise I can't access in.pixels[]
        img.loadPixels();

        /* Using a hardcoded transformation because it's 
        a hell lot faster than the other way using 
        PGraphics in order to center the image.
        */
        int tmpX = (box_size - in.width) >> 1;  // >> 1 means / 2
        int tmpY = (box_size - in.height) >> 1;
        for (int x = 0; x < in.width; x++)
            for (int y = 0; y < in.height; y++)
                img.pixels[ y * box_size + x + tmpY * box_size + tmpX] = 
                    in.pixels[y * in.width + x];

        img.updatePixels();
        return img;
    }

    /**
     * Detectes edges of an image with Canny edge detection.
     * @param src The input image 
     * @param box_size Size of box, in which lines are destributed
     * @return PImage The final canny image. It's a square image with 
     *      width / height of box_size and the canny image in the center,
     *      filling the black square.
     **/
    public PImage getCanny(PImage src, short box_size) {
        /* This scales the input image down to box_size. I 
        use it here, so that my canny edges aren't to thin,
        when I scale it down later.
        */
        if (src.width > src.height)
            src.resize(box_size, 0);
        else
            src.resize(0, box_size);

        // Because OpenCV is awkward to use
        if (opencv == null 
            || src.width != opencv.width 
            || src.height != opencv.height)
            opencv = new OpenCV(app, src);
        else
            opencv.loadImage(src);

        opencv.blur(3);  // removes noise
        opencv.findCannyEdges(PApplet.parseInt(0xFF * 0.30f), PApplet.parseInt(0xFF * 0.50f));

        return addBorder(opencv.getSnapshot());
    }

    /**
     * Makes an input image half transparent.
     * @param src The input
     * @return PImage The half transparent input
     **/
    public PImage addTransparent(PImage src) {
        PImage img = createImage(src.width, src.height, ARGB);
        img.loadPixels();
        src.loadPixels();

        for (int i = 0; i < src.width * src.height; ++i)
            img.pixels[i] = (src.pixels[i] & 0xFFFFFF) | 0x7f000000;

        img.updatePixels();
        return img;
    }
}
/**
 * This class is responsible for calculating the score of an individual.
 **/
public class ScoreMaker {

    public ScoreMaker() {
        
    }

    /**
     * Renders the DNA. This is more than the DNA.draw() method, 
     * because here, I also specifiy the colors, perspective, camera, \u2026
     * in way that I can actually compare it to my edge image.
     * @param individual The DNA to display
     * @return PGraphics The rendered image
     **/
    public PGraphics renderDNA(DNA individual) {
        int h = individual.box_size;
        /* I need to divide by the displayDensity() here, 
        because createGrapics() otherwise creates an image with 
        (h * displayDensity())^2 pixels. (It still says that the 
        width and height is each h.) And Because I later use the 
        raw pixel data, I need h^2 pixels and not (h * displayDensity())^2
        */
        PGraphics pg = createGraphics(h / displayDensity(), 
            h / displayDensity(), P3D);  // creates a 3D scene
        pg.beginDraw();

        pg.scale(1.0f / displayDensity());  // to correct my drawing behaviour
        pg.background(0);

        pg.camera(h, 0, 0, 0, 0, 0, 0, 1, 0);
        // pg.frustum(h/2, -h/2, h/2, -h/2, h/2, h/2*3);
        pg.ortho(h>>1, -h>>1, h>>1, -h>>1);  // I want to see all lines
        // >>1 means / 2

        pg.stroke(255);
        individual.draw(pg);
        // for perspective debugging
        // pg.noFill();
        // pg.box(h);
        pg.endDraw();

        return pg;
    }

    /**
     * Calculates the score of my DNA, by comparing it with my canny image,
     * substract (with absolute value) them by each other and taking the
     * average.<br>
     * This has the effect, that the image, that has the most intersections
     * with my source image has the lowest score. Which means: The lower the 
     * score the better!!!!!!
     *
     * @param individual The DNA to score
     * @param grand_filter The canny image to compare to
     * @return double A score how far apart the two images are. 
     *      e.g. the lower the better!!!
     * @throws Exception Occours, when the grand_filter width or height isn't
     *      the box_size.
     **/
    public double calcScore(DNA individual, PImage grand_filter) throws Exception {
        if (grand_filter.width != individual.box_size 
            || grand_filter.height != individual.box_size)
            throw new Exception("The grand_filter image doesn't have the" +
                "width / height as the DNA box_size provides. " +
                "Both values must be the same.");

        PGraphics pg = renderDNA(individual);

        int score = 0;

        // For debuging purposes
        //PImage img = createImage(individual.box_size, individual.box_size, RGB);
        //img.loadPixels();


        pg.loadPixels();
        grand_filter.loadPixels();

        for (int i=0; i<pow(box_size, 2); i++) {
            int c = max(min(abs( (grand_filter.pixels[i] & 0xFF) 
                - (pg.pixels[i] & 0xFF)), 255), 0);
            // img.pixels[i] = c | c << 8 | c << 16;
            score += c;
        }

        // img.updatePixels();

        // println("score: "+ (score / pow(individual.box_size,2)));
        // return score / dim;
        //return img;
        return score / pow(individual.box_size,2);
    }
}
  public void settings() {  size(600, 600, P3D);  pixelDensity(displayDensity()); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Vector_with_Gen_Algo" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
