#########
# PD1/2 #
#########
if(!exists("process")){
  source("data-raw/hemibrain/startupHemibrain.R")
  process = TRUE
}
# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
pd1 = x = c("5813035117", "325458991", "5813043073", "359568460", "5813009749",
            "330259272", "297520036", "420977956", "5813009497", "267223027",
            "297524212", "325460206", "5813047774")
pd2 = y = c("704798196", "263674097", "675800901", "676138357", "486850582",
            "5813099667", "264014957", "5812980658", "735772860", "947859021",
            "947862945", "704078253", "822358833", "391328156", "5813039932",
            "329254539", "356429209", "5813089504", "509928512", "548872750",
            "5813129453", "571666400", "640963556", "573337611", "571666434",
            "542634516", "573329304", "760268555", "448869118", "5813014640",
            "699178922", "675800901", "676138357", "704798196", "695500178",
            "5813040707", "5813019487", "5813009445")
z = "5813049920"
pd1_pd2 = c(x,y,z)

### Get FAFB assigned hemilineage information
# x.match = unique(hemibrain_lhns[x,"FAFB.match"])
# x.match = x.match[!is.na(x.match)]
# x.match = read.neurons.catmaid.meta(x.match)
# y.match = unique(hemibrain_lhns[y,"FAFB.match"])
# y.match = y.match[!is.na(y.match)]
# y.match = read.neurons.catmaid.meta(y.match)

### Meta info
# mx = neuprint_get_meta(x)
# my = neuprint_get_meta(y)
# table(mx$cellBodyFiber)
# table(my$cellBodyFiber)
#
# ### CBFs:
# ### PDL06^aSLPF1 PDL07^dLH PDL15^aSLPF3
# AVL18 = neuprint_read_neurons("AVL18")
# AVL18 = AVL18[names(AVL18)%in%hemibrain.lhn.bodyids]
# AVL18 = neuprint_read_neurons("AVL18")
# PDL06 = neuprint_read_neurons("PDL06")
# PDL06 = PDL06[names(PDL06)%in%hemibrain.lhn.bodyids]
# PDL07 = neuprint_read_neurons("PDL07")
# PDL07 = PDL07[names(PDL07)%in%hemibrain.lhn.bodyids]
# PDL15 = neuprint_read_neurons("PDL15")
# PDL15 = PDL15[names(PDL15)%in%hemibrain.lhn.bodyids]
# pd2.hemi = union(PDL06,PDL07,PDL15,AVL18)

### Re-define some of these CBFs
# sd = setdiff(pd1_pd2, names(pd2.hemi))
# ds = setdiff(names(pd2.hemi),pd1_pd2)
# pd1_pd2 = unique(pd1_pd2, names(pd2.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% pd1_pd2)
df$cbf.change = FALSE
df$class = "LHN"
df$cell.type = NA
rownames(df) = df$bodyid

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "VLPd&p1_posterior "
df[x,"Hartenstein_Hemilineage"] = "DPLl2_posterior"
df[y,"ItoLee_Hemilineage"] = "SLPad1_posterior"
df[y,"Hartenstein_Hemilineage"] = "DPLl3_posterior"
df[z,"ItoLee_Hemilineage"] = "primary"
df[z,"Hartenstein_Hemilineage"] = "primary"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### PD1  ###
############

a1 = c("5813009497", "297524212", "5813040707", "267223027", "5813019487",
       "5813009445", "297520036", "330259272")# light = c("fru-M-600135")
df[a1,"cell.type"] = "PD2a1"

a2 = "389951232"
df[a2,"cell.type"] = "PD1a2"

b1 = c("5813035117", "325460206", "325458991", "5813009749")
df[b1,"cell.type"] = "PD1b1"

c1 = "5813047774"
df[c1,"cell.type"] = "PD1c1"

d1 = c("359568460", "5813043073", "420977956")
df[d1,"cell.type"] = "PD1d1"

e1 = "5813049920"
df[e1,"cell.type"] = "PD1e1"

############
### PD2y ###
############

#####
# a #
#####

a1 = c("573329304", "573337611", "542634516", "571666434", "640963556")
# light = c("Cha-F-600238", "Gad1-F-200234","5HT1A-F-300019", "5HT1A-F-300013","37G11#2",
#         "L989#3", "L989#4","L991#1", "L989#13", "L989#10", "L989#14","37G11#6", "L991#3", "L991#4", "L989#6", "37G11#1",
#         "L989#9", "L991#2", "37G11#4", "L989#5", "L991#5", "37G11#3", "L989#11",
#         "L989#1", "L989#7","120806c0", "JJ8", "JJ90")
df[a1,"cell.type"] = "PD2a1"

a2 = c("448869118", "699178922", "5813129453", "5813014640") # light = c("Gad1-F-500129","121018c0", "Gad1-F-500196", "JJ13")
# light = c("121225c0", "131014c3", "130612c0", "121017c0","121227c3", "130620c0","131007c0")
df[a2,"cell.type"] = "PD2a2"

a3 = c("735772860", "486850582", "5813099667")
df[a3,"cell.type"] = "PD2a3"

a4 = c("5813021728", "640963092", "449205588", "768192947", "417834021",
       "449205611") # light = ("Cha-F-100453")
df[a4,"cell.type"] = "PD2a4"

a5 = c("5812980658", "263674097", "264014957")
df[a5,"cell.type"] = "PD2a5"

a6 = c("704078253", "947862945", "822358833", "947859021")
df[a6,"cell.type"] = "PD2a6"

a7 = c("675800901", "676138357", "704798196", "695500178")
df[a7,"cell.type"] = "PD2a7"

a8 = c("329254539", "391328156", "5813039932")
df[a8,"cell.type"] = "PD2a8"

a9 = c("760268555")
df[a9,"cell.type"] = "PD2a9"

#####
# b #
#####

b1 = c("548872750", "509928512", "5813089504", "571666400")
# light = c("120926c0","37G11#5","Cha-F-000421","Cha-F-800096","121015c0","121016c0",
#         "120914c2","131009c4","L989#12", "L989#8","L989#2", "JJ11", "JJ14", "JJ88")
df[b1,"cell.type"] = "PD2b1"

c1 = "356429209"
df[c1,"cell.type"] = "PD2b1"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/PD1_PD2_celltyping.csv", row.names = FALSE)

# Process
if(process){
  # Update googlesheet
  write_lhns(df = df, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))

  # Make 2D Images
  take_pictures(df)
}
