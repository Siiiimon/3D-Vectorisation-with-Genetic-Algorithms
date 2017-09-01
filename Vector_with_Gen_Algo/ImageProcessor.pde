public class ImageProcessor {

    private OpenCV opencv;
    private PApplet app;
     

    public ImageProcessor(PApplet app) {
        this.app = app;
    }

    public PImage getCanny(PImage src) {
        if (opencv == null || src.width != opencv.width || src.height != opencv.height)
            opencv = new OpenCV(app, src);
        else
            opencv.loadImage(src);

        opencv.blur(6);
        opencv.findCannyEdges(int(0xFF * 0.30), int(0xFF * 0.50));
        return opencv.getSnapshot();
    }
}