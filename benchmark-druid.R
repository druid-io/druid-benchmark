#! /usr/bin/env Rscript

if(!require("RDruid")) {
  cat(paste("Benchmark requires the RDruid package, please install using:",
            "install.packages(\"devtools\")",
            "devtools::install_github(\"RDruid\", \"metamx\")\n", sep="\n"))
}

args <- commandArgs(TRUE)
if(length(args) < 1) {
  cat("Usage: benchmark-druid.R <broker/compute> [datasource] [outputname] [count]\n")
  quit(status=2)
}

suppressMessages(library(RDruid))
suppressMessages(library(microbenchmark))

# benchmark nodes (compute node for 1GB, broker for 100GB data set)
host <- args[1]
url <- druid.url(host)

datasource <- "tpch_lineitem_small"
engine <- "druid-benchmark.tsv"
n <- 100

if(!is.na(args[2])) datasource <- args[2]
if(!is.na(args[3])) engine <- args[3]
if(!is.na(args[4])) n <- as.numeric(args[4])

cat(sprintf("Running benchmarks against [%s] on [%s], running each query [%d] times.\n", datasource, host, n))

i <- interval(fromISO("1992-01-01T00:00:00"), fromISO("1999-01-01T00:00:00"))

###############################################


runBenchmark <- function(absTestFileName, testFuncRegexp)
{
  sandbox <- new.env(parent=.GlobalEnv)

  if (!file.exists(absTestFileName)) {
    msgText <- paste("Test case file ", absTestFileName," not found.")
    cat(sprintf(msgText))
    return
  }

  ##  catch syntax errors in test case file
  res <- try(sys.source(absTestFileName, envir=sandbox))
  if (inherits(res, "try-error")) {
    message <- paste("Error while sourcing ",absTestFileName,":",geterrmessage())
    cat(sprintf(message))
    return
  }
  results <-list()
  testFunctions <- ls(pattern=testFuncRegexp, envir=sandbox)
  for (funcName in testFunctions) {
    cat(sprintf("Executing Test: %s Case: %s.\n",absTestFileName, funcName))
    testcase <- get(funcName, envir=sandbox)
    ## anything else than a function is ignored.
    if(mode(testcase) != "function") {
      return(invisible())
    }
    benchmarkResult <- microbenchmark(testcase(datasource), times=n)
    results <- rbind(results, benchmarkResult)
  }

  return(results)
}

resultsList <- list()
testFiles <- list.files("testcases", pattern = ".+\\.[rR]$", full.names=TRUE)
for (file in testFiles){
  case <- runBenchmark(file, ".+")
  resultsList <- rbind(resultsList, case)
}

#########

results <- as.data.frame(rbind(resultsList))
cat(sprintf("Result List %s.\n", results$time))

results$time <- results$time / 1e9
results$query <- as.character(sub("\\(.*\\)", replacement="", results$expr))
druid <- results[c("query", "time")]

filename <- paste(engine, ".tsv", sep="")
cat(sprintf("Writing results to %s.\n", filename))
write.table(druid, filename, quote=F, sep="\t", col.names=F, row.names=F)



