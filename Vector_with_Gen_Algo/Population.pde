public class Population {
    int amount = 20;
    int bestScoreIndex;
    double maxScore;
    DNA lastDna;
    ArrayList<DNA> dnas = new ArrayList<DNA>();

    public Population() {
        dnas.clear();
        for(int i = 0; i < amount; i++) {
            dnas.add(new DNA(box_size));
            dnas.get(i).score(canny);
            if (dnas.get(i).getScore() > maxScore) {
                maxScore = dnas.get(i).getScore();
                bestScoreIndex = i;
            }
        }
        println("best score: " + maxScore);
    }

    // public Population(DNA lastDna) {
    //     dnas.clear();
    //     for(int i = 0; i < amount; i++) {
    //         dnas.add(lastDna.mutate());
    //         dnas.get(i).score(canny);
    //         if (dnas.get(i).getScore() > maxScore) {
    //             maxScore = dnas.get(i).getScore();
    //             bestScoreIndex = i;
    //         }
    //     }
    //     println("best score: " + maxScore);
    // }

    public DNA getBest() {
        return dnas.get(bestScoreIndex);
    }

    public List<DNA> getDnas() {
        return dnas;
    }
}
