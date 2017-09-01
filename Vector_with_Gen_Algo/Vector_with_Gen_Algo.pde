import gab.opencv.*;
import java.util.*;

OpenCV opencv;
PImage src, canny, blur;
ImageProcessor imgP;

List<Gene> a = new ArrayList<Gene>();
int box_size = 400;

long start;
long stop;

void setup() {
    src = loadImage("test.jpg");
    size(600, 600, P3D);
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

void draw() {
    // PImage screen = get(); - stores frame
    background(200);
    camera(cos(radians(angle))*width, 0, sin(radians(angle))*width, 0, 0, 0, 0, 1, 0);
    

    for (Gene el : a)
        el.draw(this);

    pushMatrix();
    scale(0.3);
    translate(0, 0, box_size / 2 / 0.3);
    image(src, -width, -height/2);
    image(canny, 0, -height/2);
    popMatrix();

    text("Canny", 10, 20, box_size/2 + 1);
 

    // the animation procedure
    if (keyPressed) {
        if (keyCode == LEFT)
            angle += 0.5;
        else if (keyCode == RIGHT)
            angle -= 0.5;
    } else if (is_ani)
        angle += 0.5;
}

void keyPressed() {
    if (key == ' ') {
        is_ani = !is_ani;
    }
}