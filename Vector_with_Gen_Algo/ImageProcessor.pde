public class ImageProcessor {

    private OpenCV opencv;
    private PApplet app;
     

    public ImageProcessor(PApplet app) {
        this.app = app;
    }

    private PImage addBorder(PImage in) {
        PImage img = createImage(box_size, box_size, RGB);

        in.loadPixels();
        img.loadPixels();
        

        int tmpX = (box_size - in.width) >> 1;
        int tmpY = (box_size - in.height) >> 1;
        for (int x = 0; x < in.width; x++)
            for (int y = 0; y < in.height; y++)
                img.pixels[ y * box_size + x + tmpY * box_size + tmpX] = in.pixels[y * in.width + x];
        img.updatePixels();

        return img;
    }

    public PImage getCanny(PImage src, short box_size) {
        if (src.width > src.height)
            src.resize(box_size, 0);
        else
            src.resize(0, box_size);

        if (opencv == null || src.width != opencv.width || src.height != opencv.height)
            opencv = new OpenCV(app, src);
        else
            opencv.loadImage(src);

        opencv.blur(3);
        opencv.findCannyEdges(int(0xFF * 0.30), int(0xFF * 0.50));

        /*
        PGraphics pg = createGraphics(box_size / displayDensity(), box_size / displayDensity(), P2D);
        pg.beginDraw();
        pg.background(0);
        pg.scale(1.0 / displayDensity());
        pg.translate(box_size/2, box_size/2);
        pg.image(opencv.getSnapshot(), -src.width/2,-src.height/2);
        pg.endDraw();

        return pg;*/
        return addBorder(opencv.getSnapshot());
/*
        return pg.get();
        
        return opencv.getSnapshot();
        */
    }

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