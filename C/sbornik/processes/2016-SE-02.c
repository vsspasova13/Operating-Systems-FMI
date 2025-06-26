#include <err.h>
#include <stdint.h>
#include <sys/wait.h>
#include <string.h>
#include <unistd.h>
#include <stdbool.h>
#include <stdlib.h>
#include <fcntl.h>

void waitch(void){

    int ws;
    if(wait(&ws) < 0){
        err(10, "error wait");
    }
    if(!WIFEXITED(ws)){
        errx(11, "child did not exit succesfully");
    }

    if(WEXITSTATUS(ws) != 0){
        errx(12, "cjild did not exit with 0");
    }
}

int main(void){

    while( true){

        if(write(1, "prompt\n", strlen("prompt\n")) < 0){
            err(1, "error writing");
        }

        char buff[1024];
        int l = read(0, &buff, sizeof(buff)-1);
        if(l <= 0){
             err(4, "error reading");
        }
        if(buff[l-1] == '\n'){
            buff[l-1]='\0';
        }

        if(strcmp(buff, "exit") == 0){
            return 0;
        }


        int pid = fork();
        if(pid < 0){
            err(3, "error fork");
        }
        if(pid == 0){

            if(execlp(buff, buff, NULL)<0){
                err(7, "error execlp");
            }
        }
        waitch();
    }
return 0;
}
