# ################################
# Read and process MCFO skeletons #
#################################

# Prepare data on Mike's splits
if(!exists("most.lhns")){
  stop("Please run processLHNs.R!")
}else if(!exists("most.lhins")){
  stop("Please run processLHNinputs.R!")
}

# # Read MCFO neurons
# mcfo = read.neurons("data-raw/Amira_Skeletons/")
# mcfo = nlapply(mcfo,nat::resample, stepsize = 1)
#
# # Fix skeletons (fix a few issues with Amira skeletons, like loops and star-burst node connectivity)
# nl = nat::neuronlist()
# for(mn in mcfo){
#   file = names(mcfo)[length(nl)+1]
#   message(length(nl)+1)
#   x = nat::xyzmatrix(mn)
#   k = 10
#   swc = data.frame(PointNo = 1:nrow(x),Label = 0,x,W = -2, Parent = -1, tree = NA) # Create SWC data.frame
#   nears = nabor::knn(data = x, query = x, k = k) # Find the closest k nodes
#   all.dists = nabor::knn(data = x, query = x, k = nrow(x)) # Find the closest k nodes
#   skel = 1 # We will grow our tree from, as start, the root for the first skeleton as the first point
#   used = c()
#   d = 0.1 #mean(nears[[2]][,-1]) # Start with the smallest connection distance, then grow the connection distance to its maximum. dd is the lower bound.
#   distance.steps = 0.1
#   connection.distance = 100 #max(nears[[2]][,c(2,3)]) # Max distance by which nodes can be connected
#   parents = nears[[1]][,-1][which.min(all.dists[[2]][,-1])] # Start with a faux 'root'
#   used = c()
#   print(d)
#   while(sum(is.na(swc$tree))>0) {
#     if(all(parents%in%used)){ # If we run out of nodes in the connection range
#       skel = skel + 1; leaves = c()
#       dists = nears[[2]][-1*used,-1]
#       indices = nears[[1]][-1*used,-1]
#       parents = indices[which.min(dists)]
#       parents = subset(swc,is.na(tree))$PointNo[[1]]
#     }
#     search = nears[[1]]; search[!nears[[2]]<=d] = NA # Get the closest matches in space to each non-zero point in the image stack
#     used = c(used,parents) # Parent nodes cannot be assigned to matches already within the tree
#     children = search[parents,]# Find the right match row
#     children = unique(children[!is.na(children)]) # Get children, i.e. candidate child nodes, within the connection distance
#     children = children[!children%in%used] # Remove the nodes we have already added to our skeleton
#     swc[unique(c(parents,children)),"tree"] = skel # So now we'll assign them to a skeleton
#     if(length(children[!is.na(children)])>0){ # If there are children
#       if(length(children)>1){
#         closest.parents = apply(search[children,],1, function(x) x[x%in%parents][1])
#         if(sum(is.na(closest.parents))>0){ # The the closest parent is not within the top k matches, look the other way
#           lost = children[is.na(closest.parents)]
#           closest.parents[is.na(closest.parents)] = sapply(lost,function(x) rep(parents,k)[which.max(search[parents,]==x)[1]])
#         }
#       }else{
#         closest.parents = search[children,][search[children,]%in%parents][1]
#         if(sum(is.na(closest.parents))>0){ # The the closest parent is not within the top k matches, look the other way
#           closest.parents = rep(parents,k)[which.max(search[parents,]==children)][1]
#         }
#       }
#       swc[children,"Parent"] = closest.parents # Assign to the closest parent
#       parents = children # Now grow tree from the old children
#     }
#   }
#   # Now we have created a bunch of skeletons at the minimal connection distance, d.
#   # We need to grow our search aread to d.max and so merge these different skeletons
#   dd = d # Minimal
#   d = d + distance.steps # Maximal
#   while(d<=connection.distance){
#     # Get the indices within the search distance
#     print(d)
#     search = nears[[1]]
#     search[!nears[[2]]<=d] = NA
#     search[!nears[[2]]>dd] = NA
#     # Get the distances
#     dists = nears[[2]]
#     m = reshape2::melt(dists)
#     m = subset(m,value<=d)
#     m = subset(m,value>dd)
#     # Order indices to grow by shortest distance to next node
#     m = m[order(m$value),]
#     for(parent in m$Var1){
#       t = swc[parent,"tree"]
#       used = subset(swc,tree==t)$PointNo
#       children = search[parent,]# Find the right match row
#       children = unique(children[!is.na(children)]) # Get children, i.e. candidate child nodes, within the connection distance
#       children = children[!children%in%used] # Remove the nodes we have already added to our tree
#       children = children[!duplicated(swc[children,"tree"])] # Children must be in different trees from one another
#       if(length(children)>0){
#         for(child in children){ # Now combine the trees
#           child.tree = swc[as.character(child),"tree"]
#           n = subset(swc,tree==child.tree)
#           if(nrow(n)>1){ # Connect another tree
#              n = nat::as.neuron(nat::as.ngraph(n), origin = child)$d
#              # el = n[n$Parent != -1, c("Parent", "PointNo")]
#              # el = el[el$Parent%in%n$PointNo,]
#              # n = ngraph(data.matrix(el), n$PointNo, directed = TRUE, xyz = xyzmatrix(n), diam = n$W)
#              # n = nat::as.neuron(n)$d
#              n$tree = t
#              n[n$PointNo==child,"Parent"] = parent
#              swc[n$PointNo,] = n
#            }else if (nrow(n)==1){ # Connect isolated node
#             n$tree = t
#             swc[swc$PointNo==child,"Parent"] = parent
#             swc[as.character(n$PointNo),"tree"] = t
#            }
#         }
#       }
#     }
#     # Increase the search distance
#     dd = d # New min
#     d = d + distance.steps # New max
#   }
#   isolated = sapply(swc$PointNo,function(x) (!x%in%swc$Parent)&(swc[x,"Parent"]==-1))
#   swc = swc[!isolated,] # Remove isolated nodes
#   swc = swc[!is.na(swc$PointNo),]
#   nn = nat::as.neuron(swc)
#   nams = c(names(nl),file)
#   nl = c(nl,nat::as.neuronlist(nn))
#   names(nl) = nams
# }
# attr(nl,"df") = data.frame(file=names(mcfo))
# nl = nlapply(nl,nat::resample, stepsize = 1)
# names(nl) = as.character(nl[,"file"])
#
# # Fit soma - interactive
# nl = catnat::correctsoma(nl)
#
# # Flip neurons - interactive
# plot3d(nl,soma=T);plot3d(JFRC2013)
# left.side.neurons = nat::find.soma(db=nl)
# nl[left.side.neurons] = mirror_brain(nl[left.side.neurons],brain = JFRC2013)
#
#
# # Transform to FCWB space
# mcfo = nat::nlapply(nl,nat.templatebrains::xform_brain,sample = nat.flybrains::JFRC2013,reference= nat.flybrains::FCWB,OmitFailures = T) # any lost?
#
# # save
# save(mcfo,file = "data-raw/dolan_mcfo.rda")

# ##############################
# Meta-data for the MCFO object #
################################

# Load data
load("data-raw/dolan_mcfo.rda")

# Get the imade code to line mapping
dcs = read.csv("data-raw/dolan_cells.csv")
nts = read.csv("data-raw/NT_annotation_from_Mike.csv")
images2cluster = read.csv("data-raw/ImagesToCluster.csv")
codes = read.csv("data-raw/FlycoreCodes.csv")
s = as.character(codes[,"Genotype"])

# Work out metadata
d = read.csv("/GD/LMBD/Papers/2018lhsplitcode/Data/SplitGAL4annotate.csv",header = TRUE)
colnames(d) = c("linecode","imagecode","AD","DBD","old.cell.type","num.clusters","Behaviour","Polarity","MCFO","stablestock","VNC")
d$imagecode = NULL
d = d[!duplicated(d$linecode),]
rownames(d) = d$linecode
m = c()
for(nam in names(mcfo)){
  n = gsub("*-.*","",nam)
  n = gsub(".*_","",n)
  m = c(m,match(n,s))
}
mf = data.frame(linecode = codes[m,"LineCode"])
mf$genotype = codes[m,"Genotype"]
mf = cbind(mf,d[as.character(mf$linecode),])
mf[,c("pnt","anatomy.group","cell.type","type")] = "notLHproper"
mf$match = NA
mf$skeleton.type = "MCFO"
mf$file = rownames(mf) = names(mcfo)
mf[] = lapply(mf, as.character)

# # NBlast
# mcfo.dps = dotprops(mcfo,resample=1)
# result1 = nblast(mcfo.dps, lhns::most.lhns.dps)
# result2 =  nblast(lhns::most.lhns.dps, mcfo.dps)
# result = (result1 + t(result2))/2
#
# for(c in 288:ncol(result)){
#   clear3d()
#   plot3d(FCWB)
#   message(paste0(c,"/",ncol(result)))
#   message(names(mcfo[c]))
#   plot3d(mcfo[c],col = "black",lwd=3,soma=T)
#   n = nlscan(lhns::most.lhns[names(sort(result[,c],decreasing = TRUE))],col="red",lwd=2,soma=T)
# }

# ##########################
# Assignments to LHN library #
############################



# L2444; PN; AL-lALT-PN3
mf[c("GMR_MB583B-20121107_19_H4-Aligned63xScale_c0.Smt.SptGraph.swc",
     "GMR_MB583B-20121107_19_H4-Aligned63xScale_c0.Smt.SptGraph.swc",
     "GMR_MB583B-20121107_19_H4-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "PN"
mf["JRC_SS44863-20180209_21_D6-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="Cha-F-900038"

# L260; 143; PV1a; Good
mf[c("GMR_MB583B-20121107_19_H4-Aligned63xScale_c0.Smt.SptGraph.swc",
     "GMR_MB583B-20121107_19_H4-Aligned63xScale_c1.Smt5.SptGraph.swc",
     "GMR_MB583B-20121107_19_H4-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "143"
mf["GMR_MB583B-20121107_19_H4-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="TH-M-000042"
mf["GMR_MB583B-20121107_19_H4-Aligned63xScale_c1.Smt5.SptGraph.swc",]$match ="TH-M-000042" # Duplicated
mf["GMR_MB583B-20121107_19_H4-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="TH-M-000042" # Duplicated

# L16; 113 and mess; notLHproper
mf[c("GMR_SS00367-20180209_21_H5-Aligned63xScale_c2a.Smt.SptGraph.swc",
     "GMR_SS00367-20180209_21_H5-Aligned63xScale_c2b.Smt2.SptGraph.swc",
     "GMR_SS00367-20131220_19_A4-Aligned63xScale_c2a.Smt.SptGraph.swc",
     "GMR_SS00367-20180209_21_H1-Aligned63xScale_c0.Smt.SptGraph.swc"),]$old.cell.type = "Input?" # Input type
mf[c("GMR_SS00367-20180209_21_H5-Aligned63xScale_c0a.Smt.SptGraph.swc",
     "GMR_SS00367-20180209_21_H5-Aligned63xScale_c0b.Smt.SptGraph.swc",
     "GMR_SS00367-20180209_21_H1-Aligned63xScale_c1.Smt.SptGraph.swc",
     "GMR_SS00367-20180209_21_H3-Aligned63xScale_c0.Smt.SptGraph.swc",
     "GMR_SS00367-20131220_19_A4-Aligned63xScale_c1.Smt.SptGraph.swc",
     "GMR_SS00367-20131220_19_A4-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "113"
mf["GMR_SS00367-20180209_21_H5-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match ="fru-F-600136"
mf["GMR_SS00367-20180209_21_H5-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match ="PD2e2" #
mf["GMR_SS00367-20180209_21_H1-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="PD2e2"
mf["GMR_SS00367-20180209_21_H3-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="fru-F-600136" # Duplicated
mf["GMR_SS00367-20131220_19_A4-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="fru-F-600136"
mf["GMR_SS00367-20131220_19_A4-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="fru-F-600136" # Duplicated
mf["GMR_SS00367-20180209_21_H5-Aligned63xScale_c2a.Smt.SptGraph.swc",]$match ="fru-M-200431"
mf["GMR_SS00367-20180209_21_H5-Aligned63xScale_c2b.Smt2.SptGraph.swc",]$match ="fru-M-200431"
mf["GMR_SS00367-20131220_19_A4-Aligned63xScale_c2a.Smt.SptGraph.swc",]$match ="fru-M-200431"
mf["GMR_SS00367-20180209_21_H1-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="fru-M-200431"



# L173; 12B; PV5c1
mf[c("JRC_SS03225-20150828_24_F1-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS03225-20150828_24_F1-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS03225-20150828_24_F1-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS03225-20150828_24_F2-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS03225-20150828_24_F2-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS03225-20150828_24_F2-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS03225-20150828_24_G1-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS03225-20150828_24_G1-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS03225-20150828_24_G1-Aligned63xScale_c2a.Smt.SptGraph.swc"),]$old.cell.type = "12B"
mf["JRC_SS03225-20150828_24_F1-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="E0585-F-300071"
mf["JRC_SS03225-20150828_24_F1-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="E0585-F-300071" # Duplicated
mf["JRC_SS03225-20150828_24_F1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="E0585-F-300071" # Duplicated
mf["JRC_SS03225-20150828_24_F2-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="Cha-F-000317" # Duplicated
mf["JRC_SS03225-20150828_24_F2-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Cha-F-000317"
mf["JRC_SS03225-20150828_24_F2-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="Cha-F-000317" # Duplicated
mf["JRC_SS03225-20150828_24_G1-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="Gad1-F-200232"
mf["JRC_SS03225-20150828_24_G1-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Gad1-F-200232"
mf["JRC_SS03225-20150828_24_G1-Aligned63xScale_c2a.Smt.SptGraph.swc",]$match ="Gad1-F-200232"

# L1385; 1D; complicated
mf[c("JRC_SS04720-20170623_23_A4-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04720-20170623_23_A2-Aligned63xScale_c1a.Smt.SptGraph.swc",
     "JRC_SS04720-20160819_21_C1-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04720-20160819_21_C1-Aligned63xScale_c1a.Smt.SptGraph.swc",
     "JRC_SS04720-20160819_21_C1-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS04720-20160819_21_C2-Aligned63xScale_c0a.Smt.SptGraph.swc",
     "JRC_SS04720-20160819_21_C1-Aligned63xScale_c1b.Smt.SptGraph.swc",
     "JRC_SS04720-20160819_21_C3-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS04720-20160819_21_C2-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS04720-20160819_21_C7-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04720-20160819_21_C7-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS04720-20160819_21_C7-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS04720-20160819_21_C7-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS04720-20170623_23_A2-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS04720-20170623_23_A2-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04720-20170623_23_B1-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04720-20170623_23_A4-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS04720-20170623_23_A4-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS04720-20160819_21_C2-Aligned63xScale_c1b.Smt.SptGraph.swc",
     "JRC_SS04720-20160819_21_C3-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04720-20170623_23_A7-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS04720-20170623_23_A7-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS04720-20170623_23_A8-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS04720-20160819_21_C2-Aligned63xScale_c1a.Smt.SptGraph.swc",
     "JRC_SS04720-20160819_21_C2-Aligned63xScale_c0b.Smt.SptGraph.swc"),]$old.cell.type = "1D"
mf["JRC_SS04720-20170623_23_A4-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="130625c0"
mf["JRC_SS04720-20170623_23_A2-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match ="Cha-F-000242"
mf["JRC_SS04720-20160819_21_C1-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="Gad1-F-200366" # Investigate further
mf["JRC_SS04720-20160819_21_C1-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match ="Cha-F-000515" # Investigate further
mf["JRC_SS04720-20160819_21_C1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="Cha-F-000515" # Investigate further
mf["JRC_SS04720-20160819_21_C2-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match ="140618c0" # Investigate further
mf["JRC_SS04720-20160819_21_C1-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match ="Gad1-F-600106" # Investigate further
mf["JRC_SS04720-20160819_21_C3-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Gad1-F-200366" # Investigate further
mf["JRC_SS04720-20160819_21_C2-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="Gad1-F-200366" # Investigate further
mf["JRC_SS04720-20160819_21_C7-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="Gad1-F-200366" # Investigate further
mf["JRC_SS04720-20160819_21_C7-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Gad1-F-200366" # Investigate further
mf["JRC_SS04720-20160819_21_C7-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="Gad1-F-200366" # Investigate further
mf["JRC_SS04720-20160819_21_C7-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="Gad1-F-800100" # Investigate further
mf["JRC_SS04720-20170623_23_A2-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="Cha-F-000515" # Duplicated Investigate further
mf["JRC_SS04720-20170623_23_A2-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="Cha-F-000515" # Investigate further
mf["JRC_SS04720-20170623_23_B1-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="Gad1-F-200366" # Investigate further
mf["JRC_SS04720-20170623_23_A4-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Gad1-F-200366"
mf["JRC_SS04720-20170623_23_A4-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="Gad1-F-200366" # Duplicated
mf["JRC_SS04720-20160819_21_C2-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match ="Gad1-F-200127" # Investigate further
mf["JRC_SS04720-20160819_21_C3-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="Gad1-F-600241" # Close, could also be Gad1-F-700106
mf["JRC_SS04720-20170623_23_A7-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Gad1-F-400436"
mf["JRC_SS04720-20170623_23_A7-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="Gad1-F-400436" # Duplicated
mf["JRC_SS04720-20170623_23_A8-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Gad1-F-200366"
mf["JRC_SS04720-20160819_21_C2-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match ="Gad1-F-100077"
mf["JRC_SS04720-20160819_21_C2-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match ="Cha-F-200385"

# L178; 12B; PV5c1
mf[c("JRC_SS04038-20170324_28_C5-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04038-20170324_28_C5-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS04038-20170324_28_C5-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS04038-20170324_28_C7-Aligned63xScale_c1.Smt.SptGraph.swc"),]$old.cell.type = "12B"
mf["JRC_SS04038-20170324_28_C5-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="E0585-F-400025"
mf["JRC_SS04038-20170324_28_C5-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="E0585-F-400025" # Duplicated
mf["JRC_SS04038-20170324_28_C5-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="E0585-F-400025" # Duplicated
mf["JRC_SS04038-20170324_28_C7-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="E0585-F-400025"

# L258; 54A; PV2a1
mf[c("JRC_SS04955-20151009_19_B1-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04955-20151009_19_B1-Aligned63xScale_c1a.Smt.SptGraph.swc",
     "JRC_SS04955-20151009_19_B1-Aligned63xScale_c1b.Smt.SptGraph.swc",
     "JRC_SS04955-20151009_19_B1-Aligned63xScale_c2a.Smt.SptGraph.swc",
     "JRC_SS04955-20151009_19_B1-Aligned63xScale_c2b.Smt.SptGraph.swc",
     "JRC_SS04955-20151009_19_B2-Aligned63xScale_c0a.Smt.SptGraph.swc",
     "JRC_SS04955-20151009_19_B2-Aligned63xScale_c0b.Smt.SptGraph.swc",
     "JRC_SS04955-20151009_19_B2-Aligned63xScale_c1a.Smt.SptGraph.swc",
     "JRC_SS04955-20151009_19_B2-Aligned63xScale_c1b.Smt.SptGraph.swc",
     "JRC_SS04955-20151009_19_B3-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04955-20151009_19_B3-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS04955-20151009_19_B3-Aligned63xScale_c2a.Smt.SptGraph.swc",
     "JRC_SS04955-20151009_19_B3-Aligned63xScale_c2b.Smt.SptGraph.swc",
     "JRC_SS04955-20151009_19_B5-Aligned63xScale_c0a.Smt.SptGraph.swc",
     "JRC_SS04955-20151009_19_B5-Aligned63xScale_c0b.Smt.SptGraph.swc",
     "JRC_SS04955-20151009_19_B5-Aligned63xScale_c1a.Smt.SptGraph.swc",
     "JRC_SS04955-20151009_19_B5-Aligned63xScale_c1b.Smt.SptGraph.swc",
     "JRC_SS04955-20151009_19_B5-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "54A"
mf["JRC_SS04955-20151009_19_B1-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="Cha-F-300168"
mf["JRC_SS04955-20151009_19_B1-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match ="Cha-F-300168"
mf["JRC_SS04955-20151009_19_B1-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match ="Cha-F-300168"
mf["JRC_SS04955-20151009_19_B1-Aligned63xScale_c2a.Smt.SptGraph.swc",]$match ="Cha-F-300168"
mf["JRC_SS04955-20151009_19_B1-Aligned63xScale_c2b.Smt.SptGraph.swc",]$match ="Cha-F-300168"
mf["JRC_SS04955-20151009_19_B2-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match ="5HT1A-F-100028"
mf["JRC_SS04955-20151009_19_B2-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match ="131031c1"
mf["JRC_SS04955-20151009_19_B2-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match ="Cha-F-300168"
mf["JRC_SS04955-20151009_19_B2-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match ="131031c1"
mf["JRC_SS04955-20151009_19_B3-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="5HT1A-M-100027"
mf["JRC_SS04955-20151009_19_B3-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="5HT1A-M-100027" # Duplicated
mf["JRC_SS04955-20151009_19_B3-Aligned63xScale_c2a.Smt.SptGraph.swc",]$match ="5HT1A-M-100027" # Duplicated
mf["JRC_SS04955-20151009_19_B3-Aligned63xScale_c2b.Smt.SptGraph.swc",]$match ="Cha-F-300168"
mf["JRC_SS04955-20151009_19_B5-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match ="5HT1A-F-100028"
mf["JRC_SS04955-20151009_19_B5-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match ="Cha-F-400222"
mf["JRC_SS04955-20151009_19_B5-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match ="Cha-F-400222" # Duplicated
mf["JRC_SS04955-20151009_19_B5-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match ="5HT1A-M-100027"
mf["JRC_SS04955-20151009_19_B5-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="Cha-F-300168"

# L421; 1B; AV4c1
mf[c("JRC_SS04958-20160225_19_C1-Aligned63xScale_c0a.Smt.SptGraph.swc",
     "JRC_SS04958-20160225_19_C1-Aligned63xScale_c0b.Smt.SptGraph.swc",
     "JRC_SS04958-20160225_19_C1-Aligned63xScale_c1a.Smt.SptGraph.swc",
     "JRC_SS04958-20160225_19_C1-Aligned63xScale_c1b.Smt.SptGraph.swc",
     "JRC_SS04958-20160225_19_C1-Aligned63xScale_c2a.Smt.SptGraph.swc",
     "JRC_SS04958-20160225_19_C1-Aligned63xScale_c2b.Smt.SptGraph.swc",
     "JRC_SS04958-20160225_19_C2-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04958-20160225_19_C2-Aligned63xScale_c1a.Smt.SptGraph.swc",
     "JRC_SS04958-20160225_19_C2-Aligned63xScale_c1b.Smt.SptGraph.swc",
     "JRC_SS04958-20160225_19_C2-Aligned63xScale_c2b.Smt.SptGraph.swc",
     "JRC_SS04958-20160225_19_C3-Aligned63xScale_c0a.Smt.SptGraph.swc",
     "JRC_SS04958-20160225_19_C3-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS04958-20160225_19_C3-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "1B"
mf["JRC_SS04958-20160225_19_C1-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match ="fru-F-500093"
mf["JRC_SS04958-20160225_19_C1-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match ="131123c1"
mf["JRC_SS04958-20160225_19_C1-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match ="fru-F-500093"
mf["JRC_SS04958-20160225_19_C1-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match ="131123c1"
mf["JRC_SS04958-20160225_19_C1-Aligned63xScale_c2a.Smt.SptGraph.swc",]$match ="fru-F-400486"
mf["JRC_SS04958-20160225_19_C1-Aligned63xScale_c2b.Smt.SptGraph.swc",]$match ="131123c1"
mf["JRC_SS04958-20160225_19_C2-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="fru-F-500093" # Also 131003c1? sort out
mf["JRC_SS04958-20160225_19_C2-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match ="131123c1"
mf["JRC_SS04958-20160225_19_C2-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match ="fru-F-500093" # Also 131003c1? sort out
mf["JRC_SS04958-20160225_19_C2-Aligned63xScale_c2b.Smt.SptGraph.swc",]$match ="131003c1"
mf["JRC_SS04958-20160225_19_C3-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match ="131123c1"
mf["JRC_SS04958-20160225_19_C3-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="131123c1"
mf["JRC_SS04958-20160225_19_C3-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="fru-F-400486"

# L1828; 29E & 8A;PV4b2 & AD3b1 (# Segmentation: L187; 29E; PV4b1)
mf[c("JRC_SS03773-20180209_21_A7-Aligned63xScale_c1.Smt.SptGraph.swc"),]$old.cell.type = "29E"
mf[c("JRC_SS03773-20180209_21_A7-Aligned63xScale_c0.Smt.SptGraph.swc"),]$old.cell.type = "8A"
mf["JRC_SS03773-20180209_21_A7-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="Cha-F-000533"
mf["JRC_SS03773-20180209_21_A7-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="VGlut-F-400084"

# L509; 114A; PV4b2 (# Segmentation: not present)
mf[c("JRC_SS03773-20180209_21_A7-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS03783-20151231_33_A1-Aligned63xScale_c1b.Smt.SptGraph.swc"),]$old.cell.type = "114A"
mf["JRC_SS03783-20151231_33_A1-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match ="fru-M-200351"
mf["JRC_SS03783-20151231_33_A1-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match ="fru-M-200351"

# L784; 4B; PV4a5/9
mf[c("JRC_SS03802-20180209_20_A3-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS03802-20180209_20_A5-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS03802-20180209_20_A5-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "4B"
mf["JRC_SS03802-20180209_20_A3-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="VGlut-F-500253"
mf["JRC_SS03802-20180209_20_A5-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="130205c2"
mf["JRC_SS03802-20180209_20_A5-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="130205c2" # Duplicated

# L1467; 4A; PV4a1:6/f1
mf[c("JRC_SS04967-20151022_20_A1-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_A1-Aligned63xScale_c1a.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_A2-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_A2-Aligned63xScale_c0b.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_A2-Aligned63xScale_c1a.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_A2-Aligned63xScale_c1b.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_A2-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_A2-Aligned63xScale_c2a.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_A3-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_A3-Aligned63xScale_c1b.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_A5-Aligned63xScale_c1a.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_A5-Aligned63xScale_c1b.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_A5-Aligned63xScale_c2a.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_A5-Aligned63xScale_c2b.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_A7-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_A7-Aligned63xScale_c1a.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_A7-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_A8-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_A8-Aligned63xScale_c3.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_B1-Aligned63xScale_c0a.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_B1-Aligned63xScale_c0b.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_B1-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_B1-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS04967-20151022_20_A3-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "4A"
mf["JRC_SS04967-20151022_20_A1-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="130703c0" # Check 130925c2? 130219c0? Cha-F-900046?
mf["JRC_SS04967-20151022_20_A1-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match ="Cha-F-500234"
mf["JRC_SS04967-20151022_20_A2-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="VGlut-F-500253"
mf["JRC_SS04967-20151022_20_A2-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match ="Gad1-F-000381"
mf["JRC_SS04967-20151022_20_A2-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match ="130724c0"
mf["JRC_SS04967-20151022_20_A2-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match ="fru-F-400219"
mf["JRC_SS04967-20151022_20_A2-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="fru-F-400219" # Duplicated
mf["JRC_SS04967-20151022_20_A2-Aligned63xScale_c2a.Smt.SptGraph.swc",]$match ="130911c2" # Check, Gad1-F-200395? 130724c0? VGlut-F-700430?
mf["JRC_SS04967-20151022_20_A3-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="130625c0"
mf["JRC_SS04967-20151022_20_A3-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match ="fru-F-400219"
mf["JRC_SS04967-20151022_20_A5-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match ="Cha-F-400318" # Check, "Gad1-F-000381"?
mf["JRC_SS04967-20151022_20_A5-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match = "Cha-F-500234" # check "130625c0"
mf["JRC_SS04967-20151022_20_A5-Aligned63xScale_c2a.Smt.SptGraph.swc",]$match ="Cha-F-400318" # Check, "Gad1-F-000381"?
mf["JRC_SS04967-20151022_20_A5-Aligned63xScale_c2b.Smt.SptGraph.swc",]$match ="Gad1-F-000381" # Check, 130625c0? Cha-F-500234?
mf["JRC_SS04967-20151022_20_A7-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="VGlut-F-500253" # 130625c0 ? Cha-F-500234? 130411c2?
mf["JRC_SS04967-20151022_20_A7-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match ="Cha-F-500234"
mf["JRC_SS04967-20151022_20_A7-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="VGlut-F-500253"
mf["JRC_SS04967-20151022_20_A8-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="VGlut-F-500253"
mf["JRC_SS04967-20151022_20_A8-Aligned63xScale_c3.Smt.SptGraph.swc",]$match ="Gad1-F-000381"
mf["JRC_SS04967-20151022_20_B1-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match ="130704c1" # Check VGlut-F-500253?
mf["JRC_SS04967-20151022_20_B1-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match ="fru-F-500479"
mf["JRC_SS04967-20151022_20_B1-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="fru-F-500479" # Duplicated
mf["JRC_SS04967-20151022_20_B1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="fru-F-500479" # Duplicated
mf["JRC_SS04967-20151022_20_A3-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "VGlut-F-600090"

# L1735;  4A; PV4a2/3/5
mf[c("JRC_SS04970-20150828_24_B1-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS04970-20150828_24_B1-Aligned63xScale_c2b.Smt.SptGraph.swc",
     "JRC_SS04970-20150828_24_B1-Aligned63xScale_c3.Smt.SptGraph.swc",
     "JRC_SS04970-20150828_24_B5-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS04970-20151002_21_F2-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04970-20151002_21_F2-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04970-20151002_21_F2-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS04970-20151002_21_F2-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS04970-20151002_21_F2-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS04970-20151002_21_F4-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04970-20151002_21_F4-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS04970-20151002_21_F7-Aligned63xScale_c0a.Smt.SptGraph.swc",
     "JRC_SS04970-20151002_21_F7-Aligned63xScale_c0b.Smt.SptGraph.swc",
     "JRC_SS04970-20151002_21_F7-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "4A"
mf["JRC_SS04970-20150828_24_B1-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Gad1-F-000381"
mf["JRC_SS04970-20150828_24_B1-Aligned63xScale_c2b.Smt.SptGraph.swc",]$match ="Cha-F-500234"
mf["JRC_SS04970-20150828_24_B1-Aligned63xScale_c3.Smt.SptGraph.swc",]$match ="Gad1-F-000381"
mf["JRC_SS04970-20150828_24_B5-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="130625c0"
mf["JRC_SS04970-20151002_21_F2-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="VGlut-F-500253"
mf["JRC_SS04970-20151002_21_F2-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="130408c0"
mf["JRC_SS04970-20151002_21_F2-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="130408c0" # Duplicated
mf["JRC_SS04970-20151002_21_F2-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="VGlut-F-500253"
mf["JRC_SS04970-20151002_21_F2-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="VGlut-F-500253"
mf["JRC_SS04970-20151002_21_F4-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="VGlut-F-500253"
mf["JRC_SS04970-20151002_21_F4-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="130625c0"
mf["JRC_SS04970-20151002_21_F7-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match ="VGlut-F-500253" # Gad1-F-500281? 130408c0?
mf["JRC_SS04970-20151002_21_F7-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match ="Cha-F-100412"
mf["JRC_SS04970-20151002_21_F7-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="VGlut-F-500253"

# L1475; 4A; PV4a2:4
mf[c("JRC_SS04974-20150828_24_H1-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS04974-20150828_24_H1-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS04974-20150828_24_H1-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04974-20150828_24_H3-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04974-20150828_24_H3-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS04974-20150828_24_H3-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS04974-20150828_24_H5-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04974-20150828_24_H5-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS04974-20150828_24_H6-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04974-20151002_21_E1-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS04974-20151002_21_E1-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS04974-20151002_21_E1-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS04974-20151002_21_E2-Aligned63xScale_c0.Smt.SptGraph.swc"),]$old.cell.type = "4A"
mf["JRC_SS04974-20150828_24_H1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="Gad1-F-000381" # 130411c2
mf["JRC_SS04974-20150828_24_H1-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Gad1-F-000381"
mf["JRC_SS04974-20150828_24_H1-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="Gad1-F-000381" # 130703c0?
mf["JRC_SS04974-20150828_24_H3-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="fru-M-500368"
mf["JRC_SS04974-20150828_24_H3-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="fru-M-500368" # Duplicated
mf["JRC_SS04974-20150828_24_H3-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="fru-M-500368" # Duplicated, Gad1-F-000381?
mf["JRC_SS04974-20150828_24_H5-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="Gad1-F-000381"
mf["JRC_SS04974-20150828_24_H5-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Gad1-F-000381"
mf["JRC_SS04974-20150828_24_H6-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="Gad1-F-000381"
mf["JRC_SS04974-20151002_21_E1-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Unknown"
mf["JRC_SS04974-20151002_21_E1-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Unknown"
mf["JRC_SS04974-20151002_21_E1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Unknown"
mf["JRC_SS04974-20151002_21_E2-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "130703c0"

# L234; 4A; PV4a1/2
mf[c("JRC_SS15295-20151002_21_A5-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS15295-20151008_22_B5-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS15295-20151008_22_B5-Aligned63xScale_c0b.Smt.SptGraph.swc"),]$old.cell.type = "4A"
mf["JRC_SS15295-20151002_21_A5-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "130619c0"
mf["JRC_SS15295-20151008_22_B5-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "fru-F-400219"
mf["JRC_SS15295-20151008_22_B5-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match = "fru-F-400219"

# L954; 4A; PV4a5
mf[c("JRC_SS16060-20151125_19_E7-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS16060-20151125_19_E7-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "4A"
mf["JRC_SS16060-20151125_19_E7-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "VGlut-F-500253"
mf["JRC_SS16060-20151125_19_E7-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "VGlut-F-500253" # Duplicated

# L568; 54A + 1H; PV2a2 + AV4c1/b6
mf[c("JRC_SS16329-20151125_23_A6-Aligned63xScale_c1b.Smt.SptGraph.swc",
     "JRC_SS16329-20151125_23_A1-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "54A"
mf[c("JRC_SS16329-20151125_23_A1-Aligned63xScale_c2b.Smt.SptGraph.swc",
     "JRC_SS16329-20151125_23_A6-Aligned63xScale_c1a.Smt.SptGraph.swc",
     "JRC_SS16329-20151125_23_A1-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS16329-20151125_23_A6-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "1H"
# PV2a2
mf["JRC_SS16329-20151125_23_A6-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match = "5HT1A-M-100027"
mf["JRC_SS16329-20151125_23_A1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Cha-F-000242"
# AV4c1/b6
mf["JRC_SS16329-20151125_23_A1-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Gad1-F-100051"
mf["JRC_SS16329-20151125_23_A1-Aligned63xScale_c2b.Smt.SptGraph.swc",]$match = "fru-F-400486"
mf["JRC_SS16329-20151125_23_A6-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match = "140213c1"
mf["JRC_SS16329-20151125_23_A6-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Cha-F-400293"

# L1473; 4A; PV4a1:4/7/9
mf[c("JRC_SS16345-20151022_20_D2-Aligned63xScale_c0a.Smt.SptGraph.swc",
     "JRC_SS16345-20151022_20_D2-Aligned63xScale_c0b.Smt.SptGraph.swc",
     "JRC_SS16345-20151022_20_D2-Aligned63xScale_c1.Smt2.SptGraph.swc",
     "JRC_SS16345-20151022_20_D2-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS16345-20151022_20_D3-Aligned63xScale_c0a.Smt.SptGraph.swc",
     "JRC_SS16345-20151022_20_D3-Aligned63xScale_c0b.Smt.SptGraph.swc",
     "JRC_SS16345-20151022_20_D3-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS16345-20151022_20_D4-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS16345-20151022_20_D4-Aligned63xScale_c2.Smt3.SptGraph.swc",
     "JRC_SS16345-20151022_20_D5-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS16345-20151022_20_D5-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS16345-20151022_20_D5-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "4A"
mf["JRC_SS16345-20151022_20_D2-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match = "130205c2" # Check
mf["JRC_SS16345-20151022_20_D2-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match = "130703c0" # Check
mf["JRC_SS16345-20151022_20_D2-Aligned63xScale_c1.Smt2.SptGraph.swc",]$match = "130625c0"
mf["JRC_SS16345-20151022_20_D2-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "130411c2"
mf["JRC_SS16345-20151022_20_D3-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match = "fru-F-500479"
mf["JRC_SS16345-20151022_20_D3-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match = "Cha-F-500234"
mf["JRC_SS16345-20151022_20_D3-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "fru-F-400219"
mf["JRC_SS16345-20151022_20_D4-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "130625c0"
mf["JRC_SS16345-20151022_20_D4-Aligned63xScale_c2.Smt3.SptGraph.swc",]$match = "130411c2"
mf["JRC_SS16345-20151022_20_D5-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "VGlut-F-700436" # Check
mf["JRC_SS16345-20151022_20_D5-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "fru-F-400219"
mf["JRC_SS16345-20151022_20_D5-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "fru-F-400219"

# L542; 4A; PV4a4
mf[c("JRC_SS16652-20170303_25_A2-Aligned63xScale_c0.Smt.SptGraph.swc"),]$old.cell.type = "4A"
mf["JRC_SS16652-20170303_25_A2-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "130703c0"

# L1354; 4A; PV4a3
mf[c("JRC_SS22604-20160729_27_A2-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS22604-20160729_27_A2-Aligned63xScale_c1b.Smt.SptGraph.swc"),]$old.cell.type = "4A"
mf["JRC_SS22604-20160729_27_A2-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Gad1-F-000381"
mf["JRC_SS22604-20160729_27_A2-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match = "Gad1-F-000381"

# L2013; 54C; PV2a1
mf[c("JRC_SS23347-20170303_26_E2-Aligned63xScale_c1.Smt.SptGraph.swc"),]$old.cell.type = "54C"
mf["JRC_SS23347-20170303_26_E2-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "131030c0"

# L1539; 16B; AD1b1/b2/c1 (# Segmentation 16B; AD1b2)
mf[c("JRC_SS22647-20161007_29_E2-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS22647-20161007_29_E3-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS22647-20161007_29_E3-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS22647-20161007_29_E6-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS22647-20161007_29_E6-Aligned63xScale_c2a.Smt.SptGraph.swc",
     "JRC_SS22647-20161007_29_E6-Aligned63xScale_c2b.Smt.SptGraph.swc",
     "JRC_SS22647-20161007_29_E7-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS22647-20161007_29_E7-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS22647-20161007_29_E7-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "16B"
mf[c("JRC_SS22647-20161007_29_E2-Aligned63xScale_c0b.Smt.SptGraph.swc"),]$old.cell.type = ""
mf["JRC_SS22647-20161007_29_E2-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "120714c4"
mf["JRC_SS22647-20161007_29_E3-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "120714c4"
mf["JRC_SS22647-20161007_29_E3-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "120726c3"
mf["JRC_SS22647-20161007_29_E6-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "120714c4"
mf["JRC_SS22647-20161007_29_E6-Aligned63xScale_c2a.Smt.SptGraph.swc",]$match = "130711c3"
mf["JRC_SS22647-20161007_29_E6-Aligned63xScale_c2b.Smt.SptGraph.swc",]$match = "120913c1"
mf["JRC_SS22647-20161007_29_E7-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "120913c1"
mf["JRC_SS22647-20161007_29_E7-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "120913c1"
mf["JRC_SS22647-20161007_29_E7-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "130711c3"
mf["JRC_SS22647-20161007_29_E2-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match = "Gad1-F-200241"

# L1749; 116A & 4A; PD3a1/2/3 & PV4a7; (# Segmentation 116A; PD3a1)
mf[c("JRC_SS22723-20170324_29_F4-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS22723-20170324_29_F5-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS22723-20170324_29_F4-Aligned63xScale_c0b.Smt.SptGraph.swc",
     "JRC_SS22723-20170324_29_F5-Aligned63xScale_c1a.Smt3.SptGraph.swc",
     "JRC_SS22723-20170324_29_F2-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "116A"
mf[c("JRC_SS22723-20170324_29_F1-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS22723-20170324_29_F2-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS22723-20170324_29_F3-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS22723-20170324_29_F4-Aligned63xScale_c0a.Smt.SptGraph.swc",
     "JRC_SS22723-20170324_29_F4-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS22723-20170324_29_F5-Aligned63xScale_c1b.Smt.SptGraph.swc"),]$old.cell.type = "4A"
# PD3
mf["JRC_SS22723-20170324_29_F4-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Gad1-F-100168"
mf["JRC_SS22723-20170324_29_F5-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Gad1-F-100168"
mf["JRC_SS22723-20170324_29_F4-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match = "PD3a3"
mf["JRC_SS22723-20170324_29_F5-Aligned63xScale_c1a.Smt3.SptGraph.swc",]$match = "Cha-F-400165"
mf["JRC_SS22723-20170324_29_F2-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Gad1-F-200150"
# PV4a7
mf["JRC_SS22723-20170324_29_F1-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Gad1-F-100345"
mf["JRC_SS22723-20170324_29_F2-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Gad1-F-100345"
mf["JRC_SS22723-20170324_29_F3-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Gad1-F-100345"
mf["JRC_SS22723-20170324_29_F4-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match = "Gad1-F-100345"
mf["JRC_SS22723-20170324_29_F4-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Gad1-F-100345"
mf["JRC_SS22723-20170324_29_F5-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match = "Gad1-F-100345"

# L1328; 138; PV2a1; Good
mf[c("JRC_SS16353-20170303_21_C1-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS16353-20170303_21_C2-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS16353-20170303_21_C5-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS16353-20170303_21_C5-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS16353-20170303_21_C6-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS16353-20170303_21_C6-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "138"
mf["JRC_SS16353-20170303_21_C1-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Cha-F-400222"
mf["JRC_SS16353-20170303_21_C2-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Cha-F-400222"
mf["JRC_SS16353-20170303_21_C5-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Cha-F-400222"
mf["JRC_SS16353-20170303_21_C5-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Cha-F-400222" # Duplicated
mf["JRC_SS16353-20170303_21_C6-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Cha-F-400222"
mf["JRC_SS16353-20170303_21_C6-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Cha-F-400222"

# L907; 27A; Av2a1; Good
mf[c("JRC_SS16364-20151217_22_B7-Aligned63xScale_c1.Smt.SptGraph.swc"),]$old.cell.type = "27A"
mf["JRC_SS16364-20151217_22_B7-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Gad1-F-000240"

# L247; 1B; AV4a2/5
mf[c("JRC_SS16661-20151125_20_F1-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS16661-20151125_20_F1-Aligned63xScale_c0b.Smt.SptGraph.swc",
     "JRC_SS16661-20151125_20_F1-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS16661-20151125_20_F1-Aligned63xScale_c1a.Smt.SptGraph.swc",
     "JRC_SS16661-20151125_20_F1-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS16661-20151125_20_F1-Aligned63xScale_c2b.Smt.SptGraph.swc"),]$old.cell.type = "1B"
mf["JRC_SS16661-20151125_20_F1-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Cha-F-000481"
mf["JRC_SS16661-20151125_20_F1-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match = "Cha-F-000481"
mf["JRC_SS16661-20151125_20_F1-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Cha-F-000481"
mf["JRC_SS16661-20151125_20_F1-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match = "Cha-F-000481"
mf["JRC_SS16661-20151125_20_F1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Gad1-F-000079"
mf["JRC_SS16661-20151125_20_F1-Aligned63xScale_c2b.Smt.SptGraph.swc",]$match = "Cha-F-600191"

# L1046; 1A; Av4a2/5/6
mf[c("JRC_SS16786-20151022_19_B3-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS16786-20151022_19_B4-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS16786-20151022_19_B4-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS16786-20151022_19_B6-Aligned63xScale_c1a.Smt.SptGraph.swc",
     "JRC_SS16786-20151022_19_B6-Aligned63xScale_c1b.Smt.SptGraph.swc",
     "JRC_SS16786-20151022_19_B7-Aligned63xScale_c0a.Smt.SptGraph.swc",
     "JRC_SS16786-20151022_19_B7-Aligned63xScale_c0b.Smt.SptGraph.swc",
     "JRC_SS16786-20151022_19_B7-Aligned63xScale_c1.Smt.SptGraph.swc"),]$old.cell.type = "1A"
mf["JRC_SS16786-20151022_19_B3-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Gad1-F-400436" # Av4a5
mf["JRC_SS16786-20151022_19_B4-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Cha-F-000481" # Av4a5
mf["JRC_SS16786-20151022_19_B4-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Gad1-F-100051" # AV4b5
mf["JRC_SS16786-20151022_19_B6-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match = "fru-F-600131" # Av4a6
mf["JRC_SS16786-20151022_19_B6-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match = "Gad1-F-700106" # Av4a2
mf["JRC_SS16786-20151022_19_B7-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match = "Cha-F-000481" # Av4a5
mf["JRC_SS16786-20151022_19_B7-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match = "fru-F-600131" # Av4a6
mf["JRC_SS16786-20151022_19_B7-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Gad1-F-400436" # Av4a5

# L1827; 29E & others; PV4b1/2
mf[c("JRC_SS22732-20180209_20_B1-Aligned63xScale_c0a.Smt.SptGraph.swc",
     "JRC_SS22732-20180209_20_B1-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "29E"
mf[c("JRC_SS22732-20180209_20_B1-Aligned63xScale_c2b.Smt.SptGraph.swc"),]$old.cell.type = ""
mf[c("JRC_SS22732-20180209_20_B2-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS22732-20180209_20_B4-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS22732-20180209_20_B4-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS22732-20180209_20_B5-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS22732-20180209_20_B5-Aligned63xScale_c2b.Smt.SptGraph.swc",
     "JRC_SS22732-20180209_20_B6-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS22732-20180209_20_B6-Aligned63xScale_c1b.Smt.SptGraph.swc",
     "JRC_SS22732-20180209_20_B6-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS22732-20180209_20_B7-Aligned63xScale_c1a.Smt.SptGraph.swc",
     "JRC_SS22732-20180209_20_B7-Aligned63xScale_c1b.Smt.SptGraph.swc"),]$old.cell.type = "29E"
# PV4b4
mf["JRC_SS22732-20180209_20_B1-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match = "PV4b4"
mf["JRC_SS22732-20180209_20_B1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "PV4b4"
# AD1d1
mf["JRC_SS22732-20180209_20_B1-Aligned63xScale_c2b.Smt.SptGraph.swc",]$match = "Gad1-F-300229"
# PV4b1/2
mf["JRC_SS22732-20180209_20_B2-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "140117c2"
mf["JRC_SS22732-20180209_20_B4-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "VGlut-F-700602"
mf["JRC_SS22732-20180209_20_B4-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "140117c2"
mf["JRC_SS22732-20180209_20_B5-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "VGlut-F-400084"
mf["JRC_SS22732-20180209_20_B5-Aligned63xScale_c2b.Smt.SptGraph.swc",]$match = "VGlut-F-400084"
mf["JRC_SS22732-20180209_20_B6-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "VGlut-F-400084"
mf["JRC_SS22732-20180209_20_B6-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match = "VGlut-F-400084" # Duplicated
mf["JRC_SS22732-20180209_20_B6-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "VGlut-F-400084"
mf["JRC_SS22732-20180209_20_B7-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match = "VGlut-F-400084"
mf["JRC_SS22732-20180209_20_B7-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match = "140117c2"

# L629; 27A + 4A; AV2a1/2 + PV4a6 (# Segmentation AV2a1)
mf[c("JRC_SS22737-20160624_20_B3-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS22737-20160624_20_B3-Aligned63xScale_c0b.Smt.SptGraph.swc",
     "JRC_SS22737-20160624_20_B4-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS22737-20160624_20_B4-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS22737-20160624_20_B4-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS22737-20160624_20_B5-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS22737-20160624_20_B5-Aligned63xScale_c2b.Smt.SptGraph.swc"),]$old.cell.type = "27A"
mf[c("JRC_SS22737-20160624_20_B5-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "4A"
# Av2
mf["JRC_SS22737-20160624_20_B3-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Gad1-F-800214"
mf["JRC_SS22737-20160624_20_B3-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match = "Gad1-F-800214"
mf["JRC_SS22737-20160624_20_B4-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Gad1-F-800214"
mf["JRC_SS22737-20160624_20_B4-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Gad1-F-800214" # Duplicated
mf["JRC_SS22737-20160624_20_B4-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Gad1-F-800214"
mf["JRC_SS22737-20160624_20_B5-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Gad1-F-800214"
mf["JRC_SS22737-20160624_20_B5-Aligned63xScale_c2b.Smt.SptGraph.swc",]$match = "fru-F-200126"
# PV4
mf["JRC_SS22737-20160624_20_B5-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Gad1-F-200395"

# L1842; 4G; PV4c2
mf[c("JRC_SS23341-20160805_24_A1-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS23341-20160805_24_A1-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS23341-20160805_24_A1-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS23341-20160805_24_A1-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS23341-20160805_24_A4-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS23341-20160805_24_A4-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS23341-20160805_24_A5-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS23341-20160805_24_A7-Aligned63xScale_c1.Smt.SptGraph.swc"),]$old.cell.type = "27A"
mf["JRC_SS23341-20160805_24_A1-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Gad1-F-100178"
mf["JRC_SS23341-20160805_24_A1-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Gad1-F-100178" # Duplicated
mf["JRC_SS23341-20160805_24_A1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Gad1-F-100178" # Duplicated
mf["JRC_SS23341-20160805_24_A1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Gad1-F-700258"
mf["JRC_SS23341-20160805_24_A4-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Gad1-F-700258"
mf["JRC_SS23341-20160805_24_A4-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Gad1-F-700258" # Duplicated
mf["JRC_SS23341-20160805_24_A5-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Gad1-F-700258"
mf["JRC_SS23341-20160805_24_A7-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Gad1-F-700258"

# L1989; 17C; Av1a1; Good
mf[c("JRC_SS23827-20160902_22_A3-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS23827-20160902_22_A3-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS23827-20160902_22_A3-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS23827-20160902_22_A4-Aligned63xScale_c1.Smt.SptGraph.swc"),]$old.cell.type = "17C"
mf["JRC_SS23827-20160902_22_A3-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Cha-F-200201"
mf["JRC_SS23827-20160902_22_A3-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Cha-F-200201"
mf["JRC_SS23827-20160902_22_A3-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Cha-F-200201"
mf["JRC_SS23827-20160902_22_A4-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Gad1-F-500105"

# L1990; 17C; Av1a1
mf[c("JRC_SS23828-20160902_22_G1-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS23828-20160902_22_G1-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS23828-20160902_22_G1-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS23828-20160902_22_G4-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS23828-20160902_22_G4-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS23828-20160902_22_G5-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS23828-20160902_22_G7-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS23828-20160902_22_G7-Aligned63xScale_c1b.Smt.SptGraph.swc"),]$old.cell.type = "17C"
mf["JRC_SS23828-20160902_22_G1-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Cha-F-200201"
mf["JRC_SS23828-20160902_22_G1-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Cha-F-200201"
mf["JRC_SS23828-20160902_22_G1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Cha-F-200201"
mf["JRC_SS23828-20160902_22_G4-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Cha-F-200201"
mf["JRC_SS23828-20160902_22_G4-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Cha-F-200201" # Duplicated
mf["JRC_SS23828-20160902_22_G5-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Cha-F-200201"
mf["JRC_SS23828-20160902_22_G7-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Cha-F-200201" # Duplicated
mf["JRC_SS23828-20160902_22_G7-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match = "Cha-F-200201"

# L240; 1B; Av4a2/3/5
mf[c("JRC_SS10567-20151008_22_D1-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS10567-20151008_22_D1-Aligned63xScale_c0b.Smt.SptGraph.swc",
     "JRC_SS10567-20151008_22_D1-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS10567-20151008_22_D1-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS10567-20151008_22_D2-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS10567-20151008_22_D2-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS10567-20151008_22_D4-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS10567-20151008_22_D4-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS10567-20151008_22_D6-Aligned63xScale_c0b.Smt.SptGraph.swc",
     "JRC_SS10567-20151008_22_D6-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS10567-20151008_22_D7-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS10567-20151008_22_D7-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS10567-20160408_21_A1-Aligned63xScale_c0a.Smt.SptGraph.swc",
     "JRC_SS10567-20160408_21_A1-Aligned63xScale_c0b.Smt2.SptGraph.swc",
     "JRC_SS10567-20160408_21_A1-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS10567-20160408_21_A1-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS10567-20160408_21_A2-Aligned63xScale_c0a.Smt.SptGraph.swc",
     "JRC_SS10567-20160408_21_A2-Aligned63xScale_c0b.Smt.SptGraph.swc",
     "JRC_SS10567-20160408_21_A2-Aligned63xScale_c1a.Smt2.SptGraph.swc",
     "JRC_SS10567-20160408_21_A2-Aligned63xScale_c1b.Smt.SptGraph.swc",
     "JRC_SS10567-20160408_21_A2-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS10567-20160408_21_A4-Aligned63xScale_c0.Smt2.SptGraph.swc",
     "JRC_SS10567-20160408_21_A4-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "1B"
mf["JRC_SS10567-20151008_22_D1-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="Cha-F-300146"
mf["JRC_SS10567-20151008_22_D1-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match ="Gad1-F-000079"
mf["JRC_SS10567-20151008_22_D1-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Gad1-F-000079"
mf["JRC_SS10567-20151008_22_D1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="Gad1-F-000079"
mf["JRC_SS10567-20151008_22_D2-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="Gad1-F-400436"
mf["JRC_SS10567-20151008_22_D2-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Gad1-F-400436"
mf["JRC_SS10567-20151008_22_D4-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="Cha-F-000481"
mf["JRC_SS10567-20151008_22_D4-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Cha-F-000481"
mf["JRC_SS10567-20151008_22_D6-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match ="Gad1-F-000079"
mf["JRC_SS10567-20151008_22_D6-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Cha-F-000524"
mf["JRC_SS10567-20151008_22_D7-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="Gad1-F-400436"
mf["JRC_SS10567-20151008_22_D7-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Trh-M-500176"
mf["JRC_SS10567-20160408_21_A1-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match ="Cha-F-600191"
mf["JRC_SS10567-20160408_21_A1-Aligned63xScale_c0b.Smt2.SptGraph.swc",]$match ="Cha-F-000481"
mf["JRC_SS10567-20160408_21_A1-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Gad1-F-000079"
mf["JRC_SS10567-20160408_21_A1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="Gad1-F-000079"
mf["JRC_SS10567-20160408_21_A2-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match ="Gad1-F-000079"
mf["JRC_SS10567-20160408_21_A2-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match ="Cha-F-000481"
mf["JRC_SS10567-20160408_21_A2-Aligned63xScale_c1a.Smt2.SptGraph.swc",]$match ="Gad1-F-000079" # Duplicated
mf["JRC_SS10567-20160408_21_A2-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match ="Gad1-F-000079"
mf["JRC_SS10567-20160408_21_A2-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="Gad1-F-000079" # Duplicated
mf["JRC_SS10567-20160408_21_A4-Aligned63xScale_c0.Smt2.SptGraph.swc",]$match ="Gad1-F-000079"
mf["JRC_SS10567-20160408_21_A4-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="Gad1-F-000079"

# L374; 3E; PV5g1/2 (#Segmentation PV5g1)
mf[c("JRC_SS15112-20180209_20_E1-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS15112-20180209_20_E1-Aligned63xScale_c1b.Smt2.SptGraph.swc",
     "JRC_SS15112-20180209_20_E1-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS15112-20180209_20_E2-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS15112-20180209_20_E2-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS15112-20180209_20_E5-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS15112-20180209_20_E7-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS15112-20180209_20_E7-Aligned63xScale_c1.Smt.SptGraph.swc"),]$old.cell.type = "3E"
mf["JRC_SS15112-20180209_20_E1-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Gad1-F-200177"
mf["JRC_SS15112-20180209_20_E1-Aligned63xScale_c1b.Smt2.SptGraph.swc",]$match = "Gad1-F-200177"
mf["JRC_SS15112-20180209_20_E1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Gad1-F-200177"
mf["JRC_SS15112-20180209_20_E2-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Gad1-F-200177"
mf["JRC_SS15112-20180209_20_E2-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Gad1-F-200177" # Duplicated
mf["JRC_SS15112-20180209_20_E5-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="Gad1-F-300312"
mf["JRC_SS15112-20180209_20_E7-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="Gad1-F-300312"
mf["JRC_SS15112-20180209_20_E7-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Gad1-F-300312" # Duplicated

# L194; 116A; PD3a1 only
mf[c("JRC_SS15256-20151009_19_E1-Aligned63xScale_c1.Smt.SptGraph.swc"),]$old.cell.type = "116A"
mf["JRC_SS15256-20151009_19_E1-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Cha-F-500011"



# L259; 54A; PV2a1
mf[c("JRC_SS15285-20150828_23_A1-Aligned63xScale_c0a.Smt.SptGraph.swc",
     "JRC_SS15285-20150828_23_A1-Aligned63xScale_c0b.Smt.SptGraph.swc",
     "JRC_SS15285-20150828_23_A1-Aligned63xScale_c1a.Smt.SptGraph.swc",
     "JRC_SS15285-20150828_23_A1-Aligned63xScale_c1b.Smt.SptGraph.swc",
     "JRC_SS15285-20150828_23_A1-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS15285-20150828_23_A1-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "54A"
mf["JRC_SS15285-20150828_23_A1-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match ="Cha-F-400222"
mf["JRC_SS15285-20150828_23_A1-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match ="Cha-F-300168"
mf["JRC_SS15285-20150828_23_A1-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match ="Cha-F-400222"
mf["JRC_SS15285-20150828_23_A1-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match ="Cha-F-300168"
mf["JRC_SS15285-20150828_23_A1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="5HT1A-F-100028"
mf["JRC_SS15285-20150828_23_A1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Cha-F-400222"

# L62; 12B 4? 29C; PV4d8
mf[c("JRC_SS15256-20151009_19_E1-Aligned63xScale_c1.Smt.SptGraph.swc"),]$old.cell.type = "4?"
mf["JRC_SS15289-20160226_20_F2-Aligned63xScale_c0.Smt2.SptGraph.swc",]$match = "PV4d8"

# L1293; 12A; PV5c1
mf[c("JRC_SS16977-20150828_24_D4-Aligned63xScale_c1a.Smt.SptGraph.swc",
     "JRC_SS16977-20150828_24_D4-Aligned63xScale_c1b.Smt.SptGraph.swc",
     "JRC_SS16977-20150828_24_D4-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS16977-20150828_24_E1-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS16977-20151002_21_G2-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS16977-20151002_21_G2-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS16977-20151002_21_G4-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS16977-20151002_21_G4-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS16977-20151002_21_G4-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS16977-20151002_21_G7-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS16977-20151002_21_G7-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS16977-20170623_22_D1-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS16977-20170623_22_D1-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS16977-20170623_22_D3-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS16977-20170623_22_D3-Aligned63xScale_c3.Smt.SptGraph.swc",
     "JRC_SS16977-20170623_22_D8-Aligned63xScale_c0.Smt.SptGraph.swc"),]$old.cell.type = "12A"
mf["JRC_SS16977-20150828_24_D4-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match = "E0585-F-400025"
mf["JRC_SS16977-20150828_24_D4-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match = "130814c0" # Check, bad match, 130814c0? 130712c1? 130711c1?
mf["JRC_SS16977-20150828_24_D4-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "E0585-F-400025"
mf["JRC_SS16977-20150828_24_E1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "E0585-F-400025"
mf["JRC_SS16977-20151002_21_G2-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "E0585-F-400025"
mf["JRC_SS16977-20151002_21_G2-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "E0585-F-400025"
mf["JRC_SS16977-20151002_21_G4-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "130814c0"
mf["JRC_SS16977-20151002_21_G4-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "130814c0" # Duplicated
mf["JRC_SS16977-20151002_21_G4-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "130814c0" # Duplicated
mf["JRC_SS16977-20151002_21_G7-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Cha-F-000317"
mf["JRC_SS16977-20151002_21_G7-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "E0585-F-300071"
mf["JRC_SS16977-20170623_22_D1-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "E0585-F-300071"
mf["JRC_SS16977-20170623_22_D1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "E0585-F-300071" # Duplicated
mf["JRC_SS16977-20170623_22_D3-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "E0585-F-400008"
mf["JRC_SS16977-20170623_22_D3-Aligned63xScale_c3.Smt.SptGraph.swc",]$match = "E0585-F-400008"
mf["JRC_SS16977-20170623_22_D8-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Cha-F-000317"

# L1594; 101; Av4b1; Good
mf[c("JRC_SS16986-20180209_21_B3-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS16986-20180209_21_B3-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "101"
mf["JRC_SS16986-20180209_21_B3-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Cha-F-800067"
mf["JRC_SS16986-20180209_21_B3-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Cha-F-800067" # Duplicated

# L2278; 16B; AD1b2
mf[c("JRC_SS24645-20161007_28_B3-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS24645-20161007_28_B4-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS24645-20161007_28_B6-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS24645-20161007_28_B7-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS24645-20161007_28_B7-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS24645-20161007_28_B7-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "16B"
mf["JRC_SS24645-20161007_28_B3-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "120714c4"
mf["JRC_SS24645-20161007_28_B4-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "120714c4"
mf["JRC_SS24645-20161007_28_B6-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "120714c4"
mf["JRC_SS24645-20161007_28_B7-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "120714c4"
mf["JRC_SS24645-20161007_28_B7-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "120714c4" # Duplicated
mf["JRC_SS24645-20161007_28_B7-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "120714c4" # Duplicated

# L2385; 116B; PD3a2
mf[c("JRC_SS24840-20160909_25_F1-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS24840-20160909_25_F1-Aligned63xScale_c1.Smt.SptGraph.swc"),]$old.cell.type = "116B"
mf["JRC_SS24840-20160909_25_F1-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Gad1-F-200150"
mf["JRC_SS24840-20160909_25_F1-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Gad1-F-200150"

# L876; 116A + 27A; PD3a1/2 + Av2a2/e1
mf[c("JRC_SS25832-20170324_29_D5-Aligned63xScale_c0a.Smt.SptGraph.swc",
     "JRC_SS25832-20170324_29_D5-Aligned63xScale_c0b.Smt.SptGraph.swc",
     "JRC_SS25832-20170324_29_D5-Aligned63xScale_c1a.Smt.SptGraph.swc",
     "JRC_SS25832-20170324_29_E1-Aligned63xScale_c0.Smt.SptGraph.swc",
     "JRC_SS25832-20170324_29_E1-Aligned63xScale_c1.Smt.SptGraph.swc"),]$old.cell.type = "27A"
mf[c("JRC_SS25832-20170324_29_D5-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS25832-20170324_29_E1-Aligned63xScale_c2.Smt.SptGraph.swc"),]$old.cell.type = "116B"
mf["JRC_SS25832-20170324_29_D5-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match = "Cha-F-500105"
mf["JRC_SS25832-20170324_29_D5-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match = "Gad1-F-500140"
mf["JRC_SS25832-20170324_29_D5-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match = "Gad1-F-500140"
mf["JRC_SS25832-20170324_29_E1-Aligned63xScale_c0.Smt.SptGraph.swc",]$match = "Cha-F-500105"
mf["JRC_SS25832-20170324_29_E1-Aligned63xScale_c1.Smt.SptGraph.swc",]$match = "Cha-F-500105" # Duplicated
# PD3a
mf["JRC_SS25832-20170324_29_D5-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Gad1-F-200150"
mf["JRC_SS25832-20170324_29_E1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match = "Cha-F-400165"

# L1479; 1H; AV4a1
mf[c("JRC_SS04973-20151125_23_E4-Aligned63xScale_c0.Smt.SptGraph.swc"),]$old.cell.type = "1H"
mf["JRC_SS04973-20151125_23_E4-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="fru-M-700211"

# L979; 29D + others; PV4d3/4 (+ PV1a1 - in image?)
mf[c("JRC_SS04972-20180209_21_F8-Aligned63xScale_c1.Smt.SptGraph.swc",
     "JRC_SS04972-20180209_21_F8-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS04972-20180209_21_F8-Aligned63xScale_c0b.Smt.SptGraph.swc",
     "JRC_SS04972-20180209_21_F8-Aligned63xScale_c0a.Smt.SptGraph.swc",
     "JRC_SS04972-20180209_21_F5-Aligned63xScale_c2b.Smt.SptGraph.swc",
     "JRC_SS04972-20180209_21_F5-Aligned63xScale_c2.Smt.SptGraph.swc",
     "JRC_SS04972-20180209_21_F5-Aligned63xScale_c1.Smt.SptGraph.swc"),]$old.cell.type = "29D"
mf["JRC_SS04972-20180209_21_F8-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Cha-F-600209"
mf["JRC_SS04972-20180209_21_F8-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="Cha-F-600209"
mf["JRC_SS04972-20180209_21_F8-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match ="130912c1"
mf["JRC_SS04972-20180209_21_F8-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match ="130912c1"
mf["JRC_SS04972-20180209_21_F5-Aligned63xScale_c2b.Smt.SptGraph.swc",]$match ="Cha-F-600209"
mf["JRC_SS04972-20180209_21_F5-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="Cha-F-600209"
mf["JRC_SS04972-20180209_21_F5-Aligned63xScale_c1.Smt.SptGraph.swc",]$match ="Cha-F-600209"

# Not LH proper
mf["JRC_SS15112-20180209_20_E1-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="Trh-M-100087"
mf["JRC_SS04720-20160819_21_C7-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match ="notLHproper"
mf["JRC_SS04720-20160819_21_C7-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match ="notLHproper"
mf["JRC_SS04720-20170623_23_A2-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match ="notLHproper"
mf["JRC_SS10567-20151008_22_D6-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match ="notLHproper"
mf["JRC_SS15112-20180209_20_E5-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="notLHproper"
mf["JRC_SS16786-20151022_19_B3-Aligned63xScale_c0a.Smt.SptGraph.swc",]$match ="notLHproper"
mf["JRC_SS16786-20151022_19_B3-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match ="notLHproper"
mf["JRC_SS16786-20151022_19_B6-Aligned63xScale_c0b.Smt.SptGraph.swc",]$match ="notLHproper"
mf["JRC_SS16786-20151022_19_B6-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="notLHproper"
mf["JRC_SS23347-20170303_26_E2-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="notLHproper"
mf["JRC_SS23347-20170303_26_E2-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="notLHproper"

# Mis-registered
mf["JRC_SS03802-20180209_20_A8-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="mis-registered"
mf["JRC_SS03802-20180209_20_A8-Aligned63xScale_c2b.Smt.SptGraph.swc",]$match ="mis-registered"
mf["JRC_SS03802-20180209_20_A8-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="mis-registered"
mf["JRC_SS04958-20160225_19_C2-Aligned63xScale_c2a.Smt.SptGraph.swc",]$match ="mis-registered"
mf["JRC_SS04967-20151022_20_A1-Aligned63xScale_c1b.Smt.SptGraph.swc",]$match ="mis-registered"
mf["JRC_SS04967-20151022_20_A1-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="mis-registered"
mf["JRC_SS04967-20151022_20_A3-Aligned63xScale_c1a.Smt.SptGraph.swc",]$match ="mis-registered"
mf["JRC_SS22723-20170324_29_F5-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="mis-registered"
mf["JRC_SS03225-20150828_24_G1-Aligned63xScale_c2b.Smt.SptGraph.swc",]$match = "mis-registered" # Or "131204c0"

# Badly traced
mf["JRC_SS22732-20180209_20_B7-Aligned63xScale_c2.Smt.SptGraph.swc",]$match ="mis-registered"
mf["JRC_SS16329-20151125_23_A6-Aligned63xScale_c0.Smt.SptGraph.swc",]$match ="mis-registered"


# #############
# Make Matches #
###############


df.a = most.lhns[,c("pnt","anatomy.group","cell.type","type")]
df.b = data.frame(pnt = most.lhins[,c("tract")],anatomy.group=most.lhins[,c("anatomy.group")],cell.type=most.lhins[,c("anatomy.group")], type = "IN")
rownames(df.b) = names(most.lhins)
df = rbind(df.b,df.a[!rownames(df.a)%in%rownames(df.b),])
mf$pnt = as.character(sapply(mf$match,function(x) df[x,]$pnt))
mf$anatomy.group = as.character(sapply(mf$match,function(x) df[x,]$anatomy.group))
mf$cell.type = as.character(sapply(mf$match,function(x) df[x,]$cell.type))
mf$type = as.character(sapply(mf$match,function(x) df[x,]$type))



#################
# New cell types #
#################



mf[grepl("PV4d8",mf$match),]$pnt = "PV4"
mf[grepl("PV4d8",mf$match),]$anatomy.group = "PV4d8"
mf[grepl("PV4d8",mf$match),]$type = "ON"
mf[grepl("PV4d8",mf$match),]$cell.type = "PV4d8"

mf[grepl("PV4b4",mf$match),]$pnt = "PV4"
mf[grepl("PV4b4",mf$match),]$anatomy.group = "PV4b4"
mf[grepl("PV4b4",mf$match),]$type = "ON"
mf[grepl("PV4b4",mf$match),]$cell.type = "PV4b4"

mf[grepl("PD3a3",mf$match),]$pnt = "PD3"
mf[grepl("PD3a3",mf$match),]$anatomy.group = "PD3a"
mf[grepl("PD3a3",mf$match),]$type = "LN"
mf[grepl("PD3a3",mf$match),]$cell.type = "PD3a3"

mf[grepl("PD2e2",mf$match),]$pnt = "PD2"
mf[grepl("PD2e2",mf$match),]$anatomy.group = "PD2e"
mf[grepl("PD2e2",mf$match),]$type = "ON"
mf[grepl("PD2e2",mf$match),]$cell.type = "PD2e2"



# ###########
# Save data #
#############


lh.mcfo = mcfo
r <- rle(as.character(mf$linecode))
rownames(mf) = names(lh.mcfo) = paste0(rep(r$values, times = r$lengths), "#",unlist(lapply(r$lengths, seq_len)))
attr(lh.mcfo,"df") = mf
#lh.mcfo = subset(lh.mcfo,!is.na(cell.type)|cell.type=="notLHproper")


# #################
# Update Meta-Data #
###################


lh.mcfo = nlapply(lh.mcfo,nat::resample,stepsize = 1)
lh.mcfo = as.neuronlistfh(lh.mcfo,dbdir = 'inst/extdata/data/', WriteObjects="missing")
lh.mcfo.dps = nat::dotprops(lh.mcfo,OmitFailures=TRUE)
lh.mcfo.dps = as.neuronlistfh(lh.mcfo.dps,dbdir = 'inst/extdata/data/', WriteObjects="missing")


#####################
# Write neuronlistfh #
#####################


write.neuronlistfh(lh.mcfo, file='inst/extdata/lh.mcfo.rds',overwrite = TRUE)
write.neuronlistfh(lh.mcfo.dps, file='inst/extdata/lh.mcfo.dps.rds',overwrite = TRUE)


