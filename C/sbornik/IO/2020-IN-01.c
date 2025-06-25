#include <fcntl.h>
#include <string.h>
#include <stdlib.h>
#include <err.h>
#include <stdint.h>
#include <unistd.h>

int open_f(const char* filename);

typedef struct{
    uint32_t magic;
    uint8_t header;
    uint8_t datav;
    uint16_t count;
    uint32_t res1;
    uint32_t res2;
} patch;

typedef struct{
    uint32_t offset;
    uint16_t old;
    uint16_t new;
} nword;

typedef struct{
    uint16_t offset;
    uint8_t old;
    uint8_t new;
} nbyte;

int open_f(const char* filename){

    int fd = open(filename, O_RDONLY);
    if( fd < 0 ){
        err(2, "cannot open %s file", filename);
    }
    return fd;

}

int main(int argc, char* argv [])
{
    if(argc != 4){
        errx(1, "provide 3 arguments!");
    }

    int f1 = open_f(argv[1]);
    int f2 = open_f(argv[2]);
    int newf = open(argv[3], O_RDWR | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR);

    patch p;
    if( read(f1, &p, sizeof(p)) != sizeof(p) ){
        err(2, "error while reading");
    }

    char b;
    while( read(f2, &b, sizeof(b)) > 0){
        if(write (newf, &b, sizeof(b)) < 0){
            err(3, "error while writing");
        }
    }

    if ( p.datav == 0x01 ){
        nword w;
        while( read(f1, &w, sizeof(w)) == sizeof(w)){
           if( lseek(newf, w.offset, SEEK_SET) < 0 ){
            errx(4, "error while seeking");
           }

           uint16_t curr;
           int rdd = read(newf, &curr, sizeof(curr));
           if( rdd == -1){
                err(2, "error while reading");
           }

           if(w.old == curr){
                if(write(newf, &w.new, sizeof(w.new)) < 0){
                    err(3, "error while writing");
                }
            }

           else{
                 errx(5, "this word doesnt exist!");
                }
        }
   }

else
{
        nbyte w;
        while( read(f1, &w, sizeof(w)) == sizeof(w)){
           if( lseek(newf, w.offset*sizeof(uint8_t), SEEK_SET) < 0 ){
            errx(4, "error while seeking");
           }

           uint8_t curr;
           int rdd = read(newf, &curr, sizeof(curr));
           if( rdd < 0){
                err(2, "error while reading");
           }

           if(w.old == curr){
                if(write(newf, &w.new, sizeof(w.new)) < 0){
                    err(3, "error while writing");
                }
            }

           else{
                 errx(5, "this word doesnt exist!");
                }
        }
}

close(f1);
close(f2);
close(newf);
}
