all : src/lexer.c src/lexer.l
	bash init.sh
	flex -o src/lex.yy.c src/lexer.l
	gcc src/lex.yy.c src/lexer.c -lfl -o bin/lexer

clean :
	rm -rf src/lex.yy.c bin
