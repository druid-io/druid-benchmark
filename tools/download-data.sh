#!/bin/sh

if [ $# -lt 1 ]; then echo "Usage: $0 <output_dir>"; exit 2; fi
data=$1

mkdir -p $data
pushd .
cd $data

# 1GB data set
curl -O http://static.druid.io/data/benchmarks/tpch/1/lineitem.tbl.gz

# 100GB data set
for i in $(seq 1 100) ; do curl -O http://static.druid.io/data/benchmarks/tpch/100/lineitem.tbl.$i.gz ; done

popd
