/**
 * This class represents one Gene of the DNA.
 * In this case, that's one line.
 **/
public class Gene {

    public PVector v1, v2;
    public final int box_size;

    public Gene (int box_size) {
        this.box_size = box_size;
        v1 = new PVector(rand(), rand(), rand());
        v2 = new PVector(rand(), rand(), rand());
    }

    private float rand() {
        return random(-box_size/2, box_size/2);
    }

    public void draw(PGraphics pg) {
        pg.line(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z);
    }

}