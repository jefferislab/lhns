### This script is for checking assigned LHN cell types
source("data-raw/hemibrain/startupHemibrain.R")
process = FALSE
# If sourcing the start up file does not work
## Go through it line by line, and see what's up.
## You do not need the google sheet functionality from this
## You will need google filestream loaded.

# If you can, before running this code, change your .Renivron to be
## looking at neuprint-test rather than the default neuprint server
### However, you may lack access rights

## Use this to co-plot Ito (left) and Bates/Frechter (right) types
# hemibrain_type_plot(x), where x is a vector of bodyids

## Use this to co-plot sets of neurons
# hemibrain_multi3d(x, y, z), where x,y,z are vectors of different bodyids.

## If you want to plot a light level neuro
## plot3d(most.lhns.hemibrain[id]), where id is a vector from most.lhn names
## plot3d(most.lhins.hemibrain[id]), where id is a vector from most.lhin names

# Build master
## Files made en masse in processPNTs.csv
csvs = list.files("data-raw/hemibrain/pnts/csv/", full.names = TRUE)
hemibrain.master = data.frame()
for(csv in csvs){
  df = read.csv(file = csv)
  hemibrain.master = rbind(hemibrain.master,df)
}
hemibrain.master$is.lhn = is.lhn(hemibrain.master$bodyid)

# Now let's go through and check all of the types
## I have not written this as a pipeline.
## So what you will need to do is make changes manually to the individual
## .R files for each PNT under data-raw/hemibrain/pnts
## You can also modify the below code, or run it in bits, to just look at certain
## PNTs or otherwise change things up.
pnts = sort(unique(hemibrain.master$pnt)) # change this line to look at only certain PNTs, e.g. 'LHAV2'
for(p in pnts){
  dfp = subset(hemibrain.master, hemibrain.master$pnt == p)
  cts = unique(sort(dfp$cell.type))
  ags = unique(gsub("([a-z]).*","\\1",cts))
  message("There are ",length(ags)," antatomy groups: ")
  cat(paste(gsub(p,"",ags), collapse = ", "))
  for(ag in ags){
    agp = gsub(p,"",ag)
    assign(agp, as.character(subset(dfp, grepl(ag,dfp$cell.type))$bodyid))
  }
  nat::nopen3d()
  choose = TRUE
  message("Looking at anatomy groups")
  message("Cell types will appear within each group in RGB colour order")
  while(choose){
    choices = hemibrainr:::must_be(prompt = "Choose anatomy groups to plot (single letter), or proceed to cell types (z) ",
                                   answers = c(gsub(p,"",ags),"z"))
    if(choices=="z"){
      choose = FALSE
      next
    }
    message("chosen: ",p, choices)
    dfct = subset(dfp,grepl(paste0(p,choices),dfp$cell.type))
    if(!nrow(dfct)){
      next
    }
    clear3d();plot3d(hemibrain.surf, alpha = 0.1)
    message("Cell types: ")
    message(paste(unique(dfct$cell.type),collapse = ", "))
    hemibrain_ct3d(dfct)
  }
  message("Ito types to the left (colour sets by cell type), Bates/Frechtet types to the right (cells coloured separately)")
  for(ct in cts){
    message(ct)
    plot = as.character(subset(dfp,dfp$cell.type==ct)$bodyid)
    hemibrain_type_plot(plot, meta = lh.meta) # can also run with just first argument
    continue = readline(prompt = "Press any key to continue ")
  }
}





