/*
TIC TAC TOE GAME
*/
#include <stdio.h>

#define LEN 3
#define MAX_SCORE LEN*LEN+1

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

	printf ("\n\033[1;32m   TIC TAC TOE %dx%d   \033[0m\n", LEN, LEN);
	printf ("\n\033[1mThese are the input positions:\n");

	count=1;

	/*
	create a table like the following:
	1 | 2 | 3
	----------
	4 | 5 | 6
	----------
	7 | 8 | 9
	*/
	for (i=0; i<LEN; i++)
		for (j=0; j<LEN; j++)
		{
			table[i][j] = count;
			count++;
		}

	Print_Table_With_Numbers (table);
	printf ("\nYou are 'X' and I am 'O'.\nYour move must be a number between 1 and %d.\nPress [ENTER] to start the game...\033[0m\n", LEN*LEN);
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

		if (count == LEN*LEN && !winner) // if there is no empty space and there is no winner
			winner = -MAX_SCORE-1;

		if (!winner)
			do 
			{
				printf ("\033[1m");
				PrintTable (table);

				printf ("\n\n\nYour move?\033[0m ");
				scanf ("%d", &move);
				getchar ();
				clear ();

				if (move>=1 && move <= LEN*LEN)
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
					printf ("\nError: your move must be a number between 1 and %d!\n", LEN*LEN);
					error=1;
				}
			} while (error);

	} while (!winner);

	printf ("\033[1m");
	PrintTable (table);

	printf ("\n\n\n\033[1;36m");

	if (winner == -MAX_SCORE-1)
		printf ("No winner :(");
	else if (winner == MAX_SCORE)
		printf ("The machines are superior! I am the winner!!");
	else if (winner == -MAX_SCORE)
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
		int row = LEN/2;
		int col= LEN/2;

		return ((LEN*row) + (col+1)); // formula to get the position: position = (LEN*row) + (col+1)
	}

	int i;
	int score, my_move;
	int best_score = -MAX_SCORE-1;

	for (i=1; i <= LEN*LEN; i++)
		if (insert ('O', tab, i))
		{
			score=minimax (tab, 0, 0);
			insert ('0', tab, i); // reset the spot occupied

			if (score > best_score)
			{
				best_score=score;
				my_move=i;
			}
		}

	return my_move;
}

int minimax (int tab[][LEN], int depth, int Maximising_Turn)
{
	int i;
	int score, best_score;
	int winner;

	winner=CheckWinner (tab);

	if (winner)
		return winner;

	if (Maximising_Turn)
	{
		best_score = -MAX_SCORE-1;

		for (i=1; i <= LEN*LEN; i++)
			if (insert ('O', tab, i))
			{
				score = minimax (tab, depth+1, 0) - depth;
				insert ('0', tab, i);

				if (score > best_score)
					best_score=score;
			}
	}
	else
	{
		best_score = MAX_SCORE+1;

		for (i=1; i <= LEN*LEN; i++)
			if (insert ('X', tab, i))
			{
				score = minimax (tab, depth+1, 1) + depth;
				insert ('0', tab, i);

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
	int i, j, equal;

	// check rows
	for (i=0; i<LEN; i++)
	{
		equal=1;

		for (j=1; j<LEN && equal; j++)
			if (tab[i][j-1] != tab[i][j])
				equal=0;

		if (equal)
		{
			if (tab[i][0] == 1)
				return MAX_SCORE;
			else if (tab[i][0] == -1)
				return -MAX_SCORE;
		}
	}

	// check coloumns
	for (j=0; j<LEN; j++)
	{
		equal=1;

		for (i=1; i<LEN && equal; i++)
			if (tab[i-1][j] != tab[i][j])
				equal=0;

		if (equal)
		{
			if (tab[0][j] == 1)
				return MAX_SCORE;
			else if (tab[0][j] == -1)
				return -MAX_SCORE;
		}
	}
	
	// check diagonals
	equal=1;

	for (i=1, j=1; i<LEN && equal; i++, j++)
		if (tab[i-1][j-1] != tab[i][j])
			equal=0;

	if (equal)
	{
		if (tab[0][0] == 1)
			return MAX_SCORE;
		else if (tab[0][0] == -1)
			return -MAX_SCORE;
	}

	equal=1;

	for (i=1, j=LEN-2; i<LEN && equal; i++, j--)
		if (tab[i-1][j+1] != tab[i][j])
			equal=0;

	if (equal)
	{
		if (tab[0][LEN-1] == 1)
			return MAX_SCORE;
		else if (tab[0][LEN-1] == -1)
			return -MAX_SCORE;
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