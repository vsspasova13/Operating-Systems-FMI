#include <err.h>
#include <stdint.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>

int open_file(const char* name);
int open_file(const char* name){
    int fd = open(name, O_RDONLY);
    if(fd < 0){
        err(2, "error while opening");
    }
    return fd;
}

int main(int argc, char* argv[]){

    if(argc != 4){
        errx(1, "provide 3 files");
    }

    int fd1=open_file(argv[1]);
    int fd2=open_file(argv[2]);
    int fd3 = open(argv[3], O_CREAT | O_TRUNC | O_RDWR, S_IWUSR | S_IRUSR);
    if(fd3 < 0){
        err(2, "error while opening");
    }

    uint8_t b;
    ssize_t ind = 0;

    while( read(fd1, &b, sizeof(b)) > 0){

        uint8_t mask = 1;
        mask<<=7;
        uint16_t n;

        for(int i = 0; i < 8; i++){

            if(mask & b){
                if(lseek(fd2, ind*sizeof(uint16_t), SEEK_SET) < 0){
                    err(3, "error while seeking");
                }
                if(read(fd2, &n, sizeof(n)) != sizeof(n)){
                    err(4, "error while reading");
                }
                if(write(fd3, &n, sizeof(n)) < 0){
                    err(5, "error while writing");
                }
            }
            mask>>=1;
            ind++;
        }

    }

close(fd1);
close(fd2);
close(fd3);

}
