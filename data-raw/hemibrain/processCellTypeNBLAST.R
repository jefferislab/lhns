####################
# cell type NBLAST #
####################

# pnt is a vector of bodyids to examine
nblast = hemibrain_all_nblast[pnts,pnts]

# Read neurons
pnts.meta = neuprint_get_meta(pnts)
ns = neuprint_search(paste(unique(pnts.meta$type),collapse="|"),field="type")
pnt.neurons = neuprint_read_neurons(ns$bodyid)

# NBLAST dendrogram cut-height
h = 0.5

# Cluster
fibsem.hclust=nhclust(scoremat = nblast)
dkcs=dendroextras::colour_clusters(fibsem.hclust, h = h)
k = max(dendextend::cutree(dkcs,h=h))
plot(dkcs)
abline(h=h)

# Choose height
h = readline("Choose a value by which to cut the dendrogram (recommended 0.5, shown) ")
h = as.numeric(h)

# Scan
nopen3d()
message("Present cluster shown in colours Previous in light grey, next in dark grey.")
for(i in 1:k){

    # Get NBLAST cluster
    clear3d()
    message(i)
    if(i>1){
      n0 = subset(fibsem.hclust, groups = c(i-1), h = h)
      neurons0 = pnt.neurons[n0]
    }
    n1 = subset(fibsem.hclust, groups = c(i), h = h)
    n2 = subset(fibsem.hclust, groups = c(i+1), h = h)
    neurons = pnt.neurons[n1]
    neurons2 = pnt.neurons[n2]
    ito.cts = unique(pnt.neurons[n1,"type"])
    cols = rainbow(length(ito.cts))

    # Set up rgl
    clear3d()
    mat <- matrix(1:2, nrow = 1, 2)
    layout3d(mat, height = 3, sharedMouse = TRUE)

    # Plot
    next3d()
    rgl.viewpoint(userMatrix = structure(c(0.988000273704529, -0.0847902745008469,
                                           -0.129098162055016, 0, 0.0781147107481956, -0.446752369403839,
                                           0.891240775585175, 0, -0.133243337273598, -0.890630483627319,
                                           -0.434768080711365, 0, 0, 0, 0, 1), .Dim = c(4L, 4L)), zoom = 1)
    plot3d(hemibrain.lhr, alpha = 0.1, col = "grey", add = TRUE)
    for(i in 1:length(ito.cts)){
      ilhns = subset(pnt.neurons, type==ito.cts[i])
      plot3d(ilhns, lwd = 2, soma = 500, col = cols[i])
    }
    next3d()
    rgl.viewpoint(userMatrix = structure(c(0.988000273704529, -0.0847902745008469,
                                           -0.129098162055016, 0, 0.0781147107481956, -0.446752369403839,
                                           0.891240775585175, 0, -0.133243337273598, -0.890630483627319,
                                           -0.434768080711365, 0, 0, 0, 0, 1), .Dim = c(4L, 4L)), zoom = 1)
    plot3d(hemibrain.lhr, alpha = 0.1, col = "grey", add = TRUE)
    dput(names(neurons))
    if(i>i){
      plot3d(neurons0, col= "lightgrey", lwd = 2, soma = 500);
    }
    plot3d(neurons, lwd = 2, soma = 500);
    if(length(n2)){
      plot3d(neurons2, col = "darkgrey", soma = 500);
    }
    highlevel(integer())
    p = readline("Continue? ")
}




