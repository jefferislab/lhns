##########################################
# Process Jeanne functional connectivity #
##########################################

if(!exists("jfw.lhns")){
  stop("Please run processJJLHNs.R!")
}

# Get data
load("data-raw/jj.m.fcwb.rda")
df = jj.m.fcwb[,]

# All by all NBLAST
nb = nblast_allbyall(nat::dotprops(jj.m.fcwb,resample=1),normalisation="normalised")

# Re-order the data based on NBLAST score
clust=nhclust(scoremat=nb)
