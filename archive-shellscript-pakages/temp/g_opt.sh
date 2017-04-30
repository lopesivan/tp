#!/bin/bash
# Usage:
# ./g_opt.sh b.sh bits-opt.sh
# ./g_opt.sh b.sh btable-opt.sh
# ./g_opt.sh cm.sh cm-opt.sh
# ./g_opt.sh cm.sh opt.sh
# ./g_opt.sh lulu.sh opt.sh
# ./g_opt.sh tp.sh  tp-opt.sh
# ./g_opt.sh tp.sh tb-opt.sh
# ./g_opt.sh tp.sh tp-opt.sh

LIBDIR='${SHELLSCRIPT_PAKAGES}'

[ "$2" ] || exit 1

Line()
{
echo '#-----------------------------------------------------------------------------' >> $1
}

cat << EOF-GEN > $1
#!/bin/bash
# vi:set nu nowrap:
# g_opt.sh: <+ =Short Description= +>.

# \$Id:\$
# Unite Software
#      Author: `git config --get user.name`
#        Mail: `git config --get user.email| sed -e 's/\./ (dot) /g' -e 's/@/ (at) /g'`
#     License: gpl
#    Language: Shell Script
#        File: $EMPTY|n$EMPTY|
#        Date: $EMPTY|d$EMPTY|
# Description:
#
#

# ----------------------------------------------------------------------------
nversion=2.1
#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
[ "\$1" = '-d' ] && { DEBUG=1; shift; }
_debug(){ [ "\$DEBUG" = 1 ] && echo "\$*" ; }
_basename=\${0##*/}

#
# opt
#
source $LIBDIR/getoptx.sh
#
# commun functions
#
source $LIBDIR/util.sh

#
#=============================================================================
#

#
# Version
#
function _version()
{
	# Verify command cat
	#
	have cat &&
	{
         cat <<EOF
\$_basename (Unite tools) \$nversion
Copyright (C) 2013 Unite Software, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by `git config --get user.name`.
EOF
	} || { _error 'bash: cat: command not found'; _abort_now; }
	# End have cat
}

#
#=============================================================================
#

#
# Usage
#
function _usage()
{
	# Verify command cat
	#
	have cat &&
	{
         cat <<EOF
Usage: \$_basename [-DIGITS] [OPTION]... [FILE]...
Reformat each paragraph in the FILE(s), writing to standard output.
If no FILE or if FILE is \\\`-', read standard input.

Mandatory arguments to long options are mandatory for short options too.
  -c, --crown-margin        preserve indentation of first two lines
  -p, --prefix=STRING       reformat only lines beginning with STRING,
                              reattaching the prefix to reformatted lines
  -s, --split-only          split long lines, but do not refill
  -t, --tagged-paragraph    indentation of first line different from second
  -u, --uniform-spacing     one space between words, two after sentences
  -w, --width=WIDTH         maximum line width (default of 75 columns)
      --help     display this help and exit
      --version  output version information and exit

With no FILE, or when FILE is -, read standard input.

Report bugs to <`git config --get user.email`>.
EOF
	} || { _error 'bash: cat: command not found'; _abort_now; }
	# End have cat
}

#
#=============================================================================
#

#
# Help
#
function _help()
{
	# Verify command cat
	#
	have cat &&
	{
         cat <<EOF
Usage: \$_basename [-DIGITS] [OPTION]... [FILE]...
Reformat each paragraph in the FILE(s), writing to standard output.
If no FILE or if FILE is \\\`-', read standard input.

Mandatory arguments to long options are mandatory for short options too.
  -c, --crown-margin        preserve indentation of first two lines
  -p, --prefix=STRING       reformat only lines beginning with STRING,
                              reattaching the prefix to reformatted lines
  -s, --split-only          split long lines, but do not refill
  -t, --tagged-paragraph    indentation of first line different from second
  -u, --uniform-spacing     one space between words, two after sentences
  -w, --width=WIDTH         maximum line width (default of 75 columns)
      --help     display this help and exit
      --version  output version information and exit

With no FILE, or when FILE is -, read standard input.

Report bugs to <`git config --get user.email`>.
EOF
	} || { _error 'bash: cat: command not found'; _abort_now; }
	# End have cat
}
##############################################################################
##############################################################################
##############################################################################
EOF-GEN

##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
source $2

grep _opt $2 > /dev/null
if [ "$?" = 1 ]; then

	echo arquivo \"$2\" com problemas.
	exit 1
fi
#-----------------------------------------------------------------------------
Line $1
Line $1
Line $1

cat $2 >> $1

Line $1
Line $1
Line $1

cat << EOF >> $1
_opt=\\
\`echo \$_opt| \\
sed \\
'\\
s/ //g                          ;\\
s/-\\(.[:.]\\?\\)\s*|/\\1  /g       ;\\
:b                              ;\\
s/--\\(.[^ .]\\+[:.]\\)\\s*|/ \\1 /  ;\\
tb                              ;\\
s/--\\(.[^ |]\+\\)\\s*|/ \\1 /g     ;\\
s/--\\(.[^ |]\+\\)\\s*/ \\1 /
'\`
EOF

Line $1
Line $1
Line $1

cat << EOF >> $1
_debug Using getoptex to parse arguments:
_debug \$_opt

while getoptex "\$_opt usage help version" "\$@"
do
	_debug "Option <\$OPTOPT> \${OPTARG:+has an arg <\$OPTARG>}"
	echo \$OPTOPT | grep '-' 1> /dev/null
	if [ \$? = 0 ]; then
		eval flag_\${OPTOPT//-/_}=1
		[ "\$OPTARG" ] && eval flag_\${OPTOPT//-/_}_val=\${OPTARG}
	else
		eval flag_\${OPTOPT}=1
		[ "\$OPTARG" ] && eval flag_\${OPTOPT}_val=\${OPTARG}
	fi

	case \${OPTOPT} in
	help     ) eval flag_\${OPTOPT}=1
	;;

	version  ) eval flag_\${OPTOPT}=1
	;;

	usage    ) eval flag_\${OPTOPT}=1
	;;
	esac

done
shift \$[OPTIND-1]
for arg in "\$@"
do
	echo "Non option argument <\$arg>"
done
EOF

Line $1
Line $1
Line $1
Line $1
Line $1
Line $1

cat << EOF >> $1
if [ "\$flag_help" = 1 ]; then
#	_debug flag_help ON
	_help
	exit 0
else
	:
#	_debug flag_help OFF
fi

if [ "\$flag_version" = 1 ]; then
#	_debug flag_version ON
	_version
	exit 0
else
	:
#	_debug flag_version OFF
fi

if [ "\$flag_usage" = 1 ]; then
#	_debug flag_usage ON
	_usage
	exit 0
else
	:
#	_debug flag_usage OFF
fi

EOF

Line $1
Line $1
Line $1
Line $1
source $2

echo "$_opt" | while read line; do
	[ "$line" ] || continue

	f=0

	line=$(echo $line|sed -r 's/([^-])-([^-])/\1_\2/; s/-+/ flag_/g')

	echo $line | grep '\.' 1> /dev/null
	if [ $? = 0 ]; then
		line=$(echo $line $(echo $line|sed 's/\./_val/g'))
		line=$(echo $line|sed 's/\.//g')
		line=$(echo $line|sed 's/|//g')
		f=1
		a=( $line )

Line $1

cat << EOF >> $1
: \${${a[0]}:=0}
: \${${a[1]}:=0}
: \${${a[2]}:=0}
: \${${a[3]}:=0}

if [ "\$${a[0]}" = "1" -o "\$${a[1]}" = "1" ];
then
	:
	_debug "${a[0]} = \$${a[0]}"
	_debug "${a[1]} = \$${a[1]}"
	_debug "${a[2]} = \$${a[2]}"
	_debug "${a[3]} = \$${a[3]}"
fi
EOF

	fi

	echo $line | grep ':' 1> /dev/null
	if [ $? = 0 ]; then
		line=$(echo $line $(echo $line| sed 's/:/_val/g'))
		line=$(echo $line|sed 's/://g')
		line=$(echo $line|sed 's/|//g')
		f=1
		a=( $line )

Line $1

cat << EOF >> $1
: \${${a[0]}:=0}
: \${${a[1]}:=0}
: \${${a[2]}:=0}
: \${${a[3]}:=0}

if [ "\$${a[0]}" = "1" -o "\$${a[1]}" = "1" ];
then
	:
	_debug "${a[0]} = \$${a[0]}"
	_debug "${a[1]} = \$${a[1]}"
	_debug "${a[2]} = \$${a[2]}"
	_debug "${a[3]} = \$${a[3]}"
fi
EOF

	fi

	if [ $f = 0 ]; then
		line=$(echo $line|sed 's/|//g')
		a=( $line )

Line $1

cat << EOF >> $1
: \${${a[0]}:=0}
: \${${a[1]}:=0}

if [ "\$${a[0]}" = "1" -o "\$${a[1]}" = "1" ];
then
	:
	_debug "${a[0]} = \$${a[0]}"
	_debug "${a[1]} = \$${a[1]}"
fi
EOF
	fi

done

Line $1
echo exit 0 >> $1

chmod +x $1

exit 0
