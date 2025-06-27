#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <err.h>
#include <stdint.h>
#include <sys/wait.h>
#include <string.h>

int main(int argc, char* argv[])
{
    if (argc < 2 ) {errx(26, "Invalid args!");}

    int fd[2];
    if(pipe(fd)<0){err(26, "error pipe");}

    int pids[argc];

    for(int i = 1; i < argc; i++){

        int pid=fork();
        if(pid < 0){
            err(26, "error fork");
        }

        if(pid==0){

            close(fd[0]);
            dup2(fd[1], 1);
            close(fd[1]);

            if (execlp(argv[i], argv[i], (char*)NULL) < 0) {
                err(26, "Cannnot exec");
            }
        }
        pids[i - 1] = pid;
    }

    close(fd[1]);
    uint8_t byte;
    int idx = 0;
    char res[] = "found it!";

    while(read(fd[0],&byte,1) == 1) {
        if (byte == res[idx])
        {
            idx++;
        }
        else {
            idx = 0;
        }

        if(idx == strlen(res)) {
            //dprintf(1,"Found it");
            for (int i = 0; i < argc; i++)
            {
                kill(pids[i], SIGTERM);
            }
            exit(0);
        }

    }

    int status;

    for (int i = 1; i < argc; i++) {
        if (wait(&status) < 0) {
            err(26, "Cannot wait");
        }
        if (!WIFEXITED(status)){
            errx(26, "child did not end sucessfully");
        }
        if(WEXITSTATUS(status) != 0){
            err(26, "child did not exit with 0");
        }

    }
    exit(1);
}
