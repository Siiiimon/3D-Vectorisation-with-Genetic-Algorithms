import gab.opencv.*;
import java.util.*;

OpenCV opencv;
PImage src, canny, acanny, blur;
ImageProcessor imgP;
DNA indi;

short box_size = 400;

long start;
long stop;

double score;

void setup() {
    src = loadImage("test.jpg");
    size(600, 600, P3D);
    pixelDensity(displayDensity());
    // noLoop();

    start = millis();

    imgP = new ImageProcessor(this);
    canny = imgP.getCanny(src, box_size);

    stop = millis();
    println("Needed "+ (stop - start) + " milliseconds.");

    indi = new DNA(box_size);

    ScoreMaker sm = new ScoreMaker();

    start = millis();
    try {
        score = sm.calcScore(indi, canny);
    } catch (Exception e) {
        e.printStackTrace();
    }
    stop = millis();
    println("Needed "+ (stop - start) + " milliseconds.");
}

float angle = 90;
boolean is_ani = false;

void draw() {
    // PImage screen = get(); - stores frame
    background(100);
    camera(cos(radians(angle))*width, 0, sin(radians(angle))*width, 0, 0, 0, 0, 1, 0);
    
    stroke(255);
    indi.draw(g);
    translate(0, 0, 199);
    hint(DISABLE_DEPTH_TEST);
    image(canny, -200, -200);
    text(String.format("Score: %.3f", score) , -180, -170, 1);

    /*
    image(canny, -200, -200);
    scale(100);
    PImage t = createImage(2, 2, RGB); 
    t.loadPixels();
    t.pixels[0] = 0xFF0000;
    t.pixels[1] = 0x00FF00;
    t.pixels[2] = 0x0000FF;   

    t.updatePixels();
    image(t, -3, -3);*/

    // the animation procedure
    if (keyPressed) {
        if (keyCode == LEFT)
            angle += 1;
        else if (keyCode == RIGHT)
            angle -= 1;
    } else if (is_ani)
        angle += 0.5;
}

void keyPressed() {
    if (keyCode == ESC)
        exit();
    else if (key == ' ') {
        is_ani = !is_ani;
    }
}