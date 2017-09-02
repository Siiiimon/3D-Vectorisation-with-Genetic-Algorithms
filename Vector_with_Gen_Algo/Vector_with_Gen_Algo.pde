import gab.opencv.*;
import java.util.*;

OpenCV opencv;
PImage src, canny, acanny, blur;
ImageProcessor imgP;
DNA indi;  // one individual [testing]

short box_size = 400;
long start, stop;
double score;

void setup() {
    src = loadImage("test_03.jpg");
    size(600, 600, P3D);
    pixelDensity(displayDensity());
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
    } catch (Exception e) {  // because I throw an exception, this is needed…
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

void draw() {
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
        angle += 0.5;
}

void keyPressed() {
    if (key == 'q')
        exit();
    else if (key == ' ') {
        is_ani = !is_ani;
    }
}