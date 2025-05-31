#include <stdint.h>
#include <err.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>

typedef struct pair{
    uint32_t beg;
    uint32_t length;
} pair;

static int openFile(const char* str, int mode, mode_t perm){
    int fd = open(str, mode, perm);
    if(fd < 0){
        err(2, "error opening %s file", str);
    }

    return fd;
}

int main(int argc, char* argv[]){

    if(argc != 4){
        errx(13, "Provide 3 arguments");
    }

    int fd1 = openFile(argv[1], O_RDONLY, 0);
    int fd2 = openFile(argv[2], O_WRONLY, 0);
    int fd3 = openFile(argv[3], O_CREAT | O_WRONLY, S_IRUSR | S_IWUSR);

    struct stat sb;
    if ( fstat(fd1, &sb) < 0){
        err(3, "error on fstat");
    }

    uint32_t f1_size = sb.st_size;
    if(f1_size % (2 * sizeof(uint32_t)) != 0) {
        errx(4, "file1 is not in the right format");
    }

    if(fstat(fd2, &sb) < 0){
        err(3, "Error on fstat");
    }

    uint32_t f2_size = sb.st_size;
    pair p;
    int n;
    while((n = read(fd1, &p, sizeof(p))) == sizeof(p)){
        if((p.beg + p.length) * sizeof(uint32_t) > f2_size){
            errx(7, "f2 is not big enough");
        }

        off_t offset = (off_t)p.beg*sizeof(uint32_t);
        if( lseek(fd2, offset, SEEK_SET) < 0){
            err(111, "Error while seeking");
        }

        for( uint32_t i = 0; i < p.length; i++){
            uint32_t tmp;
            if(read(fd2, &tmp, sizeof(tmp)) < 0) {
                err(123, "error reading from f2");
            }
            if(write(fd3, &tmp, sizeof(tmp)) < 0) {
                err(321, "error writing to f3");
            }
        }
    }

    if(n < 0){
        err(5, "error reading");
    }

    close(fd1);
    close(fd2);
    close(fd3);
}
