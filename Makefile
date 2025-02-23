# for debug add -g -O0 to line below
CFLAGS+=-pthread -O2 -Wall -Wextra -Wpedantic -Wstrict-overflow -fno-strict-aliasing -std=gnu11 -g -O0
prefix=build

all:
	${CC} main.c fiche.c $(CFLAGS) -o fiche

install: fiche
	install -m 0755 fiche $(prefix)

clean:
	rm -f fiche

docker:
	docker build --tag solusipse/fiche --build-arg ALPINE_VERSION=3.21 .

.PHONY: clean
