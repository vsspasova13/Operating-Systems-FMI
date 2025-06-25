#include <stdlib.h>
#include <err.h>
#include <stdint.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>

typedef struct{
    char name[8];
    uint32_t offset;
    uint32_t length;
} triple;

int pipes[8][2];
int pids[8];

void child_logic(triple t, int index);
void child_logic(triple t, int index){

    if(pipe(pipes[index]) < 0){
        err(10, "error pipe");
    }
    int pid = fork();
    if(pid < 0){
        err(11, "error fork");
    }

    if(pid == 0){
        close(pipes[index][0]);
        int fd = open(t.name, O_RDONLY);
        if(fd < 0){
            err(2, "error opening");
        }

        if(lseek(fd, t.offset*sizeof(uint16_t), SEEK_SET) < 0){
            err(12, "error lseeking");
        }

        uint16_t res=0;
        for(int i = 0; i < t.length; i++){
            uint16_t temp;
            if(read(fd, &temp, sizeof(temp)) < 0){
                err(3, "error while reading");
            }
            res ^= temp;
        }
        if(write(pipes[index][1], &res, sizeof(res)) < 0){
            err(4, "error while writing");
        }
        exit(0);
    }
    close(pipes[index][1]);
    pids[index] = pid;

}

int main(int argc, char* argv[]){

    if(argc != 2){
        errx(1, "provide 1 file");
    }

    int fd = open(argv[1], O_RDONLY);
    if(fd < 0){
        err(2, "error while opening");
    }

    triple t;
    int n;
    int count = 0;
    while( (n = read(fd, &t, sizeof(t))) > 0){
        child_logic(t,count);
        count++;
    }

    if(n < 0){
        err(3, "error while reding");
    }

    for(int i = 0; i < count; i++){
        int wst;
        wait(&wst);
        if(!WIFEXITED(wst)){
            errx(4, "child %d did not exit", i);
        }
        if(WEXITSTATUS(wst) != 0){
            errx(5, "child %d did not exit with 0", i);
        }
    }

    uint16_t res = 0;
    for(int i =0; i < count; i++){
        uint16_t temp;
        if( read(pipes[i][0], &temp, sizeof(temp)) < 0){
            err(3, "error while reading");
        }
        res ^= temp;
        close(pipes[i][0]);
    }
    char output[1024];
    snprintf(output, 1024, "Result %x\n", res);
    write(1, output, strlen(output));

}
