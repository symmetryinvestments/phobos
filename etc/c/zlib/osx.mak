# Makefile for zlib

CC=gcc
LD=link
CFLAGS=-I. -O -g -DHAVE_UNISTD_H -DHAVE_STDARG_H
ifeq (64,$(MODEL))
	CFLAGS+=--target=x86_64-darwin-apple  # ARM cpu is not supported by dmd
endif

LDFLAGS=
O=.o

.c.o:
	"$(CC)" -c $(CFLAGS) $*

.d.o:
	"$(DMD)" -c $(DFLAGS) $*

# variables
OBJS = adler32$(O) compress$(O) crc32$(O) deflate$(O) gzclose$(O) gzlib$(O) gzread$(O) \
	gzwrite$(O) infback$(O) inffast$(O) inflate$(O) inftrees$(O) trees$(O) uncompr$(O) zutil$(O)

all:  zlib.a example infcover minigzip

adler32.o: zutil.h zlib.h zconf.h
	"$(CC)" -c $(CFLAGS) $*.c

zutil.o: zutil.h zlib.h zconf.h
	"$(CC)" -c $(CFLAGS) $*.c

gzclose.o: zlib.h zconf.h gzguts.h
	"$(CC)" -c $(CFLAGS) $*.c

gzlib.o: zlib.h zconf.h gzguts.h
	"$(CC)" -c $(CFLAGS) $*.c

gzread.o: zlib.h zconf.h gzguts.h
	"$(CC)" -c $(CFLAGS) $*.c

gzwrite.o: zlib.h zconf.h gzguts.h
	"$(CC)" -c $(CFLAGS) $*.c

compress.o: zlib.h zconf.h
	"$(CC)" -c $(CFLAGS) $*.c

uncompr.o: zlib.h zconf.h
	"$(CC)" -c $(CFLAGS) $*.c

crc32.o: zutil.h zlib.h zconf.h crc32.h
	"$(CC)" -c $(CFLAGS) $*.c

deflate.o: deflate.h zutil.h zlib.h zconf.h
	"$(CC)" -c $(CFLAGS) $*.c

infback.o: zutil.h zlib.h zconf.h inftrees.h inflate.h inffast.h inffixed.h
	"$(CC)" -c $(CFLAGS) $*.c

inflate.o: zutil.h zlib.h zconf.h inftrees.h inflate.h inffast.h inffixed.h
	"$(CC)" -c $(CFLAGS) $*.c

inffast.o: zutil.h zlib.h zconf.h inftrees.h inflate.h inffast.h
	"$(CC)" -c $(CFLAGS) $*.c

inftrees.o: zutil.h zlib.h zconf.h inftrees.h
	"$(CC)" -c $(CFLAGS) $*.c

trees.o: deflate.h zutil.h zlib.h zconf.h trees.h
	"$(CC)" -c $(CFLAGS) $*.c


example.o: test/example.c zlib.h zconf.h
	"$(CC)" -c $(cvarsdll) $(CFLAGS) test/$*.c

infcover.o: test/infcover.c zlib.h zconf.h
	"$(CC)" -c $(cvarsdll) $(CFLAGS) test/$*.c

minigzip.o: test/minigzip.c zlib.h zconf.h
	"$(CC)" -c $(cvarsdll) $(CFLAGS) test/$*.c

zlib.a: $(OBJS)
	ar -r $@ $(OBJS)

example: example.o zlib.a
	"$(CC)" $(LDFLAGS) -o $@ example.o zlib.a

infcover: infcover.o zlib.a
	"$(CC)" $(LDFLAGS) -o $@ infcover.o zlib.a

minigzip: minigzip.o zlib.a
	"$(CC)" $(LDFLAGS) -o $@ minigzip.o zlib.a

test: example infcover minigzip
	./example
	./infcover
	echo hello world | ./minigzip | ./minigzip -d

clean:
	$(RM) $(OBJS) zlib.a example.o example infcover.o infcover minigzip.o minigzip foo.gz

