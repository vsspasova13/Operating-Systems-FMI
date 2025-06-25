#include <err.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <fcntl.h>
#include <string.h>
#include <stdio.h>

int nc,wc;
int pipes[8][2];
const char* L[] = {"tic ", "tac ", "toe\n"};
int list_size = 3;

int parse_num(const char* str);
int parse_num(const char* str){
    char* endptr;
    return strtol(str, &endptr, 10);
}

void print_word(int ind);
void print_word(int ind){

    if(write(1, L[ind], strlen(L[ind])) < 0){
        err(5, "error while writing");
    }
}

void notify_next(int next, int currw);
void notify_next(int next, int currw){

    if(write(pipes[next][1], &currw, sizeof(currw)) < 0){
        err(5, "error while writing");
    }
}

void close_pipes(int child, int new);

void child_func(int child_num);
void child_func(int child_num){
    int next = child_num == nc ? 0 : child_num + 1;

    close_pipes(child_num, next);

    if(child_num == 0){
        print_word(0);
        notify_next(next, 1);
    }

    int n;
    int currw;
    while( (n = read(pipes[child_num][0], &currw, sizeof(currw))) > 0){

        int word_ind = currw % list_size;
        print_word(word_ind);
        if(currw == wc - 1){
            break;
        }
        notify_next(next, currw+1);
    }

    close(pipes[child_num][0]);
    close(pipes[next][1]);
    if(child_num!=0){
        exit(0);
    }

}

void close_pipes(int child, int next){
    for(int i=0; i <= nc; i++){
        if(i == child){
            close(pipes[i][1]);
        }
        else if(i == next){
            close(pipes[i][0]);
        }
        else{
            close(pipes[i][0]);
            close(pipes[i][1]);
        }
    }
}

int main(int argc, char* argv[]){

    if(argc != 3){
        errx(1, "provide 2 numbers");
    }

    nc = parse_num(argv[1]);
    wc = parse_num(argv[2]);

    if(nc < 1 || nc > 7){
        errx(13, "nc should be between 1 and 7");
    }

    if( wc < 1 || wc > 35){
        errx(14, "wc should be between 1 and 35");
    }

    for(int i = 0; i <= nc; i++){
        if(pipe(pipes[i]) < 0){
            err(2, "error pipe");
        }
    }

    for(int i = 1; i <= nc; i++){
        int pid = fork();
        if(pid < 0){
            err(3, "error fork");
        }
        if(pid == 0){
            child_func(i);
        }
    }
    child_func(0);

    for(int i = 0; i < nc; i++){
        int ws;
        if(wait(&ws) < 0){
            err(22, "error wait");
        }
        if(!WIFEXITED(ws)){
            errx(23, "child did not exit succesfully");
        }
        if(WEXITSTATUS(ws) != 0){
            errx(24, "child did not exit with 0");
        }
    }
}
