#' @post /systemr
#' @serializer unboxedJSON
function(req){
  cmd <- req$postBody
  out <- system(cmd, intern = T)
  return(out)
}

#' @post /ip
#' @serializer unboxedJSON
function(req){
  ip <- system("dig +short myip.opendns.com @resolver1.opendns.com", intern = T)
  return(ip)
}

#' @post /vpn
#' @serializer unboxedJSON
function(req){
  cmd <- jsonlite::fromJSON(req$postBody)

  file <- systemr::connect(cmd$country, cmd$index)

  return(file)
}

#' @post /sytemr_verbose
#' @serializer unboxedJSON
function(req){
  cmd <- req$postBody
  print(glue::glue("[{Sys.time()} ] {cmd}"))

  out <- system(cmd, intern = T)
  return(out)
}

#' @post /kill_vpn
#' @serializer unboxedJSON
function(req){
  system("killall openvpn")
  return()
}

#' @post /get
#' @serializer unboxedJSON
function(req){
  res <- jsonlite::fromJSON(req$postBody)

  head_names <- names(res[[2]])
  res[[2]] <- as.character(res[[2]])
  names(res[[2]]) <- head_names

  out <- httr::GET(res$url, httr::add_headers(.headers = res[[2]]))

  return(jsonlite::fromJSON(rawToChar(out$content)))
}
