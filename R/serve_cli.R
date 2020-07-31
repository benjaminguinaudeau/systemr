#' serve_cli
#' @export
serve_cli <- function(host = "0.0.0.0", port = 5000){
  # file <- fs::file_temp()
  # download.file("https://raw.githubusercontent.com/benjaminguinaudeau/systemr/master/R/api.R", destfile = file,quiet = T)
  file <- here::here("R/api.R")
  pr <- plumber::plumb(file = file)
  pr$run(host = host, port = port, swagger = F)
}

#' system_api
#' @export
system_api <- function(cmd = "", host = "localhost", port = 5000, verbose = F){
  endpoint <- ifelse(verbose, "sytemr_verbose", "systemr")
  req <- httr::POST(url = glue::glue("http://{host}:{port}/{endpoint}"),  body  = cmd, encode = "json")
  rawToChar(req$content)
}

#' connect_api
#' @export
connect_api <- function(country = "us", index = 0, host = "localhost", port = 5000){

  req <- httr::POST(url = glue::glue("http://{host}:{port}/vpn"),  body  = list(country = country, index = index), encode = "json")
  rawToChar(req$content)
}

#' ip_api
#' @export
ip_api <- function(host = "localhost", port = 5000){
  req <- httr::POST(url = glue::glue("http://{host}:{port}/ip"),  body  = list(), encode = "json")
  rawToChar(req$content)
}

#' connect
#' @export
connect <- function(country = "us", index = 0){
  system("ip rule add fwmark 65 table novpn")
  system("ip route add default via 192.168.1.1 dev eth0 table novpn")
  system("ip route flush cache")
  system("iptables -t mangle -A OUTPUT -p tcp --sport 5000 -j MARK --set-mark 65")


  files <-  stringr::str_subset(dir("/etc/openvpn", pattern  = glue::glue("^{country}"), full.names = T),"\\.tcp")
  if(index != 0){
    file <- stringr::str_subset(files, paste0(country, index, "\\."))
  } else {
    file <- sample(files, 1)
  }

  if(!fs::file_exists(file)){
    message("Index not existent, using a random config")
    file <- sample(files, 1)
    message(file)
  }

  system(glue::glue('echo "auth-user-pass auth.txt" >> {file}'))
  system(glue::glue("openvpn {file} &"))
}

