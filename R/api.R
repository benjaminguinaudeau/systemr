#' @post /systemr
#' @serializer unboxedJSON
function(req){
  cmd <- req$postBody
  out <- system(cmd, intern = T)
  return(out)
}
