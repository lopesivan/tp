#! /bin/sed -f
/#include <termios\.h>/{
i\
#ifdef SYSV
a\
#else\
	#include <sgtty.h>\
#endif
}
