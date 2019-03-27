#' See a FlyCircuit neuron on the FlyCircuit website
#'
#' @description See chosen FlyCircuit neuron on the FlyCircuit website, where maximal projection .lsm images are available.
#' @param fc_id A FlyCircuit neuron ID, either the neuron ID or the gene name ID
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
  df=data.frame(pnt=res[,2], anatomy.group=paste0(res[,2], res[,3]), cell.type=res[,1],stringsAsFactors = F)
  isna=is.na(res[,2]) | is.na(res[,3])
  df[['anatomy.group']][isna]=NA
  df
}

#' Download neuronal skeletons and associated meta-data
#'
#' @description Download neuronal morphologies as SWC files, compressed into a .zip file along with a CSV for their meta-data
#' @param nl the neuronlist to download
#' @param dir directory to which to download data
#' @param format unique abbreviation of one of the registered file formats for neurons including 'swc', 'hxlineset', 'hxskel'
#' @param subdir string naming field in neuron that specifies a subdirectory OR expression to evaluate in the context of neuronlist's df attribute
#' @param INDICES character vector or expression specifying output filenames. See examples and nat::write.neuron for details
#' @param files character vector or expression specifying output filenames. See examples and nat::write.neuron for details
#' @param Force whether to overwrite an existing file
#' @param ... additional arguments passed to nat::write.neuron
#' @export
#' @importFrom utils zip
downloadskeletons <- function (nl, dir, format = "swc", subdir = NULL, INDICES = names(nl), files = NULL, Force = FALSE, ...){
  if (grepl("\\.zip", dir)) {
    zip_file = dir
    if (file.exists(zip_file)) {
      if (!Force)
        stop("Zip file: ", zip_file, "already exists")
      unlink(zip_file)
    }
    zip_dir = tools::file_path_as_absolute(dirname(zip_file))
    zip_file = file.path(zip_dir, basename(zip_file))
    dir <- file.path(tempfile("user_neurons"))
  } else {
    zip_file = NULL
  }
  if (!file.exists(dir)){
    dir.create(dir)
  }
  df = attr(nl, "df")
  ee = substitute(subdir)
  subdirs = NULL
  if (!is.null(ee) && !is.character(ee)) {
    if (!is.null(df))
      df = df[INDICES, ]
    subdirs = file.path(dir, eval(ee, df, parent.frame()))
    names(subdirs) = INDICES
  }
  ff = substitute(files)
  if (!is.null(ff)) {
    if (!is.character(ff))
      files = eval(ff, df, parent.frame())
    if (is.null(names(files)))
      names(files) = INDICES
  }
  written = structure(rep("", length(INDICES)+1), .Names = c(INDICES,"metadata"))
  for (nn in INDICES) {
    n = nl[[nn]]
    thisdir = dir
    if (is.null(subdirs)) {
      if (!is.null(subdir)) {
        propval = n[[subdir]]
        if (!is.null(propval))
          thisdir = file.path(dir, propval)
      }
    }
    else {
      thisdir = subdirs[nn]
    }
    if (!file.exists(thisdir))
      dir.create(thisdir, recursive = TRUE)
    written[nn] = write.neuron(n, dir = thisdir, file = files[nn],
                               format = format, Force = Force)
  }
  # Save metadata
  utils::write.csv(df,file = paste0(dir,"/neurons_metadata.csv"),row.names = FALSE)
  written["metadata"] = paste0(dir,"_metadata.csv")
  if (!is.null(zip_file)) {
    owd = setwd(dir)
    on.exit(setwd(owd))
    zip(zip_file, files = dir(dir, recursive = TRUE))
    unlink(dir, recursive = TRUE)
    written <- zip_file
  }
  invisible(written)
}

#' Download all the LH neuronal skeletons in this package
#'
#' @description Download all the neurons in the LH library as SWC files, compressed into a .zip
#' @param dir path to directory into which to download the LH library
#' @param ... additional arguments passed to nat::write.neuron
#' @export
download_mophologies <- function(dir = paste0(getwd(),"/"),...){
  file = paste0(dir,"LH_library.zip")
  most.lhins.pnt  = most.lhins
  most.lhins.pnt[,"pnt"] = most.lhins[,"tract"]
  neurons = c(most.lhns,emlhns,most.lhins.pnt)
  attr(neurons,"df") = neurons[,c("cell.type", "anatomy.group", "pnt", "tract","type", "skeleton.type", "coreLH", "id")]
  neurons[,"skeleton.type_pnt"] = paste0(neurons[,"skeleton.type"],"_",neurons[,"pnt"])
  downloadskeletons(neurons,dir = file,subdir = skeleton.type_pnt,format="swc",files = paste0(cell.type,"_",id),Force = TRUE, ...)
}




