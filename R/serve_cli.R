#' serve_cli
#' @export
serve_cli <- function(host = "127.0.0.1", port = 5000){
  file <- fs::file_temp()
  download.file("https://raw.githubusercontent.com/benjaminguinaudeau/systemr/master/R/api.R", destfile = file,quiet = T)
  pr <- plumber::plumb(file = file)
  pr$run(host = host, port = port, swagger = F)
}

#' system_api
#' @export
system_api <- function(cmd = "", host = "localhost", port = 5000){
  req <- httr::POST(url = glue::glue("http://{host}:{port}/systemr"),  body  = cmd, encode = "json")
  rawToChar(req$content)
}

