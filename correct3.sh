#!/bin/bash
# Convert Video from H.265 to H.264 

SRC=$1
DST=out-$1

# Converting from from hevc to h264
# https://ffmpeg.org/pipermail/ffmpeg-user/2016-March/031385.html

ffmpeg -y -i $SRC -map 0 -c:a copy -c:s copy -c:v libx264 $DST

./MP4Box -inter 500 $DST
