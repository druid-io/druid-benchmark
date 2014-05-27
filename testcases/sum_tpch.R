
sum_price <- function(datasource) {
  druid.query.timeseries(
    url = url,
    dataSource   = datasource,
    intervals    = i,
    aggregations = list(
      sum(metric("l_extendedprice"))
    ),
    granularity = granularity("all"),
    context=list(useCache=F, populateCache=F)
  )
}

sum_all <- function(datasource) {
  druid.query.timeseries(
    url = url,
    dataSource   = datasource,
    intervals    = i,
    aggregations = list(
      sum(metric("l_extendedprice")),
      sum(metric("l_discount")),
      sum(metric("l_quantity")),
      sum(metric("l_tax"))
    ),
    filter = NULL,
    granularity = granularity("all"),
    context=list(useCache=F, populateCache=F)
  )
}

sum_all_year <- function(datasource) {
  druid.query.timeseries(
    url = url,
    dataSource   = datasource,
    intervals    = i,
    aggregations = list(
      sum(metric("l_extendedprice")),
      sum(metric("l_discount")),
      sum(metric("l_quantity")),
      sum(metric("l_tax"))
    ),
    filter = NULL,
    granularity = granularity("P1Y"),
    context=list(useCache=F, populateCache=F)
  )
}


sum_all_filter <- function(datasource) {
  druid.query.timeseries(
    url = url,
    dataSource   = datasource,
    intervals    = i,
    aggregations = list(
      sum(metric("l_extendedprice")),
      sum(metric("l_discount")),
      sum(metric("l_quantity")),
      sum(metric("l_tax"))
    ),
    filter = dimension("l_shipmode") %~% ".*AIR.*",
    granularity = granularity("all"),
    context=list(useCache=F, populateCache=F)
  )
}
