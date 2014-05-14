
top_100_parts <- function(datasource) {
  druid.query.topN(
    url = url,
    dataSource   = datasource,
    intervals    = i,
    metric = "l_quantity",
    dimension = "l_partkey",
    n=100,
    aggregations = list(
      sum(metric("l_quantity"))
    ),
    filter = NULL,
    granularity = granularity("all"),
    context=list(useCache=F, populateCache=F)
  )
}

top_100_parts_details <- function(datasource) {
  druid.query.topN(
    url = url,
    dataSource   = datasource,
    intervals    = i,
    metric = "l_quantity",
    dimension = "l_partkey",
    n=100,
    aggregations = list(
      sum(metric("l_quantity")),
      sum(metric("l_extendedprice")),
      min(metric("l_discount")),
      max(metric("l_discount"))
    ),
    filter = NULL,
    granularity = granularity("all"),
    context=list(useCache=F, populateCache=F)
  )
}


top_100_parts_filter <- function(datasource) {
  druid.query.topN(
    url = url,
    dataSource   = datasource,
    intervals    = interval(ymd(19960115), ymd(19980315)),
    metric = "l_quantity",
    dimension = "l_partkey",
    n=100,
    aggregations = list(
      sum(metric("l_quantity")),
      sum(metric("l_extendedprice")),
      min(metric("l_discount")),
      max(metric("l_discount"))
    ),
    granularity = granularity("all"),
    context=list(useCache=F, populateCache=F)
  )
}

top_100_commitdate <- function(datasource) {
  druid.query.topN(
    url = url,
    dataSource   = datasource,
    intervals    = i,
    metric = "l_quantity",
    dimension = "l_commitdate",
    n=100,
    aggregations = list(
      sum(metric("l_quantity"))
    ),
    filter = NULL,
    granularity = granularity("all"),
    context=list(useCache=F, populateCache=F)
  )
}
