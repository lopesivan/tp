#!/bin/bash
#
# Developed by Fred Weinhaus 10/1/2009 .......... revised 11/27/2011
#
# USAGE: colorconverter -c "color" [-d dimensions] [-s] [-v]
# USAGE: colorconverter [-h or -help]
#
# OPTIONS:
#
# -c      color           Any valid IM color specification
# -d      dimensions      Dimensions of optional color swatch; WidthxHeight;
# -s                      Show color swatch of specified color
# -v                      Validate all converted colors by showing color swatches 
#
###
#
# NAME: COLORCONVERTER
# 
# PURPOSE: To convert any valid ImageMagick color specification to the other 
# ImageMagick color representations.
# 
# DESCRIPTION: COLORCONVERTER converts any valid ImageMagick color specification 
# to other ImageMagick color representations, including: RGB, HEX, HSL, HSB 
# and CMYK. The values will be listed to the Terminal. A color swatch for the 
# input color may be displayed. Also a swatch for each of the other color 
# representations may be displayed.
# 
# 
# OPTIONS: 
# 
#
# -c color ... COLOR is any valid IM color specification, including RGB, HEX, 
# HSL, HSB, CMYK or by name. If not a color name, the color specification 
# should be enclosed in quotes.
#
# -d dimensions ... DIMENSIONS specifies the WidthxHeight for the color 
# swatch(es). The default="150x150".
#
# -s ... Indicates to display a color swatch for the specified color.
# 
# -v ... Indicates to display a color swatch for each converted color in 
# the various color representations.
# 
# NOTE: Prior to IM 6.5.6-6, HSL colors may not produce correct swatches, as 
# changes and bugs were fixed starting with IM 6.5.6-4. Prior to IM 6.5.6-4, 
# HSL colors were specified only with hue in range 0-360 and saturation and 
# lightness as percentages. HSB color specification and swatches were only 
# first available and correct starting with IM 6.5.6-6.
# 
# CAVEAT: No guarantee that this script will work on all platforms, 
# nor that trapping of inconsistent parameters is complete and 
# foolproof. Use At Your Own Risk. 
# 
######
#

# set default values
color=""
dimensions="150x150"
show="no"
validate="no"



# set up functions to report Usage and Usage with Description
PROGNAME=`type $0 | awk '{print $3}'`  # search for executable on path
PROGDIR=`dirname $PROGNAME`            # extract directory of program
PROGNAME=`basename $PROGNAME`          # base name of program
usage1() 
	{
	echo >&2 ""
	echo >&2 "$PROGNAME:" "$@"
	sed >&2 -n '/^###/q;  /^#/!q;  s/^#//;  s/^ //;  4,$p' "$PROGDIR/$PROGNAME"
	}
usage2() 
	{
	echo >&2 ""
	echo >&2 "$PROGNAME:" "$@"
	sed >&2 -n '/^######/q;  /^#/!q;  s/^#*//;  s/^ //;  4,$p' "$PROGDIR/$PROGNAME"
	}


# function to report error messages
errMsg()
	{
	echo ""
	echo $1
	echo ""
	usage1
	exit 1
	}


# function to test for minus at start of value of second part of option 1 or 2
checkMinus()
	{
	test=`echo "$1" | grep -c '^-.*$'`   # returns 1 if match; 0 otherwise
    [ $test -eq 1 ] && errMsg "$errorMsg"
	}


# function to compute and show color swatch
function showSwatch()
	{
	convert -respect-parenthesis \( -size "$dimensions" xc:"$1" \) -colorspace rgb \
	-background white -fill black -font Helvetica -pointsize 10 \
	label:"$1" -gravity south -append -alpha off show:
	}


# test for correct number of arguments and get values
if [ $# -eq 0 ]
	then
	# help information
   echo ""
   usage2
   exit 0
elif [ $# -gt 6 ]
	then
	errMsg "--- TOO MANY ARGUMENTS WERE PROVIDED ---"
else
	while [ $# -gt 0 ]
		do
			# get parameter values
			case "$1" in
		  -h|-help)    # help information
					   echo ""
					   usage2
					   exit 0
					   ;;
		 		-c)    # color
					   shift  # to get the next parameter - color
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID COLOR SPECIFICATION ---"
					   checkMinus "$1"
					   color="$1"
					   ;;
		 		-d)    # dimensions
					   shift  # to get the next parameter - color
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID DIMENSION SPECIFICATION ---"
					   checkMinus "$1"
					   dimensions="$1"
					   test=`expr "$1" : '^[0-9][0-9]*x[0-9][0-9]*$'`
					   [ $test -eq 0 ] && errMsg "--- DIMENSIONS=$dimensions ARE NOT VALID ---"
					   ;;
		 		-s)    # show
					   show="yes"
					   ;;
		 		-v)    # validate
					   validate="yes"
					   ;;
 				 -)    # STDIN, end of arguments
  				 	   break
  				 	   ;;
				-*)    # any other - argument
					   errMsg "--- UNKNOWN OPTION ---"
					   ;;					   
				*)     # end of arguments
					   break ;;
			esac
			shift   # next option
	done
fi

# test if color supplied
[ "$color" = "" ] && errMsg "--- A COLOR MUST BE SPECIFIED ---"

# get im version
im_version=`convert -list configure | \
sed '/^LIB_VERSION_NUMBER /!d;  s//,/;  s/,/,0/g;  s/,0*\([0-9][0-9]\)/\1/g' | head -n 1``

the_version="06050606"

echo ""
echo "RGB:"
# get rgb colors
rgb=`convert xc:"$color" -colorspace RGB txt:- | tail -n 1 | sed -n 's/ *//g; s/^.*[:][(]\(.*\)[)].*[\#].*$/\1/p'`
RR=`echo "$rgb" | cut -d, -f1`
GG=`echo "$rgb" | cut -d, -f2`
BB=`echo "$rgb" | cut -d, -f3`
AA=`echo "$rgb" | cut -d, -f4`
RRV=`convert xc: -format "%[fx:255*$RR/quantumrange]" info:`
GGV=`convert xc: -format "%[fx:255*$GG/quantumrange]" info:`
BBV=`convert xc: -format "%[fx:255*$BB/quantumrange]" info:`
RRP=`convert xc: -format "%[fx:100*$RR/quantumrange]" info:`
GGP=`convert xc: -format "%[fx:100*$GG/quantumrange]" info:`
BBP=`convert xc: -format "%[fx:100*$BB/quantumrange]" info:`
[ "$AA" != "" ] && AAV=`convert xc: -format "%[fx:$AA/quantumrange]" info:`
#echo "$RR $GG $BB $AA; $RRV $GGV $BBV; $RRP $GGP $BBP; $AAV"
if [ "$AA" = "" ]; then
	echo "rgb($RRV,$GGV,$BBV)"
	[ "$validate" = "yes" ] && showSwatch "rgb($RRV,$GGV,$BBV)"
	echo "rgb($RRP%,$GGP%,$BBP%)"
	[ "$validate" = "yes" ] && showSwatch "rgb($RRP%,$GGP%,$BBP%)"
else
	echo "rgba($RR,$GG,$BB,$AAV)"
	[ "$validate" = "yes" ] && showSwatch "rgba($RR,$GG,$BB,$AA)"
	echo "rgba($RRP%,$GGP%,$BBP%,$AAV)"
	[ "$validate" = "yes" ] && showSwatch "rgba($RRP%,$GGP%,$BBP%,$AAV)"
fi


echo ""
echo "HEX:"
# get hex colors
hex=`convert xc:"$color" -colorspace RGB txt:- | tail -n 1 | sed -n 's/^.*\([\#][0-9,A-F,a-f]*\) *.*$/\1/p'`
echo "$hex"
[ "$validate" = "yes" ] && showSwatch "$hex"


echo ""
echo "HSL:"
# get hsl colors
hsl=`convert xc:"$color" -colorspace HSL txt:- | tail -n 1 | sed -n 's/ *//g; s/^.*[:][(]\(.*\)[)].*[\#].*$/\1/p'`
HH=`echo "$hsl" | cut -d, -f1`
SS=`echo "$hsl" | cut -d, -f2`
LL=`echo "$hsl" | cut -d, -f3`
AA=`echo "$hsl" | cut -d, -f4`
HHV=`convert xc: -format "%[fx:360*$HH/quantumrange]" info:`
SSV=`convert xc: -format "%[fx:255*$SS/quantumrange]" info:`
LLV=`convert xc: -format "%[fx:255*$LL/quantumrange]" info:`
HHP=`convert xc: -format "%[fx:100*$HH/quantumrange]" info:`
SSP=`convert xc: -format "%[fx:100*$SS/quantumrange]" info:`
LLP=`convert xc: -format "%[fx:100*$LL/quantumrange]" info:`
[ "$AA" != "" ] && AAV=`convert xc: -format "%[fx:$AA/quantumrange]" info:`
#echo "$HH $SS $LL $AA; $HHV $SSV $LLV; $HHP $SSP $LLP; $AAV"
if [ "$AA" = "" ]; then
	if [ "$im_version" -ge "$the_version" ]
		then 
		echo "hsl($HHV,$SSV,$LLV)"
		[ "$validate" = "yes" ] && showSwatch "hsl($HHV,$SSV,$LLV)"
		echo "hsl($HHP%,$SSP%,$LLP%)"
		[ "$validate" = "yes" ] && showSwatch "hsl($HHP%,$SSP%,$LLP%)"
	else
		echo "hsl($HHV,$SSP%,$LLP%)"
		[ "$validate" = "yes" ] && showSwatch "hsl($HHV,$SSP%,$LLP%)"
	fi
else
	if [ "$im_version" -ge "$the_version" ]
		then 
		echo "hsla($HH,$SS,$LL,$AAV)"
		[ "$validate" = "yes" ] && showSwatch "hsla($HH,$SS,$LL,$AAV)"
		echo "hsla($HHP%,$SSP%,$LLP%,$AAV)"
		[ "$validate" = "yes" ] && showSwatch "hsla($HHP%,$SSP%,$LLP%,$AAV)"
	else
		echo "hsla($HHV,$SSP%,$LLP%,$AAV)"
		[ "$validate" = "yes" ] && showSwatch "hsla($HHV,$SSP%,$LLP%,$AAV)"
	fi
fi


echo ""
echo "HSB:"
# get hsb colors
hsb=`convert xc:"$color" -colorspace HSB txt:- | tail -n 1 | sed -n 's/ *//g; s/^.*[:][(]\(.*\)[)].*[\#].*$/\1/p'`
HH=`echo "$hsb" | cut -d, -f1`
SS=`echo "$hsb" | cut -d, -f2`
BB=`echo "$hsb" | cut -d, -f3`
AA=`echo "$hsb" | cut -d, -f4`
HHV=`convert xc: -format "%[fx:360*$HH/quantumrange]" info:`
SSV=`convert xc: -format "%[fx:255*$SS/quantumrange]" info:`
BBV=`convert xc: -format "%[fx:255*$BB/quantumrange]" info:`
HHP=`convert xc: -format "%[fx:100*$HH/quantumrange]" info:`
SSP=`convert xc: -format "%[fx:100*$SS/quantumrange]" info:`
BBP=`convert xc: -format "%[fx:100*$BB/quantumrange]" info:`
[ "$AA" != "" ] && AAV=`convert xc: -format "%[fx:$AA/quantumrange]" info:`
#echo "$HH $SS $BB $AA; $HHV $SSV $BBV; $HHP $SSP $BBP; $AAV"
if [ "$AA" = "" ]; then
	if [ "$im_version" -ge "$the_version" ]
		then 
		echo "hsb($HHV,$SSV,$BBV)"
		[ "$validate" = "yes" ] && showSwatch "hsb($HHV,$SSV,$BBV)"
		echo "hsb($HHP%,$SSP%,$BBP%)"
		[ "$validate" = "yes" ] && showSwatch "hsb($HHP%,$SSP%,$BBP%)"
	else
		echo "hsb($HHV,$SSP%,$BBP%)"
		[ "$validate" = "yes" ] && showSwatch "hsb($HHV,$SSP%,$BBP%)"
	fi
else
	if [ "$im_version" -ge "$the_version" ]
		then 
		echo "hsba($HH,$SS,$BB,$AAV)"
		[ "$validate" = "yes" ] && showSwatch "hsba($HH,$SS,$BB,$AAV)"
		echo "hsba($HHP%,$SSP%,$BBP%,$AAV)"
		[ "$validate" = "yes" ] && showSwatch "hsba($HHP%,$SSP%,$BBP%,$AAV)"
	else
		echo "hsba($HHV,$SSP%,$BBP%,$AAV)"
		[ "$validate" = "yes" ] && showSwatch "hsba($HHV,$SSP%,$BBP%,$AAV)"
	fi
fi

echo ""
echo "CMYK:"
# get cmyk colors
cmyk=`convert xc:"$color" -colorspace CMYK txt:- | tail -n 1 | sed -n 's/ *//g; s/^.*[:][(]\(.*\)[)].*[\#].*$/\1/p'`
CC=`echo "$cmyk" | cut -d, -f1`
MM=`echo "$cmyk" | cut -d, -f2`
YY=`echo "$cmyk" | cut -d, -f3`
KK=`echo "$cmyk" | cut -d, -f4`
AA=`echo "$cmyk" | cut -d, -f5`
CCV=`convert xc: -format "%[fx:255*$CC/quantumrange]" info:`
MMV=`convert xc: -format "%[fx:255*$MM/quantumrange]" info:`
YYV=`convert xc: -format "%[fx:255*$YY/quantumrange]" info:`
KKV=`convert xc: -format "%[fx:255*$KK/quantumrange]" info:`
CCP=`convert xc: -format "%[fx:100*$CC/quantumrange]" info:`
MMP=`convert xc: -format "%[fx:100*$MM/quantumrange]" info:`
YYP=`convert xc: -format "%[fx:100*$YY/quantumrange]" info:`
KKP=`convert xc: -format "%[fx:100*$KK/quantumrange]" info:`
[ "$AA" != "" ] && AAV=`convert xc: -format "%[fx:$AA/quantumrange]" info:`
#echo "$CC $MM $YY $KK $AA; $CCV $YYV $YYV $KKV; $CCP $MMP $YYP $KKP; $AAV"
if [ "$AA" = "" ]; then
	echo "cmyk($CCV,$MMV,$YYV,$KKV)"
		[ "$validate" = "yes" ] && showSwatch "cmyk($CCV,$MMV,$YYV,$KKV)"
	echo "cmyk($CCP%,$MMP%,$YYP%,$KKP%)"
		[ "$validate" = "yes" ] && showSwatch "cmyk($CCP%,$MMP%,$YYP%,$KKP%)"
else
	echo "cmyka($CCV,$MMV,$YYV,$KKV,$AAV)"
		[ "$validate" = "yes" ] && showSwatch "cmyka($CCV,$MMV,$YYV,$KKV,$AA)"
	echo "cmyka($CCP%,$MMP%,$YYP%,$KKP%,$AAV)"
		[ "$validate" = "yes" ] && showSwatch "cmyka($CCP%,$MMP%,$YYP%,$KKP%,$AAV)"
fi

echo ""

if [ "$show" = "yes" ]; then
	showSwatch "$color"
fi

exit 0
