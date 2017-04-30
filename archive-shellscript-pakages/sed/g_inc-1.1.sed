#! /bin/sed -f

s/.*/__\U&__/
s/\./_/g

h

s/^/#ifndef /

p;g

s/^/#define /

p;g

# replace variable in buffer
i\
\
CODE HERE!\

s/^/#endif \t\t\/\/ /
