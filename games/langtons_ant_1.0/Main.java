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
                board[i][j] = -1;
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
                if (Ant.row == i && Ant.col == j)
                    System.out.print(Output.BLUE + " o" + Output.RESET + Output.BOLD);
                else if (board[i][j] == +1) 
                    System.out.print(Output.GREEN + " o" + Output.RESET + Output.BOLD);
                else if (board[i][j] == -1)
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
    static int row, col;
    static int or; // ant orientation: 0=down; 1=right; 2=up; 3=left;

    static void initPosition ()
    {
        row = (int) (Math.random()*GameBoard.LEN);
        col = (int) (Math.random()*GameBoard.LEN);
        or = (int) (Math.random()*4);
    }

    static void nextMove ()
    {
        or += GameBoard.board[row][col];
        or = (or == 4) ? 0 : (or == -1) ? 3 : or;

        GameBoard.board[row][col] *= -1;

        switch (or)
        {
            case 0: 
                if (row+1 == GameBoard.LEN)
                {
                    GameBoard.board[row][col] *= -1;
                    nextMove();
                } 
                else
                    row++;

                break;

            case 1:
                if (col+1 == GameBoard.LEN)
                {
                    GameBoard.board[row][col] *= -1;
                    nextMove();
                } 
                else
                    col++;

                break;

            case 2:
                if (row-1 == -1)
                {
                    GameBoard.board[row][col] *= -1;
                    nextMove();
                } 
                else
                    row--;

                break;

            case 3:
                if (col-1 == -1)
                {
                    GameBoard.board[row][col] *= -1;
                    nextMove();
                } 
                else
                    col--;

                break;
        }
    }
}

public class Main
{
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
        
        System.out.println (Output.CLEAR + Output.BOLD + Output.GREEN + "\n   LANGTON'S ANT" + Output.RESET);
        System.out.println (Output.BOLD + "\nHere the rules:\n1) At an empty spot, turn 90° clockwise, flip the color of the square, move forward one unit.\n2) At a filled spot, turn 90° counter-clockwise, flip the color of the square, move forward one unit.\n\nPress [ENTER] to start the game!");
        scan.nextLine();
        scan.close();

        GameBoard.resetBoard();
        Ant.initPosition();

        do
        {
            Output.clear();
            GameBoard.printBoard();
            Ant.nextMove();
            wait(100);

        } while (true);
    }
}