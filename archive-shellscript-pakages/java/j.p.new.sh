#! /bin/bash
JAVA_SCRIPT_DIR=$SHELLSCRIPT_PKG/../archive-shellscript-pakages/java
PROGRAM_NAME=$(echo `basename $0`)

DEBUG=DDB # Developer DeBug

case $PROGRAM_NAME in
	'j.new-project'    ) echo =*= Java New Project     =*=; OPT=1
	;;
	'j.new-lib-project') echo =*= Java New Project     =*=; OPT=2
	;;
	'j.update-make'    ) echo =*= Java Tools Makefiles =*=; OPT=3
	;;
esac

##############################################################################
##############################################################################
##############################################################################

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
if [ $OPT -eq 1 ]; then
  application=$1
      package=br.com.fortytwo.$2
nameOfProject=$3
     activity=${application^}
         path=${nameOfProject}
         main="$path/src/$(echo $package | tr '\.' '/')"
mkdir -p $main
mkdir -p $path/test

cat << EOF > $main/${activity}.java
package $package;
public class $activity {

    public static void main(String[] args) {
        System.out.println("Hello, World");
    }

}
EOF

cat << EOF > $path/test/${activity}Test.java
package $package;
import org.apache.log4j.Logger;
import junit.framework.Assert;
import junit.framework.TestCase;

public class ${activity}Test extends TestCase {
	private static Logger log = Logger.getRootLogger();

	public ${activity}Test(String name)
	{
		super(name);
		log.info("-- ${activity}Test --");

	}
	public void setUp()
	{
		log.info("-- setUp --");

	}
	public void testUnique()
	{
		log.info("-- testUnique --");
//		Assert.assertEquals(true, sone == stwo);
	}
}
EOF
	cp -r $JAVA_SCRIPT_DIR/03/*  $path/

	echo "`basename $0` $*" > $path/cmd.i
	sed "s/__PACKAGE__/$package/"    -i $path/Makefile
	sed "s/__ClassName__/$activity/" -i $path/Makefile

	sed "s/__PACKAGE__/$package/" -i $path/build.haml
	sed "s/__MyProject__/$nameOfProject/" -i $path/build.haml
	sed "s/__MyProject__/$nameOfProject/" -i $path/.project
	find $path
fi
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
if [ $OPT -eq 2 ]; then
	echo não impelentado ainda
fi
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
if [ $OPT -eq 3 ]; then
	tar xvzf $JAVA_SCRIPT_DIR/b.1.tgz
fi
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

#-----------------------------------------------------------------------------
exit 0
