library(elmr)
library(googlesheets)

# INSERT CATMAID_LOGIN HERE
# FAFB.conn = catmaid_login(server = "https://neuropil.janelia.org/tracing/fafb/v14/", authname = "X", authpassword = "X", token = "X")

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
em.neurons = xform_brain(em.neurons,reference = FCWB,sample=FAFB14)
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
em.neurons[,"citation"] = "Dolan et al. 2019"
em.neurons[grepl("PD2a|PD2b",em.neurons[,"cell.type"]),"citation"] = "Dolan & Belliart-Guérin et al. 2018"

# Add neurons from Paavo's and the PN Paper
lhns.done.pn.paper = read.neurons.catmaid("annotation:WTPN2017_LHNs")
da2.project.neurons = read.neurons.catmaid("annotation:Huoviala et al. 2018 cell type ASB")
lhns.done = c(lhns.done.pn.paper, setdiff(da2.project.neurons,lhns.done.pn.paper))
da2.project.only.neurons = setdiff(da2.project.neurons,lhns.done.pn.paper)
process_lhn_name <- function(x) {
  res=stringr::str_match(x, "([AP][DV][1-9][0-9]{0,1})([a-z])([1-9][0-9]{0,2})")
  data.frame(pnt=res[,2], anatomy.group=paste0(res[,2], res[,3]), cell.type=res[,1],
             stringsAsFactors = F)
}
matches = read.csv("/GD/LMBD/Papers/2017pns/fig/Alex/data/neurons/mostlhns_matches.csv")
df = merge(lhns.done[,],matches)
cts = lhns::most.lhns[as.character(df$match),"cell.type"]
new.indices = grep("new:",as.character(df$match))
new.cts = gsub("new:","",as.character(df$match)[new.indices])
cts[new.indices] = new.cts
df = cbind(df,process_lhn_name(cts))
df$good.trace = TRUE
df$skeleton.type = "EM"
df[df$match=="Incomplete",c("cell.type","anatomy.group","pnt")] = "Incomplete"
df[df$match=="Incomplete",c("good.trace")] = FALSE
rownames(df) = df$skid
df[df$skid%in%names(lhns.done.pn.paper),"citation"] = "Schlegel & Bates et al. in prep"
df[df$skid%in%names(da2.project.neurons),"citation"] = "Huoviala et al. 2019"
df  = df[match(names(lhns.done),df$skid),]
lhns.done[,] = df

# Make a cohesive set of neurons
em.neurons = c(em.neurons,lhns.done[setdiff(names(lhns.done),names(em.neurons))])
em.neurons[,] = em.neurons[,c("skid", "pnt", "anatomy.group", "cell.type", "skeleton.type", "citation")]

# Remove connector information
strip_connectivity <- function(neuron){
  neuron$connectors = NULL
  neuron
}
emlhns = nlapply(subset(em.neurons,!cell.type%in%c("PD2a1","PD2b1","PV4a1","PV4a2","AD1b2")),strip_connectivity)
emlhns = c(emlhns,subset(em.neurons,cell.type%in%c("PD2a1","PD2b1","PV4a1","PV4a2","AD1b2")))

# Save!
emlhns.dps = dotprops(emlhns)
devtools::use_data(emlhns,overwrite=TRUE,compress=TRUE)
devtools::use_data(emlhns.dps,overwrite=TRUE,compress=TRUE)




