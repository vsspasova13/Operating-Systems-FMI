#include <sys/wait.h>
#include <err.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>

void wait_child(void);
void wait_child(void){
    int ws;
    if(wait(&ws) < 0){
        err(10, "error while wait");
    }
    if(!WIFEXITED(ws)){
        errx(11, "child did not end succesfully");
    }
    if(WEXITSTATUS(ws) != 0){
        errx(12, "child did not exist with 0");
    }
}

int main(int argc, char* argv[]){

    if(argc != 3){
        errx(1, "provide 2 files");
    }

    int out = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if(out <0){
        err(2, "error while opening file");
    }

    int p[2];
    if(pipe(p) < 0){
        err(3, "error while pipe");
    }

    int pid = fork();
    if(pid < 0){
        err(4, "error while fork");
    }

    if(pid == 0){
        close(p[0]);
        dup2(p[1],1);
        close(p[1]);
        if(execlp("cat", "cat", argv[1], NULL) < 0){
            err(5, "error execlp");
        }
    }
    close(p[1]);
    wait_child();

    char b;
    while( read(p[0], &b, sizeof(b)) > 0){
        if(b == 0x7D){
            if(read(p[0], &b, sizeof(b)) < 0){
                err(6, "error reading");
            }
            uint8_t newb = b ^ 0x020;
            if(write(out, &newb, sizeof(newb)) < 0){
                err(7, "error writing");
            }
        }
        else if(b != 0x55){
            if(write(out, &b, sizeof(b)) < 0){
                  err(7, "error writing");
            }
        }
    }
    close(p[0]);
    close(out);
    return 0;
}
