#include <stdlib.h>
#include <fcntl.h>
#include <stdint.h>
#include <unistd.h>
#include <err.h>

int open_file(const char* name);

int open_file(const char* name){

    int fd = open(name, O_RDONLY);
    if( fd < 0){
        err(1, "error opening %s file", name);
    }

    return fd;
}

typedef struct{
    uint16_t offset;
    uint8_t len;
    uint8_t saved;
} str;

int main(int argc, char* argv[]){

    if( argc != 5)
    {
        errx(2, "provide 4 files");
    }

    int fd1 = open_file(argv[1]);
    int fd2 = open_file(argv[2]);

    int fd3 = open(argv[3], O_RDWR | O_CREAT | O_TRUNC, S_IWUSR | S_IRUSR);
    if( fd3 < 0){
        err(1, "error opening file");
    }

    int fd4 = open(argv[4], O_RDWR | O_CREAT | O_TRUNC, S_IWUSR | S_IRUSR);
    if( fd4 < 0){
         err(1, "error opening file");
    }

    str s;

    while(read(fd2, &s, sizeof(s)) > 0){

    if( lseek(fd1, s.offset, SEEK_SET) < 0){
        errx(3, "error wile seeking");
    }

    char let;
    if( read(fd1, &let, sizeof(let)) < 0){
        err(4, "error while reading");
    }

    if(let >= 0x41 && let <= 0x5A){

     if(lseek(fd1, -1, SEEK_CUR) < 0){
        errx(6, "error while seeking");
     }

     uint8_t word[s.len];
     if( read(fd1, &word, s.len) < 0){
        err(4, "error reading");
     }

     str n;

     n.offset = lseek(fd3, 0 , SEEK_CUR);
     if(n.offset < 0){
        errx(6, "error while seeking");
     }

     if(write(fd3, &word, s.len) < 0){
        err(5, "error while writing");
     }

     n.len = s.len;
     n.saved = 0x00;

     if(write(fd4, &n, sizeof(n)) < 0){
        err(5, "error while writing");
     }

    }
}

close(fd1);
close(fd2);
close(fd3);
close(fd4);

}
