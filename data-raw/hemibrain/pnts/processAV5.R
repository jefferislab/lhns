#######
# AV5 #
#######
if(!exists("process")){
  source("data-raw/hemibrain/startupHemibrain.R")
  process = TRUE
}
# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
x = c("517138678", "541628695", "541632940", "5813047407", "673302212",
          "360927799",  "483988886", "421638281", "450924155",
          "451986590", "542298702", "481941863", "392985492", "391625677",
          "667444187", "544012081", "451990898", "360950551",
          "549961114", "512976561", "419889751", "420235118", "5901195359",
          "360573708", "422312023", "419548748", "512294414", "511949386",
          "419889682", "420226410", "450574212", "450579065", "5813047173",
          "449910002", "481941855", "359892436", "419880385", "419543946",
          "452655734", "420594200", "419207462", "359568205", "481600824",
          "422312162", "419884971", "390245740", "5813010170", "5813013173",
          "481941688", "390935535", "451619287", "422312019", "419884922",
          "542298159", "419880519", "481941832", "329215923", "605399330",
          "668466304", "481941922", "541615798", "419884905", "603003871",
          "481941611", "636451654", "420230547", "451619617", "421633905",
          "419885042")
y = c("390271275")
z = "480276374"
av5 = c(x,y,z)

### Get FAFB assigned hemilineage information
# x.match = unique(hemibrain_lhns[x,"FAFB.match"])
# x.match = x.match[!is.na(x.match)]
# x.match = read.neurons.catmaid.meta(x.match)
# y.match = unique(hemibrain_lhns[y,"FAFB.match"])
# y.match = y.match[!is.na(y.match)]
# y.match = read.neurons.catmaid.meta(y.match)
# z.match = unique(hemibrain_lhns[z,"FAFB.match"])
# z.match = z.match[!is.na(z.match)]
# z.match = read.neurons.catmaid.meta(z.match)
#
# ### Meta info
# mx = neuprint_get_meta(x)
# my = neuprint_get_meta(y)
# mz = neuprint_get_meta(z)
# table(mx$cellBodyFiber)
# table(my$cellBodyFiber)
# table(mz$cellBodyFiber)
#
# ### CBFs:
# ### ADL11^LBDL5 ADL07^dlLHT ADL07^dlLHT
# ADL11 = neuprint_read_neurons("ADL11")
# ADL11 = ADL11[names(ADL11)%in%hemibrain.lhn.bodyids]
# ADL07 = neuprint_read_neurons("ADL07")
# ADL07 = ADL07[names(ADL07)%in%hemibrain.lhn.bodyids]
# av5.hemi = c(ADL11,ADL07)
#
# ### Re-define some of these CBFs
# sd = setdiff(av5, names(av5.hemi))
# ds = setdiff(names(av5.hemi),av5)
# av5 = unique(av5, names(av5.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% av5)
df$cbf.change = FALSE
df$class = "LHN"
df$cell.type = NA
rownames(df) = df$bodyid

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "VPNl&d1_dorsal"
df[x,"Hartenstein_Hemilineage"] = "BLAvm2_dorsal"
df[z,"ItoLee_Hemilineage"] = "SIPa1_dorsal"
df[z,"Hartenstein_Hemilineage"] = "BLAd2_dorsal"
df[y,"ItoLee_Hemilineage"] = "SLPav2_dorsal"
df[y,"Hartenstein_Hemilineage"] = "BLD2_dorsal"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### AV5x ###
############

#####
# a #
#####

a1 = c("451990898", "450924155", "451986590", "421633905", "391625677", "542298702")
df[a1,"cell.type"] = "AV5a1"

a2 = c("481941688", "481941922", "541615798", "5813013173", "481941855",
      "605399330", "512294414", "449910002", "359892436", "419880385",
      "483988886", "419548748", "450579065", "481941863", "481941832",
      "329215923", "5901195359", "419884971", "419889682")
df[a2,"cell.type"] = "AV5a2"

a3 = c("668466304", "422312023", "390935535","422312162", "419884922", "422312019", "451619287")
df[a3,"cell.type"] = "AV5a3"

a4 = c("360573708", "419885042", "420230547", "481600824", "481941611")
df[a4,"cell.type"] = "AV5a4"

a5 = c("392985492", "360927799", "667444187", "421638281") # light = = c("Cha-F-800067","L1594#1","L1594#2")
df[a5,"cell.type"] = "AV5a5"

a6 = c("542298159", "450574212", "420226410", "511949386", "5813047173", "359568205")
df[a6,"cell.type"] = "AV5a6"

a7 = c("5813010170", "390245740", "549961114", "420594200", "419543946","451619617", "512976561", "452655734", "419207462") #light = c("Cha-F-700219")
df[a7,"cell.type"] = "AV5a7"

a8 = c("419884905", "419880519", "636451654", "419889751", "603003871", "420235118")
df[a8,"cell.type"] = "AV5a8"

a9 = c("419889751", "603003871", "420235118")
df[a9,"cell.type"] = "AV5a9"

a10 = c("544012081", "673302212")
df[a10,"cell.type"] = "AV5a10"

#####
# i #
#####

c1 = c("541628695", "541632940")
df[c1,"cell.type"] = "AV5c1"

c2 = c("360950551", "517138678")
df[c2,"cell.type"] = "AV5c2"

#####
# h #
#####

d1 = "5813047407" # light = c("131016c1", "Gad1-F-900076", "Gad1-F-700224", "JJ141")
df[d1,"cell.type"] = "AV5d1"

############
### AV5y ###
############

b1 = "449241371"
df[b1,"cell.type"] = "AV5b1"

b2 = "479912666"
df[b2,"cell.type"] = "AV5b2"

############
### AV5y ###
############

e1 = "480276374"
df[e1,"cell.type"] = "AV5e1"

f1 = "390271275"
df[f1,"cell.type"] = "AV5f1"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/AV5_celltyping.csv", row.names = FALSE)

# Process
if(process){
  # Make 2D Images
  take_pictures(df)

  # Update googlesheet
  write_lhns(df = df, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))
}
