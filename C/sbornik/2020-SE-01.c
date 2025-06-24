#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <err.h>
#include <stdint.h>

int open_file(const char* name);
int open_file(const char* name){

    int fd = open(name, O_RDONLY);
    if(fd < 0){
        err(2, "error opening file");
    }
    return fd;
}

typedef struct{
    uint16_t start;
    uint16_t count;
}interval;

typedef struct{
    interval post;
    interval pre;
    interval in;
    interval suf;
}set;

void copyData(int fdin, int fdout, interval in, ssize_t type);
void copyData(int fdin, int fdout, interval in, ssize_t type){

    if(lseek(fdin, 16 + in.start*type, SEEK_SET) < 0){
        errx(6, "error while seeking");
    }

    char buf[8];

    for(int i = 0; i < in.count; i++){

        if(read(fdin, buf, sizeof(buf)) < 0){
            err(3, "error while reading");
        }

        if(write(fdout, buf, sizeof(buf)) < 0){
            err(4, "error while writing");
        }
    }

}

int main(int argc, char* argv[]){

    if(argc != 7){
        errx(1, "provide 6 files");
    }

    int af=open_file(argv[1]);
    int post=open_file(argv[2]);
    int pre=open_file(argv[3]);
    int in=open_file(argv[4]);
    int suf=open_file(argv[5]);
    int res = open(argv[6], O_CREAT | O_TRUNC | O_RDWR, S_IRUSR | S_IWUSR);
    if(res < 0){
        err(2, "error opening file");
    }

    char buf[16];
    if(read(af, buf, sizeof(buf)) < 0){
        err(3, "error while reading");
    }

    uint16_t count = *(uint16_t*)(buf + 4);

    for(int i = 0; i < count; i++){

        set s;
        if(read(af, &s, sizeof(s)) <0 ){
            err(3, "error while reading");
        }


        copyData(post,res,s.post,4);
        copyData(pre,res,s.pre,1);
        copyData(in,res,s.in,2);
        copyData(suf,res,s.suf,8);

    }

close(pre);
close(af);
close(post);
close(in);
close(res);
close(suf);

}
