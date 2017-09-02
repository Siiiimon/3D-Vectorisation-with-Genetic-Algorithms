/**
 * This class is responsible for calculating the score of an individual.
 **/
public class ScoreMaker {

    public ScoreMaker() {
        
    }

    /**
     * Renders the DNA. This is more than the DNA.draw() method, 
     * because here, I also specifiy the colors, perspective, camera, …
     * in way that I can actually compare it to my edge image.
     * @param individual The DNA to display
     * @return PGraphics The rendered image
     **/
    public PGraphics renderDNA(DNA individual) {
        int h = individual.box_size;
        /* I need to divide by the displayDensity() here, 
        because createGrapics() otherwise creates an image with 
        (h * displayDensity())^2 pixels. (It still says that the 
        width and height is each h.) And Because I later use the 
        raw pixel data, I need h^2 pixels and not (h * displayDensity())^2
        */
        PGraphics pg = createGraphics(h / displayDensity(), 
            h / displayDensity(), P3D);  // creates a 3D scene
        pg.beginDraw();

        pg.scale(1.0 / displayDensity());  // to correct my drawing behaviour
        pg.background(0);

        pg.camera(0, 0, h, 0, 0, 0, 0, 1, 0);
        // pg.frustum(h/2, -h/2, h/2, -h/2, h/2, h/2*3);
        pg.ortho(-h>>1, h>>1, -h>>1, h>>1);  // I want to see all lines
        // >>1 means / 2

        pg.stroke(255);
        individual.draw(pg);
        // for perspective debugging
        // pg.noFill();
        // pg.box(h);
        pg.endDraw();

        return pg;
    }

    /**
     * Calculates the score of my DNA, by comparing it with my canny image,
     * substract (with absolute value) them by each other and taking the
     * average.<br>
     * This has the effect, that the image, that has the most intersections
     * with my source image has the lowest score. Which means: The lower the 
     * score the better!!!!!!
     *
     * @param individual The DNA to score
     * @param grand_filter The canny image to compare to
     * @return double A score how far apart the two images are. 
     *      e.g. the lower the better!!!
     * @throws Exception Occours, when the grand_filter width or height isn't
     *      the box_size.
     **/
    public double calcScore(DNA individual, PImage grand_filter) throws Exception {
        if (grand_filter.width != individual.box_size 
            || grand_filter.height != individual.box_size)
            throw new Exception("The grand_filter image doesn't have the" +
                "width / height as the DNA box_size provides. " +
                "Both values must be the same.");

        PGraphics pg = renderDNA(individual);

        int score = 0;

        // For debuging purposes
        //PImage img = createImage(individual.box_size, individual.box_size, RGB);
        //img.loadPixels();


        pg.loadPixels();
        grand_filter.loadPixels();

        for (int i=0; i<pow(box_size, 2); i++) {
            int c = max(min(abs( (grand_filter.pixels[i] & 0xFF) 
                - (pg.pixels[i] & 0xFF)), 255), 0);
            // img.pixels[i] = c | c << 8 | c << 16;
            score += c;
        }

        // img.updatePixels();

        // println("score: "+ (score / pow(individual.box_size,2)));
        // return score / dim;
        //return img;
        return score / pow(individual.box_size,2);
    }
}