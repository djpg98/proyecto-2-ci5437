main:		main.cc othello_cut.h
		g++ -O3 -Wall -o main main.cc

clean:
		rm -f main core *~

