#!/usr/bin/python

from optparse import OptionParser

parser = OptionParser()
parser.add_option("-o", "--output-file", dest="outputSql",
                  help="write sqls to FILE", metavar="FILE")
parser.add_option("-s", "--size", dest="sizeInGB",
                  help="total SIZE (in GB) of segments.", metavar="SIZE")
parser.add_option("-t", "--table-name", dest="tableName", default="`druid`.`benchmark_segments`",
                  help="druid segments table NAME", metavar="NAME")


(options, args) = parser.parse_args()

if options.outputSql is None:
    parser.error('Output Filename not given')

if options.sizeInGB is None:
    parser.error('total segment size not given')

limit = int(options.sizeInGB) * 1000 * 1000 * 1000
sum=0
with open('sqls/tpch_segments.sql', 'r') as inFile:
  with open(options.outputSql, 'w') as outFile:
    for insert in inFile:
      s = insert.find("\\\"size\\\"") + 9
      e = insert.find(",",s)
      size = int(insert[s:e])
      if (sum < limit):
        sum+=size
        outFile.write(insert.replace("TABLENAME", options.tableName))

outFile.close()
print "Added segments for total size of " ,sum, " bytes to ", options.outputSql


