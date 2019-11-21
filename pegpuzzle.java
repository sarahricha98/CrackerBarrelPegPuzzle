import java.util.*;

public class pegpuzzle {

    private static ArrayList<int[]> Solution = new ArrayList<int[]>(13);
    private final static int moves[][] = {
            {0,1,3},{3,1,0},
            {0,2,5},{5,2,0},
            {1,3,6},{6,3,1},
            {1,4,8},{8,4,1},
            {2,4,7},{7,4,2},
            {2,5,9},{9,5,2},
            {3,6,10},{10,6,3},
            {3,7,12},{12,7,3},
            {4,7,11},{11,7,4},
            {4,8,13},{13,8,4},
            {5,8,12},{12,8,5},
            {5,9,14},{14,9,5},
            {3,4,5},{5,4,3},
            {6,7,8},{8,7,6},
            {7,8,9},{9,8,7},
            {10,11,12},{12,11,10},
            {11,12,13},{13,12,11},
            {12,13,14},{14,13,12}
    };

    public static int play(ArrayList<Integer> Filled, ArrayList<Integer> Empty, ArrayList<int[]> plays, int l){
        if(l == 1){
            Solution = new ArrayList<int []>(plays);
            return 1;
        }

        for(int x = 0; x < 36; x++) {
            if (Empty.contains(moves[x][2]) && Filled.contains(moves[x][0]) && Filled.contains(moves[x][1])) {
                ArrayList<Integer> filledUp = new ArrayList<Integer>(Filled);
                ArrayList<Integer> empty = new ArrayList<Integer>(Empty);
                ArrayList<int[]> differentPlays = new ArrayList<int[]>(plays);
                int currentL = l;

                empty.add(moves[x][0]);
                empty.add(moves[x][1]);
                empty.remove(Integer.valueOf(moves[x][2]));
                filledUp.remove(Integer.valueOf(moves[x][0]));
                filledUp.remove(Integer.valueOf(moves[x][1]));
                filledUp.add(moves[x][2]);

                currentL--;
                differentPlays.add(moves[x]);

                if (play(filledUp, empty, differentPlays, currentL) == 1) {
                    return 1;
                }
            }
        }
        return 0;
    }

    public static void printBoard(char[] puzzle){
        System.out.println(" " + puzzle[0] + " ");
        System.out.println(" " + puzzle[1] + puzzle[2] + " ");
        System.out.println(" " + puzzle[3] + puzzle[4] + puzzle[5] + " ");
        System.out.println(" " + puzzle[6] + puzzle[7] + puzzle[8] + puzzle[9] + " ");
        System.out.println(puzzle[10] + " " + puzzle[11] + puzzle[12] + puzzle[13] + puzzle[14] + "\n");
    }

    public static void main(String[] args){
        char puzzle[] = new char[15];
        ArrayList<Integer> Empty = new ArrayList<Integer>(15);
        ArrayList<Integer> Filled = new ArrayList<Integer>(15);

        for(int x = 0; x < 5; x++){
            System.out.println("-- " + x + " --\n");
            for(int y = 0; y < 15; y++){
                Filled.add(y);
                puzzle[y]= 'X';
            }

            puzzle[x]= '.';
            Filled.remove(Integer.valueOf(x));
            Empty.add(x);
            printBoard(puzzle);

            if(play(Filled, Empty, Solution, 14) == 1){
                for(int k = 0; k < 13; k++){
                    puzzle[Solution.get(k)[0]] = '-';
                    puzzle[Solution.get(k)[1]] = '-';
                    puzzle[Solution.get(k)[2]] = 'X';
                    printBoard(puzzle);
                }
            } else {
                return;
            }
        }
    }
}
