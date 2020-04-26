####################
# Process Raw Data #
####################
library(elmr)
library(catnat)

###################################
# Generate Primary Neurite Tracts #
###################################


### Make a model of all the tracts that can be viewed easily
pnts = sort(unique(most.lhns[,"pnt"]))
pnts = pnts[pnts!="notLHproper"]
message("Finding primary.neurite.tracts for all neurons!")
most.lhns.pnts = catnat::primary.neurite(most.lhns)
message("Making average primary.neurite.tracts!")
primary.neurite.tracts = nlapply(pnts,function(z) catnat::average.tracts(subset(most.lhns.pnts,pnt==z),mode=1))
names(primary.neurite.tracts) = pnts
attr(primary.neurite.tracts,"df") = data.frame(pnt=names(primary.neurite.tracts))

#############
# Save data #
#############

message("Saving data!")
devtools::use_data(primary.neurite.tracts,overwrite=TRUE,compress=TRUE) # Save PNT, averaged structures
