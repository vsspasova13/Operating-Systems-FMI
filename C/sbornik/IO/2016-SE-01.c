#include <stdint.h>
#include <err.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int compare(const void* a, const void* b);

int compare(const void* a, const void* b){
    uint8_t x = *(const uint8_t*)a;
    uint8_t y = *(const uint8_t*)b;

    if( x  < y) return -1;
    if (y < x) return 1;
    return 0;
}

int main(int argc, char* argv[]){

    if(argc != 2){
        errx(1, "provide 1 file");
    }

    int fd = open(argv[1], O_RDWR);

    uint8_t buffer[4096];

    int bytes_read =  read(fd, &buffer, sizeof(buffer));
    if(bytes_read < 0){
        err(2, "error while reading");
    }

    qsort(buffer, bytes_read, sizeof(uint8_t), compare);

    if( lseek(fd,0, SEEK_SET) < 0){
        errx(3, "error while seeking");
    }

    if( write(fd, &buffer, bytes_read) < 0){
        err(4, "error while writing");
    }

    close(fd);



}
