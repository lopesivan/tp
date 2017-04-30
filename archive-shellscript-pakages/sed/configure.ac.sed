#! /bin/sed -f

/^1.*/bis_mode_one
/^2.*/bis_mode_two
/^3.*/bis_mode_three
/^4.*/bis_mode_four

bis_first
# ----------------------------------------------------------------------------
                                       :is_first
# ----------------------------------------------------------------------------
h
i\
#                                               -*- Autoconf -*-\
# Process this file with autoconf to produce a configure script.\

g
s/.*/AC_INIT([&],[0.01]['$(git config user.email)'])/
p

bis_eof
# ----------------------------------------------------------------------------
                                       :is_mode_one
# ----------------------------------------------------------------------------
# echo 1 hello | ./configure.ac.sed
s/[1-9]\+\s*//
h

i\
#                                               -*- Autoconf -*-\
# Process this file with autoconf to produce a configure script.\
# one\

g
s/.*/AC_INIT([&],[0.01])/
p

bis_eof

# ----------------------------------------------------------------------------
                                       :is_mode_two
# ----------------------------------------------------------------------------
# echo 2 hello 1.2| ./configure.ac.sed
# entrada echo 2 hello 1.6
#              ^ ^     ^
#              | |     |
#              | |     ` version
#              | `project name
#              `option number

s/[1-9]\+\s*//
h

i\
#                                               -*- Autoconf -*-\
# Process this file with autoconf to produce a configure script.\
# two\

g
#s/.*/AC_INIT([&],[0.01])/
s/\(^\w\+\)\s\+\(.*\)/AC_INIT([\1],[\2])/
p

bis_eof

# ----------------------------------------------------------------------------
                                       :is_mode_three
# ----------------------------------------------------------------------------
s/[1-9]\+\s*//
h

i\
#                                               -*- Autoconf -*-\
# Process this file with autoconf to produce a configure script.\
# three\

g
s/.*/AC_INIT([&],[0.01])/
p

bis_eof

# ----------------------------------------------------------------------------
                                       :is_mode_four
# ----------------------------------------------------------------------------
s/[1-9]\+\s*//
h

i\
#                                               -*- Autoconf -*-\
# Process this file with autoconf to produce a configure script.\
# four\

g
s/.*/AC_INIT([&],[0.01])/
p

bis_eof

# #############################################################################
:is_eof
# #############################################################################
g
s/^.*/AC_OUTPUT/
