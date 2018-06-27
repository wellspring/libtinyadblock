# libTinyAdBlock -- proof of concept

all:
	@mkdir -p src

	@echo " [+] Downloading host list..."
	@curl 'https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&mimetype=plaintext' | awk '(/^[^\s#]/ && $$2 !~ "localhost") {print $$2}' | tr -d '\r' | sort -u > src/libtinyadblock.hosts

	@echo " [+] Generating code..."
	@printf 'int host_blocked(const char *YYCURSOR){const char *YYMARKER;/*!re2c re2c:define:YYCTYPE=char;re2c:yyfill:enable=0;*{return 0;}("%s")"\\x00"{return 1;}*/}' "$$(sed ':a;N;s/\n/" | "/;ta' src/libtinyadblock.hosts)" > src/libtinyadblock.src
	@re2c -i src/libtinyadblock.src > src/libtinyadblock.c

	@echo " [+] Compiling..."
	@clang -O3 -Wall -shared -o libtinyadblock.so src/libtinyadblock.c

test:
	@echo Compiling tests...
	@clang -Wall -O3 -Isrc -L. -ltinyadblock -o tests/test_libtinyadblock_fast{,.c}
	@LD_LIBRARY_PATH=. ./tests/test_libtinyadblock_fast
