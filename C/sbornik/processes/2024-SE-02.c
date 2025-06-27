#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <err.h>
#include <sys/wait.h>
#include <stdint.h>

#define MAX 10

int pids[MAX];
char* commands[MAX];

void spawn(int index) {
    int pid = fork();
    if(pid < 0) {
        err(2,"Error");
    }
    if(pid == 0) {
        if(execlp(commands[index],commands[index],(char*)NULL) < 0) {
            err(3,"Error");
        }
    }
    pids[index] = pid;
}

int findIndex(int pid) {
    for(int i=0;i< MAX; i++) {
        if(pids[i] == pid) {
            return i;
        }
    }
    return -1;
}

int allDone(void) {
    for(int i=0;i<MAX;i++) {
        if(pids[i] != 0) {
            return 0;
        }
    }
    return 1;

}

int main(int argc, char* argv[])
{
    if (argc < 2 || argc > 11) {errx(1, "Cannot open!");}

    for(int i = 1; i < argc ; i++) {
        commands[i-1] = argv[i];
        spawn(i - 1);
    }

    while(1) {
        int status;
        int pid;
        if((pid = wait(&status)) < 0) {
            err(4,"Error");
        }
        int index = findIndex(pid);

        if(WEXITSTATUS(status) == 0) {
            pids[index] = 0;
        }
        else {
            spawn(index);
        }

        if(!WIFEXITED(status)) {
            for(int i=0;i<MAX;i++) {
                if(i != index) {
                    kill(pids[i],SIGTERM);
                    waitpid(pids[i],&status,0);
                }
            }
            exit(index + 1);
        }
        if(WEXITSTATUS(status) == 0) {
             pids[index] = 0;
         }
         else {
             spawn(index);
         }

        if(allDone() == 1) {
            break;
        }
    }
    exit(0);
}
