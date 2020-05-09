#######
# PV5 #
#######
source("data-raw/hemibrain/startupHemibrain.R")

# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
x = c("511271574",
         "360284300",
         "579912201",
         "5813068669",
         "517506265",
         "330268940",
         "328861282",
         "487144598",
         "327499164",
         "5813020988")

### Get FAFB assigned hemilineage information
x.match = unique(hemibrain_lhns[x,"FAFB.match"])
x.match = x.match[!is.na(x.match)]
x.match = read.neurons.catmaid.meta(x.match)

### Meta info
mx = neuprint_get_meta(x)
table(mx$cellBodyFiber)

### Set-up data.frame
df = subset(namelist, bodyid %in% x)
df$cbf.change = FALSE
df$cell.type = NA
rownames(df) = df$bodyid

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "primary"
df[x,"Hartenstein_Hemilineage"] = "primary"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### Cent ###
############

c8 = c("511271574",
       "360284300")
df[c8,] = "CENT8"

c5 = c("579912201")
df[c5,] = "CENT5"

c6 = c("5813068669")
df[c6,] = "CENT6"

c4 = c("517506265")
df[c4,] = "CENT4"

c9 = c("330268940")
df[c9,] = "CENT9"

c1 = c("328861282")
df[c1,] = "CENT1"

c3 = c("487144598")
df[c3,] = "CENT3"

c2 = c("327499164")
df[c2,] = "CENT2"

lhmb1 = c("5813020988")
df[lhmb1,] = "LHMB1"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/CENT_celltyping.csv", row.names = FALSE)

# Make 2D Images
take_pictures(df, pnt="CENT")

# Update googlesheet
write_lhns(df = df, column = c("cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))


