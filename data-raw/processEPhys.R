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
ephys.lhns = physplit.analysis::create_raw_summary_array(x = physplitdata::smSpikes, cells = cells)

# Get odours
odours = colnames(ephys.lhns)
odours.long = c("Mineral Oil", "trans-2-Hexenal", "trans-2-Hexenal", "Propyl acetate", "Isoamyl acetate", "Ethyl 3-hydroxybutyrate", "Nonanal",
                "11-cis Vaccenyl Acetate", "Methyl salicylate", "Hexyl acetate", "Phenethyl alcohol", "Acetoin acetate", "Ethyl hexanoate", "2-Phenethyl acetate",
                "5 odor mix", "Benzaldehyde", "β-Citronellol", "1-Hexanol", "Farnesol", "Water Blank", "Cadaverine",
                "Spermine", "Acetoin", "Methyl acetate", "Methyl acetate", "Propionic acid", "Butyric acid", "Ammonia",
                "Pyridine", "Pyridine", "HCl", "Phenylacetic acid", "Vinegar", "Geosmin", "Vineger and Geosmin mix",
                "Phenethylamine", "Blank1", "Blank2", "FlyFM", "Ethylamine", "MtAmn", "Putrescine",
                "Linalool", "2,3-Butanedione", "Spermidine", "CO2")
names(odours.long) = odours

# Get matrix
ephys.lhns.m = physplit.analysis::createSummarySpikesMat(ephys.lhns,NALimit=10,numSamplePoints=7)
choose.just.max1.cols = as.logical(rep(c(0,0,1,0,0,0,0),ncol(ephys.lhns.m)/7))
ephys.lhns.m = ephys.lhns.m[,choose.just.max1.cols]
colnames(ephys.lhns.m) = odours[1:ncol(ephys.lhns.m)]
row.cells = dye.fills[gsub("nm20","",rownames(ephys.lhns.m))]
rownames(ephys.lhns.m) = row.cells[,"cell.type"]
ephys.lhns.m = ephys.lhns.m[order(rownames(ephys.lhns.m)),order(colnames(ephys.lhns.m))]

# Select certain odours to show
ephys.lhns.m = ephys.lhns.m[,!colnames(ephys.lhns.m)%in%c("ClrBL","ClrB2","FlyFM")]
colnames(ephys.lhns.m) = odours.long[colnames(ephys.lhns.m)]

########
# Save #
########

lhn_odour_responses = ephys.lhns.m
devtools::use_data(lhn_odour_responses,overwrite=TRUE)

