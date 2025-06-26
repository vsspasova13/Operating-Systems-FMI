#include <stdlib.h>
#include <sys/wait.h>
#include <stdint.h>
#include <string.h>
#include <err.h>
#include <unistd.h>
#include <stdbool.h>
#include <time.h>
#include <fcntl.h>
#include <stdio.h>

int parse_num(const char* str);
int parse_num(const char* str){
    char* endp;
    return strtol(str, &endp, 10);
}

int wait_child(void);
int wait_child(void){

    int ws;
    if(wait(&ws) < 0){
        err(10, "error wait");
    }
    if(WIFEXITED(ws)){
        return WEXITSTATUS(ws);
    }
    else if(WIFSIGNALED(ws)){
        return 129;
    }
    return 0;
}

const char* file = "run.log";

int main(int argc, char* argv[]){

    if( argc < 3){
        errx(1, "provide seconds, Q");
    }

    int sec = parse_num(argv[1]);
    if( sec < 1 || sec > 9){
        errx(2,"seconds must be between 1 and 9");
    }

    int fd = open(file, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if(fd < 0){
        err(11, "error opening file");
    }
    char* cmd = argv[2];

    bool lastend=false;

    while(true){
        int start = time(NULL);
        int pid=fork();
        if(pid < 0){
            err(3, "error while fork");
        }

        if(pid==0){

            if(execvp(cmd, &argv[2]) < 0){
                err(4, "error execlp");
            }
        }

        int endstatus = wait_child();
        int end = time(NULL);

        char line[1024];
        int len = snprintf(line, sizeof(line), "%d %d %d\n", start, end, endstatus);
        if(write(fd, line, len) < 0){
            err(8, "error while writing");
        }

        int dur = end - start;
        if(dur < sec && endstatus!=0){
            if(lastend){
                break;
            }
            lastend=true;
        }

      }

    close(fd);
    return 0;

}
