#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define Sleep(x) usleep((x)*1000)

#define MAXLEN 200
#define PATH "/home/pietro/Desktop/"
#define EXEC_FOR_FILE_AND_FOLDER "dolphin --new-window '"

void three_dots ();
void error_message ();

int main ()
{
    FILE *shortcut, *fp;
    char ans[MAXLEN], filename[MAXLEN], filepath[MAXLEN], path[MAXLEN], string[MAXLEN], icon[MAXLEN], terminal[MAXLEN];

    printf ("\n\033[1;32m   DESKTOP SHORTCUTS 2.0   \033[0m\n");

    printf ("\nShortcut name: ");
    gets (filename);

    fp=fopen (".filename", "w");
    fprintf (fp, "%s", filename);
    fclose (fp);

    strcpy (filepath, PATH);
    strcat(filepath, filename);
    strcat (filepath, ".desktop");

    shortcut=fopen (filepath, "r");

    if (shortcut)
    {
        printf ("\n\033[0;31m");
        printf ("Error: the file already exists. Exiting");
        three_dots ();
        printf ("\033[0m\n");

        fclose (shortcut);
    }
    else
    {
        do 
        {
            printf ("\nDo you want to create a shortcut of a folder/file [f] or of an executable/script/program, etc [e]?\n");
            gets (ans);

            if (strcmp (ans, "f") && strcmp (ans, "e"))
                error_message ();

        } while (strcmp (ans, "f") && strcmp (ans, "e"));

        if (! strcmp (ans, "f"))
        {            
            printf ("\nEnter file/folder path:\n");
            gets (string);
            strcpy (path, EXEC_FOR_FILE_AND_FOLDER);
        }
        else
        {
            printf ("\nEnter exec path/command:\n");
            gets (string);
            strcpy (path, "'");
        }

        strcat (path, string);
        strcat (path, "'");

        printf ("\nEnter icon name/path:\n");
        gets (icon);

        if (! strcmp (ans, "f"))
            strcpy (terminal, "false");
        else
            do 
            {
                printf ("\nDo you want to set terminal value as true [true] or false [false]?\n");
                gets (terminal);

                if (strcmp (terminal, "true") && strcmp (terminal, "false"))
                    error_message ();
                    
            } while (strcmp (terminal, "true") && strcmp (terminal, "false"));

        shortcut=fopen (filepath, "w");

        fprintf (shortcut, "[Desktop Entry]\nVersion=\nName=%s\nComment=%s\nExec=%s\nIcon=%s\nTerminal=%s\nType=Application\nCategories=Application;", filename, ans, path, icon, terminal);
        fclose (shortcut);

        printf ("\n\033[1;32mCool Pietro! Shortcut created successfully! Exiting");
        three_dots ();
        printf ("\033[0m\n");
    }
    
    return 0;
}

void three_dots ()
{
    int i;

    fflush (stdout);
    Sleep (1000);

    for (i=0; i<3; i++)
    {
        printf (".");
        fflush (stdout);
        Sleep (1000);
    }
}

void error_message ()
{
    printf ("\n\033[0;31m");
    printf ("Error: value not permitted");
    three_dots ();
    printf ("\033[0m\n");
}