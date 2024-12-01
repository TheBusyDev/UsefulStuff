import java.util.Scanner;
import java.lang.Math;

class Output 
{
    static void clear ()
    {
        System.out.print(Output.CLEAR);
    }

    // Clear output
    static final String CLEAR = "\033[H\033[J";
    
    // Color end string, color reset
    static final String RESET = "\033[0m";

    // Set bold
    static final String BOLD = "\033[1m";

    // Regular Colors
    static final String BLACK = "\033[30m";    // BLACK
    static final String RED = "\033[31m";      // RED
    static final String GREEN = "\033[32m";    // GREEN
    static final String YELLOW = "\033[33m";   // YELLOW
    static final String BLUE = "\033[34m";     // BLUE
    static final String MAGENTA = "\033[35m";  // MAGENTA
    static final String CYAN = "\033[36m";     // CYAN
    static final String WHITE = "\033[37m";    // WHITE
}

class GameBoard
{
    static final int LEN = 50;
    static int[][] board = new int[LEN][LEN];
    static int i, j;

    static void resetBoard ()
    {
        for (i=0; i<LEN; i++)
            for (j=0; j<LEN; j++)
                board[i][j] = 0;
    }

    static void printBoard ()
    {
        System.out.print(Output.BOLD + " ");

        for (i=0; i < LEN*2+1; i++)
            System.out.print("-");

        for (i=0; i<LEN; i++)
        {
            System.out.print("\n|");

            for (j=0; j<LEN; j++)
                if ((Main.ant1.row == i && Main.ant1.col == j) || (Main.ant2.row == i && Main.ant2.col == j) || (Main.ant3.row == i && Main.ant3.col == j))
                    System.out.print(Output.BLUE + " o" + Output.RESET + Output.BOLD);
                else if (board[i][j] == +1) 
                    System.out.print(Output.GREEN + " o" + Output.RESET + Output.BOLD);
                else if (board[i][j] == +2) 
                    System.out.print(Output.RED + " o" + Output.RESET + Output.BOLD);
                else if (board[i][j] == +3) 
                    System.out.print(Output.MAGENTA + " o" + Output.RESET + Output.BOLD);
                else if (board[i][j] == 0)
                    System.out.print("  ");

            System.out.print(" |");
        }
        System.out.print("\n ");

        for (i=0; i < LEN*2+1; i++)
            System.out.print("-");

        System.out.print(Output.RESET);
    }
}

class Ant
{
    int row, col;
    int or; // ant orientation: 0=down; 1=right; 2=up; 3=left;
    int num; // ant number

    void init (int ant_number)
    {
        row = (int) (Math.random()*GameBoard.LEN);
        col = (int) (Math.random()*GameBoard.LEN);
        or = (int) (Math.random()*4);
        num = ant_number;
    }

    void nextMove ()
    {
        or = (GameBoard.board[row][col] == num) ? or+1 : or-1;
        or = (or == 4) ? 0 : (or == -1) ? 3 : or;

        GameBoard.board[row][col] = (GameBoard.board[row][col] == num) ? 0 : num;

        switch (or)
        {
            case 0: 
                if (row+1 == GameBoard.LEN)
                {
                    GameBoard.board[row][col] = (GameBoard.board[row][col] == num) ? 0 : num;
                    nextMove();
                } 
                else
                    row++;

                break;

            case 1:
                if (col+1 == GameBoard.LEN)
                {
                    GameBoard.board[row][col] = (GameBoard.board[row][col] == num) ? 0 : num;
                    nextMove();
                } 
                else
                    col++;

                break;

            case 2:
                if (row-1 == -1)
                {
                    GameBoard.board[row][col] = (GameBoard.board[row][col] == num) ? 0 : num;
                    nextMove();
                } 
                else
                    row--;

                break;

            case 3:
                if (col-1 == -1)
                {
                    GameBoard.board[row][col] = (GameBoard.board[row][col] == num) ? 0 : num;
                    nextMove();
                } 
                else
                    col--;

                break;
        }
    }

    int spots ()
    {
        int count=0;
        
        for (int i=0; i < GameBoard.LEN; i++)
            for (int j=0; j < GameBoard.LEN; j++)
                if (GameBoard.board[i][j] == num)
                    count++;

        return count;
    }
}

public class Main
{
    static Ant ant1 = new Ant ();
    static Ant ant2 = new Ant ();
    static Ant ant3 = new Ant ();
    
    public static void wait(int ms)
    {
        try
        {
            Thread.sleep(ms);
        }
        catch(InterruptedException ex)
        {
            Thread.currentThread().interrupt();
        }
    }

    public static void main (String[] args)
    {
        Scanner scan = new Scanner(System.in);
        
        System.out.println (Output.CLEAR + Output.BOLD + Output.GREEN + "\n   LANGTON'S ANTS" + Output.RESET);
        System.out.println (Output.BOLD + "\nHere the rules:\n1) At an empty/enemy spot, turn 90° clockwise, flip the color of the square, move forward one unit.\n2) At an ally spot, turn 90° counter-clockwise, flip the color of the square, move forward one unit.\n\nPress [ENTER] to start the game!");
        scan.nextLine();
        scan.close();

        GameBoard.resetBoard();
        ant1.init(1);
        ant2.init(2);
        ant3.init(3);

        do
        {
            Output.clear();
            GameBoard.printBoard();

            ant1.nextMove();
            ant2.nextMove();
            ant3.nextMove();

            System.out.print(Output.BOLD + Output.GREEN + "\nAnt1: " + ant1.spots() + "\n" + Output.RED + "Ant2: " + ant2.spots() + "\n" + Output.MAGENTA + "Ant3: " + ant3.spots() + Output.RESET);

            wait(100);
        } while (true);
    }
}