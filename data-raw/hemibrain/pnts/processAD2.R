#######
# AD2 #
#######
if(!exists("process")){
  source("data-raw/hemibrain/startupHemibrain.R")
  process = TRUE
}

# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
x = c( "702364805", "706831482" )
y = c("670219670", "574027813", "760272462", "576843029", "666136034",
      "573713481", "917497441", "361968122", "330604760", "390952738",
      "788519447")
ad2 = c(x, y)


### Get FAFB assigned hemilineage information
# x.match = unique(hemibrain_lhns[x,"FAFB.match"])
# x.match = x.match[!is.na(x.match)]
# x.match = read.neurons.catmaid.meta(x.match)
# y.match = unique(hemibrain_lhns[y,"FAFB.match"])
# y.match = y.match[!is.na(y.match)]
# y.match = read.neurons.catmaid.meta(y.match)

# ### Meta info
# mx = neuprint_get_meta(x)
# my = neuprint_get_meta(y)
# table(mx$cellBodyFiber)
# table(my$cellBodyFiber)
#
# ### CBFs:
# ### ADL14^dAOTU2 ADL18^dAOTU3 ADL12^dAOTU1
# ADL14 = neuprint_read_neurons("ADL14")
# ADL14 = ADL14[names(ADL14)%in%hemibrain.lhn.bodyids]
# ADL18 = neuprint_read_neurons("ADL18")
# ADL18 = ADL18[names(ADL18)%in%hemibrain.lhn.bodyids]
# ADL12 = neuprint_read_neurons("ADL12")
# ADL12 = ADL12[names(ADL12)%in%hemibrain.lhn.bodyids]
# ad2.hemi = c(ADL14,ADL18, ADL12)
#
# ### Re-define some of these CBFs
# sd = setdiff(ad2, names(ad2.hemi))
# ds = setdiff(names(ad2.hemi),ad2)
# ad2 = unique(ad2, names(ad2.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% ad2)
df$cbf.change = FALSE
df$class = "LHN"
df$cell.type = NA
rownames(df) = df$bodyid

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "SLPad1"
df[x,"Hartenstein_Hemilineage"] = "DPLl3"
df[y,"ItoLee_Hemilineage"] = "VLPd1"
df[y,"Hartenstein_Hemilineage"] = "DPLam"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### ad2x ###
############

# a1 = c("767433432", "790629881", "727153132", "795745097") # light = c("fru-F-500117", "fru-F-400067", "fru-F-500116", "fru-F-500184","fru-F-700078")
# df[a1,"cell.type"] = "AD2a1"

# a2 = c("642948546", "391652073", "328543082", "359913281") # light = c("VGlut-F-500148")
# df[a2,"cell.type"] = "AD2a2"

b1 = "702364805"
df[b1,"cell.type"] = "AD2b1"

############
### ad2y ###
############

e1 = "390952738" # keep
df[e1,"cell.type"] = "AD2e1"

e2 = "330604760"
df[e2,"cell.type"] = "AD2e2"

e3 = "361968122"
df[e3,"cell.type"] = "AD2e3"

d1 = "706831482"
df[d1,"cell.type"] = "AD2d1"

# d2 = c("541347811", "604070433") # dead
# df[d2,"cell.type"] = "AD2d2"

c1 = c("576843029", "573713481")
df[c1,"cell.type"] = "AD2c1"

c2 = c("666136034", "917497441")
df[c2,"cell.type"] = "AD2c2"

c3 = c("788519447", "574027813", "760272462")
df[c3,"cell.type"] = "AD2c3"

ff = "670219670"
df[f1,"cell.type"] = "AD2f1"

# f1 = "421668365"
# df[f1,"cell.type"] = "AD2f1" # dead
#
# f2 = "5813010770"
# df[f2,"cell.type"] = "AD2f2" # dead

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/AD2_celltyping.csv", row.names = FALSE)

# Process
if(process){
  # Make 2D Images
  take_pictures(df)

  # Update googlesheet
  write_lhns(df = df, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))
}

