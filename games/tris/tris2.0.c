/*
TIC TAC TOE GAME
*/
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define LEN 3
#define SPOTS LEN*LEN
#define MAX_SCORE SPOTS+1

void Print_Table_With_Numbers (int [][LEN]);
void PrintTable (int [][LEN]);
int My_Move (int [][LEN], int);
int minimax (int [][LEN], int, int);
int CheckWinner (int [][LEN]); // this function returns 0 if there is no winner, 10 if the winner is the computer, -10 if you are the winner
void clear ();
int insert (char, int [][LEN], int);

int main ()
{
	int table[LEN][LEN];
	int i, j, count; // counters
	int winner, move, error;
	
	clear ();
	printf ("\n\033[1;32m   TIC TAC TOE %dx%d   \033[0m\n", LEN, LEN);
	printf ("\n\033[1mThese are the input positions:\n");
	
	/*
	create a table like the following:
	1 | 2 | 3
	----------
	4 | 5 | 6
	----------
	7 | 8 | 9
	*/
	for (count=1, i=0; i<LEN; i++)
		for (j=0; j<LEN; j++)
		{
			table[i][j] = count;
			count++;
		}

	Print_Table_With_Numbers (table);
	printf ("\nYou are 'X' and I am 'O'.\nYour move must be a number between 1 and %d.\nPress [ENTER] to start the game...\033[0m\n", SPOTS);
	getchar ();

	// reset the table to 0 values
	for (i=0; i<LEN; i++)
		for (j=0; j<LEN; j++)
			table[i][j] = 0;
	
	clear ();
	count=0; // move counter

	do 
	{
		insert ('O', table, My_Move (table, count));
		count++;
		
		winner=CheckWinner (table);

		if (count == SPOTS && !winner) // if there is no empty space and there is no winner
			winner = -2;

		if (!winner)
			do 
			{
				printf ("\033[1m");
				PrintTable (table);

				printf ("\n\n\nYour move?\033[0m ");
				scanf ("%d", &move);
				getchar ();
				clear ();

				if (move>=1 && move <= SPOTS)
				{
					if (insert ('X', table, move))
					{
						count++;
						winner=CheckWinner (table);
						error=0;
					}
					else
					{
						printf ("\nError: position %d already occupied!\n", move);
						error=1;
					}
				}
				else 
				{
					printf ("\nError: your move must be a number between 1 and %d!\n", SPOTS);
					error=1;
				}
			} while (error);

	} while (!winner);

	printf ("\033[1m");
	PrintTable (table);

	printf ("\n\n\n\033[1;36m");

	if (winner == -2)
		printf ("No winner :(");
	else if (winner == +1)
		printf ("The machines are superior! I am the winner!!");
	else if (winner == -1)
		printf ("Oh no, you defeated me!!");

	printf ("\nPress [ENTER] to quit...\033[0m\n");
	getchar ();
	
	return 0;
}

void Print_Table_With_Numbers (int tab[][LEN])
{
	int i, j, k;

	printf ("\n");

	for (i=0; i<LEN; i++)
	{
		for (j=0; j<LEN; j++)
			printf (" %d |", tab[i][j]);

		printf ("\n");

		for (k=0; k < LEN*4; k++)
			printf ("-");

		printf ("\n");
	}
}

void PrintTable (int tab[][LEN])
{
	int i, j, k;

	printf ("\n");

	for (i=0; i<LEN; i++)
	{
		for (j=0; j<LEN; j++)
			if (tab[i][j] == 1)
				printf (" O |");
			else if (tab[i][j] == -1)
				printf (" X |");
			else
				printf ("   |");

		printf ("\n");

		for (k=0; k < LEN*4; k++)
			printf ("-");

		printf ("\n");
	}
}

int My_Move (int tab[][LEN], int count)
{	
	if (!count) // first move
	{
		srand (time(NULL));
		return (rand()%(SPOTS) + 1);
	}

	int i;
	int score, my_move;
	int best_score = -MAX_SCORE-1;

	for (i=1; i <= SPOTS; i++)
		if (insert ('O', tab, i))
		{
			score=minimax (tab, 0, 0);
			insert ('0', tab, i); // reset the spot occupied

			if (score > best_score)
			{
				best_score=score;
				my_move=i;
			}
			
			if (best_score == MAX_SCORE) // AI will win in 1 move - no more searching needed
				return my_move;
		}

	return my_move;
}

int minimax (int tab[][LEN], int depth, int Maximising_Turn)
{
	int i;
	int score, best_score;
	int winner;

	winner=CheckWinner (tab);

	if (winner == +1)
		return MAX_SCORE-depth;
	else if (winner == -1)
		return -MAX_SCORE+depth;

	if (Maximising_Turn)
	{
		best_score = -MAX_SCORE-1;

		for (i=1; i <= SPOTS; i++)
			if (insert ('O', tab, i))
			{
				score = minimax (tab, depth+1, 0);
				insert ('0', tab, i);
				
				if (score == MAX_SCORE-depth) // maximising player will win in 1 move - no more searching needed
					return score;

				if (score > best_score)
					best_score=score;
			}
	}
	else
	{
		best_score = MAX_SCORE+1;

		for (i=1; i <= SPOTS; i++)
			if (insert ('X', tab, i))
			{
				score = minimax (tab, depth+1, 1);
				insert ('0', tab, i);
				
				if (score == -MAX_SCORE+depth) // minimising player will win in 1 move - no more searching needed
					return score;

				if (score < best_score)
					best_score=score;
			}
	}

	if (best_score == -MAX_SCORE-1 || best_score == MAX_SCORE+1) // implies that there is no winner and no empty space
		return 0;
	else
		return best_score;
}

int CheckWinner (int tab[][LEN])
{
	int i, j, win;

	// check rows
	for (i=0; i<LEN; i++)
	{
		win=1;

		for (j=1; j<LEN && win; j++)
			if (tab[i][j-1] != tab[i][j] || !tab[i][j])
				win=0;

		if (win)
		{
			if (tab[i][0] == 1)
				return +1;
			else if (tab[i][0] == -1)
				return -1;
		}
	}

	// check coloumns
	for (j=0; j<LEN; j++)
	{
		win=1;

		for (i=1; i<LEN && win; i++)
			if (tab[i-1][j] != tab[i][j] || !tab[i][j])
				win=0;

		if (win)
		{
			if (tab[0][j] == 1)
				return +1;
			else if (tab[0][j] == -1)
				return -1;
		}
	}
	
	// check diagonals
	win=1;

	for (i=1, j=1; i<LEN && win; i++, j++)
		if (tab[i-1][j-1] != tab[i][j] || !tab[i][j])
			win=0;

	if (win)
	{
		if (tab[0][0] == 1)
			return +1;
		else if (tab[0][0] == -1)
			return -1;
	}

	win=1;

	for (i=1, j=LEN-2; i<LEN && win; i++, j--)
		if (tab[i-1][j+1] != tab[i][j] || !tab[i][j])
			win=0;

	if (win)
	{
		if (tab[0][LEN-1] == 1)
			return +1;
		else if (tab[0][LEN-1] == -1)
			return -1;
	}

	return 0;
}

void clear ()
{
	int i;

	for (i=0; i<60; i++)
		printf ("\n");
}

int insert (char symbol, int tab[][LEN], int position)
{
	int row = (position-1) / LEN;
	int col = (position-1) % LEN;

	if (symbol == '0')
		tab[row][col] = 0;

	if (tab[row][col]) // position already occupied
		return 0;
	
	if (symbol == 'O')
		tab[row][col] = 1;
	else if (symbol == 'X')
		tab[row][col] = -1;

	return 1;
}