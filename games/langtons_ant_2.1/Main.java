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
    static int i, j, k;

    static void reset ()
    {
        for (i=0; i<LEN; i++)
            for (j=0; j<LEN; j++)
                board[i][j] = 0;
    }

    static void printBoard ()
    {
        boolean found;
        
        System.out.print(Output.BOLD + " ");

        for (i=0; i < LEN*2+1; i++)
            System.out.print("-");

        for (i=0; i<LEN; i++)
        {
            System.out.print("\n|");

            for (j=0; j<LEN; j++)
            {
                found = false;

                for (k=0; !found && k < Main.dim; k++)
                    if (Main.ant[k].row == i && Main.ant[k].col == j)
                    {
                        System.out.print(Output.BLUE + " o" + Output.RESET + Output.BOLD);
                        found = true;
                    }

                for (k=0; !found && k < Main.dim; k++)
                    if (board[i][j] == Main.ant[k].num) 
                    {
                        System.out.print(Main.ant[k].color + " o" + Output.RESET + Output.BOLD);
                        Main.ant[k].spots++;
                        found = true;
                    }

                if (!found)
                    System.out.print("  ");
            }

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
    int row = (int) (Math.random()*GameBoard.LEN);
    int col = (int) (Math.random()*GameBoard.LEN);
    int or = (int) (Math.random()*4); // ant orientation: 0=down; 1=right; 2=up; 3=left;
    int spots = 0;
    int num; // ant number
    String color;

    Ant (int ant_number, int color_sed) // class constructor
    {
        num = ant_number;

        if (Main.dim != 6) // set ant color
            color = "\033[38;5;" + (color_sed + (num-1)*180/(Main.dim-1)) + "m";
        else
            color = "\033[38;5;" + (color_sed + (num-1)*180/7) + "m";

    }

    void nextMove ()
    {
        spots = 0;

        or = (GameBoard.board[row][col] == 0) ? or-1 : or+1;
        or = (or == 4) ? 0 : (or == -1) ? 3 : or;

        switch (or)
        {
            case 0: 
                if (row+1 == GameBoard.LEN)
                    nextMove();
                else
                {
                    GameBoard.board[row][col] = (GameBoard.board[row][col] == 0) ? num : 0;
                    row++;
                }

                break;

            case 1:
                if (col+1 == GameBoard.LEN)
                    nextMove();
                else
                {
                    GameBoard.board[row][col] = (GameBoard.board[row][col] == 0) ? num : 0;
                    col++;
                }

                break;

            case 2:
                if (row-1 == -1)
                    nextMove();
                else
                {
                    GameBoard.board[row][col] = (GameBoard.board[row][col] == 0) ? num : 0;
                    row--;
                }

                break;

            case 3:
                if (col-1 == -1)
                    nextMove();
                else
                {
                    GameBoard.board[row][col] = (GameBoard.board[row][col] == 0) ? num : 0;
                    col--;
                }
        }
    }
}

public class Main
{
    static int dim;
    static Ant[] ant;
    
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
        int i, sed;
        Scanner scan = new Scanner(System.in);
        
        System.out.println (Output.CLEAR + Output.BOLD + Output.GREEN + "\n   LANGTON'S ANTS" + Output.RESET);
        System.out.println (Output.BOLD + "\nHere the rules:\n1) At an empty spot, turn 90° clockwise, color the square, move forward one unit.\n2) At a filled spot, turn 90° counter-clockwise, free the square, move forward one unit.");
        
        do
        {
            System.out.println(Output.BOLD + "\nHow many ants? (the number must be between 1 and 6)" + Output.RESET);
            dim = scan.nextInt();
        } while (dim < 1 || dim > 6);

        scan.close();

        ant = new Ant[dim];
        sed = (int) (Math.random()*30) + 22;

        for (i=0; i<dim; i++)
            ant[i] = new Ant(i+1, sed);

        GameBoard.reset();

        do
        {
            Output.clear();
            GameBoard.printBoard();

            System.out.print("\n" + Output.BOLD);

            for (i=0; i<dim; i++)
            {
                System.out.print (ant[i].color + "Ant" + ant[i].num + ": " + ant[i].spots);

                if (i%2 == 0)
                {
                    if (ant[i].spots < 10)
                        System.out.print("\t\t\t");
                    else
                        System.out.print("\t\t");
                }
                else
                    System.out.print("\n");
            }

            System.out.print(Output.RESET);

            for (i=0; i<dim; i++)
                ant[i].nextMove();

            wait(100);
        } while (true);
    }
}