library(elmr)
library(googlesheets)

# INSERT CATMAID_LOGIN HERE
FAFB.conn = catmaid_login(server = "https://neuropil.janelia.org/tracing/fafb/v14/", authname = "X", authpassword = "X", token = "X")

# Access google sheet for cell type and EM matches information
googlesheets::gs_auth(verbose=TRUE)
gs = googlesheets::gs_title("EMsearch")
gs = googlesheets::gs_read(gs, ws = 1, range = NULL, literal = TRUE, verbose = TRUE, col_names = TRUE)
g = subset(gs, Miketype!=FALSE&!is.na(Miketype))
all.cts = unique(g$cell.type)
skids = g$em.match.skid
skids = as.numeric(skids)
skids = unique(skids[!is.na(skids)])
em.neurons = read.neurons.catmaid(skids,OmitFailures = FALSE)
em.neurons = xform_brain(em.neurons,reference = JFRC2,sample=FAFB14)
cts = c()
for(s in em.neurons[,"skid"]){
  c = subset(gs,em.match.skid==s)$cell.type[1]
  cts = c(cts,c)
}
em.neurons[,"old.cell.type"] = g$Miketype[match(cts,g$cell.type)]
em.neurons[,"cell.type"] = cts
em.neurons[,"pnt"] = process_lhn_name(em.neurons[,"cell.type"])$pnt
em.neurons[,"anatomy.group"] = process_lhn_name(em.neurons[,"cell.type"])$anatomy.group
em.neurons[grepl("WED",em.neurons[,"cell.type"]),"pnt"] = "WEDT"
em.neurons[grepl("WED",em.neurons[,"cell.type"]),"anatomy.group"] = "WED-PN"
em.neurons[grepl("LO-",em.neurons[,"cell.type"]),"pnt"] = "LOT"
em.neurons[grepl("LO-",em.neurons[,"cell.type"]),"anatomy.group"] = "LO-PN"
em.neurons[grepl("VNC",em.neurons[,"cell.type"]),"pnt"] = "VNCT"
em.neurons[grepl("VNC",em.neurons[,"cell.type"]),"anatomy.group"] = "VNC-PN"
em.neurons[grepl("GNG",em.neurons[,"cell.type"]),"pnt"] = "GNGT"
em.neurons[grepl("GNG",em.neurons[,"cell.type"]),"anatomy.group"] = "GNG-PN"
em.neurons[,"type"] = ifelse(em.neurons[,"cell.type"]%in%subset(most.lhns,type=="LN")[,"cell.type"],"LN","ON")
em.neurons[,"type"] = ifelse(grepl("PN",em.neurons[,"cell.type"]),"PN",em.neurons[,"type"])
em.neurons[,"skeleton.type"] = "EM"

# Remove connector information
strip_connectivity <- function(neuron){
  neuron$connectors = NULL
  neuron
}
emlhns = nlapply(subset(em.neurons,!cell.type%in%c("PV4a1","PV4a2","AD1b2")),strip_connectivity)
emlhns = c(emlhns,subset(em.neurons,cell.type%in%c("PV4a1","PV4a2","AD1b2")))

# Save!
emlhns.dps = dotprops(emlhns)
devtools::use_data(emlhns,overwrite=TRUE,compress=TRUE)
devtools::use_data(emlhns.dps,overwrite=TRUE,compress=TRUE)




