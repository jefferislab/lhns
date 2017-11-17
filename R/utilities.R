#' See a FlyCircuit neuron on the FlyCircuit website
#'
#' @description See chosen FLyCircuit neuron on the FlyCircuit website, where maximal projection .lsm images are available.
#' @param fc_id A flycirucit neuron ID, either the neuron ID or the gene name ID
#' @param max Maximum number of webpages to open
#' @source \url{http://www.flycircuit.tw/}
#' @export
#' @importFrom utils
see_fc <- function (fc_id, max = 10){
  if(length(fc_id)>10){
    stop("Too many FlyCircuit IDs!!!")
  }
  for(f in 1:length(fc_id)){
    f= flycircuit::fc_neuron(fc_id)
    url = paste0("http://flycircuit.tw/modules.php?name=clearpage&op=detail_table&neuron=",f)
    utils::browseURL(url)
  }
}
