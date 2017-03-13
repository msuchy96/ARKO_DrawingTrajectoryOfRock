CC = gcc
CFLAGS = -Wall -m64

all: main.o parabola.o
	$(CC) $(CFLAGS) -o output main.o parabola.o `allegro-config --shared`

parabola.o: parabola.s
	nasm -f elf64 -o parabola.o parabola.s

main.o: main.c parabola.h
	$(CC) $(CFLAGS) -c -o main.o main.c

clean:
	rm -f *.o

