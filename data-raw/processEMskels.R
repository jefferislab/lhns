library(elmr)
library(googlesheets)

# INSERT CATMAID_LOGIN

# Get all of our input info
googlesheets::gs_auth(verbose=TRUE)
gs = googlesheets::gs_title("EMsearch")
gs = googlesheets::gs_read(gs, ws = 1, range = NULL, literal = TRUE, verbose = TRUE, col_names = TRUE)
g = subset(gs, Miketype!=FALSE)
cts = unique(g$cell.type)
#names(skids) = cts
skids = g$em.match.skid
skids = as.numeric(skids)
skids = unique(skids[!is.na(skids)])
# neurons = read.neurons.catmaid(skids,OmitFailures = TRUE)
# neurons = xform_brain(neurons,reference = FAFB14,sample=FCWB)
# neurons = neurons[!is.na(neurons)]

matches = neuronlist()
for (c in cts){
  skid = subset(g,cell.type==c)$em.match.skid[1]
  if(skid%in%names(neurons)){
    print(c)
    m = paste(subset(g,cell.type==c)$Miketype,collapse="/")
    neuron = elmr::fetchn_fafb(skid,mirror=FALSE,reference = FCWB)
    # Get meta info
    meta = subset(c(most.lhns,most.lhins),cell.type==c)[1]
    neuron[,"pnt"] = meta[,"pnt"]
    neuron[,"anatomy.group"] = meta[,"anatomy.group"]
    neuron[,"cell.type"] = c
    neuron[,"old.cell.type"] = m
    neuron[,"type"] = meta[,"type"]
    neuron[,"skeleton.type"] = "EM"
    matches = c(matches,neuron)
  }
}

strip_connectivity <- function(neuron){
  neuron$connectors = NULL
  neuron
}
emlhns = nlapply(matches,strip_connectivity)

# Capitalise
emlhns[,"cell.type"] = capitalise_cell_type_name(emlhns[,"cell.type"])
emlhns[,"anatomy.group"] = capitalise_cell_type_name(emlhns[,"anatomy.group"])
emlhns[,"pnt"] = capitalise_cell_type_name(emlhns[,"pnt"])

# Save!
emlhns.dps = dotprops(emlhns,resample = 1)
devtools::use_data(emlhns,overwrite=TRUE,compress=TRUE)
devtools::use_data(emlhns.dps,overwrite=TRUE,compress=TRUE)




