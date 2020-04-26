#####################
# FIB-FAFB matching #
#####################
devtools::load_all(".")
source("data-raw/hemibrain/startupHemibrain.R")

# The google sheet database:
# https://docs.google.com/spreadsheets/d/1OSlDtnR3B1LiB5cwI5x5Ql6LkZd8JOS5bBr-HTi0pOw/edit#gid=0

# load NBLAST
load("/Volumes/GoogleDrive/Shared\ drives/flyconnectome/fafbpipeline/fafb (1).fib.twigs5.crossnblast.rda")
# load("/Volumes/GoogleDrive/Shared\ drives/flyconnectome/fafbpipeline/fafb.fib.twigs5.crossnblast.rda") ## Or this one
nb.complete = t(fafb.fib.twigs5.crossnblast)
rm("fafb.fib.twigs5.crossnblast")

# Scan through matches
nopen3d()
unsaved = c()
for(n in lh.meta$bodyid){
  n = as.character(n)
  done = subset(gs, !is.na(FAFB.match))
  if(n%in%done$bodyid){
    next
  }
  clear3d()
  plot3d(FAFB14,alpha = 0.1, col ="grey")
  message(n)
  lhn = db[as.character(n)]
  # lhn  = neuprint_read_neurons(n)
  lhn = hemibrainr:::scale_neurons.neuronlist(lhn, scaling = (8/1000))
  lhn = nat.templatebrains::xform_brain(lhn, reference = "FAFB14", sample = "JRCFIB2018F")
  message(lhn[n,"type"])
  message(lhn[n,"bodyid"])
  r = sort(nb.complete[,n],decreasing = TRUE)
  plot3d(lhn[n], lwd = 2, soma = 500, col = "black")
  message("Reading the top 10 FAFB hits")
  fafb = read.neurons.catmaid(names(r)[1:10])
  sel = c("go","for","it")
  k = 1
  j = 10
  while(length(sel)>1){
    if(j>10){
      fafb = c(fafb, read.neurons.catmaid(names(r)[(k+1):j]))
    }
    sel = nlscan(fafb[names(r)[1:j]], col = "red", soma = TRUE)
    if(length(sel)>1){
      message("You selected more than one neuron, please select again ... ")
    }
    if(!length(sel)){
      prog = hemibrainr:::hemibrain_choice("You selected no neurons. Are you happy with that? ")
        if(!prog){
          prog = hemibrainr:::hemibrain_choice("Do you want to read more neurons from CATMAID? ")
          if(prog){
            k = j
            j = j + 10
          }
          sel = c("go","for","it")
        }
    }
  }
  gs[n,"FAFB.match"] = ifelse(length(sel)==0,'none',sel)
  if(length(sel)){
    plot3d(fafb[sel],col="blue",lwd=2,soma=TRUE)
    quality = hemibrainr:::must_be("What is the quality of this match? exact(e)/okay(o)/poor(p) ", answers = c("e","o","p"))
  }else{
      quality = "n"
  }
  gs[n,"FAFB.match.quality"] = quality
  unsaved = c(unsaved, n)
  message(length(unsaved), " unsaved matches")
  print(knitr::kable(gs[unsaved,c("bodyid","bodytype","FAFB.match","FAFB.match.quality")]))
  p = hemibrainr:::must_be("Continue (enter) or save (s)? ", answers = c("","s"))
  if(p=="s"){
    # Write!
    hemibrainr:::plot_inspirobot()
      write_lhns(gs=gs,
                 bodyids = unsaved,
                 column = "FAFB.match")
      write_lhns(gs=gs,
                 bodyids = unsaved,
                 column = "FAFB.match.quality")
      gs = hemibrainr:::gsheet_manipulation(FUN = googlesheets4::read_sheet,
                                            ss = selected_file,
                                            sheet = "lhns",
                                            return = TRUE)
      rownames(gs) = gs$bodyid
      unsaved = c()
      bg3d("white")
  }
}

