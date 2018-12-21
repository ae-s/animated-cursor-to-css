#!/bin/bash

GIFURL="$1"
GIF=$( basename "$GIFURL" )
FMT=cursor_%03d.png

if [ ! -f "$GIF" ] ; then
    wget "$GIFURL" -O "$GIF"
fi

convert -coalesce "$GIF" $FMT

FRAMES=$( ls cursor_*.png | wc -l )
INCR=$( echo 4k 100 $FRAMES / p | dc )

cat <<EOF
/* 
 * gif cursor from $GIFURL
 * dumb idea from https://css-tricks.com/forums/topic/animated-cursor/
 */
* { animation: cursor 1s infinite; }
@keyframes cursor {
EOF
for P in $( seq 0 $(( $FRAMES - 1 )) ) ; do
    echo $( echo 15k 100 $FRAMES 1- / $P \* 0k 1/ p | dc )'% { cursor: url('$( printf $FMT $P )'), auto; }'
done
echo '}'
