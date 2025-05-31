/*
   Реализирайте команда head без опции (т.е. винаги да извежда
   на стандартния изход само първите 10 реда от съдържанието на
   файл подаден като първи параматър)
*/

#include <fcntl.h>
#include <err.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char* argv[])
{

    int fd1;
    int i = 0;
    char c;

    if ( argc != 2 ){
        errx(1, "Provide 1 argumenrt");
    }

    if(( fd1 = open(argv[1], O_RDONLY)) == -1 ){
        err(2, "Error opening %s file", argv[1]);
    }

    int read_size;
    while( (read_size = read(fd1, &c, sizeof(c))) == sizeof(c)){
        if ( c == '\n'){
            i = i + 1;
        }

        if( write(1, &c, 1) < 0){
            err(3, "Error while writing");
        }

        if( i == 10){
            break;
        }
    }

    if(read_size < 0){
        err(4, "Error while reading");
    }

    if(close(fd1) < 0){
        err(5, "Error while closing the file");
    }

    exit(0);
}
