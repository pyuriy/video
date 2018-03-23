#!/bin/bash

SRC0=$1
SRC=in-$1
DST=out-$1

ffmpeg -i $SRC0 -i NTDLogo2015-HD.png -filter_complex "[0:v][1:v] overlay=0:0" -pix_fmt yuv420p -c:a copy $SRC

# mp=eq2= The old order was gamma:contrast:brightness:saturation:rg:gg:bg:weight
# The new contrast:brightness:saturation:gamma:gamma_red:gamma_green:gamma_blue:gamma_weighted:eval
#https://ffmpeg.org/ffmpeg-filters.html#eq

ffmpeg -y -i $SRC -c:v libx264 -b:v 1000k -pix_fmt +yuv420p -profile:v high -level 3.0 \
        -vf "yadif=0:-1:1, crop=min(iw\,ih/sar*1.7778):min(ih\,iw*sar/1.7778), \
        scale=853:480, eq=1:0:1:0.95:1:0.95:1, unsharp=5:5:1:3:3:1" -sws_flags lanczos -aspect 1.7778 \
        -pass 1 -an -f null - &&
ffmpeg -y -i $SRC -c:v libx264 -b:v 1000k -pix_fmt +yuv420p -profile:v high -level 3.0 \
        -vf "yadif=0:-1:1, crop=min(iw\,ih/sar*1.7778):min(ih\,iw*sar/1.7778), \
        scale=853:480, eq=1:0:1:0.95:1:0.95:1, unsharp=5:5:1:3:3:1" -sws_flags lanczos -aspect 1.7778 \
        -pass 2 -c:a aac -b:a 128k -ar 44100 -ac 2 $DST

./MP4box -inter 500 $DST
