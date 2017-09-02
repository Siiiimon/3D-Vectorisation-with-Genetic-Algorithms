/**
 * This class represents one DNA with many Genes. It's 
 * one individual
 **/
public class DNA {

    public static final int DEFAULT_AMOUNT = 100;
    public static final short DEFAULT_BOX_SIZE = 400;

    final int amount;
    final int box_size;
    List<Gene> genes = new ArrayList<Gene>();

    public DNA (short box_size, int amount) {
        this.amount = amount;
        this.box_size = box_size;

        for (int i=0; i<amount; i++)
            genes.add(new Gene(box_size));
    }

    public DNA(int amount) {
        this(DEFAULT_BOX_SIZE, amount);
    }

    public DNA (short box_size) {
        this(box_size, DEFAULT_AMOUNT);
    }

    public DNA() {
        this(DEFAULT_BOX_SIZE, DEFAULT_AMOUNT);
    }

    public void draw(PGraphics pg) {
        for (Gene gene : genes)
            gene.draw(pg);
    }

    public List<Gene> getGenes() {
        return genes;
    }
}