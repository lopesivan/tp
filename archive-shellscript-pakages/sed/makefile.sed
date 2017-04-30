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
	$(CC) $(CFLAGS) $<\
\
all: $(targets)\

s/\([^ ]\.cpp\)\s*/\1: /
s/\.cpp//
s/\(.*\):\([^:]*\)/\1: \1.o\2/
s/\.cpp/.o/g

p;g

i\
\t$(CC) $(LDFLAGS) $@ $^\
\
clean:\
\t\/bin\/rm -rf $(target) $(sources:.cpp=.o)

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
	$(CC) $(CFLAGS) $<\
\
all: $(targets)\

s/\([^ ]\.c\)\s*/\1: /
s/\.c//
s/\(.*\):\([^:]*\)/\1: \1.o\2/
s/\.c/.o/g

p;g

i\
\t$(CC) $(LDFLAGS) $@ $^\
\
clean:\
\t\/bin\/rm -rf $(target) $(sources:.c=.o)

##############################################################################
:is_eof
g
s/^.*/# END OF FILE/
