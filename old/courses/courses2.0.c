// COURSES 2.0 - please, before running this program, fill "courses.dat" file with all your courses
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define FILENAME "courses.dat"
#define MAXLEN 50

typedef struct hour
{
    char course[MAXLEN];
} hour;

typedef struct weekday
{
    hour h[24];
} weekday;

int main ()
{    
    weekday d[7];
    int i, j; // counters
    int read, course_day, course_hour;
    char course_name[MAXLEN], cmd[200];
    char c;
    FILE *fp;
    time_t now = time (NULL);

    fp = fopen (FILENAME, "r");

    if (!fp)
    {
        printf ("\nError: file \"%s\" not found...\nPress [ENTER] to quit!\n", FILENAME); 
        getchar ();
    }
    else
    {
        // initialize 'd'
        for (i=0; i<7; i++)
            for (j=0; j<24; j++)
                strcpy (d[i].h[j].course, "#");

        // load all the values to memory
        do
        {
            read = fscanf (fp, "%s", course_name);

            if (read > 0)
            {
                if (! strcmp (course_name, "#"))
                    do
                    {
                        fscanf (fp, "%c", &c);
                    } while (! feof (fp) && c != '\n');
                else
                {
                    read = fscanf (fp, "%d %d", &course_day, &course_hour);

                    if (read > 0)
                        strcpy (d[course_day-1].h[course_hour-1].course, course_name);
                }
            }
        } while (! feof (fp));
        
        fclose (fp);

        strcpy (course_name, d[localtime (&now)->tm_wday - 1].h[localtime (&now)->tm_hour - 1].course);

        if (! strcmp (course_name, "#"))
        {
            printf ("\nError: there's no course scheduled now...\nPress [ENTER] to quit!\n");
            getchar ();
        }
        else
        {
            strcpy (cmd, "start msedge https://politecnicomilano.webex.com/meet/");
            strcat (cmd, course_name);
            system (cmd);
            system ("timeout 15");            
            system ("taskkill /F /IM msedge.exe");
        }
    } 

    return 0;
}
