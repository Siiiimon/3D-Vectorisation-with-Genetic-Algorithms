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
}

void draw() {
    image(canny, 0, 0);
    image(in01, 100, 0);

    println("score 1: " + calcScore(canny, in01, 0));
    println("score 2: " + calcScore(canny, in02, 100));
}

double calcScore(PImage in1, PImage in2, int x) {
    if (in1.width != in2.width || in2.height != in2.height) {
        println("in1 and in2 sizes aren't matching.");
        exit();
    }

    int score = 0;
    double dim = in1.width * in1.height;

    PImage img = createImage(in1.width, in1.height, RGB);
    img.loadPixels();

    in1.loadPixels();
    in2.loadPixels();

    for (int i=0; i<dim; i++) {
        int c = max(min(abs( (in1.pixels[i] & 0xFF) - (in2.pixels[i] & 0xFF)), 255), 0);
        img.pixels[i] = c | c << 8 | c << 16;
        score += c;
    }

    image(img, x, 100);
    return score / dim;
}