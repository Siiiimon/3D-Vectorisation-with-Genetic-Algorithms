import gab.opencv.*;

OpenCV opencv;
PImage src, canny, blur;

long start;
long stop;

void setup() {
    src = loadImage("test.jpg");
    size(829, 511);
    noLoop();
    
    start = millis();

    opencv = new OpenCV(this, src);
    opencv.blur(6);

    blur = opencv.getSnapshot();

    opencv.findCannyEdges( int(0xFF * 0.30), int(0xFF * 0.50));
    canny = opencv.getSnapshot();

    stop = millis();
    println("Needed "+ (stop - start) + " milliseconds.");
}


void draw() {
    pushMatrix();
    scale(0.5);
    image(src, 0, 0);
    image(blur, src.width, 0);
    image(canny, src.width*2, 0);
    popMatrix();

    text("Source", 10, 25); 
    text("Canny", src.width/2 * 2 + 10, 25); 
}