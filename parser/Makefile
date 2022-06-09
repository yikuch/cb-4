#!/usr/bin/make
.SUFFIXES:
.PHONY: all run pack clean

PCK = lab-4.zip
TAR = minako

LEX = flex
YACC = bison

CSRC = 
LSRC = minako-lexic.l
YSRC = minako-syntax.y
OBJ = $(YSRC:%.y=%.tab.o) $(LSRC:%.l=%.o) $(CSRC:%.c=%.o)
DEP = $(OBJ:%.o=%.d)
-include $(DEP)

CFLAGS = -std=c11 -Wall -pedantic -MMD -MP
LFLAGS = -t
YFLAGS = -d -v

%.c: %.l
	$(LEX) $(LFLAGS) $< > $@
%.tab.c %.tab.h: %.y
	$(YACC) $(YFLAGS) $<
%.o: %.c
	$(CC) $(CFLAGS) -c $<

$(TAR): $(OBJ)
	$(CC) $(CFLAGS) $^ -o $@

all: $(TAR)

run: all
	./$(TAR) demorgan.c1

pack:
	zip -vj $(PCK) $(YSRC)

clean:
	$(RM) $(RMFILES) $(TAR) $(OBJ) $(DEP) $(PCK) $(LSRC:%.l=%.c) $(YSRC:%.y=%.tab.c) $(YSRC:%.y=%.tab.h)
