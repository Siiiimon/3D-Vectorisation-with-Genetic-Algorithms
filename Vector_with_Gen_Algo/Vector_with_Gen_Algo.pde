import gab.opencv.*;
import java.util.*;

OpenCV opencv;
PImage src, canny, rendered;
ImageProcessor imgP;
DNA indi;  // one individual [testing]

short box_size = 400;
long start, stop;
double score;

void setup() {
    src = loadImage("test_03.jpg");
    // fullScreen(P3D, span);
    size(600, 600, P3D);
    pixelDensity(displayDensity());
    surface.setResizable(true);

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

    start = millis();
    rendered = sm.renderDNA(indi);
    stop = millis();
    println("Renderer calc.: "+ (stop - start) + " ms.");

    if (orthogonal)
        ortho();
}

/* The view can be controlled with space, left and right arrow.
space   Toggle viewing rotation
left    Rotates the view clockwise
right   Rotates the view counterclockwise

There's also 'q', it stops the execution of the program
*/
float angle = 90;  // the initial viewing angle
boolean is_ani = false;  // if the camera should rotate around the center
boolean orthogonal = false;
boolean show_canny = true;

void draw() {
    background(0);  // black background
    camera(cos(radians(angle))*box_size*1.5, 0, sin(radians(angle))*box_size*1.5, 
        0, 0, 0, 0, 1, 0);  // for rotation
    
    /**** The block down here is [testing] ****/
    stroke(150);  // lines, that look like transparent
    indi.draw(g);  // drawing my current individual

    translate(0, 0, 200);
    hint(DISABLE_DEPTH_TEST);  // so that I can see the lines through my image
    image(show_canny ? canny : rendered, -200, -200, 400, 400);  // the cannyed result I want to get to
    text(String.format("Score: %.3f", score) , -180, -170, 1);  // the current score
    translate(0, 0, -400);

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
    else if (key == 'o') {
        orthogonal = !orthogonal;
        if (orthogonal)
            ortho();
        else
            perspective();
    } else if (key == 'a')
        angle = (floor(angle / 90) + 1) * 90;
    else if (key == 'd')
        angle = (ceil(angle / 90) - 1) * 90;
    else if (key == 'c')
        show_canny = !show_canny;
    else if (key == ' ')
        is_ani = !is_ani;
}