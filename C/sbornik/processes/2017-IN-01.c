#include <err.h>
#include <unistd.h>
#include <sys/wait.h>

void wait_child(void);
void wait_child(void){

    int wst;
    if(wait(&wst) < 0){
        err(4, "error wait");
    }
    if(!WIFEXITED(wst)){
        errx(5, "child did not exit");
    }
    if(WEXITSTATUS(wst) != 0){
        errx(6, "child din not exit with 0");
    }
}

int main(void){

    int pipe1[2];
    if(pipe(pipe1) < 0){
        err(1, "error while pipe");
    }

    int pid1 = fork();
    if(pid1 < 0){
        err(2, "error fork");
    }

    if(pid1 == 0){
        close(pipe1[0]);
        dup2(pipe1[1], 1);
        close(pipe1[1]);
        if(execlp("cut", "cut", "-d:", "-f7", "/etc/passwd", (char*) NULL) < 0){
            err(10, "error cut");
        }
    }
    close(pipe1[1]);
    wait_child();

    int pipe2[2];
    if(pipe(pipe2) < 0){
        err(1, "error pipe");
    }

    int pid2=fork();
    if(pid2 < 0){
        err(2, "error fork");
    }

    if(pid2==0){
        close(pipe2[0]);
        dup2(pipe1[0], 0);
        dup2(pipe2[1], 1);
        close(pipe1[0]);
        close(pipe2[1]);
        if( execlp("sort", "sort", NULL) < 0){
            err(10, "sort");
        }
    }
    close(pipe2[1]);
    close(pipe1[0]);
    wait_child();

    int pipe3[2];
    if(pipe(pipe3) < 0){
        err(1, "error pipe");
    }
    int pid3=fork();
    if(pid3 < 0){
        err(2, "error fork");
    }
    if(pid3==0){
       close(pipe3[0]);
       dup2(pipe2[0],0);
       dup2(pipe3[1], 1);
       close(pipe2[0]);
       close(pipe3[1]);
       if( execlp("uniq", "uniq", "-c", NULL) < 0){
            err(10, "error uniq");
       }
    }
    close(pipe3[1]);
    close(pipe2[0]);
    wait_child();

    int pid4=fork();
    if(pid4 < 0){
        err(2, "error fork");
    }
    if(pid4==0){
        dup2(pipe3[0],0);
        close(pipe3[0]);
        if(execlp("sort", "sort", "-n", NULL) < 0){
            err(10, "error sort");
        }
    }
    close(pipe3[0]);
    wait_child();

    return 42;

}
