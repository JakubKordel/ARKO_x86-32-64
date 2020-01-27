CC=gcc
CFLAGS=-m64 -Wall -std=c99 -fpack-struct=1

all:	main.o shaderect.o
	$(CC) $(CFLAGS) main.o shaderect.o -o shaderect

main.o:	main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

shaderect.o:	shaderect.s
	nasm -f elf64 shaderect.s

clean:
	rm -f *.o
