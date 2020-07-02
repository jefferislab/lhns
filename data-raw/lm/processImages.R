#################
# Line contents #
#################

# Load packages
library(natverse)
library(nat.jrcbrains)
library(nat.templatebrains)
library(hemibrainr)
library(catnat)
library(stringi)

# Image folder
folder = "data-raw/images/"

# EM
db = hemibrain_neurons()

# LM
most.lh = nat::union(most.lhns,most.lhins)
most.lhns.f = hemibrain_lm_lhns(brainspace = c("JRCFIB2018F"),cable = c("lhns"))
most.lhins.f = hemibrain_lm_lhns(brainspace = c("JRCFIB2018F"),cable = c("lhins"))
most.lines.f = hemibrain_lm_lhns(cable = "lines", brainspace = c("JRCFIB2018F"))
lms = nat::union(most.lhns.f,most.lhins.f)
lms = nat::union(lms,most.lines.f)

# Hemibrain matches
matches = hemibrain_matches()
lm.matches =lm_matches()

# Set colours
reds = grDevices::colorRampPalette(colors = c(hemibrainr::hemibrain_bright_colors["cerise"],"grey10"))
blues = grDevices::colorRampPalette(colors = c(hemibrainr::hemibrain_bright_colors["marine"],"grey10"))
greens = grDevices::colorRampPalette(colors = c(hemibrainr::hemibrain_bright_colors["green"],"grey10"))
oranges = grDevices::colorRampPalette(colors = c(hemibrainr::hemibrain_bright_colors["orange"],"grey10"))
purples = grDevices::colorRampPalette(colors = c(hemibrainr::hemibrain_bright_colors["purple"],"grey10"))
yellows = grDevices::colorRampPalette(colors = c(hemibrainr::hemibrain_bright_colors["yellow"],"grey10"))

# Cell counts
cells = data.frame()
for(lc in linecodes){
  nocs = lh_line_info[lc,"no.cells"]
  if(nocs==""|is.null(nocs)|is.na(nocs)){
    next
  }
  types = lh_line_info[lc,"cell.type"]
  if(types==""|is.null(types)|is.na(types)){
    next
  }
  cts = unlist(strsplit(types, split = "/"))
  search = paste(paste0(cts,".*"),collapse="|")
  bis = neuprint_search(search,field="type", all_segments = TRUE)
  if(is.null(bis)){
    next
  }
  count = nrow(bis)
  cdf = data.frame(linecode = lc,
                   cell.types = types,
                   light.count = nocs,
                   EM.count = count)
  cells = rbind(cells,cdf)
}


# View
nat::nopen3d(userMatrix = structure(c(0.983344256877899, -0.0629246532917023,
                                      -0.170512795448303, 0, 0.180973306298256, 0.25219514966011, 0.950602948665619,
                                      0, -0.0168138425797224, -0.965628147125244, 0.259382396936417,
                                      0, 63.5698204040527, -15.4188394546509, 5.44496870040894, 1), .Dim = c(4L,
                                                                                                             4L)), zoom = 0.530321657657623, windowRect = c(24L, 47L, 1202L,
                                                                                                                                                            877L))

# For line in lh.mcfo, plot
# L1000 27C
issues = c()
linecodes = sort(unique(lh_line_info$linecode))
for(lc in linecodes){
  message(lc)

  # Cell types
  cts  = unique(unlist(strsplit(lh_line_info[lc,"cell.type"],split="/")))
  cts = cts[!is.na(cts)&cts!=""&cts!="notLHproper"]
  search = paste(paste0(cts,".*"),collapse="|")

  # Skip if needs
  if(!length(cts)){
    next
  }else{
    message(lh_line_info[lc,"cell.type"])
  }

  # Plot MCFO
  mcfo = names(subset(lh.mcfo,linecode == lc & InLine == TRUE))

  # Plot cloud
  splits = names(subset(lh.splits.dps, linecode == lc | cell.type %in% cts))

  # PLot hemibrain
  lights = unique(c(mcfo,splits))
  bis = unique(lm.matches[lights,"match"])
  bis = bis[bis!="none"]
  if(!length(bis)){
    bis = subset(hemibrain_lhns, grepl(search,cell.type))$bodyid
  }
  if(!length(bis)){
    bis = neuprint_search(search,field="type", all_segments = TRUE)
  }
  if(!length(bis)){
    next
  }
  hemibrain = nat::as.neuronlist(tryCatch(neuprint_read_skeletons(bis, OmitFailures = TRUE), error =  function(e) NULL))
  hemibrain = tryCatch(hemibrainr:::scale_neurons.neuronlist(hemibrain, scaling = (8/1000), OmitFailures = TRUE), error =  function(e) NULL)

  # Plot FAFB
  skids = matches[as.character(bis),"match"]
  skids = skids[!is.na(skids)]
  if(!length(skids)){
    issues = c(issues, bis)
  }
  fafb = tryCatch(catmaid::read.neurons.catmaid(skids, OmitFailures = TRUE), error = function(e) NULL)
  fafb = tryCatch( suppressWarnings(nat.templatebrains::xform_brain(fafb, sample = "FAFB14", reference = "JRCFIB2018F", OmitFailures = TRUE)), error = function(e) NULL)

  # Plot other LM skeletons
  fc = names(subset(most.lh, grepl(search,cell.type) & skeleton.type == "FlyCircuit"))
  df = names(subset(most.lh, grepl(search,cell.type) & skeleton.type == "DyeFill"))
  jj = names(subset(jfw.lhns, grepl(search,cell.type)))
  fc = lms[names(lms) %in%fc]
  df = lms[names(lms) %in%df]
  jj = lms[names(lms) %in%jj]
  splits = lms[splits]
  mcfo = lms[names(lms) %in% mcfo]

  # Stage picture
  clear3d()
  rgl::plot3d(hemibrain_microns.surf, col="grey10", alpha = 0.0)

  # Plot hemibrain neurons
  if(length(hemibrain)){
    col1 = oranges(length(hemibrain)+4)[1:length(hemibrain)]
    rgl::plot3d(hemibrain,lwd=3,col=col1, soma = FALSE)
  }
  # Plot mcfo
  if(length(mcfo)){
    col2 = greens(length(mcfo)+4)[1:length(mcfo)]
    rgl::plot3d(mcfo,lwd=3,col=col2, soma = FALSE)
  }
  # Take just hemibrain and MCFO
  rgl.snapshot(file=paste0(folder,"hemibrainMCFO_",lc,"_",paste(cts,collapse="_"),".png"))
  # Plot dye fills
  if(length(fc)){
    col2 = reds(length(fc)+4)[1:length(fc)]
    rgl::plot3d(fc,lwd=3,col=col2, soma = FALSE)
  }
  # Plot dye fills
  if(length(df)){
    col2 = purples(length(df)+4)[1:length(df)]
    rgl::plot3d(df,lwd=3,col=col2, soma = FALSE)
  }
  # Plot jj
  if(length(jj)){
    col2 = yellows(length(jj)+4)[1:length(jj)]
    rgl::plot3d(jj,lwd=3,col=col2, soma = FALSE)
  }
  # Plot splits
  # if(!length(mcfo)){
  #   if(length(splits)){
  #     rgl::points3d(nat::xyzmatrix(splits),lwd=3,col=hemibrainr::hemibrain_bright_colors["green"])
  #   }
  # }
  # Plot FAFB
  if(length(fafb)){
    col3 = blues(length(fafb)+4)[1:length(fafb)]
    rgl::plot3d(fafb,lwd=3,col=col3, soma = FALSE)
  }
  # Take picture
  rgl.snapshot(file=paste0(folder,lc,"_",paste(cts,collapse="_"),".png"))

}
