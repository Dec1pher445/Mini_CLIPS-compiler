all:
	bison -dvl simple-bison-code.y
	flex simple-flex-code.l
	gcc simple-bison-code.tab.c lex.yy.c -o s-parser
	./s-parser input.txt output.txt
clean:
	rm simple-bison-code.tab.c simple-bison-code.tab.h lex.yy.c s-parser
