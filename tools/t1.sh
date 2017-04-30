#! /bin/bash

v4lctl setinput Composite1
v4lctl setnorm PAL
gst-launch v4l2src ! clockoverlay ! xvimagesink
