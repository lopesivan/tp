#! /bin/sed -f

# Convert C++ line-style comments (//)
# to old C-style comments (/* */)
#######################################
# Replace comment (note end marker \n)
s_//\(.*\)$_/*\1 */\n_
# First line kept in the hold buffer
1h;1d
# Is this a pure comment line?
\_^[ \t]*/\*_{
x
# Is it is a multi-line comment?
/ \*\/\n/{
# Ok - change accordingly
s_ \*\/\n__
x
s_/_ _
}
# No? Then we're fine as is
/ \*\/\n/!x
}
# Display previous line (without end marker)
x;s/\n//
# Last line. Have to handle current and previous.
${p;x;s/\n//}
