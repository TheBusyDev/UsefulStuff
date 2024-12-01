/*
Save your grades on a file and calculate avarage of your exams
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define Sleep(x) usleep((x)*1000)
#define FILENAME "Aeronautical_Engineering"
#define CAREER "Aeronautical Engineer"
#define MAXLEN 100
#define BAR_LEN 25
#define TOTAL_CREDITS 100

typedef struct exam
{
	char course[MAXLEN];
	int grade; // a grade of 33 is equal to 30 cum laude
	int credits;
	struct exam *next;
} exam;

exam *head = NULL;
FILE *input, *output_grade, *output_avg;
float avg, avg_cum_laude;

void LoadExams (); // load exams on the list
void AddToList (char [], int, int);
void PrintList ();
void SaveExams ();
void delete (char []);

int main ()
{
	exam *tmp;
	char career[MAXLEN], filename_grade[MAXLEN], filename_avg[MAXLEN];
	char c[MAXLEN]; // course
	int g, cr; // grade and credits of each exam
	int credits_gained;
	int i;
	int ans, laude;
	float perc;
	
	strcpy (career, CAREER);
	sprintf (filename_grade, "%s_grade.txt", FILENAME);
	sprintf (filename_avg, "%s_avg.txt", FILENAME);
	
	// this cycle replaces all the lowercase letters with uppercase letters for the title	
	for (i=0; career[i]!='\0'; i++)
		if (career[i] >= 'a' && career[i] <= 'z')
			career[i] = career[i] - 32; 
	
	printf ("\n\033[1;32m   MY CAREER AS "); // set green color and bold for output
	
	if (career[0] == 'A')
		printf ("AN ");
	else
		printf ("A ");
	
	printf ("%s AT POLIMI   \033[0m\n", career);

	input=fopen (filename_grade, "r");

	if (input)
	{
		LoadExams ();
		fclose (input);

		if (head)
			PrintList ();
	}

	do 
	{
		printf ("\nDo you want to add more exams? [1]=yes, [0]=no\n");
		scanf ("%d", &ans);
		getchar ();

		if (ans)
		{
			do 
			{
				printf ("\nCourse: ");
				fgets (c, MAXLEN, stdin);
				c[strcspn(c, "\n")] = 0; // remove the extra '\n'

				for (tmp=head; tmp && strcmp (tmp->course, c); tmp=tmp->next);

				if (tmp)
				{
					printf("\033[0;31m");
					printf ("\nError: this course already exists! Please, type again\n");
					printf("\033[0m");
				}

			} while (tmp);

			do 
			{
				printf ("Grade: ");
				scanf ("%d", &g);
				getchar ();

				if (g<18 || g>30)
				{
					printf("\033[0;31m");
					printf ("\nError: value not permitted! Please, type again\n");
					printf("\033[0m");
				}

			} while (g<18 || g>30);			

			if (g==30)
			{
				printf ("Cum laude? [1]=yes, [0]=no\n");
				scanf ("%d", &laude);
				getchar ();

				if (laude)
					g=33;
			}

			do
			{
				printf ("Credits: ");
				scanf ("%d", &cr);
				getchar ();

				if (cr<=0)
				{
					printf("\033[0;31m");
					printf ("\nError: value not permitted! Please, type again\n");
					printf("\033[0m");
				}
					
			} while (cr<=0);

			AddToList (c, g, cr);
		}
	} while (ans);

	if (head) // if the list was created
	{
		do
		{
			printf ("\nDo you want to delete any exam? [1]=yes, [0]=no\n");
			scanf ("%d", &ans);
			getchar ();

			if (ans)
			{
				printf ("\nCourse to delete: ");
				fgets (c, MAXLEN, stdin);
				c[strcspn(c, "\n")] = 0; // remove the extra '\n'
				delete (c);
			}
		} while (ans);

		PrintList ();

		for (tmp=head, credits_gained=0; tmp; tmp=tmp->next)
			credits_gained = credits_gained + tmp->credits;

		perc=(float) credits_gained/TOTAL_CREDITS;

		printf ("\n\033[1;32mLoading... ["); // set green color and bold for output

		for (i=0; i<BAR_LEN; i++)
		{
			if (i < (int) (perc*BAR_LEN))
				printf ("#");
			else
				printf ("-");

			fflush (stdout);
			Sleep (100);	
		}

		if (perc == 1)
		{
			printf ("]\nCongrats! Now you are ");
			
		        if (CAREER[0] == 'A' || CAREER[0] == 'a')
				printf ("an ");
			else
				printf ("a ");
			
			printf ("%s!\n", CAREER);
		}
		else
			printf ("]\nYour career as %s is at %.2f%%!\n", CAREER, perc*100);

		printf ("\033[0m"); // set standard output

		output_grade=fopen (filename_grade, "w");
		output_avg=fopen (filename_avg, "w");

		if (output_grade==NULL || output_avg==NULL)
		{
			printf("\033[0;31m");
			printf ("\nError while opening files, data may have not been saved!\n");
			printf("\033[0m");
		}
		else
		{		
			SaveExams ();
			fclose (output_grade);
			fclose (output_avg);
		}
		
		getchar ();
	}
	
	return 0;
}

void LoadExams ()
{
	int read1, read2, read3;
	char c[MAXLEN], tmp_c[MAXLEN];
	int g, cr;

	do
	{
	        c[0] = '\0'; // initialize string 'c'
	        
	        do
	        {
	                read1=fscanf (input, "%s", tmp_c);
	                
	                if (read1>0)
	                {
	                        strcat (tmp_c, " ");
	                        strcat (c, tmp_c);
	                }
	        } while (tmp_c[strlen(tmp_c) - 2] != ':');
	        
		read2=fscanf (input, "%d", &g);
		read3=fscanf (input, "%d", &cr);

		if (read1>0 && read2>0 && read3>0)
		{
			c[strlen(c) - 2] = '\0';
			AddToList (c, g, cr);
		}
	} while (! feof (input));
}

void AddToList (char course[], int grade, int credits)
{
	exam *tmp;

	if (!head)
	{
		head=(exam *) malloc (sizeof (exam));
		strcpy (head->course, course);
		head->grade=grade;
		head->credits=credits;
		head->next=NULL;
	}
	else
	{
		for (tmp=head; tmp->next; tmp=tmp->next);

		tmp->next=(exam *) malloc (sizeof (exam));
		strcpy (tmp->next->course, course);
		tmp->next->grade=grade;
		tmp->next->credits=credits;
		tmp->next->next=NULL;
	}
}

void PrintList ()
{
	exam *tmp;
	int sum, sum_cum_laude, credits_gained;

	sum=0;
	sum_cum_laude=0;
	credits_gained=0;

	printf ("\033[1;36m"); // set cyan color and bold for output

	for (tmp=head; tmp; tmp=tmp->next)
	{
		if (tmp->grade == 33)
		{
			sum=sum + 30*tmp->credits;
			sum_cum_laude=sum_cum_laude + tmp->grade*tmp->credits;
			credits_gained = credits_gained + tmp->credits;

			printf ("\nCourse: %s\nCredits: %d\nGrade: 30L, THIS MAN IS ON FIRE!\n", tmp->course, tmp->credits);
		}
		else
		{
			sum=sum + tmp->grade*tmp->credits;
			sum_cum_laude=sum_cum_laude + tmp->grade*tmp->credits;
			credits_gained = credits_gained + tmp->credits;
			
			printf ("\nCourse: %s\nCredits: %d\nGrade: %d, ", tmp->course, tmp->credits, tmp->grade);
			
			if (tmp->grade >= 27)
				printf ("Terrific shot!\n");
			else if (tmp->grade >= 23)
				printf ("Nice try!\n");
			else 
				printf ("You could do better! Keep improving!\n");
		}
	}

	avg=(float)sum/credits_gained;
	avg_cum_laude=(float)sum_cum_laude/credits_gained;

	printf ("\nYour current avarage:\t\t\t%.5f", avg);
	printf ("\nYour current avarage (cum laude):\t%.5f\n", avg_cum_laude);
	printf ("\033[0m"); // set standard output
}

void SaveExams ()
{
	exam *tmp;

	for (tmp=head; tmp; tmp=tmp->next)
		fprintf (output_grade, "\n%s: %d %d\n", tmp->course, tmp->grade, tmp->credits);

	fprintf (output_avg, "\nAvarage:\t%.5f", avg);
	fprintf (output_avg, "\nAvarage (cum laude):\t%.5f", avg_cum_laude);
}

void delete (char course[])
{
	exam *tmp, *element_to_delete;
	
	if (! strcmp (head->course, course))
	{
		element_to_delete=head;
		head=head->next;
		free (element_to_delete);
	}
	else
	{
		for (tmp=head; tmp->next && strcmp (tmp->next->course, course); tmp=tmp->next);

		if (tmp->next)
		{
			element_to_delete=tmp->next;
			tmp->next=tmp->next->next;
			free (element_to_delete);
		}
		else 
		{
			printf("\033[0;31m");
			printf ("\nError: course not found!\n");
			printf("\033[0m");
		}
	}
}
