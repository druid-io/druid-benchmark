library(plyr)
library(ggplot2)
library(reshape2)

benchmarks = list(
  `druid`         = "druid-m3-2xlarge.tsv",
  `mysql`         = "mysql-m3-2xlarge-ssd-myisam.tsv",
  `druid-100-x1`  = "100gb-druid-m3-2xlarge-1x.tsv",
  `mysql-100`     = "100gb-mysql-m3-2xlarge-ssd-myisam.tsv",
  `druid-100-x6`  = "100gb-druid-m3-2xlarge-6x.tsv"
)

results <- NULL
for(x in names(benchmarks)) {
  filename <- file.path("results", benchmarks[[x]])
  if(file.exists(filename)) {
    r <- read.table(filename)
    names(r) <- c("query", "time")
    r$engine <- x
    results <- rbind(results, r)
  }
}

results$engine <- factor(results$engine, levels=c("druid", "mysql", "druid-100-x1", "mysql-100", "druid-100-x6"))

results$datasize <- "1GB"
results$datasize[grep("100", results$engine)] <- "100GB"

rowcounts <- NULL
for(datasource in c("tpch_lineitem_small", "tpch_lineitem")) {
  r <- read.table(file.path("results", paste(datasource, "-rowcounts.tsv", sep="")))
  names(r) <- c("query", "rows")
  
  if(grepl("small", datasource)) r$datasize <- "1GB"
  else r$datasize <- "100GB"
  
  rowcounts <- rbind(rowcounts, r)
}

results <- join(results, rowcounts, by=c("query", "datasize"))

results_summary <- ddply(results, .(engine, query, datasize), summarise, time = median(time), rps=median(rows/time), count=length(query))
results_summary$type <- "aggregation"
results_summary$type[grep("top", results_summary$query)] <- "top-n"

baseline <- subset(results_summary, engine == c("druid-100-x1"), select=c("query", "time"))
baseline <- rename(baseline, c("time" = "baseline"))
results_summary <- join(results_summary, baseline, by=c("query"))

# table-1gb
dcast(subset(results_summary, datasize == "1GB", select=c("engine", "query", "time")), query ~ engine)

# table-100gb
dcast(subset(results_summary, datasize == "100GB", select=c("engine", "query", "time")), query ~ engine)

# druid-benchmark-1gb-median
ggplot(subset(results_summary, datasize == "1GB"),
       aes(x=query, y=time, fill=engine)) + 
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(breaks=c("druid", "mysql"), labels=c("Druid", "MySQL")) +
  ylab("Time (seconds)") +
  xlab("Query") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle(label="Median query time (100 runs) — 1GB data — single node") 

# druid-benchmark-100gb-median
ggplot(subset(results_summary, datasize == "100GB" & engine != "druid-100-x6"),
       aes(x=query, y=time, fill=engine, order=engine)) + 
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(breaks=c("druid-100-x1", "mysql-100"), labels=c("Druid", "MySQL")) +
  ylab("Time (seconds)") +
  xlab("Query") +
  facet_wrap(~ type, scales="free") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle(label="Median Query Time (3+ runs) — 100GB data — single node")

# druid-benchmark-scaling
ggplot(subset(results_summary, datasize == "100GB" & !(engine %in% c("mysql", "mysql-100"))),
       aes(x=query, y=time, fill=engine, order=engine)) + 
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(breaks=c("druid-100-x1", "druid-100-x6"), labels=c("8 (1 node)", "48 (6 nodes)")) +
  ylab("Time (seconds)") +
  xlab("Query") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle(label="Druid Scaling — 100GB") +
  guides(fill=guide_legend(title="Cores"))

# druid-benchmark-scaling-factor
ggplot(subset(results_summary, datasize == "100GB" & !(engine %in% c("mysql", "mysql-100"))),
       aes(x=query, y=baseline/time, fill=engine, order=engine)) + 
  geom_bar(position="dodge", stat="identity") +
  scale_fill_discrete(breaks=c("druid-100-x1", "druid-100-x6"), labels=c("8 (1 node)", "48 (6 nodes)")) +
  scale_y_continuous(breaks=c(1:7)) +
  ylab("Speedup Factor") +
  xlab("Query") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle(label="Druid Scaling — 100GB") +
  guides(fill=guide_legend(title="Cores"))
