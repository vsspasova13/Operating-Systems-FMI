#include <err.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char* argv[]){

    if(argc != 2){
        errx(12, "provide 1 file");
    }

    int pipe1[2];
    if(pipe(pipe1) < 0){
        err(2, "error pipe");
    }

    int pid1 = fork();
    if(pid1 < 0){
        err(3, "error fork");
    }

    if(pid1 == 0){
        dup2(pipe1[1], 1);
        close(pipe1[1]);
        close(pipe1[0]);
        if(execlp("cat", "cat", argv[1], NULL) < 0){
            err(10, "error execlp cat");
        }
    }

    int pid2 = fork();
    if(pid2 < 0){
        err(3, "error fork");
    }
    if(pid2==0){
        dup2(pipe1[0], 0);
        close(pipe1[0]);
        close(pipe1[1]);
        if(execlp("sort", "sort", NULL) < 0){
            err(11, "error execlp sort");
        }
    }

    close(pipe1[0]);
    close(pipe1[1]);

    for(int i = 0; i < 2; i++){
        int ws;
        if(wait(&ws) < 0){
            err(4, "error wait");
        }
        if(!WIFEXITED(ws)){
            errx(5, "child did not exit sucesfully");
        }
        if(WEXITSTATUS(ws) != 0){
            errx(6, "child did not exit with 0");
        }
    }

    return 0;
}
