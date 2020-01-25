#include <stdio.h>
#include "shaderect.h"
#include <stdlib.h>

int main(int argc, char* argv[]){
	if(argc<7){
		printf("Arg.missing\n");
		return 0;
	}
	unsigned int color[4];
	char * pEnd = NULL;
	for (int i = 0; i < 4; ++i )
		color[i] = strtol(argv[3 + i], &pEnd, 0);
	
	if ( atoi(argv[1]) >= 2 && atoi(argv[2]) >= 2 )
		shaderect(atoi(argv[1]), atoi(argv[2]), color );
	else 
		printf("Height and width must be greater than 1");
	return 0;
}
