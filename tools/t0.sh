#! /bin/bash

vlc http://187.48.247.69:8080/stream.mpg
exit 0

#vlc v4l2:// :v4l2-standard=0 :dvdnav-caching=300 --sout '#transcode{vcodec=theo,vb=800,scale=1,acodec=vorb,ab=128,channels=2,samplerate=44100}:duplicate{dst=std{access=http,mux=ogg,dst=0.0.0.0:8085},dst=display}'

vlc -vvv  v4l2:// :v4l2-standard=0 :dvdnav-caching=300 --sout '#standard{access=http,mux=ogg,url=187.48.247.69:8085}'
#vlc v4l2:// :v4l2-standard=0 :dvdnav-caching=300 --sout '#standard{access=http,mux=ts,url=187.48.247.69:8085}'

vlc v4l2://  --sout '#transcode{vcodec=mp4v,acodec=mpga,vb=800,ab=128}: standard{access=http,mux=ogg,url=187.48.247.69:8080}'

