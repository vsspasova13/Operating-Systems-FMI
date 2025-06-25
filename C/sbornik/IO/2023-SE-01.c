#include <err.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <stdint.h>

int main(int argc, char* argv[]) {
    if(argc != 3){
        errx(1, "provide 2 arguments");
    }

    int fd1 = open(argv[1], O_RDONLY);
    if(fd1 < 0){
        err(2, "Error on opening file %s", argv[1]);
    }

    int fd2 = open(argv[2], O_CREAT | O_WRONLY, S_IRUSR | S_IWUSR);
    if( fd2 < 0 ){
        err(2, "Error on opening file %s", argv[2]);
    }


    uint8_t byte;
    int read_res;

    uint8_t arr[255];
    int newidx=0;
    int curr = 0;

    while( (read_res=read(fd1, &byte, sizeof(byte))) > 0) {

        curr+=1;
        if(byte != 0x55) {
            continue;
        }

        uint8_t N;
        if( read(fd1, &N, sizeof(N)) < 0){
            err(3, "Error while reading N");
        }

        uint8_t checksum = N ^ 0x55;
        arr[0] = 0x55;
        arr[1] = N;

        if(N==0x55){
            newidx = 1;
        }

        for(int i = 2; i < N-1; i++){
            uint8_t temp;

            if( read(fd1, &temp, sizeof(temp)) < 0){
                err(3, "Error while reading");
            }

            if(temp == 0x55 && newidx == 0){
                newidx = 1;
            }

            arr[i]=temp;
            checksum ^= temp;
        }

        uint8_t real;
        if( read(fd1, &real, sizeof(real)) < 0){
            err(3, "Error while reading");
        }

        if(checksum == real){
            arr[N-1] = checksum;
            int wr = write(fd2, arr, N);
           if( wr < 0 || wr != N){
                err(4, "Error while writing");
            }
        }


        if( newidx > 0){
            lseek(fd1, curr + newidx - 1, SEEK_SET);
        }
    }

    if(read_res<0){
        err(2, "Error while reading");
    }

    if(close(fd1) < 0 || close(fd2) < 0){
        err(5, "Error on closing");
    }

}

