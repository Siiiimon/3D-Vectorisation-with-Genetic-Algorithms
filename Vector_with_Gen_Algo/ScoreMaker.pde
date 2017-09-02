public class ScoreMaker {

    public ScoreMaker() {
        
    }

    public PGraphics renderDNA(DNA individual) {
        
        int h = individual.box_size;
        PGraphics pg = createGraphics(h / displayDensity(), h / displayDensity(), P3D);
        pg.scale(1.0 / displayDensity());
        pg.beginDraw();
        pg.background(0);

        pg.camera(h, 0, 0, 0, 0, 0, 0, 1, 0);
        // pg.frustum(h/2, -h/2, h/2, -h/2, h/2, h/2*3);
        pg.ortho(h>>1, -h>>1, h>>1, -h>>1);

        pg.stroke(255);
        individual.draw(pg);
        // for perspective debugging
        // pg.noFill();
        // pg.box(h);
        pg.endDraw();

        return pg;
    }

    public double calcScore(DNA individual, PImage grand_filter) throws Exception {
        if (grand_filter.width != individual.box_size || grand_filter.height != individual.box_size)
            throw new Exception("The grand_filter image doesn't have the width / height as the DNA box_size provides. Both values must be the same.");

        PGraphics pg = renderDNA(individual);

        int score = 0;

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