#!/bin/bash
#                      __ __       ___
#                     /\ \\ \    /'___`\
#                     \ \ \\ \  /\_\ /\ \
#                      \ \ \\ \_\/_/// /__
#                       \ \__ ,__\ // /_\ \
#                        \/_/\_\_//\______/
#                           \/_/  \/_____/
#                                         Algoritimos
#
#
#       Author: Ivan carlos da Silva Lopes
#         Mail: ivanlopes (at) 42algoritimos (dot) com (dot) br
#      License: gpl
#        Site: http://www.42algoritmos.com.br
#       Phone: +1 561 801 7985
#    Language: Shell Script
#        File: mk.app.sh
#        Date: Sun 28 Jul 2013 07:15:15 PM BRT
# Description:
#

# ----------------------------------------------------------------------------
__debug__=0; __help__=0
__usage__=0
__clean__=0
# ----------------------------------------------------------------------------
[ "$1" = '--gui'   ] && { __gui__=1; shift;   }
[ "$1" = '-h'      ] && { __help__=1; shift;  }
[ "$1" = '--help'  ] && { __help__=1; shift;  }
[ "$1" = '-d'      ] && { __debug__=1; ECHO=echo;shift; }
[ "$1" = '--debug' ] && { __debug__=1; ECHO=echo;shift; }
[ "$1" = '--usage' ] && { __usage__=1; shift; }
[ "$1" = '--clean' ] && { __clean__=1; shift; }
# ----------------------------------------------------------------------------

##############################################################################
##############################################################################
##############################################################################

app=y
read -p "Console App:[y/n](y): " app

# ===========================================================================
if [ $app == 'n' ]; then
# ===========================================================================

# ----------------------------------------------------------------------------
# WEB APP
# ----------------------------------------------------------------------------
	echo WEB APP
	read -p "[package](br.com.fortytwo.myapp): " package
	read -p "[dir](my-app): " mydir

	: ${package:=br.com.fortytwo.myapp}
	: ${mydir:=my-app}

	test -d $mydir && {
		echo cannot create directory \`${mydir}\': File exists\`
		exit 1
	}

	$ECHO mvn archetype:generate \
		-DgroupId=${package} \
		-DartifactId=${mydir} \
		-DarchetypeArtifactId=maven-archetype-quickstart \
		-DinteractiveMode=false

	if [ $__debug__ -eq 0 ]; then
		#__debug__ has value equal 0
		#__debug__ OFF

		cat > $mydir/compile.cmd  <<EOF
mvn compile
EOF

		cat > $mydir/run.cmd  <<EOF
mvn exec:java -Dexec.mainClass="${package}.App"
EOF
fi

# ===========================================================================
else
# ===========================================================================

# ----------------------------------------------------------------------------
# CONSOLE APP
# ----------------------------------------------------------------------------
	echo CONSOLE APP
	read -p "[package](br.com.fortytwo.myapp): " package
	read -p "[dir](my-app): " mydir

	: ${package:=br.com.fortytwo.myapp}
	: ${mydir:=my-app}

	test -d $mydir && {
		echo cannot create directory \`${mydir}\': File exists\`
		exit 1
	}

	$ECHO mvn archetype:generate \
		-DgroupId=${package} \
		-DartifactId=${mydir} \
		-DarchetypeArtifactId=maven-archetype-quickstart \
		-DinteractiveMode=false

	if [ $__debug__ -eq 0 ]; then
		#__debug__ has value equal 0
		#__debug__ OFF

		cat > $mydir/compile.cmd  <<EOF
mvn compile
EOF

		cat > $mydir/run.cmd  <<EOF
mvn exec:java -Dexec.mainClass="${package}.App"
EOF
fi
# ===========================================================================
# ===========================================================================
# ===========================================================================
fi

# ----------------------------------------------------------------------------
exit 0
