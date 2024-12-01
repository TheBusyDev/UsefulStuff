/*
CONWAY'S GAME OF LIFE
Rules: 
1. Any live cell with two or three live neighbours survives.
2. Any dead cell with exactly three live neighbours comes to life.
3. All other live cells die in the next generation. Similarly, all other dead cells stay dead.
*/
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>

#define LEN 50
#define SPOTS LEN*LEN
#define FILENAME "game_of_life.board"
#define clear() printf("\033[H\033[J")

int board[LEN][LEN]; // +1 = live cell, -1=dead cell

void ResetFile ();
int LoadCells ();
void PrintBoard ();
int CountLiveCells ();
int CountNeighbours (int, int);

int main ()
{
	int i, j, k; // counters
	int flag, live_cells, neighbours;
	int changes[SPOTS]; // positions to change - live cells will die and viceversa
	char ans;

	clear ();
	printf ("\n\033[1;32mCONWAY'S GAME OF LIFE %dx%d\033[0m\n", LEN, LEN);
	printf ("\n\033[1mThis is Conway's Game of Life, as the title suggests.\nHere the rules:\n1. Any live cell with two or three live neighbours survives.\n2. Any dead cell with exactly three live neighbours comes to life.\n3. All other live cells die in the next generation. Similarly, all other dead cells stay dead.\n");
	printf ("\nPress [ENTER] to start the game and enjoy!\033[0m\n");
	getchar ();

	if (access (FILENAME, F_OK) == -1) // file does not exist
		ResetFile ();

	do
	{
		printf ("\n\033[1mPlease, fill the file '%s' with all the live cells and then press [ENTER].\nIf you like, you can type 'r' to reset the file.\033[0m\n", FILENAME);
		ans = getchar ();

		if (ans == 'r')
		{
			getchar ();
			ResetFile ();
			printf ("\n\033[1mFile reset successfully!\033[0m\n");
			flag = 0;
		}
		else if (ans == '\n')
		{
			flag = LoadCells ();

			if (!flag)
				printf ("\nError while loading the file. I suggest you to reset it...\n");
		}
		else
		{
			getchar ();
			printf ("\nError: answer not allowed...\n");
			flag = 0;
		}
	} while (!flag);

	live_cells = CountLiveCells ();

	while (live_cells)
	{
		clear ();
		printf ("\033[1m");
		PrintBoard ();
		printf ("\nPopulation: %d\nPercentage: %.2f%%\033[0m\n", live_cells, (float) live_cells/(SPOTS)*100);

		for (i=0, k=0, live_cells=0; i<LEN; i++)
			for (j=0; j<LEN; j++)
			{
				neighbours = CountNeighbours (i, j);

				if (board[i][j] == +1 && (neighbours < 2 || neighbours > 3)) // game rules
				{
					changes[k] = i*LEN + j;
					k++;
				}
				else if (board[i][j] == -1 && neighbours == 3) // game rules
				{
					changes[k] = i*LEN + j;
					k++;
					live_cells++;
				}
				else if (board[i][j] == +1)
					live_cells++;
			}

		for (i=0; i<k; i++)
			board[ changes[i]/LEN ][ changes[i]%LEN ] *= -1; // live cells will die and viceversa

		usleep (250000); // sleep 0.25 seconds
	}

	clear ();
	printf ("\033[1m");
	PrintBoard ();
	printf ("\nGame over: no more live cells!\nPress [ENTER] to quit...\033[0m\n");
	getchar ();
	
	return 0;
}

void ResetFile ()
{
	FILE *fp = fopen (FILENAME, "w");
	int i, j;

	for (i=0; i<LEN; i++)
	{
		for (j=0; j<LEN; j++)
			fprintf (fp, "-");

		fprintf (fp, "\n");
	}

	fprintf (fp, "\n\nThis is a comment.\nReplace '-' with 'x' for all the starting cells!\n");
	fclose (fp);
}

int LoadCells ()
{
	FILE *fp = fopen (FILENAME, "r");
	int read, count = 0;
	char ch;

	if (!fp)
		return 0;

	do
	{
		read = fscanf (fp, "%c", &ch);

		if (read > 0 && ch != '\n')
		{
			if (ch == 'x')
			{
				board[ count/LEN ][ count%LEN ] = +1; // live cell
				count++;
			}
			else if (ch == '-')
			{
				board[ count/LEN ][ count%LEN ] = -1; // dead cell
				count++;
			}
			else
				return 0;
		}
	} while (!feof (fp) && count < SPOTS);
	
	fclose (fp);

	return 1;
}

void PrintBoard ()
{
	int i, j;

	printf ("\n ");

	for (i=0; i < LEN*2+1; i++)
		printf ("-");

	for (i=0; i<LEN; i++)
	{
		printf ("\n| ");

		for (j=0; j<LEN; j++)
			if (board[i][j] == +1) // live cell
				printf ("O ");
			else // dead cell
				printf ("  ");

		printf ("|");
	}

	printf ("\n ");

	for (i=0; i < LEN*2+1; i++)
		printf ("-");

	printf ("\n");
}

int CountLiveCells ()
{
	int i, j, count = 0;

	for (i=0; i<LEN; i++)
		for (j=0; j<LEN; j++)
			if (board[i][j] == +1)
				count++;

	return count;
}

int CountNeighbours (int row, int col)
{
	int i, j, count = 0;

	for (i = -1; i <= +1; i++)
		for (j = -1; j <= +1; j++)
			if (board[row+i][col+j] == +1 && (i || j) && (row+i >= 0 && row+i < LEN) && (col+j >= 0 && col+j < LEN))
				count++;

	return count;
}