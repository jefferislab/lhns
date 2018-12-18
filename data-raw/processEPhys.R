#######################
# Process E-Phys Data #
#######################

# Load required libraries
library(physplit.analysis)
library(physplitdata)

### Let's make a lighter, simplified version of the E-Phys data to use in the LHlibrary Shiny App ###

# get dye filled skeletons that will have E-Phys data
dye.fills = lhns::most.lhns[grepl("^1",names(lhns::most.lhns))]
cells = paste0("nm20",names(dye.fills))
cells = cells[cells%in%names(physplitdata::smSpikes)]
dye.fills = dye.fills[cells%in%names(physplitdata::smSpikes)] # Final list of neurons for which there is e-phy data

# Get the E-Phys data
physdb = subset(PhySplitDB, !grepl("Old Odor Concentration",comments.IV) & Group %in%c("O", "PN", "L") & cell %in% names(Spikes))
pns = subset(physdb, Group%in%c("PN"))[,"cell"]
gloms = paste0(subset(physdb, Group%in%c("PN"))[,"Anatomy.type"]," PN")
names(gloms) = pns
cells = c(cells,pns)

# # Get ephys data
ephys.lh = physplit.analysis::create_raw_summary_array(x = physplitdata::smSpikes, cells = cells)

# Get odours
odours = colnames(ephys.lh)
odours.long = c("Mineral Oil", "trans-2-Hexenal", "Geranyl acetate", "Propyl acetate", "Isoamyl acetate", "Ethyl 3-hydroxybutyrate", "Nonanal",
                "11-cis Vaccenyl Acetate", "Methyl salicylate", "Hexyl acetate", "Phenethyl alcohol", "Acetoin acetate", "Ethyl hexanoate", "2-Phenethyl acetate",
                "5 odor mix", "Benzaldehyde", "β-Citronellol", "1-Hexanol", "Farnesol", "Water Blank", "Cadaverine",
                "Spermine", "Acetoin", "Methyl acetate", "Acetic acid", "Propionic acid", "Butyric acid", "Ammonia",
                "Pyridine", "Phenylacetaldehyde", "HCl", "Phenylacetic acid", "Vinegar", "Geosmin", "Vinegar and Geosmin mix",
                "Phenethylamine", "Blank1", "Blank2", "FlyFM", "Ethylamine", "MtAmn", "Putrescine",
                "Linalool", "2,3-Butanedione", "Spermidine", "CO2", "Mineral Oil","Valencene", "Methyl laurate",
                "Methyl palmitate", "Methyl myristate", "4-Ethylguaiacol","Nonanal2","Hexyl acetate","Blank3","Ethyl acetate 10^8",
                "Trans-2-hexenal 10^7", "2-butanone 10^6", "Methyl salicylate 10^6")
names(odours.long) = odours

# # Get matrix
# # ephys.lh.a = physplit.analysis::createSummarySpikesArray(summary_array = ephys.lh,NALimit=3,numSamplePoints=7)
# ephys.lh.a = ephys.lh
# odours = rownames(ephys.lh.a[1,,])
# ephys.lh.m =  t(base::apply(ephys.lh.a, 1, base::t)) # Sampled at 7 time points
# choose.just.max1.cols = as.logical(rep(c(0,0,1,0,0,0,0),ncol(ephys.lh.m)/7))
# ephys.lh.m = ephys.lh.m[,choose.just.max1.cols]
# colnames(ephys.lh.m) = odours
# row.cells = rownames(ephys.lh.m)
# row.cells[row.cells%in%pns] = gloms[row.cells[row.cells%in%pns]]
# row.cells[gsub("nm20","",rownames(ephys.lh.m))%in%names(dye.fills)] = dye.fills[gsub("nm20","",rownames(ephys.lh.m)[gsub("nm20","",rownames(ephys.lh.m))%in%names(dye.fills)])][,"cell.type"]
# rownames(ephys.lh.m) = row.cells
# ephys.lh.m = ephys.lh.m[order(rownames(ephys.lh.m)),order(colnames(ephys.lh.m))]
#
# # Select certain odours to show
# ephys.lh.m = ephys.lh.m[!rownames(ephys.lh.m)%in%c("105 PN","103 PN"),]
# ephys.lh.m = ephys.lh.m[,!colnames(ephys.lh.m)%in%c("ClrBL","ClrB2","FlyFM","ClrB1")]
# colnames(ephys.lh.m) = odours.long[colnames(ephys.lh.m)]

# make odour response matrix, summing smoothed spikes in the window 0.7-2.2 seconds
sps = physplitdata::smSpikes[names(physplitdata::smSpikes)%in%cells]
row.cells = names(sps)
M = matrix(ncol = length(odours), nrow = length(row.cells), NA,dimnames = list(row.cells,odours))
for(i in 1:length(sps)){
  sp = sps[[i]]
  for(o in odours){
    M[i,o] = sum(sp[[o]]$counts[sp[[o]]$mids>=0.7&sp[[o]]$mids<=2.2])
  }
}
colnames(M) = odours.long[colnames(M)]
row.cells[row.cells%in%pns] = gloms[row.cells[row.cells%in%pns]]
row.cells[gsub("nm20","",row.cells)%in%names(dye.fills)] = dye.fills[gsub("nm20","",row.cells[gsub("nm20","",row.cells)%in%names(dye.fills)])][,"cell.type"]
M = M[!rownames(M)%in%c("105 PN","103 PN"),]

########
# Save #
########

lhn_odour_responses = M
devtools::use_data(lhn_odour_responses,overwrite=TRUE)

