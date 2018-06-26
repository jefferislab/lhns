#' See a FlyCircuit neuron on the FlyCircuit website
#'
#' @description See chosen FLyCircuit neuron on the FlyCircuit website, where maximal projection .lsm images are available.
#' @param fc_id A flycirucit neuron ID, either the neuron ID or the gene name ID
#' @param max Maximum number of webpages to open
#' @source \url{http://www.flycircuit.tw/}
#' @export
#' @importFrom utils browseURL
#' @importFrom flycircuit fc_neuron
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

#' Capitalise cell type names
#'
#' @description Capitalise the first two letters of the cell type names
#' @param x Cell type names
#' @param inverse If TRUE, makes the first two letters lowercase
#' @export
capitalise_cell_type_name  <- function(x, inverse = FALSE){
  f <- function(y,inverse){
    if(is.na(y)){return(NA)}
    if(y!="notLHproper"){
      y = unlist(strsplit(y,split=""))
      if(inverse){
        y[1:2] = tolower(y[1:2])
      }else{
        y[1:2] = toupper(y[1:2])
      }
    paste(y,collapse="")
    }else{
      "notLHproper"
    }
  }
  sapply(x,f,inverse=inverse)
}

#' Get primary neurite tract name and anatomy group from cell types
#'
#' @description Get primary neurite tract name and anatomy group from cell types
#' @param x Cell type names
#' @export
process_lhn_name <- function(x) {
  res=stringr::str_match(x, "([AP][DV][1-9][0-9]{0,1})([a-z])([1-9][0-9]{0,2})")
  data.frame(pnt=res[,2], anatomy.group=paste0(res[,2], res[,3]), cell.type=res[,1],stringsAsFactors = F)
}
