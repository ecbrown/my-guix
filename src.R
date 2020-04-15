library(RestRserve)

options(repos=structure(c(CRAN="https://cloud.r-project.org/")))
cran <- getOption("repos")
#cran["dmlc"] <- "https://s3-us-west-2.amazonaws.com/apache-mxnet/R/CRAN/"
#options(repos = cran)
##install.packages("mxnet",dependencies = T)
#install.packages("https://s3.ca-central-1.amazonaws.com/jeremiedb/share/mxnet/CPU/3.6/mxnet.zip", repos = NULL)
#library(mxnet)
#require(devtools)
#devtools::install_github('rstudio/keras')
#
#require(keras)
#install_keras()
#
install.packages('h2o', dependencies=TRUE)

require(h2o)
h2o.init()


set.seed(0)
x = rnorm(100)
y = x + rnorm(100)
model = lm(y ~ x)
rm(x, y)

get_handler = function(request, response) {
  x = as.numeric(request$parameters_query[['x']])
  if (!is.numeric(x) || length(x) != 1L) {
    raise(HTTPError$bad_request())
  }
  response$body = paste('{ "value": ', predict(model, list(x = x)), ' }', sep='')
}

post_handler = function(request, response) {
  rq_cnt = request$content_type
  rq_body = request$body
  is_json = any(grepl('application/json', rq_cnt))
  if (length(rq_body) == 0L || !is_json) {

    raise(HTTPError$bad_request())
  }
  x = fromJSON(rawToChar(rq_body))
  if (!is.list(x)) {
    x = as.list(x)
  }
  if (!identical(names(x), 'x') || !is.numeric(x[['x']])) {
    raise(err$bad_request())
  }
  response$body = paste('{ value: ', predict(model, x), ' }', sep='')
}


app = Application$new(
  content_type = 'application/json'
)


app$add_get(
  path = '/predict',
  FUN = get_handler
)

app$add_post(
  path = '/predict',
  FUN = post_handler
)

backend = BackendRserve$new()

backend$start(app, http_port = 8080)

