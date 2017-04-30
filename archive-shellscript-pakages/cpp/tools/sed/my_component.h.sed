#! /bin/sed -f

s/.*/\U&/
s/\./_/g

h

i\
#define MY_COMPONENT_CONTRACTID "@mydomain.com/XPCOMSample/MyComponent;1"\
#define MY_COMPONENT_CLASSNAME "A Simple XPCOM Sample"\
#define MY_COMPONENT_CID _YOUR_COMPONENT_GUID_ \

s/^/#ifndef /

p;g

s/^/#define /

p;g

# insert header
i\
\
#include "IMyComponent.h"

# replace variable in buffer
s/^/\/\/Code Here! /

p;g
r IMyComponent.h.txt


s/^/#endif \t\t\/\/ /
