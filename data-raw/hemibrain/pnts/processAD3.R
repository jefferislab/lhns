#######
# AD3 #
#######
if(!exists("process")){
  source("data-raw/hemibrain/startupHemibrain.R")
  process = TRUE
}

# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
x = c("541615964", "421620469", "547457113", "329215976", "604700963",
      "457516218", "5813040092", "5813010284", "485093313", "634038998",
      "5813011756", "641291034", "360238069", "361269864", "392299403",
      "329561615", "360236750", "610938082", "604705430", "487454622",
      "549895967", "5813035115", "604364004", "5812980272", "457516092",
      "5901208044", "580585427", "360246734", "421310144", "580585323",
      "360583021", "580244242", "580926422", "329906396", "580585459",
      "359913782", "456427944", "360914617", "361955275", "604009598",
      "5813062781", "329210713", "5813010201", "512635818", "580926331",
      "488550675", "391958379", "456427965", "360578907")
ad3 = c(x)
ad4 = y = "360259229"
ad3_ad4 = c(ad3,ad4)

### Get FAFB assigned hemilineage information
# x.match = unique(hemibrain_lhns[x,"FAFB.match"])
# x.match = x.match[!is.na(x.match)]
# x.match = read.neurons.catmaid.meta(x.match)
#
# ### Meta info
# mx = neuprint_get_meta(x)
# table(mx$cellBodyFiber)
#
# ### CBFs:
# ### ADL17^aSIP1
# ADL17 = neuprint_read_neurons("ADL17")
# ADL17 = ADL17[names(ADL17)%in%hemibrain.lhn.bodyids]
# ad3.hemi = c(ADL17)
#
# ### Re-define some of these CBFs
# sd = setdiff(ad3, names(ad3.hemi))
# ds = setdiff(names(ad3.hemi),ad3)
# ad3 = unique(ad3, names(ad3.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% ad3_ad4)
df$cbf.change = FALSE
df$class = "LHN"
df$cell.type = NA
rownames(df) = df$bodyid

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "LHd1"
df[x,"Hartenstein_Hemilineage"] = "DPLd"
df[y,"ItoLee_Hemilineage"] = "LHd1"
df[y,"Hartenstein_Hemilineage"] = "DPLd"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### AD3 ####
############

#####
# a #
#####

a1 = c("361955275", "5813062781")
df[a1,"cell.type"] = "AD3a1"

a2 = c("360246734", "580585323")
df[a2,"cell.type"] = "AD3a2"

a3 = c("421310144", "5901208044", "580585427")
df[a3,"cell.type"] = "AD3a3"

a4 = c("580585459", "5813010201")
df[a4,"cell.type"] = "AD3a4"

a5 = "360914617"
df[a5,"cell.type"] = "AD3a5"

a6 = c("360578907")
df[a6,"cell.type"] = "AD3a6"

a7 = c("580244242", "360583021", "580926422") #
df[a7,"cell.type"] = "AD3a7"

a8 = c("329906396", "580926331") #
df[a8,"cell.type"] = "AD3a8"

a9 = c("359913782", "456427944") #
df[a9,"cell.type"] = "AD3a9"

a10 = "488550675" #
df[a10,"cell.type"] = "AD3a10"

a11 = c("5812980272", "5813011756") #
df[a11,"cell.type"] = "AD3a11"

#####
# b #
#####

b1 = c("604009598", "604705430", "487454622", "549895967",
       "392299403", "360236750", "610938082", "361269864", "634038998",
       "329561615", "457516092", "391958379", "456427965", "5813035115",
       "457516218", "604364004") # light = c("L1828#1", "L20#1", "L304#1", "Cha-F-100001","L19#1")
df[b1,"cell.type"] = "AD3b1"

#####
# c #
#####

c1 = "512635818"
df[c1,"cell.type"] = "AD3c1"

#####
# e #
#####

d1 = c("641291034")
df[d1,"cell.type"] = "AD3d1"

d2 = "485093313"
df[d2,"cell.type"] = "AD3d2"

d3 = "5813010284"
df[d3,"cell.type"] = "AD3d3"

d4 = "541615964"
df[d4,"cell.type"] = "AD3d4"

d5 = "5813040092"
df[d5,"cell.type"] = "AD3d5"

#####
# f #
#####

f1 = c("360238069", "547457113","329210713", "329215976", "421620469", "604700963")
df[f1,"cell.type"] = "AD3f1"


#######
# AD4 #
#######

a1 = "360259229"
df[a1,"cell.type"] = "AD4a1"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/AD3_celltyping.csv", row.names = FALSE)

# Process
if(process){
  # Make 2D Images
  take_pictures(df)

  # Update googlesheet
  write_lhns(df = df, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))
}

