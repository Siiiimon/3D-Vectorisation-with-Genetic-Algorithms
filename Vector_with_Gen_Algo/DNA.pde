/**
 * This class represents one DNA with many Genes. It's
 * one individual
 **/
public class DNA {

    public static final int DEFAULT_AMOUNT = 100;
    public static final short DEFAULT_BOX_SIZE = 400;

    final int amount;
    final int box_size;
    public double score;
    public ScoreMaker sm;
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

    public void score(PImage can) {
      sm = new ScoreMaker();  // creates the score maker class
      start = millis();  // timer for score calculation
      try {
          this.score = sm.calcScore(this, can);  // calcs score
      } catch (Exception e) {  // because I throw an exception, this is needed…
          e.printStackTrace(); // verbose mode mark
      }
      stop = millis();
      //maybe we should implement verbosity levels some time
      println("Score calc.: "+ (stop - start) + " ms.");

      start = millis();
      rendered = sm.renderDNA(indi);
      stop = millis();
      println("Renderer calc.: "+ (stop - start) + " ms.");
    }

    public double getScore() {
      return this.score;
    }
}
