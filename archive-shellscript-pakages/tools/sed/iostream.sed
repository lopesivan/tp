#! /bin/sed -f

s/using std::cin;//
s/using std::cout;//
s/using std::endl;//

/#include <iostream>/{
i\
\/\/ provides input and output functionality using streams.
a\
using std::cin;\
using std::cout;\
using std::endl;

}
