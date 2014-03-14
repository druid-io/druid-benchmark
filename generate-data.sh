#!/bin/bash

if [ $# -lt 1 ]; then echo "Usage: $0 <output_dir> [scale]"; exit 2; fi
out=$1
mkdir -p $out

scale=100
chunks=100
if [ -n "$2" ] ; then
  scale=$2
  chunks=$2
fi

for i in $(seq 1 $chunks) ; do
  fifo=lineitem.tbl.$i
  rm -f $fifo
  mkfifo $fifo
  gzip -c < $fifo > $out/$fifo.gz &
  echo "Generating chunk $i"
  ./dbgen -f -TL -C$chunks -s$scale -S$i
done

