#include <stdlib.h>
#include <err.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>

int parse_num(const char* str);
int parse_num(const char* str){
    char* endparse;
    int n = strtol(str, &endparse, 10);
    if(endparse == str || endparse == (char*) NULL || *endparse != '\0'){
        errx(2, "%s is not a valid number", str);
    }
    return n;
}

const char* DING = "DING\n";
const char* DONG = "DONG\n";
const uint8_t MY_SIGNAL = 13;

int main(int argc, char* argv[]){

    if( argc != 3 ){
        errx(1,"provide 2 numbers");
    }

    int n = parse_num(argv[1]);
    int d = parse_num(argv[2]);

    if( n < 0 || d < 0){
        errx(2, "n and d should be positive");
    }

    int fd[2];   //parent -> child
    int fd2[2];  //child  -> parent

    if(pipe(fd) < 0){
        err(3, "pipe");
    }

    if(pipe(fd2) < 0){
        err(3, "pipe");
    }

    pid_t pid = fork();
    if( pid < 0){
        err(4, "error forking");
    }

    for(int i = 0; i < n; i++){
        if(pid > 0){
            close(fd[0]);
            close(fd2[1]);
            if(write(1, DING, strlen(DING)) < 0){
                close(fd[1]);
                close(fd2[0]);
                err(5, "error while writing");
            }
            if(write(fd[1], &MY_SIGNAL, sizeof(MY_SIGNAL)) < 0){
                close(fd[1]);
                err(5, "error while writing");
            }

            uint8_t b;
            if(read(fd2[0], &b, sizeof(b)) < 0){
                err(6, "error while reading");
            }
            sleep(d);
        }
        else
        {
            close(fd[1]);
            close(fd2[0]);
            uint8_t b;
            if(read(fd[0], &b, sizeof(b)) < 0){
                err(6, "error while reading");
            }
            if(b != MY_SIGNAL){
                errx(7, "unexpected input");
            }
            if(write(1, DONG, strlen(DONG)) < 0 ){
                err(5, "error while writing");
            }
            if(write(fd2[1], &b, sizeof(b)) < 0){
                err(5, "error while writing");
            }
        }
    }

    if(pid == 0){
        close(fd[0]);
        close(fd2[1]);
        exit(0);
    }
    else{
        close(fd[1]);
        close(fd2[0]);
    }
    int waitstatus;
    if( wait(&waitstatus) < 0){
        err(8, "error wait");
    }

    if( !WIFEXITED(waitstatus) || WEXITSTATUS(waitstatus) != 0){
        errx(9, "child did not end successfully");
    }

}
