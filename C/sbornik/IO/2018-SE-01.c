
#include <err.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdint.h>
#include <fcntl.h>
#include <string.h>
#include <stdbool.h>

void no_opt( char* s1, char* s2);
void no_opt(char* s1, char* s2){

    char b1;
    ssize_t ind;

    while( read(0, &b1, sizeof(b1)) > 0){
        ind = 0;
        bool found = false;
        while( ind < strlen(s1)){

            if(s1[ind]==b1){
               if( write(1, &s2[ind], sizeof(s2[ind])) < 0){
                    err(4, "error while writing");
               }
               found = true;
               break;
            }
            ind++;
        }

        if(!found){
            if(write(1, &b1, sizeof(b1)) < 0){
                err(4, "error while writing");
            }
        }
    }
}

void sopt(char* s1);
void sopt(char* s1){

    char b;
    int ind = 0;
    bool found = false;
    char prev='\0';

    while( read(0, &b, sizeof(b)) > 0){
        found = false;
        ind = 0;
        while( ind < strlen(s1)){

            if(b == s1[ind]){
                found = true;
                break;
            }
            ind++;
         }

        if(found && b==prev){
            continue;
        }

        if(write(1, &b, sizeof(b)) < 0){
            err(4, "error while writing");
        }

        prev = b;

    }
}

void dopt(char* s1);
void dopt(char* s1){

    int ind=0;
    char b;
    bool found;

   while(read(0,&b, sizeof(b))>0){
        found = false;
        ind = 0;
       while(ind < strlen(s1)){

            if(s1[ind] == b){
                found = true;
                break;
            }
            ind++;
        }
        if(!found){
            if(write(1,&b,sizeof(b))<0){
                err(4, "error while writing");
            }
        }
    }
}

int main(int argc, char* argv[]){

    if( argc < 2 ){
        errx(1, "provide at least 1 arg");
    }

    if(strcmp(argv[1],"-d") == 0){

        dopt(argv[2]);
    }

    else if(strcmp (argv[1], "-s") == 0){
        sopt(argv[2]);
    }

    else {

        char* s1 = argv[1];
        char* s2 = argv[2];

        if(strlen(s1) != strlen(s2)){
            errx(3, "set1 and set2 have different length");
        }

        no_opt( s1, s2);
    }

}
