#include <err.h>
#include <stdint.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <sys/stat.h>

//find . -type f -printf '%T@ %p\n' | sort -nr | head -n1 | cut -d' ' -f2

void waitch(void);
void waitch(void){

    int ws;
    if(wait(&ws) < 0){
        err(10, "error while wait");
    }
    if(!WIFEXITED(ws)){
        errx(11, "child did not exit succesfully");
    }
    if(WEXITSTATUS(ws) != 0){
        errx(12, "child did not exit with 0");
    }
}

int main(int argc, char* argv[]){

    if(argc != 2){
        errx(1, "provide dir name");
    }

    struct stat st;
    if(stat(argv[1], &st) != 0 || !S_ISDIR(st.st_mode)){
        errx(2, "provide valid dir");
    }

    int pipe1[2];
    if(pipe(pipe1) < 0){
        err(3, "error while pipe");
    }
    int pid1 = fork();
    if(pid1 < 0){
        err(4, "error while fork");
    }

    if(pid1 == 0){
        dup2(pipe1[1], 1);
        close(pipe1[0]);
        close(pipe1[1]);
        if(execlp("find", "find", argv[1], "-type", "f", "-printf", "%T@ %p\n", NULL) < 0){
            err(5, "error find");
        }
    }
    close(pipe1[1]);

    int pipe2[2];
    if (pipe(pipe2) < 0) {
        err(3, "error while pipe");
    }

    int pid2 = fork();
    if (pid2 < 0) {
        err(4, "error while fork");
    }

    if (pid2 == 0) {
        dup2(pipe2[1], 1);
        dup2(pipe1[0], 0);
        close(pipe1[0]);
        close(pipe2[0]);
        close(pipe2[1]);
        if (execlp("sort", "sort","-nr", NULL) < 0) {
            err(5, "error sort");
        }
    }

    close(pipe1[0]);
    close(pipe2[1]);

    int pipe3[2];
    if (pipe(pipe3) < 0) {
        err(3, "error while pipe");
    }

    int pid3 = fork();
    if (pid3 < 0) {
        err(4, "error while fork");
    }

    if (pid3 == 0) {
        dup2(pipe3[1], 1);
        dup2(pipe2[0],0);
        close(pipe3[0]);
        close(pipe3[1]);
        close(pipe2[0]);
        if (execlp("head", "head","-n1", NULL) < 0) {
            err(5, "error head");
        }
    }

    close(pipe2[0]);
    close(pipe3[1]);

    int pid4 = fork();
    if (pid4 < 0) {
        err(4, "error while fork");
    }

    if (pid4 == 0) {
        dup2(pipe3[0], 0);
        close(pipe3[0]);
        close(pipe3[1]);
        if (execlp("cut", "cut","-d", " ", "-f2", NULL) < 0) {
            err(5, "error cut");
        }
    }
    close(pipe3[0]);

    for(int i = 0; i <4; i++){
        waitch();
    }
    return 0;

}

