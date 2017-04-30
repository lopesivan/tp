#! /bin/sed -f

/\.cpp/bis_cpp
/\.c/bis_c

# ----------------------------------------------------------------------------
								       :is_cpp
# ----------------------------------------------------------------------------

h

i\
CC = g++\
LD = $(CC)\
\
CFLAGS   = -c\
LDFLAGS  = -o\
GDBFLAGS = -g\

s/.*/sources := &/

p;g

s/\([^ ]\+\)\.cpp\s*.*/target  := \1/

p;g

i\
targets := tags $(target)\
\
# Compile\
.cpp.o:\
	$(CC) $(CFLAGS) $(GDBFLAGS) $<\
\
all: $(targets)\
\
tags:\
\t\/bin\/rm -rf tags\
\tctags -R --c++-kinds=+p --fields=+iaS --extra=+q $(sources) *.h\

s/\([^ ]\.cpp\)\s*/\1: /
s/\.cpp//
s/\(.*\):\([^:]*\)/\1: \1.o\2/
s/\.cpp/.o/

p;g

i\
\t$(CC) $(LDFLAGS) $@ $^\
\
clean:\
\t\/bin\/rm -rf $(target) $(sources:.cpp=.o) *.orig a.out

bis_eof

# ----------------------------------------------------------------------------
									 :is_c
# ----------------------------------------------------------------------------

h

i\
CC = gcc\
LD = $(CC)\
\
CFLAGS   = -c\
LDFLAGS  = -o\
GDBFLAGS = -g\

s/.*/sources := &/

p;g

s/\([^ ]\+\)\.c\s*.*/target  := \1/

p;g

i\
targets := tags $(target)\
\
# Compile\
.c.o:\
	$(CC) $(CFLAGS) $(GDBFLAGS) $<\
\
all: $(targets)\
\
tags:\
\t\/bin\/rm -rf tags\
\tctags -R --c-kinds=+p --fields=+iaS --extra=+q $(sources) *.h\

s/\([^ ]\.c\)\s*/\1: /
s/\.c//
s/\(.*\):\([^:]*\)/\1: \1.o\2/
s/\.c/.o/

p;g

i\
\t$(CC) $(LDFLAGS) $@ $^\
\
clean:\
\t\/bin\/rm -rf $(target) $(sources:.c=.o) *.orig a.out

##############################################################################
:is_eof
g
s/^.*/# END OF FILE/
