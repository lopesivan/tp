#! /bin/bash

v4lctl setinput Composite1
v4lctl setnorm PAL
gst-launch-0.10 v4l2src ! deinterlace ! queue ! autovideosink alsasrc device=hw:2,0 ! deinterleave ! alsasink sync=false
