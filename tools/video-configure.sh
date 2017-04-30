#! /bin/bash
[ "$1" = '-d' ] && { ECHO=echo; shift; }
LAUNCH=gst-launch

#[ "$ECHO" ] || {
[ "$1" ] &&  {
echo configure video input ...

# show list ...
#v4lctl list

v4lctl -c /dev/video0 setinput Composite1
#v4lctl -c /dev/video0 setinput S-Video
v4lctl show input
v4lctl -c /dev/video0 setnorm PAL-M
v4lctl show norm
v4lctl -c /dev/video0 setattr 'mute' off
v4lctl show mute
v4lctl -c /dev/video0 setattr 'volume' 20
v4lctl show volume

}

[ "$ECHO" ] && {
cat << EOF
$ vgrabbj -s /dev/video0
vgrabbj, Version 0.9.6
Videodevice name: /dev/video0 (Pinnacle Dazzle DVC 90/100/101/)
Capabilities
Type     : 1    Values can be looked up at videodev.h
Channels : 2
Audio    : 0
MaxWidth : 720
MaxHeight: 480
MinWidth : 48
MinHeigth: 32

Current Settings:
Brightness: 32896
Hue       : 32896
Color     : 33026
Contrast  : 33026
Whiteness : 0
Depth     : 16
Palette   : YUYV (8)
Width     : 720
Height    : 480
Chromakey : 0

#
# A simple RTP server
#  sends the output of v4l2src as h264 encoded RTP on port 5000, RTCP is sent on
#  port 5001. The destination is 127.0.0.1.
#  the video receiver RTCP reports are received on port 5005
#  sends the output of autoaudiosrc as alaw encoded RTP on port 5002, RTCP is sent on
#  port 5003. The destination is 127.0.0.1.
#  the receiver RTCP reports are received on port 5007
#
# .-------.    .-------.    .-------.      .----------.     .-------.
# |v4lssrc|    |h264enc|    |h264pay|      | rtpbin   |     |udpsink|  RTP
# |      src->sink    src->sink    src->send_rtp send_rtp->sink     | port=5000
# '-------'    '-------'    '-------'      |          |     '-------'
#                                          |          |
#                                          |          |     .-------.
#                                          |          |     |udpsink|  RTCP
#                                          |    send_rtcp->sink     | port=5001
#                           .-------.      |          |     '-------' sync=false
#                RTCP       |udpsrc |      |          |               async=false
#              port=5005    |     src->recv_rtcp      |
#                           '-------'      |          |
#                                          |          |
# .-------.    .-------.    .-------.      |          |     .-------.
# |autoaudiosrc|    |alawenc|    |pcmapay|      | rtpbin   |     |udpsink|  RTP
# |      src->sink    src->sink    src->send_rtp send_rtp->sink     | port=5002
# '-------'    '-------'    '-------'      |          |     '-------'
#                                          |          |
#                                          |          |     .-------.
#                                          |          |     |udpsink|  RTCP
#                                          |    send_rtcp->sink     | port=5003
#                           .-------.      |          |     '-------' sync=false
#                RTCP       |udpsrc |      |          |               async=false
#              port=5007    |     src->recv_rtcp      |
#                           '-------'      '----------'
#
# ideally we should transport the properties on the RTP udpsink pads to the
# receiver in order to transmit the SPS and PPS earlier.
EOF
}

# change this to send the RTP data and RTCP to another host
DEST=187.67.32.168
DEST=127.0.0.1

# tuning parameters to make the sender send the streams out of sync. Can be used
# ot test the client RTCP synchronisation.
#VOFFSET=900000000
VOFFSET=0
AOFFSET=0

# H264 encode from the source
  VELEM="videotestsrc is-live=1"
  VELEM="v4l2src"
  VCAPS="video/x-raw-yuv,width=720,height=480,framerate=15/1"
  VCAPS="video/x-raw-yuv"
_CLOCK_="clockoverlay halign=left valign=top time-format=\"%Y/%m/%d %H:%M:%S\""
   TIME="timeoverlay halign=right valign=top ! $_CLOCK_"
   TEXT="textoverlay text='LivecamMobile'"

VSOURCE="$VELEM ! $VCAPS ! queue ! videorate ! ffmpegcolorspace ! $TIME ! $TEXT"

# select x264/jpeg/mpeg
VENC="jpegenc  ! rtpjpegpay"
VENC="mpeg2enc ! rtpmpadepay"
VENC="x264enc byte-stream=true bitrate=300 ! rtph264pay"

 VRTPSINK="udpsink port=5000 host=$DEST ts-offset=$VOFFSET name=vrtpsink"
VRTCPSINK="udpsink port=5001 host=$DEST sync=false async=false name=vrtcpsink"
 VRTCPSRC="udpsrc port=5005 name=vrtpsrc"

# PCMA encode from the source
#AELEM="autoaudiosrc"
  AELEM="audiotestsrc is-live=1"
ASOURCE="$AELEM ! queue ! audioresample ! audioconvert"
   AENC="alawenc ! rtppcmapay"

 ARTPSINK="udpsink port=5002 host=$DEST ts-offset=$AOFFSET name=artpsink"
ARTCPSINK="udpsink port=5003 host=$DEST sync=false async=false name=artcpsink"
 ARTCPSRC="udpsrc  port=5007 name=artpsrc"

[ "$1" ] && { DEBUG="-v --gst-debug-level=$1"; }

$ECHO $LAUNCH -v $DEBUG gstrtpbin name=rtpbin \
	$VSOURCE ! $VENC ! rtpbin.send_rtp_sink_0  \
		rtpbin.send_rtp_src_0 ! $VRTPSINK      \
		rtpbin.send_rtcp_src_0 ! $VRTCPSINK    \
	$VRTCPSRC ! rtpbin.recv_rtcp_sink_0        \
	$ASOURCE ! $AENC ! rtpbin.send_rtp_sink_1  \
		rtpbin.send_rtp_src_1 ! $ARTPSINK      \
		rtpbin.send_rtcp_src_1 ! $ARTCPSINK    \
	$ARTCPSRC ! rtpbin.recv_rtcp_sink_1

exit 0
