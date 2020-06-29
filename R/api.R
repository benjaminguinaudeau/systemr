#' @post /systemr
#' @serializer unboxedJSON
function(req){
  cmd <- req$postBody
  out <- system(cmd, intern = T)
  return(out)
}

#' @post /sytemr_verbose
#' @serializer unboxedJSON
function(req){
  cmd <- req$postBody
  print(glue::glue("[{Sys.time()} ] {cmd}"))
  out <- system(cmd, intern = T)
  return(out)
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
