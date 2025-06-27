#include <err.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdint.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/stat.h>
#include <string.h>
#include <stdbool.h>

int pids[4096];

bool endswith(const char* file, const char* str){

    int lf=strlen(file);
    int ls=strlen(str);
    if(ls > lf)return false;
    return strcmp(file+lf-ls,str)==0;
}

void get_hashsum(const char* str, char* res);
void get_hashsum(const char* str, char* res){

    while(*str != ' '){
        *res=*str;
        str++;
        res++;
    }
    *res='\0';
}

int readd(int fd, char* buff, int size){
    int s = read(fd, buff, size);
    if(s < 0){
        err(4, "error reading");
    }
    return s;
}

void wait_child(int pid){
  int ws;
  if(waitpid(pid,&ws,0) < 0){
      err(7, "error wait");
  }
  if(!WIFEXITED(ws)){
      errx(8, "child did not end sucessfully");
  }
  if(WEXITSTATUS(ws) != 0){
     errx(9, "child did not exit with 0");
  }
}

int child_logic(char* filen);
int child_logic(char* filen){

    int p[2];
    if(pipe(p) < 0){
        err(4, "error pipe");
    }

    int pid = fork();
    if(pid  < 0){
        err(5, "error fork");
    }

    if(pid == 0){
        close(p[0]);
        dup2(p[1],1);
        close(p[1]);
        if(execlp("md5sum", "md5sum", filen, (char*)NULL) < 0){
            err(6, "error md5sum");
        }
    }
    close(p[1]);

    char buff[1024];
    readd(p[0],buff,sizeof(buff));
    char res[1024];
    get_hashsum(buff,res);

    char final_name[2048];
    snprintf(final_name, sizeof(final_name), "%s.hash", filen);

    int fd = open(final_name, O_CREAT | O_TRUNC | O_WRONLY, 0644);
    if(fd < 0){
        err(10, "error opening file");
    }

    if(write(fd, res, strlen(res)) < 0){
        err(11, "error while writing");
    }

    close(fd);
    return pid;
}

int main(int argc, char* argv[]){

    if(argc != 2){
        errx(1, "provide 1 dir");
    }

    struct stat st;
    if(stat(argv[1], &st) < 0){
        err(2, "error stat");
    }

    if(!S_ISDIR(st.st_mode)){
        errx(3, "provide valid dir");
    }

    int fd[2];
    if(pipe(fd) < 0){
        err(4, "error pipe");
    }

    int pid1 = fork();
    if(pid1 < 0){
        err(5, "error fork");
    }

    if(pid1 == 0){
        close(fd[0]);
        dup2(fd[1], 1);
        close(fd[1]);
        if(execlp("find", "find", argv[1], "-type", "f", (char*)NULL) < 0){
            err(6, "error find");
        }
    }
    close(fd[1]);

    int ws;
    if(waitpid(pid1, &ws, 0) < 0){
        err(7, "error wait");
    }
    if(!WIFEXITED(ws)){
        errx(8, "child did not end sucessfully");
    }
    if(WEXITSTATUS(ws) != 0){
        errx(9, "child did not exit with 0");
    }

    char file[1024];
    int ind=0;
    char b;
    int count=0;
    while(read(fd[0],&b,sizeof(b)) > 0){
        if(b=='\n'){
            file[ind]='\0';
            if(endswith(file, ".hash")){
                ind=0;
                continue;
            }
            pids[count++]=child_logic(file);
            ind=0;
        }
        else{
            file[ind++]=b;
        }
    }

    for(int i =0; i < count; i++){

        wait_child(pids[i]);

    }
    return 0;

}
