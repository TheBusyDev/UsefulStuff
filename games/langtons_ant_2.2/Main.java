import java.util.Scanner;
import java.lang.Math;

class Output 
{
    static void moveto (int row, int col)
    {
        System.out.print("\033[" + row + ";" + col + "H");
    }

    static void clear ()
    {
        System.out.print(CLEAR);
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

    static final String ANT = "\033[38;5;21m";
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
                System.out.print("  ");

            System.out.print(" |");
        }

        System.out.print("\n ");

        for (i=0; i < LEN*2+1; i++)
            System.out.print("-");

        // print ants
        System.out.print(Output.ANT);

        for (i=0; i < Main.dim; i++)
        {
            Output.moveto(Main.ant[i].row+2, Main.ant[i].col*2+3);
            System.out.print("o");
        }

        System.out.print(Output.RESET);
    }

    static void printNextMove ()
    {
        System.out.print(Output.BOLD);

        for (i=0; i < Main.dim; i++)
        {
            Main.ant[i].nextMove();

            // print ants
            Output.moveto(Main.ant[i].row+2, Main.ant[i].col*2+3);
            System.out.print(Output.ANT);
            System.out.print("o");

            // print changed spots
            Output.moveto(Main.ant[i].prev_row+2, Main.ant[i].prev_col*2+3);

            if (board[ Main.ant[i].prev_row ][ Main.ant[i].prev_col ] == -1) // empty spot
                System.out.print(" ");
            else
                System.out.print(Main.ant[i].color + "o");
        }

        System.out.print(Output.RESET);
    }
}

class Ant
{
    int prev_row, prev_col;
    int row = (int) (Math.random()*GameBoard.LEN);
    int col = (int) (Math.random()*GameBoard.LEN);
    int or = (int) (Math.random()*4); // ant orientation: 0=down; 1=right; 2=up; 3=left;
    int spots = 0;
    int num; // ant number
    String color;

    Ant (int ant_number, int color_seed) // class constructor
    {
        num = ant_number;

        if (Main.dim != 6) // set ant color
            color = "\033[38;5;" + (color_seed + num*180/(Main.dim-1)) + "m";
        else
            color = "\033[38;5;" + (color_seed + num*180/7) + "m";

    }

    void nextMove ()
    {
        // save previous ant position
        prev_row = row;
        prev_col = col;

        or = (GameBoard.board[row][col] == -1) ? or-1 : or+1;
        or = (or == 4) ? 0 : (or == -1) ? 3 : or;

        switch (or)
        {
            case 0: 
                if (row+1 == GameBoard.LEN)
                    nextMove();
                else
                {
                    switchSpot();
                    row++;
                }

                break;

            case 1:
                if (col+1 == GameBoard.LEN)
                    nextMove();
                else
                {
                    switchSpot();
                    col++;
                }

                break;

            case 2:
                if (row-1 == -1)
                    nextMove();
                else
                {
                    switchSpot();
                    row--;
                }

                break;

            case 3:
                if (col-1 == -1)
                    nextMove();
                else
                {
                    switchSpot();
                    col--;
                }
        }
    }

    void switchSpot ()
    {
        if (GameBoard.board[row][col] == -1) // empty spot
        {
            spots++;
            GameBoard.board[row][col] = num;
        }
        else
        {
            Main.ant[ GameBoard.board[row][col] ].spots--;
            GameBoard.board[row][col] = -1;
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
        int i, seed;
        Scanner scan = new Scanner(System.in);
        
        System.out.println (Output.CLEAR + Output.BOLD + Output.GREEN + "\n   LANGTON'S ANTS" + Output.RESET);
        System.out.println (Output.BOLD + "\nHere the rules:\n1) At an empty spot, turn 90° clockwise, color the square, move forward one unit.\n2) At a filled spot, turn 90° counter-clockwise, free the square, move forward one unit.");
        
        do
        {
            System.out.println(Output.BOLD + "\nHow many ants? (the number must be between 1 and 20)" + Output.RESET);
            dim = scan.nextInt();
        } while (dim < 1 || dim > 20);

        scan.close();

        ant = new Ant[dim];
        seed = (int) (Math.random()*30) + 22;

        for (i=0; i<dim; i++)
            ant[i] = new Ant(i, seed);

        GameBoard.reset();
        Output.clear();
        GameBoard.printBoard();

        Output.moveto(GameBoard.LEN+3, 1); // move cursor to the GameBoard end
        System.out.print(Output.BOLD);

        for (i=0; i<dim; i++)
        {
            if (i < 9)
                System.out.print (ant[i].color + "Ant0" + (i+1) + ":");
            else
                System.out.print (ant[i].color + "Ant" + (i+1) + ":");

            if ((i+1)%5 != 0)
                System.out.print("\033[15C"); // move cursor 15 spots right
            else
                System.out.print("\n");
        }

        while (true)
        {
            GameBoard.printNextMove();
            Output.moveto(GameBoard.LEN+3, 1); // move cursor to the GameBoard end
            System.out.print(Output.BOLD);

            for (i=0; i<dim; i++)
            {
                if (ant[i].spots < 10)
                    System.out.print ("\033[7C00" + ant[i].spots);
                else if (ant[i].spots < 100)
                    System.out.print ("\033[7C0" + ant[i].spots);
                else 
                    System.out.print ("\033[7C" + ant[i].spots);

                if ((i+1)%5 != 0)
                    System.out.print("\033[11C"); // move cursor 11 spots right
                else
                    System.out.print("\n");
            }

            wait(100);
        }
    }
}