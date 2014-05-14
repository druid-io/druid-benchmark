count_star_interval <- function(datasource) {
  druid.query.timeseries(
    url = url,
    dataSource   = datasource,
    intervals    = interval(ymd(19920103),ymd(19981130)),
    aggregations = list(druid.count()),
    granularity = granularity("all"),
    context=list(useCache=F, populateCache=F)
  )
}
