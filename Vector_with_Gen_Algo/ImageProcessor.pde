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
        opencv.findCannyEdges(int(0xFF * 0.30), int(0xFF * 0.50));

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