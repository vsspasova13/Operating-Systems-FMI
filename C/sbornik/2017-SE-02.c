#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <stdlib.h>
#include <err.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

void catcmd(int fd, bool ln, int* lines);

void catcmd(int fd, bool ln, int* lines){

    char byte;
    char buff[16];
    snprintf(buff,sizeof(buff),"%d ",*lines);

    if(ln){
        if(write (1, &buff, strlen(buff)) < 0){
                err(3, "error while writing");
        }
    }

    while( read(fd, &byte, sizeof(byte)) > 0){

       if(write (1, &byte, sizeof(byte)) < 0){
            err(3, "error while writing");
       }
       if(ln){
            if(byte == '\n'){

            (*lines)++;

            snprintf(buff,sizeof(buff),"%d ",*lines);

                if(write (1, &buff, strlen(buff)) < 0){
                    err(3, "error while writing");
                }
            }
        }
    }
}


int open_file(const char* name);

int open_file(const char* name){
    int fd = open(name, O_RDONLY);
    if(fd < 0){
        err(2, "error while opening file");
    }

    return fd;
}

int main(int argc, char* argv[]){

    if( argc == 1 ){
        errx(1, "provide at least 1 argument");
    }

    int index = 1;
    bool ln = false;

    if( strcmp(argv[1],"-n")==0){
        ln = true;
        index++;
    }

    int lines=1;
    while( index < argc ){

        if(strcmp(argv[index],"-")==0){

            catcmd(0,ln,&lines);
        }

        else{
            int fd = open_file(argv[index]);

            catcmd(fd,ln,&lines);
            close(fd);
        }
        index++;
    }

}
