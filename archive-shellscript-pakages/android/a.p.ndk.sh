#! /bin/bash
ANDROID_SCRIPT_DIR=$SHELLSCRIPT_PKG/../archive-shellscript-pakages/android/
PROGRAM_NAME=$(echo `basename $0`)
res=res.1.0.tgz

DEBUG=DDB # Developer DeBug

case $PROGRAM_NAME in
	'a.ndk'    ) echo =*= Android New Project     =*=; OPT=1
	;;
	'a.ndk-lib') echo =*= Android New Project     =*=; OPT=2
	;;
	'a.ndk-make'    ) echo =*= Android Tools Makefiles =*=; OPT=3
	;;
esac

##############################################################################
##############################################################################
##############################################################################

if [ "$1" = "-u" ]; then
   path=$(uuidgen)/
   shift
else
   path=
fi
  application=$1
nameOfProject=$3
      NDK_DIR=$ANDROID_NDK
      package=com.apptechcorp.$2
     activity=${application^}
       target=android-10
       path=${path}${nameOfProject}
        main="$path/src/$(echo $package | tr '\.' '/')"
        _com_package_="_$(echo $package | tr '\.' '_')"_
        com_package_="$(echo $package | tr '\.' '_')"_
        etc="$main/etc"
   haml_dir=$path/__res__
  MYLIBNAME=mylib
#=============================================================================

makefileDefault() {

# Cria Makefile
cat << EOF > $path/Makefile
targetId = $target
package  = $package
activity = $activity
TAG      = $DEBUG
ACTION   = android.intent.action.MAIN
COMMAND  = \$(package)/.\$(activity)

all: resource configure debug

configure:
	@android update project --path . --target "\$(targetId)"
	@echo target=\$(targetId) > default.properties

resource:
	@make -f Makefile.\$@

ndk: configure
	@make -f Makefile.ndk compile

cleanlogcat:
	@adb logcat -c

log: cleanlogcat
	@adb logcat -s "\$(TAG)" | tee f.logcat

#livewallpaper:
#	@adb shell am start -a \$(ACTION) -n \$(COMMAND)
#	@adb shell am start -n \$(COMMAND)

run:
	@adb shell am start -a \$(ACTION) -n \$(COMMAND)

indent:
	@ant \$@

debug:
	@ant \$@

release:
	@ant \$@

signing: configure ndk
	@./\$@.sh

debug-install: debug
	@ant installd

release-install: signing
	@ant \$(@)r

deploy: clean resource-clean resource uninstall
	@ant debug
	@ant installd

install:
	@ant \$(@)d

uninstall:
	@ant \$@

ps:
	@adb shell ps| grep com.apptechcorp

ndk-clean:
	@make -f Makefile.ndk clean

resource-clean:
	@make -f Makefile.resource clean

doc-clean:
	@(cd doc; make clean)

clean-all: clean resource-clean ndk-clean doc-clean

clean:
	@ant \$@
	-rm -rf obj/ *.log default.properties f.logcat
	@(find src/ -type f -name \*.orig -exec rm {} \; )
	-rm *.keystore
EOF
}

makefileResource() {

# Cria Makefile
cat << EOF > $path/Makefile.resource
hamls    = \$(wildcard __res__/*/*.haml) AndroidManifest.haml
EXT      = .xml

.SUFFIXES:              # Delete the default suffixes
.SUFFIXES: .haml \$(EXT) # Define our suffix list

# -------------------------------------------------------------------------- #
# -------------------------------------------------------------------------- #
# -------------------------------------------------------------------------- #
#HAML     = haml
HAML     = ./resource.rb
#HAMLFLAGS= --debug

# -------------------------------------------------------------------------- #
# shell macro
# -------------------------------------------------------------------------- #
targets=\\
	for d in \$(hamls); \\
	do \\
		echo \$\${d%.haml}\$(EXT); \\
	done
##############################################################################

%\$(EXT): %.haml
	\$(HAML) \$(HAMLFLAGS) \$< \$(shell echo \$@| sed 's/__//g' )
	@sed 's/android:/\\n&/g' -i \$(shell echo \$@| sed 's/__//g' )

# -------------------------------------------------------------------------- #
# -------------------------------------------------------------------------- #
# -------------------------------------------------------------------------- #

all: \$(shell \$(targets))
#
# ============================================================================
#

clean:
	-rm -rf \$(shell echo \$(hamls:.haml=.xml)| sed 's/__//g' )
# END OF FILE
EOF
}

makeScripts() {

	cat $ANDROID_SCRIPT_DIR/resource.rb > $path/resource.rb

	chmod +x $path/resource.rb

	cat $ANDROID_SCRIPT_DIR/layoutmain.rb > $path/layoutmain.rb

	cat $ANDROID_SCRIPT_DIR/manifest.rb| \
	sed "s/__PKG__/$package/"  > $path/manifest.rb

	cat $ANDROID_SCRIPT_DIR/AndroidManifest.haml | \
	sed "s/__ACTIVITY__/$activity/" > $path/AndroidManifest.haml

	# Cria Arquivo com configuração global
	cat $ANDROID_SCRIPT_DIR/main.haml.example.1 > $haml_dir/layout/main.haml.example.1
	# Cria Arquivo com configuração global
	cat $ANDROID_SCRIPT_DIR/main.haml > $haml_dir/layout/main.haml
}

makeGlobalConfiguration() {

# Cria Arquivo L de log
cat << EOF > $etc/L.java
package $package.etc;

// log
import android.util.Log;

// etc
import $package.etc.Configurations;

public class L {

	static final String TAG = Configurations.getInstance().getTAG();

	public static void d(String message) {

		String fullClassName = Thread.currentThread().getStackTrace()[3].getClassName();
		String className     = fullClassName.substring(fullClassName.lastIndexOf(".") + 1);
		String methodName    = Thread.currentThread().getStackTrace()[3].getMethodName();
		int lineNumber       = Thread.currentThread().getStackTrace()[3].getLineNumber();

		Log.d(TAG, className + "." + methodName + "():" + lineNumber + "\n> " + message);
	}
}
EOF
# Cria Arquivo com configuração global
cat << EOF > $etc/Configurations.java
package $package.etc;

// log
import android.util.Log;

public final class Configurations {

	private static Configurations INSTANCE = new Configurations();
	private final String TAG;

	private Configurations()
	{
		TAG = "$DEBUG";
		Log.d(TAG, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + "()");
	}

	/**
	 * Returns the Configurations instance
	 *
	 * @return {@link Configurations}
	 */
	public static Configurations getInstance()
	{
		if (Configurations.INSTANCE == null) {
			Configurations.INSTANCE = new Configurations();
		}

		return Configurations.INSTANCE;
	}

	public final String getTAG()
	{
		return TAG;
	}
	// --
}
EOF
}

makeSource() {

cat << EOF > ${path}/jni/Android.mk
LOCAL_PATH := \$(call my-dir)

include \$(CLEAR_VARS)

LOCAL_MODULE    := ${MYLIBNAME}
LOCAL_SRC_FILES := ${MYLIBNAME}.c

include \$(BUILD_SHARED_LIBRARY)
EOF
cat << EOF > ${path}/jni/${MYLIBNAME}.c
#include "${com_package_}Native.h"

JNIEXPORT jstring JNICALL Java${_com_package_}Native_getMyData
    (JNIEnv* pEnv, jobject pThis) {
    return (*pEnv)->NewStringUTF(pEnv,
                                 "My native project talks C++");
}
EOF

#cat << EOF > ${path}/jni/${MYLIBNAME}.h
##include <jni.h>
#
##ifndef _MYLIB_H
##define _MYLIB_H
##ifdef __cplusplus
#extern "C" {
##endif
#/*
# * Class:     com_apptechcorp_Native
# * Method:    getMyData
# * Signature: ()Ljava/lang/String;
# */
#JNIEXPORT jstring JNICALL Java${_com_package_}Native_getMyData
#  (JNIEnv *, jobject);
#
##ifdef __cplusplus
#}
##endif
##endif
#EOF

# Cria Actcvity Principal
cat << EOF > ${main}/Native.java
package ${package};

import java.io.File;

//import android.content.Context;
//import android.content.pm.PackageManager.NameNotFoundException;

// log
import android.util.Log;

// etc
import ${package}.etc.Configurations;
import ${package}.etc.L;

public class Native {
	private static final boolean useNative;

	private static String[] sLibs = {
		"${MYLIBNAME}"
	};

	static {
		boolean success;

		try {
			for (String lib : sLibs) {
				L.d("Load library:" + lib);
				System.loadLibrary(lib);
			}
			success = true;
		}
		catch (Throwable e) {
			success = false;
		}

		useNative = success;
	}

	private native String getMyData();

	public String nGetMyData() {
		if (useNative) {
			return getMyData();
		}

		return "NONE";
	}
}
EOF

# Cria Actcvity Principal
cat << EOF > ${main}/${activity}.java
package ${package};

import android.app.Activity;
import android.os.Bundle;
//import android.widget.TextView;

// log
import android.util.Log;

// etc
import ${package}.etc.Configurations;
import ${package}.etc.L;

// Native
import ${package}.Native;

public class $activity extends Activity {
	private final String TAG = Configurations.getInstance().getTAG();

	private Native mNative = new Native();

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		Log.d(TAG, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + "()");

		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		/*
		String Title = mNative.nGetMyData();
		setTitle(Title);
		*/

		/*
		String text = mNative.nGetMyData();
		TextView tv =  (TextView) findViewById(R.id.main_layoutTextView_1);
		tv.setText(text);
		*/
	}

	public $activity() {
		L.d("ctor");
	}

	@Override
	public void onDestroy() {
		super.onDestroy();

		Log.d(TAG, new Exception().getStackTrace()[0].getClassName() + "." + new Exception().getStackTrace()[0].getMethodName() + "()");

		/*
		 * Kill application when the root activity is killed.
		 */
		killApp(true);
	}

	private void killApp(boolean killSafely) {

		if (killSafely) {
			/*
			 * Notify the system to finalize and collect all objects of the app
			 * on exit so that the virtual machine running the app can be killed
			 * by the system without causing issues. NOTE: If this is set to
			 * true then the virtual machine will not be killed until all of its
			 * threads have closed.
			 */
			System.runFinalizersOnExit(true);

			/*
			 * Force the system to close the app down completely instead of
			 * retaining it in the background. The virtual machine that runs the
			 * app will be killed. The app will be completely created as a new
			 * app in a new virtual machine running in a new process if the user
			 * starts the app again.
			 */
			System.exit(0);
		}

		else {
			/*
			 * Alternatively the process that runs the virtual machine could be
			 * abruptly killed. This is the quickest way to remove the app from
			 * the device but it could cause problems since resources will not
			 * be finalized first. For example, all threads running under the
			 * process will be abruptly killed when the process is abruptly
			 * killed. If one of those threads was making multiple related
			 * changes to the database, then it may have committed some of those
			 * changes but not all of those changes when it was abruptly killed.
			 */
			android.os.Process.killProcess(android.os.Process.myPid());
		}

	}
}
EOF
}

makeAndroidManifest() {
# Cria AndroidManifest
cat << EOF > $path/AndroidManifest.xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
		package="$package"
		android:versionCode="1"
		android:versionName="1.0">
	<application
			android:label="@string/app_name"
			android:icon="@drawable/icon" >
		<activity
				android:name="$activity"
				android:label="@string/app_name">
			<intent-filter>
				<action android:name="android.intent.action.MAIN" />
				<category android:name="android.intent.category.LAUNCHER" />
			</intent-filter>
		</activity>
	</application>
</manifest>
EOF
}

makefileNDK() {
# Cria Makefile NDK
cat << EOF > $path/Makefile.ndk
targetId = $target
package  = $package
activity = $activity
NDK_DIR  = $NDK_DIR

all: configure compile

configure:
	@android update lib-project --path . --target "\$(targetId)"
	@echo target=\$(targetId) > default.properties

compile:
	javah -classpath bin/classes -jni -d jni ${package}.Native
	@\$(NDK_DIR)/ndk-build NDK_LOG=1 V=1 -B | tee compile.log

indent:
	@ant \$@

clean:
	@\$(NDK_DIR)/ndk-build clean
	-rm -rf obj/ *.log
	-rm -rf obj/ *.log default.properties
	@(find src/ -type f -name \*.orig -exec rm {} \; )

EOF
}

addIndent() {

sed '/<\/project>/d' -i $path/build.xml

cat ~/.vim/templates/indent.tpl >> $path/build.xml
cat << EOF >> $path/build.xml

</project>
EOF
}

eclipse() {
cat << EOF > $path/.project
<?xml version="1.0" encoding="UTF-8"?>
<projectDescription>
	<name>$nameOfProject</name>
	<comment></comment>
	<projects>
	</projects>
	<buildSpec>
		<buildCommand>
			<name>com.android.ide.eclipse.adt.ResourceManagerBuilder</name>
			<arguments>
			</arguments>
		</buildCommand>
		<buildCommand>
			<name>com.android.ide.eclipse.adt.PreCompilerBuilder</name>
			<arguments>
			</arguments>
		</buildCommand>
		<buildCommand>
			<name>org.eclipse.jdt.core.javabuilder</name>
			<arguments>
			</arguments>
		</buildCommand>
		<buildCommand>
			<name>com.android.ide.eclipse.adt.ApkBuilder</name>
			<arguments>
			</arguments>
		</buildCommand>
	</buildSpec>
	<natures>
		<nature>com.android.ide.eclipse.adt.AndroidNature</nature>
		<nature>org.eclipse.jdt.core.javanature</nature>
	</natures>
</projectDescription>
EOF

cat << EOF > $path/.classpath
<?xml version="1.0" encoding="UTF-8"?>
<classpath>
	<classpathentry kind="src" path="src"/>
	<classpathentry kind="src" path="gen"/>
	<classpathentry kind="con" path="com.android.ide.eclipse.adt.ANDROID_FRAMEWORK"/>
	<classpathentry kind="con" path="com.android.ide.eclipse.adt.LIBRARIES"/>
	<classpathentry kind="output" path="bin/classes"/>
</classpath>
EOF
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
if [ $OPT -eq 1 ]; then
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

[ "$1" ] || {
	echo Usage:
	echo $PROGRAM_NAME celebrity mode.audio celebrityAudioStream

	exit 1
}

# Cria projeto
android create project --target $target \
	--name $nameOfProject  \
	--path    ./$path      \
	--activity $activity   \
	--package  $package

mkdir -p $etc
mkdir -p $path/jni

mkdir -p $haml_dir/layout \
         $haml_dir/xml    \
         $haml_dir/values \
         $haml_dir/anim

makefileNDK
makefileDefault
makefileResource
makeScripts
makeAndroidManifest
makeGlobalConfiguration
makeSource
eclipse
addIndent

tar xvzf /opt/files/$res -C $path/
rm -rf $path/res/drawable-xdpi

tar xvzf /opt/files/android-signing.tgz -C $path/
echo "`basename $0` $*" > $path/cmd.i

tar xvzf /opt/files/doc.2.tgz -C $path/
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fi # => 1 <= @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
if [ $OPT -eq 2 ]; then
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

[ "$1" ] || {
	echo Usage:
	echo $PROGRAM_NAME celebrity mode.audio celebrityAudioStream

	exit 1
}

# Cria projeto
android create lib-project --target $target \
	--name $nameOfProject  \
	--path    ./$path      \
	--activity $activity   \
	--package  $package

mkdir -p $etc
mkdir -p $path/jni

mkdir -p $haml_dir/layout \
         $haml_dir/xml    \
         $haml_dir/values \
         $haml_dir/anim

makefileNDK
makefileDefault
makefileResource
makeScripts
makeAndroidManifest
makeGlobalConfiguration
makeSource
eclipse
addIndent

tar xvzf /opt/files/$res -C $path/
rm -rf $path/res/drawable-xdpi

tar xvzf /opt/files/android-signing.tgz -C $path/
echo "`basename $0` $*" > $path/cmd.i

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fi # => 2 <= @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
if [ $OPT -eq 3 ]; then
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

tar xvzf /opt/files/build-android.tgz

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fi # => 3 <= @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

#-----------------------------------------------------------------------------
exit 0
