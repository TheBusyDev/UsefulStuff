/*
TIC TAC TOE GAME
UPDATES: 
4x4 board added
function 'PrintTableWithNumbers' changed
print the avalaible spots at every turn
track number of outcomes calculated
track depth reached
*/
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define LEN 4
#define SPOTS LEN*LEN
#define MAX_SCORE SPOTS+1

int tab[SPOTS]; // game board
int outcomes;

void PrintTableWithNumbers (int);
void PrintTable ();
int ExtractTurn (); // +1 = maximising player turn, -1 = minimising player turn
int AImove ();
int minimax (int, int, int, int);
int CheckWinner (); // this function returns 0 if there is no winner, 10 if the winner is the computer, -10 if you are the winner
void clear ();
int insert (int, int);
int max (int, int);
int min (int, int);

int main ()
{
	int i, count; // counters
	int winner, move, turn, error;
	
	clear ();
	printf ("\n\033[1;32m   TIC TAC TOE %dx%d   \033[0m\n", LEN, LEN);
	printf ("\n\033[1mThese are the input positions:\n");
	
	// initialize the table
	for (i=0; i<SPOTS; i++)
		tab[i] = 0;

	count=0; // move counter

	PrintTableWithNumbers (count);
	printf ("\nYou are 'X' and I am 'O'.\nYour move must be a number between 1 and %d.\nPress [ENTER] to start the game...\033[0m\n", SPOTS);
	getchar ();
	
	clear ();
	srand (time(NULL));
	turn=ExtractTurn ();

	do 
	{		
		if (turn == +1)
		{
			count++;

			if (count == 1) // first move
			{
				printf ("\n\033[1mThat's my move:\n");
				insert (+1, rand()%(SPOTS) + 1);
			}
			else if (count == 2) // second move
				while (! (insert (+1, rand()%(SPOTS) + 1)));
			else 
				insert (+1, AImove());
		}

		if (turn == -1)
		{
			if (!count)
				printf ("\n\033[1mIt's your turn!\n");

			count++;

			do 
			{
				printf ("\033[1m");
				PrintTableWithNumbers (count);
				PrintTable ();

				printf ("\n\n\nYour move?\033[0m ");
				scanf ("%d", &move);
				getchar ();
				clear ();

				if (move>=1 && move <= SPOTS)
				{
					if (insert (-1, move))
						error=0;
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
		}

		turn=turn*(-1);
		winner=CheckWinner ();

		if (count == SPOTS && !winner) // if there is no empty space and there is no winner
			winner = -2;

	} while (!winner);

	printf ("\033[1m");
	PrintTable ();

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

void PrintTableWithNumbers (int count)
{
	int i, j;

	printf ("\n");

	if (count)
		printf ("Available spots:\n\n");

	for (i=1; i <= SPOTS; i++)
	{
		if (tab[i-1])
			printf ("  -  |");
		else if (i<10)
			printf ("  %d  |", i);
		else
			printf ("  %d |", i);

		if (! (i%LEN))
		{
			printf ("\n");

			for (j=0; j < LEN*6; j++)
				printf ("-");

			printf ("\n");
		}
	}
}

void PrintTable ()
{
	int i, j;

	printf ("\n");

	for (i=0; i<SPOTS; i++)
	{
		if (tab[i] == 1)
			printf ("  O  |");
		else if (tab[i] == -1)
			printf ("  X  |");
		else
			printf ("     |");

		if (! ((i+1)%LEN))
		{
			printf ("\n");

			for (j=0; j < LEN*6; j++)
				printf ("-");

			printf ("\n");
		}
	}
}

int ExtractTurn ()
{
	int turn;
	
	turn=rand()%2;

	if (!turn)
		turn=-1;

	return turn;
}

int AImove ()
{	
	int i;
	int score, ai_move;
	int best_score = -MAX_SCORE-1;
	int alpha = -MAX_SCORE-1, beta = +MAX_SCORE+1;
	
	outcomes=0;

	for (i=1; i <= SPOTS; i++)
		if (insert (+1, i))
		{
			score = minimax (0, alpha, beta, 0);
			tab[i-1]=0; // reset the spot occupied

			alpha = max (score, alpha);
			
			if (score > best_score)
			{
				best_score = score;
				ai_move = i;
			}
			
			if (best_score == MAX_SCORE) // AI will win in 1 move - no more searching needed
				return ai_move;
		}

	printf ("\n%d outcomes calculated\n", outcomes);

	return ai_move;
}

int minimax (int depth, int alpha, int beta, int Maximising_Turn)
{	
	int i;
	int score, best_score;
	int winner;

	winner=CheckWinner ();

	if (winner == +1)
	{
		outcomes++;
		printf ("\nDepth reached: %d\n", depth);
		return +MAX_SCORE-depth;
	}
	else if (winner == -1)
	{
		outcomes++;
		printf ("\nDepth reached: %d\n", depth);
		return -MAX_SCORE+depth;
	}

	if (depth == 9)
	{
		outcomes++;
		return 0;
	}

	if (Maximising_Turn)
	{
		best_score = -MAX_SCORE-1;

		for (i=1; i <= SPOTS; i++)
			if (insert (+1, i))
			{
				score = minimax (depth+1, alpha, beta, 0);
				tab[i-1]=0; // reset the spot occupied

				best_score = max (score, best_score);
				alpha = max (score, alpha);

				if (best_score == +MAX_SCORE-depth || alpha >= beta) // maximising player will win in 1 move - no more searching needed + alpha-beta pruning
					return best_score;
			}
	}
	else
	{
		best_score = +MAX_SCORE+1;

		for (i=1; i <= SPOTS; i++)
			if (insert (-1, i))
			{
				score = minimax (depth+1, alpha, beta, 1);
				tab[i-1]=0; // reset the spot occupied

				best_score = min (score, best_score);
				beta = min (score, beta);

				if (best_score == -MAX_SCORE+depth || alpha >= beta) // minimising player will win in 1 move - no more searching needed + alpha-beta pruning
					return best_score;
			}
	}

	if (best_score == -MAX_SCORE-1 || best_score == +MAX_SCORE+1) // implies that there is no winner and no empty space
	{
		outcomes++;
		return 0;
	}
	else
		return best_score;
}

int CheckWinner ()
{
	int i, j, win;

	// check rows
	for (i=0; i<SPOTS; i=i+LEN)
	{
		win=1;

		if (!tab[i])
			win=0;

		for (j=1; j<LEN && win; j++)
			if (tab[i] != tab [i+j])
				win=0;

		if (win)
			return tab[i];
	}

	// check coloumns
	for (i=0; i<LEN; i++)
	{
		win=1;

		if (!tab[i])
			win=0;

		for (j=LEN; j<SPOTS && win; j=j+LEN)
			if (tab[i] != tab [i+j])
				win=0;

		if (win)
			return tab[i];
	}
	
	// check diagonals
	// check first diagonal
	win=1;

	if (!tab[0])
		win=0;

	for (i = LEN+1; i < SPOTS && win; i = i + (LEN+1))
		if (tab[0] != tab[i])
			win=0;

	if (win)
		return tab[0];

	// check second diagonal
	win=1;

	if (!tab[LEN-1])
		return 0;

	for (i = (LEN-1)*2; i <= (LEN-1)*LEN && win; i = i + (LEN-1))
		if (tab[LEN-1] != tab[i])
			win=0;

	if (win)
		return tab[LEN-1];

	return 0;
}

void clear ()
{
	int i;

	for (i=0; i<60; i++)
		printf ("\n");
}

int insert (int player, int position)
{
	if (tab[position-1]) // position already occupied
		return 0;
	
	tab[position-1] = player;

	return 1;
}

int max (int a, int b)
{
	if (a>=b)
		return a;
	else
		return b;
}

int min (int a, int b)
{
	if (a<=b)
		return a;
	else
		return b;
}