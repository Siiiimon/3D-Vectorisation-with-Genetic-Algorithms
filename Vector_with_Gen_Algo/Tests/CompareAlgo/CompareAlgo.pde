import gab.opencv.*;

PImage canny, src, in01, in02, diff01, diff02;

void setup() {
    src = loadImage("test.png");
    in01 = loadImage("in_01.png");
    in02 = loadImage("in_02.png");
    size(200, 200);
    noLoop();

    OpenCV opencv = new OpenCV(this, src);
    // opencv.blur(6);
    opencv.findCannyEdges(int(0xFF * 0.30), int(0xFF * 0.50));
    canny = opencv.getSnapshot();

    println("canny: "+canny);

    opencv.loadImage(in01);

    opencv.diff(canny);
    diff01 = opencv.getSnapshot();

    opencv.loadImage(canny);
    opencv.diff(in02);
    diff02 = opencv.getSnapshot();

}

void draw() {
    image(canny, 0, 0);
    image(in01, 100, 0);
    image(diff01, 0, 100);
    image(diff02, 100, 100);

    println("score 1: "+calcScore(diff01));
    println("score 2: "+calcScore(diff02));
}

double calcScore(PImage in1, PImage in2) {
    double score = 0;

    if (in1.width != in2.width || in2.height != in2.height) {
        println("in1 and in2 sizes aren't matching.");
        exit();
    }

    in1.loadPixels();
    in2.loadPixels();

    for (int i=0, i<in1.width * in2.width, i++) {
        //if(c & 0xFF != 0xFF/2)
        score += max(min((in1.pixels[i] - in2.pixels[i]) & 0xFF, 255), 0);
    }

    score /= in1.width * in2.height;
    return score;
}