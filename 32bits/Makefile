CC=gcc
CFLAGS=-m32 -Wall

all:	main.o shaderect.o
	$(CC) $(CFLAGS) main.o shaderect.o -o shaderect

main.o:	main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

shaderect.o:	shaderect.s
	nasm -f elf32 shaderect.s

clean:
	rm -f *.o
