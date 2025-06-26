#include <err.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdint.h>

void waitch(void);
void waitch(void){

    int ws;
    if(wait(&ws) < 0){
        err(10, "error while wait");
    }
    if(!WIFEXITED(ws)){
        errx(11, "child did not end successfuly");
    }
    if(WEXITSTATUS(ws) != 0){
        errx(12, "child did not exit with 0");
    }
}

int main(int argc, char* argv[]){

    if( argc > 2){
        err(1, "provide max 1 command");
    }

    char cmd[1024];
    if(argc == 1){
        strcpy(cmd,"echo");
    }
    else{
        strcpy(cmd,argv[1]);
    }

    char b;
    char word[5];
    int count=0;
    int ind=0;
    char arg[1024][5];

    while( read(0, &b, sizeof(b)) > 0){

        if(b == 0x20 || b==0x0A){

            if(ind  == 0){
                continue;
            }

            if(ind > 4){
                errx(15, "word length > max");
            }

            word[ind]='\0';
            strcpy(arg[count],word);
            count++;
            strcpy(word,"");
            ind=0;
        }

        else
        {
            if(ind > 4){
                errx(15, "word length > max");
            }

            word[ind]=b;
            ind++;
        }
    }

    if(ind > 0){
        if(ind > 4){
             errx(15, "word length > max");
        }
        word[ind]='\0';
        strcpy(arg[count],word);
        count++;
    }

    int i;
    for(i = 0; i <= count-2; i+=2)
    {

        int pid=fork();
        if(pid < 0){
            err(5, "error while fork");
        }

        if(pid == 0){
            execlp(cmd, cmd, arg[i], arg[i+1], NULL);
        }

        waitch();
    }

    if(i <= count-1){
        int pid=fork();
        if(pid < 0){
             err(5, "error while fork");
        }

        if(pid == 0){
            execlp(cmd, cmd, arg[i], NULL);
        }

        waitch();
    }

    return 0;

}
