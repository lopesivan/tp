#!/bin/sh
# This script was generated using Makeself 2.1.5

CRCsum="3357571103"
MD5="84e83d8afeed2452d33ea6c7163cc175"
TMPROOT=${TMPDIR:=/tmp}

label="Unofficial Qt for Symbian 4.6.3 All-In-One (GNUPOC 1.15 + Qt 4.6.3 + Qt Mobility 1.0.2 + Nokia Smart Installer 1.0) Linux Installer"
script="./install.sh"
scriptargs=""
targetdir="qt_all_in_one_linux_installer"
filesizes="9259"
keep=n

print_cmd_arg=""
if type printf > /dev/null; then
    print_cmd="printf"
elif test -x /usr/ucb/echo; then
    print_cmd="/usr/ucb/echo"
else
    print_cmd="echo"
fi

unset CDPATH

MS_Printf()
{
    $print_cmd $print_cmd_arg "$1"
}

MS_Progress()
{
    while read a; do
	MS_Printf .
    done
}

MS_diskspace()
{
	(
	if test -d /usr/xpg4/bin; then
		PATH=/usr/xpg4/bin:$PATH
	fi
	df -kP "$1" | tail -1 | awk '{print $4}'
	)
}

MS_dd()
{
    blocks=`expr $3 / 1024`
    bytes=`expr $3 % 1024`
    dd if="$1" ibs=$2 skip=1 obs=1024 conv=sync 2> /dev/null | \
    { test $blocks -gt 0 && dd ibs=1024 obs=1024 count=$blocks ; \
      test $bytes  -gt 0 && dd ibs=1 obs=1024 count=$bytes ; } 2> /dev/null
}

MS_Help()
{
    cat << EOH >&2
Makeself version 2.1.5
 1) Getting help or info about $0 :
  $0 --help   Print this message
  $0 --info   Print embedded info : title, default target directory, embedded script ...
  $0 --lsm    Print embedded lsm entry (or no LSM)
  $0 --list   Print the list of files in the archive
  $0 --check  Checks integrity of the archive
 
 2) Running $0 :
  $0 [options] [--] [additional arguments to embedded script]
  with following options (in that order)
  --confirm             Ask before running embedded script
  --noexec              Do not run embedded script
  --keep                Do not erase target directory after running
			the embedded script
  --nox11               Do not spawn an xterm
  --nochown             Do not give the extracted files to the current user
  --target NewDirectory Extract in NewDirectory
  --tar arg1 [arg2 ...] Access the contents of the archive through the tar command
  --                    Following arguments will be passed to the embedded script
EOH
}

MS_Check()
{
    OLD_PATH="$PATH"
    PATH=${GUESS_MD5_PATH:-"$OLD_PATH:/bin:/usr/bin:/sbin:/usr/local/ssl/bin:/usr/local/bin:/opt/openssl/bin"}
	MD5_ARG=""
    MD5_PATH=`exec <&- 2>&-; which md5sum || type md5sum`
    test -x "$MD5_PATH" || MD5_PATH=`exec <&- 2>&-; which md5 || type md5`
	test -x "$MD5_PATH" || MD5_PATH=`exec <&- 2>&-; which digest || type digest`
    PATH="$OLD_PATH"

    MS_Printf "Verifying archive integrity..."
    offset=`head -n 402 "$1" | wc -c | tr -d " "`
    verb=$2
    i=1
    for s in $filesizes
    do
		crc=`echo $CRCsum | cut -d" " -f$i`
		if test -x "$MD5_PATH"; then
			if test `basename $MD5_PATH` = digest; then
				MD5_ARG="-a md5"
			fi
			md5=`echo $MD5 | cut -d" " -f$i`
			if test $md5 = "00000000000000000000000000000000"; then
				test x$verb = xy && echo " $1 does not contain an embedded MD5 checksum." >&2
			else
				md5sum=`MS_dd "$1" $offset $s | eval "$MD5_PATH $MD5_ARG" | cut -b-32`;
				if test "$md5sum" != "$md5"; then
					echo "Error in MD5 checksums: $md5sum is different from $md5" >&2
					exit 2
				else
					test x$verb = xy && MS_Printf " MD5 checksums are OK." >&2
				fi
				crc="0000000000"; verb=n
			fi
		fi
		if test $crc = "0000000000"; then
			test x$verb = xy && echo " $1 does not contain a CRC checksum." >&2
		else
			sum1=`MS_dd "$1" $offset $s | CMD_ENV=xpg4 cksum | awk '{print $1}'`
			if test "$sum1" = "$crc"; then
				test x$verb = xy && MS_Printf " CRC checksums are OK." >&2
			else
				echo "Error in checksums: $sum1 is different from $crc"
				exit 2;
			fi
		fi
		i=`expr $i + 1`
		offset=`expr $offset + $s`
    done
    echo " All good."
}

UnTAR()
{
    tar $1vf - 2>&1 || { echo Extraction failed. > /dev/tty; kill -15 $$; }
}

finish=true
xterm_loop=
nox11=y
copy=none
ownership=y
verbose=n

initargs="$@"

while true
do
    case "$1" in
    -h | --help)
	MS_Help
	exit 0
	;;
    --info)
	echo Identification: "$label"
	echo Target directory: "$targetdir"
	echo Uncompressed size: 52 KB
	echo Compression: gzip
	echo Date of packaging: Wed Aug 18 19:47:11 AMT 2010
	echo Built with Makeself version 2.1.5 on 
	echo Build command was: "/usr/bin/makeself \\
    \"--nox11\" \\
    \"qt_all_in_one_linux_installer\" \\
    \"qt_for_symbian_4.6.3_all_in_one_linux_installer_v3.sh\" \\
    \"Unofficial Qt for Symbian 4.6.3 All-In-One (GNUPOC 1.15 + Qt 4.6.3 + Qt Mobility 1.0.2 + Nokia Smart Installer 1.0) Linux Installer\" \\
    \"./install.sh\""
	if test x$script != x; then
	    echo Script run after extraction:
	    echo "    " $script $scriptargs
	fi
	if test x"" = xcopy; then
		echo "Archive will copy itself to a temporary location"
	fi
	if test x"n" = xy; then
	    echo "directory $targetdir is permanent"
	else
	    echo "$targetdir will be removed after extraction"
	fi
	exit 0
	;;
    --dumpconf)
	echo LABEL=\"$label\"
	echo SCRIPT=\"$script\"
	echo SCRIPTARGS=\"$scriptargs\"
	echo archdirname=\"qt_all_in_one_linux_installer\"
	echo KEEP=n
	echo COMPRESS=gzip
	echo filesizes=\"$filesizes\"
	echo CRCsum=\"$CRCsum\"
	echo MD5sum=\"$MD5\"
	echo OLDUSIZE=52
	echo OLDSKIP=403
	exit 0
	;;
    --lsm)
cat << EOLSM
No LSM.
EOLSM
	exit 0
	;;
    --list)
	echo Target directory: $targetdir
	offset=`head -n 402 "$0" | wc -c | tr -d " "`
	for s in $filesizes
	do
	    MS_dd "$0" $offset $s | eval "gzip -cd" | UnTAR t
	    offset=`expr $offset + $s`
	done
	exit 0
	;;
	--tar)
	offset=`head -n 402 "$0" | wc -c | tr -d " "`
	arg1="$2"
	shift 2
	for s in $filesizes
	do
	    MS_dd "$0" $offset $s | eval "gzip -cd" | tar "$arg1" - $*
	    offset=`expr $offset + $s`
	done
	exit 0
	;;
    --check)
	MS_Check "$0" y
	exit 0
	;;
    --confirm)
	verbose=y
	shift
	;;
	--noexec)
	script=""
	shift
	;;
    --keep)
	keep=y
	shift
	;;
    --target)
	keep=y
	targetdir=${2:-.}
	shift 2
	;;
    --nox11)
	nox11=y
	shift
	;;
    --nochown)
	ownership=n
	shift
	;;
    --xwin)
	finish="echo Press Return to close this window...; read junk"
	xterm_loop=1
	shift
	;;
    --phase2)
	copy=phase2
	shift
	;;
    --)
	shift
	break ;;
    -*)
	echo Unrecognized flag : "$1" >&2
	MS_Help
	exit 1
	;;
    *)
	break ;;
    esac
done

case "$copy" in
copy)
    tmpdir=$TMPROOT/makeself.$RANDOM.`date +"%y%m%d%H%M%S"`.$$
    mkdir "$tmpdir" || {
	echo "Could not create temporary directory $tmpdir" >&2
	exit 1
    }
    SCRIPT_COPY="$tmpdir/makeself"
    echo "Copying to a temporary location..." >&2
    cp "$0" "$SCRIPT_COPY"
    chmod +x "$SCRIPT_COPY"
    cd "$TMPROOT"
    exec "$SCRIPT_COPY" --phase2 -- $initargs
    ;;
phase2)
    finish="$finish ; rm -rf `dirname $0`"
    ;;
esac

if test "$nox11" = "n"; then
    if tty -s; then                 # Do we have a terminal?
	:
    else
        if test x"$DISPLAY" != x -a x"$xterm_loop" = x; then  # No, but do we have X?
            if xset q > /dev/null 2>&1; then # Check for valid DISPLAY variable
                GUESS_XTERMS="xterm rxvt dtterm eterm Eterm kvt konsole aterm"
                for a in $GUESS_XTERMS; do
                    if type $a >/dev/null 2>&1; then
                        XTERM=$a
                        break
                    fi
                done
                chmod a+x $0 || echo Please add execution rights on $0
                if test `echo "$0" | cut -c1` = "/"; then # Spawn a terminal!
                    exec $XTERM -title "$label" -e "$0" --xwin "$initargs"
                else
                    exec $XTERM -title "$label" -e "./$0" --xwin "$initargs"
                fi
            fi
        fi
    fi
fi

if test "$targetdir" = "."; then
    tmpdir="."
else
    if test "$keep" = y; then
	echo "Creating directory $targetdir" >&2
	tmpdir="$targetdir"
	dashp="-p"
    else
	tmpdir="$TMPROOT/selfgz$$$RANDOM"
	dashp=""
    fi
    mkdir $dashp $tmpdir || {
	echo 'Cannot create target directory' $tmpdir >&2
	echo 'You should try option --target OtherDirectory' >&2
	eval $finish
	exit 1
    }
fi

location="`pwd`"
if test x$SETUP_NOCHECK != x1; then
    MS_Check "$0"
fi
offset=`head -n 402 "$0" | wc -c | tr -d " "`

if test x"$verbose" = xy; then
	MS_Printf "About to extract 52 KB in $tmpdir ... Proceed ? [Y/n] "
	read yn
	if test x"$yn" = xn; then
		eval $finish; exit 1
	fi
fi

MS_Printf "Uncompressing $label"
res=3
if test "$keep" = n; then
    trap 'echo Signal caught, cleaning up >&2; cd $TMPROOT; /bin/rm -rf $tmpdir; eval $finish; exit 15' 1 2 3 15
fi

leftspace=`MS_diskspace $tmpdir`
if test $leftspace -lt 52; then
    echo
    echo "Not enough space left in "`dirname $tmpdir`" ($leftspace KB) to decompress $0 (52 KB)" >&2
    if test "$keep" = n; then
        echo "Consider setting TMPDIR to a directory with more free space."
   fi
    eval $finish; exit 1
fi

for s in $filesizes
do
    if MS_dd "$0" $offset $s | eval "gzip -cd" | ( cd "$tmpdir"; UnTAR x ) | MS_Progress; then
		if test x"$ownership" = xy; then
			(PATH=/usr/xpg4/bin:$PATH; cd "$tmpdir"; chown -R `id -u` .;  chgrp -R `id -g` .)
		fi
    else
		echo
		echo "Unable to decompress $0" >&2
		eval $finish; exit 1
    fi
    offset=`expr $offset + $s`
done
echo

cd "$tmpdir"
res=0
if test x"$script" != x; then
    if test x"$verbose" = xy; then
		MS_Printf "OK to execute: $script $scriptargs $* ? [Y/n] "
		read yn
		if test x"$yn" = x -o x"$yn" = xy -o x"$yn" = xY; then
			eval $script $scriptargs $*; res=$?;
		fi
    else
		eval $script $scriptargs $*; res=$?
    fi
    if test $res -ne 0; then
		test x"$verbose" = xy && echo "The program '$script' returned an error code ($res)" >&2
    fi
fi
if test "$keep" = n; then
    cd $TMPROOT
    /bin/rm -rf $tmpdir
fi
eval $finish; exit $res
� �plL�<mw����Z��-�5�HB���qN�MRNlC 7�SEH�ZH�$�����ߙ]	$,;�㦧牒 Z������ۮ"ɏ���W�V�o�Q+'��둢T+��Z���JY���ڣ�p-�P�	y4��{�מ�K/I���mK���d���ڀvEUk�G��C����gyl9�XfB@C"R".���?I�1JT��	g�\Ԙ�$w�S�M�e��t���MѴ�g���P�ev�#�~Uy�s+$�0�a��������;�ݼ"�j�z�ߩl��	uN�2��Gď�}����w���+d�}���I@��8nH`"9�O(	>%��E�5�a���$�cZ�m}���I��Ɓk/B���Y�(|N��WrI"e���i���}�$�:%���.0+�䮛��Os�����~J�a!�	2'�q�ͨqb9S�P���_��e�@���`�!9ܯ
\����I���-z�q�(�W�H�C�~B׵������<	 ���@aw��2�|�<�+7>�_rND7A���~1[�#�uw�0��Dϩ <&���m9'D2W�lk�NB� T`�����i ��R�����^��\�4,
ЍQI���*�Ԧz@eݟ��dx(L\�P�j�h�!��4 L�A<y����Y>B.?��t�/� Qo򓄾�>�WҽA���Ɨ���ǋs5F� ��t't-��!�f�~FӔ�AD<�e���t�L`��Q��#	�a��	B�Ƞ�
(2邜Y�L#��=Ͼ���!�m�"�|�	I^��  
��(��\b���9Smb����-�%�����k�
�$ y�1��ק��h�&�N�idS x"g>p��̀>{�"�z��S��"����-/D�;� j�Tw�/�>�׆�+�5t�Mr���:�;�ks~85ԍ9�j,B}lSae(֨�B���թE`n,�6�x���F���:k*��Z\j�IOX�1�'N�X�0ߗ�\w��
:Eњ�b�w2%[����bV��T����Z
�6JӍ���F�fK����n\O�*f�I'��y 5��	�̽4Ȓ��Z����L>F�pH�B2o��=Vy�Z	a0��z��|�:D��C}D��N.&R`�-��0Jda��o@�&Ɍ��E��fb�x�H�$�U���؄�O�G��K'���'�q���������`Yj�I�T���k��E�O!�ʴ�� �c��2%�6-:0u87�p~t�%4�,��rṬ��J���nC�|�0�^k���D�Gyl�Ib�����C�|�m,KA�S��$�Nu�B��	� �HY�+&R�Ou�[��	�9j�C�b1�0i�_�a�L��څ�k.ƞ��=`��s����-�6$�`�!�|h�d��cC!�Y�L��7�T��s[`��я�_X��^�߱�SQ5Q�S��j�V�Q�����dL:ڏT!H�C!(���xq�85���Od�&��_}������� �^������Nu�2s_+C��c�&4�0j�.\��i��tg�޵�k4��)��F�S�3A����s�}�9��i����N�(*�$�0:^Й��T)$k���Ѣ#�`����ƻ,� ���&p�����2Ԍ+O �
��k�dP?�y �5��:���i� �&������������_ż�WF#��Y�X>&`�����)V���r?�
BY$�$�D�`8s!�8s}v"�a<>������
F�h����lDIO �� �����ّ �E��3���o\�����_Bʴ�=�!>�� �B����󅇏�%����r��:��Cp�|*�cZX��F��x����ȵ&���K�%6f��:�pV��Q�w2-�g�z�FI���5k���wI�
���=�X&ǳf�"Vt{�R
Y����\a�;ɛ4|�(EG�`���~�2�o�zZ�=������j�3K�3ݗ�L��Ƿ>P��5;�<[qU��F=��7���Ԣ���ƕ�˥���~� ��H��X1]�"ֈ���X���J���
v�Qn�f+�����|���dw�浒@����5���;�m9��a��w��O���m~��m�E�6��	�/�?���6l�_�!G�Z*���\U��"�+{� �)?�������D~>��q��"��Rm*[�j�#�	ѵ.�^��|B��j�c����r��Gi�l�+��Y�|lM '"o��@{�9��\ȏ�т���~��'9�9:>�A47��&=���m3X��	Z0�^�_u����a{�k��1`�e��v�DN"#`d�^�gV�(<���es� ��l���㖺U�j��I_
V����
�3^>/����6��+,�9�G3�p�u�D�x�U��U˒V�x�&���=�B1Sdwb��k����^���|����p�P,��B���T���%�m��;�\a��<U׵����H'J���|[�1h��n6�[��V�+&�������\@5i��M���y�r��'����G���l�
.Hg�Q�
<l��z�!��p C����+��o��y��Yn����
�|�7�7�͵a�����:ۉ���"�G�Ir�*:ztw����O�4�J��/n�;�f5v���km�D19�m'qqv��>����i�C\5no��8 �� �I�(�!;��#t{�pE����/�
����U�d�{�\��ݓ��+����;/;{�!Ć����w��^k0��և%[�o�.�����J����+�p8��7:I��-�~�����{.���<���5��ܛ��4#%hf+A�w��\U�\���:���J�����	�V�K	��A���H��93\�Rk��V��u�p�Z����j�^�M�VW'��>���N�y�����r�����\1���k�2��a�A�v�"��I�Ϩ�$P��v�Q��wAd��"ψ�nS��
A��kw����Fqk�A 	0v��`�	=�P�m���`�jɎ����~gfWb�����\��Ķvgv�1���y�>|�Uz�L��h'�e4,�a�[0�)�h3KE�C��G����
��P��-���ᚰ�ά�r��R�䍫Z��5�a�}
�=Ai5�����}���_g��=��J�-S�+���w�އz�m�)j�����c!#���^���ѬE�E�2g�&'����>�L&��*շu��ZA q��B��9ο�85��.�h�|n���!����C�m�0;�0X���ʽp�1��l,�+�W���R�)i��t��j&�4�x:�1�����7ѓ���%-$�ݧI�Ã
As�z/�?�b��� ߚb(�%A]��Z�Q�7�������3'6�p<��샲vb���1o��I����l�D���U�,��+��0|�<61j�ǻ��5�F��a(�1
����"�����(���m?�~�ŕ�@�%�(>G��=چ���6y<o�`ʮ�/�=<��
�}s�ev�`�p�i4�c�_����&�n,��˼!����
�����/A��#˹�+S�Z��`�Ta W�<f���h�ҏLw>4�
3�vSR�HG:����>S���n;�.���E]_סc5��[�2�$^`K���P�@|断�
�u�V"��0r�n�����
Ų�-��t���E�YxΘ7�wX�d�8(�c�av�3@8N���Z�z�~�o+'�f�SJ7�.X7o��\���(	�z�B��L6_�bw=^�� DŞ�8^�8��G��B8��-�P�9}
(.:�bx
nE�ZY�t�z�E���H�-����+
���д'�������$d�`�;�?|)g�-���d��y-�����uF����p-�EEn��������:���:[��Tc�1�����B6g/vwc�6)���L;%�H�T��p_�Y��ߴ��1J�ZX���DK���s�z��R��q�jlm�#/�nb����z�Lz1o�Q��g���ã��G���y&é�����9e]r�T>z �N�vZ�u�@��lD@���b6�GXrV2��&��`�t����k�*?�<W�`�v�
�$/��PE�#k�{��82�^%j@� b{��I�I�Ֆ�� �Y�6_7�`�}�]�ٿ���$n�
��8V2��	�|\���F[��L�4�.S&1t|��a�|>�[ŴI��,�C9J�{}Ky��S>.�����W�S8�2�0���S��19���<,ۋ��v$��Xn�K�[<������.��]���o�K^T��ʽ�6�7u;�u��ŶC��}byl����fI��z��?T�g3F}0�јsD+�΢��T����t��:�Ŷ�ڄ��t��z�,nU��S��q�'#�I��ȊQiK����r͜s=�?N@��;C_A�a�?�:�/�����_��oF�Tx:�{���ؘ��r���=�%�x�x�do�yCu�֍��Q{�O-�Q���A��A���
(���l:[\�Wt����J�B�nȌ	�bY��W k5��y�#�֔�����'g�,�+��3�Jl�#����Ч0ZgB5��G�����T)>h��E��]�����U7��Nn'����D!�w����)���5�������V�XEE�lEٵG+h��
BD�q~R6��rҰ��Si�S��w�Hߢ����t,����-�Rw�%�5NɵUaכF9�+�^�5>