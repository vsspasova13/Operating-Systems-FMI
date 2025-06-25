#include <stdlib.h>
#include <err.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <stdbool.h>

typedef struct{
    uint16_t offset;
    uint8_t old;
    uint8_t new;
} str;

int open_file(const char* name);

int open_file(const char* name){

    int fd = open(name, O_RDONLY);
    if(fd  < 0){
        err(2, "error opening %s file", name);
    }

    return fd;
}

int main(int argc, char* argv[]){

    if( argc != 4){
        errx(1, "provide 3 files");
    }

    int fd1 = open_file(argv[1]);
    int fd2 = open_file(argv[2]);
    int fd3 = open(argv[3], O_WRONLY | O_CREAT | O_TRUNC, S_IWUSR | S_IRUSR);
    if(fd3 < 0){
        err(2, "error while opening");
    }

    str s;
    s.offset = 0;

    int r1,r2;

    while(true){
        r1= read(fd1, &s.old, sizeof(s.old));
        r2=read (fd2, &s.new, sizeof(s.new));

        if(r1 == 0 && r2 == 0){
            break;
        }

        if(r1 != r2){
            errx(4, "files have diff length");
        }

        if(r1 < 0 || r2 < 0){
            err(5, "error while reading");
        }

        if(s.old != s.new){
            if( write (fd3, &s, sizeof(s)) < 0){
                err(3, "error while writing");
            }
        }
        s.offset++;
    }

close(fd1);
close(fd2);
close(fd3);

}
