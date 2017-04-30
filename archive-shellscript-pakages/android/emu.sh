#! /bin/bash

listAndroidAvd(){
	android list avd
}

if [ "$1" = '-d' ];
then
	ECHO=echo
	shift
fi

listAndroidTargets(){
	android list target|
	sed -n '/^id:/p' |
    sed 's@^id:\s*\([0-9]\+\)[^"]*\(.*\)@printf "OPT: %d\\t Description: %s\n" \1 \2@'| sh
	echo
	echo "USAGE:"
	echo "`basename $0` OPT -[c|d]"
}

if [ "$1" = '-l' ];
then
	listAndroidAvd
	exit 0
fi

if [ "$1" = '-L' ];
then
	listAndroidTargets
	exit 0
fi

[ $1 ] && \
	source $SHELLSCRIPT_PAKAGES/android/$1.conf
size=128M
[ $1 ] || skin=HVGA

createAndroidAvd() {
	echo android create avd -n $avdName -t \"$target\" -c $size --skin $skin
	$ECHO android create avd -n $avdName -t "$target" -c $size --skin $skin
}

deleteAndroidAvd(){
	$ECHO android delete avd -n $avdName
}

if [ "$2" = '-d' ];
then
	deleteAndroidAvd
	exit 0
fi

if [ "$2" = '-c' ];
then
	createAndroidAvd
	exit 0
fi

if [ "$2" = '-n' ];
then
	echo emulator -avd $avdName
	$ECHO emulator -avd $avdName
else

	id=$(uuidgen)

	echo emulator -cpu-delay 0 -no-boot-anim -cache /tmp/cache-$id -avd $avdName
	$ECHO emulator -cpu-delay 0 -no-boot-anim -cache /tmp/cache-$id -avd $avdName

	rm /tmp/cache-$id
	echo exit
fi

exit 0
