#' serve_cli
#' @export
serve_cli <- function(host = "localhost", port = 5000){
  pr <- plumber::plumb("R/api.R")
  pr$run(host = host, port = port, swagger = F)
}


