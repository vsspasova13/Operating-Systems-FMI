// wc command
#include <fcntl.h>
#include <stdlib.h>
#include <err.h>
#include <unistd.h>
#include <stdio.h>
#include <stdbool.h>

int main (int argc, char* argv[]){

    int fd1;
    char c;
    int lines=0;
    int words=0;
    int chars=0;

    if ( argc != 2 ){
        errx(1, "Provide 1 argument");
    }

    if ( (fd1 = open(argv[1], O_RDONLY)) == -1){
        err(2, "Error opening %s file", argv[1]);
    }

    bool word=false;

    int read_size;
    while ( (read_size = read(fd1, &c, sizeof(c))) == sizeof(c)){
        chars++;

        if (c == '\n'){
            lines++;

            if(word){
                words++;
                word=false;
            }
        }
        else if (c == ' ') {
                if(word) {
                    words++;
                    word=false;
                }
            }
        else {
                word = true;
            }
        }

        if(read_size < 0){
            err(3, "Error while reading");
        }

        char output_message[2048];
        int sn_len = snprintf(output_message, sizeof(output_message),
            "File %s has:\n%d number of lines.\n%d number of words.\n%d numbers of chars.\n",
            argv[1], lines, words, chars);
        if (sn_len < 0) {
            err(4, "Error on snprintf");
        }
        if (sn_len > 2048) {
            sn_len = 2048;
        }

        if(write(1, output_message, sn_len) < 0){
            err(5, "Error while wriing output message");
        }

        if(close(fd1) < 0){
            err(6, "Error while closing input file");
        }


}
