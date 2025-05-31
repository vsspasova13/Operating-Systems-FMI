//Копирайте съдържанието на файл1 във файл2
#include <unistd.h>
#include <err.h>
#include <stdlib.h>
#include <fcntl.h>

int  main(int argc, char* argv[])
{

    if ( argc != 3 ){
        errx(1, "Not enough arguments");
    }

    char* src=argv[1];
    char* dst=argv[2];

    int fd1=open(src, O_RDONLY);
    if( fd1 < 0 ){
        err(1, "Error while opening %s", src);
    }

    int fd2=open(dst, O_CREAT | O_WRONLY | O_TRUNC, S_IWUSR | S_IRUSR);
    if( fd2 < 0){
        err(1, "File %s failed to open in write mode", dst);
    }

    char c;
    int read_size;
    while ( ( read_size = read(fd1, &c, 1)) == 1 )
    {
        if (write (fd2, &c, 1) < 0 ){
            err(2, "Error while writing");
        }
    }

    if (read_size < 0) {
        err(3, "Error while reading");
    }

    if(close(fd1) < 0 || close(fd2) < 0){
        err(4, "Error while closing files");
    }

    exit(0);

}
