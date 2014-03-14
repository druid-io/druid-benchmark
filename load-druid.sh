#!/bin/sh

if [ $# -lt 2 ]; then echo "Usage: $0 <indexer:port> <task.json>"; exit 2; fi
indexer=$1
task=$2

curl -H 'Content-Type:application/json' -XPOST -d@$task \
       http://$indexer/druid/indexer/v1/task
