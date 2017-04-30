#! /bin/sed -f

# num | buffer Stdout | buffer hidden | command
#     |               |               |
#  01 | header.h      | Empty         | s/.*/\U&/
#     |               |               |
#  02 | HEADER.H      | Empty         | s/\./_/
#     |               |               |
#  03 | HEADER_H      | Empty         | h
#     |               |               |
#  05 | HEADER_H      | HEADER_H      | s/^/11/
#     |               |               |
#  06 | 11HEADER_H    | HEADER_H      | p
#     |               |               |
#  07 | 11HEADER_H    | HEADER_H      | g
#     | 11HEADER_H    |               |
#     |               |               |
#  08 | 11HEADER_H    | HEADER_H      | s/^/22/
#     | HEADER_H      |               |
#     |               |               |
#  09 | 11HEADER_H    | HEADER_H      | p
#     | 22HEADER_H    |               |
#     |               |               |
#  10 | 11HEADER_H    | HEADER_H      | g
#     | 22HEADER_H    |               |
#     |               |               |
#  11 | 11HEADER_H    | HEADER_H      | s/^/33/
#     | 22HEADER_H    |               |
#     | HEADER_H      |               |
#     |               |               |
#  12 | 11HEADER_H    | HEADER_H      |
#     | 22HEADER_H    |               |
#     | 33HEADER_H    |               |

s/.*/\u&/

h

s/^/class /
s/$/ { \/\/ class definition begin/

p;g

i\
\tpublic :\
\tprivate:\

# replace variable in buffer
#s/.*/<+&+>/

#p
#g
s/^/}; \t\t\/\/ end definition of class /

