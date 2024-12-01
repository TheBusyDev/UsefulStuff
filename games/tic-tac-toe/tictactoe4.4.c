/*
TIC TAC TOE GAME
UPDATES: 
feature added: track matches won by human/AI
new rule implemented in CheckWinner: win with a square
'SetLevel' and 'ChangeLevel' added
*/
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

#define VERSION "4.4"
#define LEN 4
#define SPOTS LEN*LEN
#define MAX_SCORE SPOTS+1

int tab[SPOTS]; // game board
int tab_highlight[SPOTS]; // 0=position NOT highlighted, 1=position highlighted
int max_depth; // max depth reached by minimax function
int outcomes;

void PrintTableWithNumbers (int);
void PrintTable ();
int ExtractTurn (); // +1 = maximising player turn, -1 = minimising player turn
int AImove (int);
int EvaluateFirstMoves (int);
int minimax (int ,int, int, int, int);
int StaticEvaluation (int);
int CheckWinner (int); // this function returns 0 if there is no winner, 10 if the winner is the computer, -10 if you are the winner
void clear ();
int insert (int, int);
int max (int, int);
int min (int, int);
void reset (int []); // reset to 0 all the values of a given array - dimension must be equal to SPOTS
void SaveAndPrintScores (char [], int); // save and print scores from a file
void SetAndPrintLevel (char []);
void ChangeLevel (char [], char);

int main ()
{
	int i, count; // counters
	int winner, move, turn, error;
	char ans, level;
	char filename_scores[30], filename_level[30];

	srand (time(NULL));

	strcpy (filename_scores, "tictactoe");
	strcat (filename_scores, VERSION);
	strcat (filename_scores, ".score");

	strcpy (filename_level, "tictactoe");
	strcat (filename_level, VERSION);
	strcat (filename_level, ".level");

	do 
	{	
		clear ();
		printf ("\n\033[1;32mTIC TAC TOE %dx%d, %s VERSION\033[0m\n", LEN, LEN, VERSION);
		printf ("\n\033[1mThese are the input positions:\033[0m\n");

		// initialize the tables
		reset (tab);
		reset (tab_highlight);

		count=0; // move counter

		PrintTableWithNumbers (count);
		printf ("\033[1m");
		SetAndPrintLevel (filename_level);
		printf ("\nYou are 'X' and I am 'O'.\nYour move must be a number between 1 and %d.\nPress [ENTER] to start the game...\033[0m\n", SPOTS);
		getchar ();

		clear ();
		turn=ExtractTurn ();

		do 
		{	
			if (turn == +1)
			{
				if (!count)
					printf ("\n\033[1mThat's my move!\n");
				
				count++;
				insert (+1, AImove (count)); // insert 'O' in the position calculated by 'AImove'
			}

			if (turn == -1)
			{
				if (!count)
					printf ("\n\033[1mIt's your turn!\n");

				count++;

				do 
				{
					PrintTableWithNumbers (count);
					PrintTable ();

					printf ("\n\n\n\033[1mYour move?\033[0m ");
					scanf ("%d", &move);
					getchar ();
					clear ();

					if (move>=1 && move <= SPOTS)
					{
						if (insert (-1, move-1))
							error=0;
						else
						{
							printf ("\nError: position %d already occupied!\n", move);
							error=1;
						}
					}
					else if (move == 999) // Game Over secret code: stop the game even if there is no winner
					{
						printf ("\n\033[1;36mGame Over code...\033[0m\n");
						error=0;
					}
					else
					{
						printf ("\nError: your move must be a number between 1 and %d!\n", SPOTS);
						error=1;
					}
				} while (error);
			}

			turn=turn*(-1);
			winner=CheckWinner (1);

			if (count == SPOTS && !winner) // if there is no empty space and there is no winner
				winner = -2;

			if (move == 999)
			{
				winner = -2;
				move = 0;
			}

		} while (!winner);

		PrintTable ();

		printf ("\n\n\n\033[1;36m");

		if (winner == -2)
			printf ("No winner :(");
		else if (winner == +1)
			printf ("The machines are superior! I am the winner!!");
		else if (winner == -1)
			printf ("Oh no, you defeated me!!");

		SaveAndPrintScores (filename_scores, winner);

		do 
		{
			printf ("\n\033[1;36mDo you like another match?\n[y]=yes, [n]=no, [c]=change level, [r]=reset scores\033[0m\n");
			ans=getchar ();
			getchar ();

			if (ans == 'c')
				do 
				{
					printf ("\n\033[1;36mType the level you want:\n[e]=easy, [m]=medium, [h]=hard\033[0m\n");
					level=getchar ();
					getchar ();

					if (level != 'e' && level != 'm' && level != 'h')
						printf ("\nError: answer not allowed...\n");
					else
					{
						ChangeLevel (filename_level, level);
						printf ("\n\033[1mLevel changed successfully!\033[0m\n");
					}
				} while (level != 'e' && level != 'm' && level != 'h');				
			else if (ans == 'r')
			{
				remove (filename_scores);
				printf ("\n\033[1mScores reset successfully!\033[0m\n");
			}
			else if (ans != 'y' && ans != 'n')
				printf ("\nError: answer not allowed...\n");

		} while (ans != 'y' && ans != 'n');

	} while (ans == 'y');
	
	return 0;
}

void PrintTableWithNumbers (int count)
{
	int i, j;

	printf ("\n\033[1m");

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

	printf ("\033[0m");
}

void PrintTable ()
{
	int i, j;

	printf ("\n\033[1m");

	for (i=0; i<SPOTS; i++)
	{
		if (tab_highlight[i])
			printf ("\033[1;36m");

		if (tab[i] == 1)
			printf ("  O  ");
		else if (tab[i] == -1)
			printf ("  X  ");
		else
			printf ("     ");

		if (tab_highlight[i])
			printf ("\033[0m\033[1m");

		printf ("|");

		if (! ((i+1)%LEN))
		{
			printf ("\n");

			for (j=0; j < LEN*6; j++)
				printf ("-");

			printf ("\n");
		}
	}

	printf ("\033[0m");
}

int ExtractTurn ()
{
	int turn;
	
	turn=rand()%2;

	if (!turn)
		turn=-1;

	return turn;
}

int AImove (int count)
{	
	int ai_move, i;

	// check whether one player has the chance to win in only one move
	for (i=0; i<SPOTS && count >= LEN*2 - 2; i++) 
	{
		if (insert (+1, i)) 
		{
			if (CheckWinner (0)) // AI has the chance to win in only one move
			{
				tab[i]=0;
				return i;
			}

			tab[i]=0;
		}

		if (insert (-1, i)) 
		{
			if (CheckWinner (0)) // human has the chance to win in only one move
			{
				tab[i]=0;
				return i;
			}

			tab[i]=0;
		}
	}

	if (count == 1 || count == 2) // first move and second move
	{
		int central_position = LEN*(LEN/2) + LEN/2; // formula to get the position: position = (LEN*row) + col
		int random;

		if (! (LEN%2)) // LEN is an even number
			do
			{
				random = rand()%4;

				if (!random)
					ai_move = central_position-LEN-1;
				else if (random == 1)
					ai_move = central_position-LEN;
				else if (random == 2)
					ai_move = central_position-1;
				else
					ai_move = central_position;

			} while (! insert (+1, ai_move));

		else if (insert (+1, central_position)) // LEN is an odd number and the central position is NOT occupied
			ai_move = central_position;

		else // LEN is an odd number and the central position is already occupied
		{
			random = rand()%8;

			if (!random)
				ai_move = central_position-(LEN-1);
			else if (random == 1)
				ai_move = central_position-LEN;
			else if (random == 2)
				ai_move = central_position-(LEN+1);
			else if (random == 3)
				ai_move = central_position-1;
			else if (random == 4)
				ai_move = central_position+1;
			else if (random == 5)
				ai_move = central_position+(LEN-1);
			else if (random == 6)
				ai_move = central_position+LEN;
			else
				ai_move = central_position+(LEN+1);
		}

		return ai_move;
	}
	else if (count == 3 || count == 4) // third move and forth move
	{
		int eval, current_position, random;

		for (i=0, current_position=0; i<SPOTS && !current_position; i++)
			if (tab[i] == +1)
				current_position = i;

		do 
		{
			do
			{
				random = rand()%8;

				if (!random)
					ai_move = current_position-(LEN-1);
				else if (random == 1)
					ai_move = current_position-LEN;
				else if (random == 2)
					ai_move = current_position-(LEN+1);
				else if (random == 3)
					ai_move = current_position-1;
				else if (random == 4)
					ai_move = current_position+1;
				else if (random == 5)
					ai_move = current_position+(LEN-1);
				else if (random == 6)
					ai_move = current_position+LEN;
				else
					ai_move = current_position+(LEN+1);

			} while (! insert (+1, ai_move));

			eval=EvaluateFirstMoves (0);
			tab[ai_move]=0; // reset the spot occupied

		} while (!eval);

		return ai_move;
	}
	else if (count == 5 || count == 6) // fifth and sixth moves
	{
		int eval, pos_to_delete, j, curr_positions[2];

		for (i=0, j=0; j<2; i++)
			if (tab[i] == +1)
			{
				curr_positions[j] = i;
				j++;
			}

		pos_to_delete = curr_positions[rand()%2];
		tab[pos_to_delete]=0;

		for (i=1, eval=0; !eval; i++)
		{
			do
			{
				ai_move = rand()%(SPOTS);
			} while (ai_move == pos_to_delete || ! insert (+1, ai_move));

			eval=EvaluateFirstMoves (0);
			tab[ai_move]=0;

			if (i==10)
			{
				tab[pos_to_delete] = +1;
				
				if (pos_to_delete == curr_positions[0])
					pos_to_delete=curr_positions[1];
				else
					pos_to_delete=curr_positions[0];

				tab[pos_to_delete]=0;
			}
			else if (i==20)
				eval=1;
		}

		tab[pos_to_delete] = +1;

		return ai_move;
	}
	
	int j;
	int score, possible_moves[SPOTS];
	int best_score = -MAX_SCORE-1;
	int alpha = -MAX_SCORE-1, beta = +MAX_SCORE+1;
	clock_t begin = clock ();
	
	outcomes=0;		

	for (i=0; i<SPOTS; i++)
		if (insert (+1, i))
		{
			score = minimax (count, 0, alpha, beta, 0);
			tab[i]=0; // reset the spot occupied

			alpha = max (score, alpha);
			
			if (score > best_score)
			{
				best_score = score;
				possible_moves[0] = i;
				j=1;
			}
			else if (score == best_score)
			{
				possible_moves[j] = i;
				j++;
			}
		}

	printf ("\n%d outcomes calculated\n", outcomes);

	// j is the dimension of possible_move[]
	if (j == 1) // only one possible move
		ai_move = possible_moves[0];
	else // if two or more moves has gained the same score (calculated by minimax algorithm), extract randomly the next move
		ai_move = possible_moves[rand()%j];

	printf ("\nPossible moves: ");

	for (i=0; i<j; i++)
		printf ("%d ", possible_moves[i]+1);

	printf ("\nMove selected: %d, score: %d\nTime elapsed: %f seconds\n", ai_move+1, best_score, (float) (clock () - begin)/CLOCKS_PER_SEC);

	return ai_move;
}

int EvaluateFirstMoves (int depth)
{
	if (CheckWinner (0))
		return +1;
	else if (depth == 2)
		return 0;
	
	int i, eval = 0;

	for (i=0; i<SPOTS && !eval; i++)
		if (insert (+1, i))
		{
			eval=EvaluateFirstMoves (depth+1);
			tab[i]=0;
		}

	return eval;
}

int minimax (int move_counter, int depth, int alpha, int beta, int Maximising_Turn)
{	
	int i;
	int score, best_score;
	int winner;

	winner=CheckWinner (0);

	if (winner)
	{
		outcomes++;
		printf ("\nDepth reached: %d, score: %d\n", depth, winner*(+MAX_SCORE - depth));
		return winner*(+MAX_SCORE - depth);
	}
	else if (depth == SPOTS-move_counter)
	{
		outcomes++;
		printf ("\nDepth: %d, tie!\n", depth);
		return 0;
	}
	else if (depth == max_depth)
	{
		outcomes++;
		printf ("\nStarting StaticEvaluation...\n");
		return StaticEvaluation (Maximising_Turn);
	}

	if (Maximising_Turn)
	{
		best_score = -MAX_SCORE-1;

		for (i=0; i<SPOTS; i++)
			if (insert (+1, i))
			{
				score = minimax (move_counter, depth+1, alpha, beta, 0);
				tab[i]=0; // reset the spot occupied

				best_score = max (score, best_score);
				alpha = max (score, alpha);

				if (alpha > beta || best_score == +MAX_SCORE - (depth+1)) // maximising player will win in 1 move - no more searching needed + alpha-beta pruning
					return best_score;
			}
	}
	else
	{
		best_score = +MAX_SCORE+1;

		for (i=0; i<SPOTS; i++)
			if (insert (-1, i))
			{
				score = minimax (move_counter ,depth+1, alpha, beta, 1);
				tab[i]=0; // reset the spot occupied

				best_score = min (score, best_score);
				beta = min (score, beta);

				if (alpha > beta || best_score == -MAX_SCORE + (depth+1)) // minimising player will win in 1 move - no more searching needed + alpha-beta pruning
					return best_score;
			}
	}
		
	return best_score;
}

int StaticEvaluation (int Maximising_Turn)
{
	int i, turn;

	if (Maximising_Turn)
		turn = +1;
	else
		turn = -1;

	for (i=0; i<SPOTS; i++)
		if (insert (turn, i))
		{
			if (CheckWinner (0))
			{
				tab[i]=0;
				return turn*(+MAX_SCORE - (max_depth+1));
			}

			tab[i]=0;		
		}
	
	return 0;
}

int CheckWinner (int highlight)
{
	int i, j, win;

	// check rows
	for (i=0; i<SPOTS; i=i+LEN)
	{
		if (!tab[i])
			win=0;
		else
			win=1;

		for (j=1; j<LEN && win; j++)
			if (tab[i] != tab [i+j])
				win=0;

		if (win)
		{
			if (highlight)
				for (j=0; j<LEN; j++)
					tab_highlight[i+j]=1;

			return tab[i];
		}
	}

	// check coloumns
	for (i=0; i<LEN; i++)
	{
		if (!tab[i])
			win=0;
		else
			win=1;

		for (j=LEN; j<SPOTS && win; j=j+LEN)
			if (tab[i] != tab [i+j])
				win=0;

		if (win)
		{
			if (highlight)
				for (j=0; j<SPOTS; j=j+LEN)
					tab_highlight[i+j]=1;
			
			return tab[i];
		}
	}
	
	// check diagonals
	// check first diagonal
	if (!tab[0])
		win=0;
	else
		win=1;

	for (i = LEN+1; i < SPOTS && win; i = i + (LEN+1))
		if (tab[0] != tab[i])
			win=0;

	if (win)
	{
		if (highlight)
			for (i=0; i<SPOTS; i = i +(LEN+1))
				tab_highlight[i]=1;

		return tab[0];
	}

	// check second diagonal
	if (!tab[LEN-1])
		win=0;
	else
		win=1;

	for (i = (LEN-1)*2; i <= (LEN-1)*LEN && win; i = i + (LEN-1))
		if (tab[LEN-1] != tab[i])
			win=0;

	if (win)
	{
		if (highlight)
			for (i = LEN-1; i <= (LEN-1)*LEN; i = i + (LEN-1))
				tab_highlight[i]=1;

		return tab[LEN-1];
	}

	// new rule: win with a square
	// check squares
	for (i=0; i < LEN*(LEN-1) - 1; i++)
		if ((i+1)%LEN)
		{
			if (!tab[i] || tab[i] != tab[i+1] || tab[i] != tab[i+LEN] || tab[i] != tab[i+LEN+1])
				win=0;
			else
				win=1;

			if (win)
			{
				if (highlight)
				{
					tab_highlight[i]=1;
					tab_highlight[i+1]=1;
					tab_highlight[i+LEN]=1;
					tab_highlight[i+LEN+1]=1;
				}

				return tab[i];
			}
		}

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
	if (tab[position]) // position already occupied
		return 0;
	
	tab[position] = player;

	return 1;
}

int max (int a, int b)
{
	if (a>b)
		return a;
	else
		return b;
}

int min (int a, int b)
{
	if (a<b)
		return a;
	else
		return b;
}

void reset (int arr[])
{
	int i;

	for (i=0; i<SPOTS; i++)
		arr[i]=0;
}

void SaveAndPrintScores (char filename[], int winner)
{
	FILE *fp;
	int human_score, ai_score;

	fp=fopen (filename, "r");

	if (fp) // file exists
	{
		fscanf (fp, "%d", &human_score);
		fscanf (fp, "%d", &ai_score);
		fclose (fp);
	}
	else // file does not exist
	{
		human_score=0;
		ai_score=0;
	}

	if (winner != -2) // there is actually a winner
	{
		if (winner == -1)
			human_score++;
		else if (winner == +1)
			ai_score++;

		fp=fopen (filename, "w");
		fprintf (fp, "%d %d", human_score, ai_score);
		fclose (fp);
	}

	printf ("\nScore: human: %d vs AI: %d\n", human_score, ai_score);
}

void SetAndPrintLevel (char filename[])
{
	FILE *fp;
	char level;

	fp=fopen (filename, "r");

	if (fp) // file exists
	{
		fscanf (fp, "%c", &level);
		fclose (fp);
	}
	else // file does not exist
		level = 'e';

	if (level == 'e')
	{
		printf ("\nEasy mode!\n");
		max_depth = 3;
	}
	else if (level == 'm')
	{
		printf ("\nLevel: medium\n");
		max_depth = 4;
	}
	else if (level == 'h')
	{
		printf ("\nYour win will be impossible!\n");
		max_depth = 5;
	}
}

void ChangeLevel (char filename[], char level)
{
	FILE *fp;

	fp=fopen (filename, "w");
	fprintf (fp, "%c", level);
	fclose (fp);
}