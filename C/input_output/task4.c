//swap cmd

#include <err.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char* argv[])
{
    int fd1;
    int fd2;

    if(argc != 3){
        errx(1,"Provide 2 arguments");
    }

    fd1 = open(argv[1], O_RDWR);
    if(fd1 < 0){
        err(2, "Cannot open %s file for reading", argv[1]);
    }

    fd2=open(argv[2], O_RDWR);
    if(fd2 < 0){
        if(close(fd1) < 0){
            err(13, "Cannot open %s. Could not close %s on cleanup.", argv[2], argv[1]);
        }
        err(3, "Cannot open %s", argv[2]);
    }

    int fd3;
    fd3=open("my_temp_file", O_CREAT | O_RDWR | O_TRUNC, S_IRUSR | S_IWUSR);
    if( fd3 < 0 ){
        err(4, "Could not create/open %s", "my_temp_file");
    }

    char c[4096];
    ssize_t read_size;

    while( (read_size = read(fd1, &c, sizeof(c))) > 0 ) {
        if(write(fd3, &c, read_size) != read_size ){
            err(1, "Error while writing");
        }
    }

    if(read_size != 0){
        err(2, "Error while reading");
    }

    if(lseek(fd1, 0, SEEK_SET) == -1){
        err(3, "Error while seeking");
    }

    while((read_size = read(fd2, &c, sizeof(c))) > 0){
        if(write(fd1, &c, read_size) != read_size){
            err(1, "Error while writing");
        }
    }

    if(read_size != 0){
        err(2, "Error while reading");
    }

    if(lseek(fd2, 0, SEEK_SET) == -1 || lseek(fd3, 0, SEEK_SET)==-1){
        err(3, "Error while seeking");
    }

    while((read_size = read(fd3, &c, sizeof(c))) > 0){
        if(write(fd2, &c, read_size) != read_size){
            err(1, "Error while writing");
        }
    }

    if(read_size != 0){
        err(2, "Error while reading");
    }

    if(close(fd1) < 0 || close(fd2) < 0 || close(fd3) < 0){
        err(4, "Error while closing file");
    }

    exit(0);
}
