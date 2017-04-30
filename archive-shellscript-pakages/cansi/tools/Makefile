CC = g++
LD = g++

CFLAGS  = -c
LDFLAGS = -o

sources := guessNumber.cpp
targets := $(sources:.cpp=)

# Compile
.cpp.o:
	$(CC) $(CFLAGS) $<

all: $(targets)

tags:
	ctags -R --c++-kinds=+p --fields=+iaS --extra=+q $(sources)

guessNumber: guessNumber.o
	$(CC) $(LDFLAGS) $@ $^

clean:
	rm -rf $(targets) $(sources:.cpp=.o)
