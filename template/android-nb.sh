# ----------------------------------------------------------------------------

d=/home/ivan/src/android-ndk-r5b/samples/hello-jni/
cp $d/default.properties .
ant compile
d=jni
test -d $d && mkdir $d

javah -jni -o jni/hello-jni.h -classpath build/classes com.example.hellojni.HelloJni

# ----------------------------------------------------------------------------
