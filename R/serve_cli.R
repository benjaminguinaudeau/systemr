#' serve_cli
#' @export
serve_cli <- function(host = "localhost", port = 5000){
  pr <- plumber::plumb("https://github.com/benjaminguinaudeau/systemr/blob/master/R/api.R")
  pr$run(host = host, port = port, swagger = F)
}

#' system_api
#' @export
system_api <- function(cmd = "", host = "localhost", port = 5000){
  req <- httr::POST(url = glue::glue("http://{host}:{port}/systemr"),  body  = cmd, encode = "json")
  rawToChar(req$content)
}

