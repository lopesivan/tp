XARGS 1 "MARCH 2014" Linux "User Manuals"
=========================================

NAME
----

xargs - Exemplos de uso

DESCRIPTION
-----------

The xargs command is extremely useful when we combine it with other commands.
This tutorials explains the usage of xargs command using few simple examples.
These example will help you understand the basics of how xargs command works.
But, once you understand these concepts, you can come-up with your own clever
examples of xargs to solve various command line problems.

1. Xargs Basic Example
----------------------

The xargs command (by default) expects the input from stdin, and executes
/bin/echo command over the input. The following is what happens when you
execute xargs without any argument, or when you execute it without combining
with any other commands.

When you type xargs without any argument, it will prompt you to enter the
input through stdin:

```
$ xargs
Hi,
Welcome to TGS.
```

After you type something, press ctrl+d, which will echo the string back to you
on stdout as shown below.

```
$ xargs
Hi,
Welcome to TGS.Hi, Welcome to TGS.
```

2. Specify Delimiter Using -d option
------------------------------------

Delimiters can be applied so that each character in the input is taken
literally using -d option in xargs.

In the previous example, even though the input contained a \n (newline) after
‘Hi,’ but the echoed output did not contain the newline ‘\n’ . So, the output
in the previous example was combined into a single line.

In the following example, when you use the -d\n, it will preserve newline
delimiter in the output, and display the output exactly as it was typed.

```
$ xargs -d\n
Hi,
Welcome to TGS.
```

After you type the above, press ctrl+d, which will echo the string back to you
on stdout as shown below. But, this time it will preserve the newline.

```
$ xargs -d\n
Hi,
Welcome to TGS.Hi,
Welcome to TGS.
```

3. Limit Output Per Line Using -n Option
----------------------------------------

By default as explained earlier, xargs displays whatever comes to its stdin as
shown below.

```
$ echo a b c d e f| xargs
a b c d e f
```

But, the output of the xargs command can be split into multiple lines using -n
option.

In the following example, we used -n 3, which will display only 3 items per
line in the xargs output.

```
$ echo a b c d e f| xargs -n 3
a b c
d e f
```

In the same way, you can also split the output with 2 items per line as shown
below using -n 2.

```
$ echo a b c d e f| xargs -n 2
a b
c d
e f
```

4. Prompt User Before Execution using -p option
-----------------------------------------------

Using option -p, you can confirm the execution of the xargs command from the
user.

Considering the previous example, if we want to confirm each execution of the
/bin/echo command by the user, use the -p option along with -n option as shown
below.

```
$ echo a b c d e f| xargs -p -n 3
/bin/echo a b c ?...y
/bin/echo d e f ?...a b c
y
d e f
```

In the following output, I said “n” to all the echo output. So, xargs did not
execute anything.

```
$ echo a b c d e f| xargs -p -n 3
/bin/echo a b c ?...n
/bin/echo d e f ?...n
/bin/echo ?...n
```

Note: This is helpful when you are combining xargs with commands that are
disruptive like rm. In those cases, you may want to see what xargs does.

5. Avoid Default /bin/echo for Blank Input Using -r Option
----------------------------------------------------------

When there is a blank input (i.e no input was given to xargs command), it will
execute a /bin/echo command which will display a new line as shown below.

```
$ xargs -p
Press ctrl-d after typing “xargs -p”, which will indicate that it executed a /bin/echo as shown below.
```

```
$ xargs -p
                      /bin/echo ?...y

$
```

6. Print the Command Along with Output Using -t Option
------------------------------------------------------

In the following example, type “abcd” as the input for the xargs -t command.

```
$ xargs -t
abcd
```

Press ctrl-d to complete the above xargs -t command, which will display the
command that xargs really executes before displaying the output. In this case,
the command that xargs executes is “/bin/echo abcd”, which is displayed here.

```
$ xargs -t
abcd
/bin/echo abcd
abcd
```

7. Combine Xargs with Find Command
----------------------------------

It is one of the most important usage of xargs command. When you need to find
certain type of files and perform certain actions on them (most popular being
the delete action).

The xargs command is very effective when we combine with other commands.

In the following example, we took the output of the find command, and passed
it as input to the xargs command. But, instead of executing the default
/bin/echo command, we are instructing xargs command to execute the rm -rm
command on the input.

So, in this example, the output of the find command is all the files with \*.c
extension, which is given as input to the xargs command, which in-turn execute
“rm -rf” command on all the \*.c files.

```
$ ls
one.c  one.h  two.c  two.h

$ find . -name "*.c" | xargs rm -rf

$ ls
one.h  two.h
```

8. Delete Files that has White-space in the Filename
----------------------------------------------------

So we see that despite of running the rm command on the .c files in this
directory, the file ‘The Geek Stuff.c’ was not deleted. This is because this
file contains white space characters in its name.

As shown in the following example, it deleted all the files with the \*.c
extension except one. i.e the file that has white space in the filename (i.e
“The Geek Stuff.c”) was not deleted by the rm command.

```
$ touch "The Geek Stuff.c"

$ ls
one.c  one.h  two.c  two.h The Geek Stuff.c

$ find . -name "*.c" | xargs rm -rf

$ ls
one.h  two.h  The Geek Stuff.c
```
In this situation, use the -print0 option with find command and -0 option with xargs command to delete files including those that has space in the filenames as shown below.

```
$ ls
one.c  one.h  two.c  two.h The Geek Stuff.c

$ find . -name "\*.c" -print0 | xargs -0 rm -rf

$ ls
one.h  two.h
```

9. Display System Limits on xargs using –show-limits option
-----------------------------------------------------------

See the example below:
The following example displays all the limits set by the OS that will have an
impact on the way how xargs command works.

```
$ xargs --show-limits
Your environment variables take up 1203 bytes
POSIX upper limit on argument length (this system): 2093901
POSIX smallest allowable upper limit on argument length (all systems): 4096
Maximum length of command we could actually use: 2092698
Size of command buffer we are actually using: 131072
```

Execution of xargs will continue now, and it will try to read its input and
run commands; if this is not what you wanted to happen, please type the
end-of-file keystroke.

Warning: /bin/echo will be run at least once.  If you do not want that to
happen, then press the interrupt keystroke

10. Combine Xargs with Grep command
-----------------------------------

The xargs command can be combined with grep command to filter particular files
from the search results of the find command.

In the following example, find command provided all the .c files as input to
xargs.

The xargs command executes the grep command to find all the files (among the
files provided by find command) that contained a string ‘stdlib.h’.

```
$ find . -name '*.c' | xargs grep 'stdlib.h'
./tgsthreads.c:#include
./valgrind.c:#include
./direntry.c:#include
./xvirus.c:#include
./temp.c:#include
...
...
...
```

