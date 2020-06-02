#########
# PD3/4 #
#########
if(!exists("process")){
  source("data-raw/hemibrain/startupHemibrain.R")
  process = TRUE
}
# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
pd3 = x = c( "5813011024",
            "479917027", "480577646", "574364525", "326475920", "386821054",
            "511608576", "480577749", "511616870", "480922968", "386821081",
            "572650358", "758178605", "417186612", "510934715", "448225646",
            "510926056", "5813035164", "386825720", "511267109", "511271342",
            "356131764", "480918798", "511267220", "386825636", "386825792",
            "417186656", "356467849", "479917037", "480581806", "386825553",
            "418865948", "390223560", "294432626", "358865451", "356486199",
            "326137566", "5812980270", "295443724")
pd4 = y = c("5813012782", "607152422", "573354832", "604429310", "542656552",
            "574028395", "542297875", "572650888", "573346248", "574351760",
            "5813057881", "359891881", "5813046968", "547129228", "359214479",
            "510317265", "421641859", "543053986", "610601810","294786630", "295115794")
pd3_pd4 = c(x,y)

### Get FAFB assigned hemilineage information
# x.match = unique(hemibrain_lhns[x,"FAFB.match"])
# x.match = x.match[!is.na(x.match)]
# x.match = read.neurons.catmaid.meta(x.match)
# y.match = unique(hemibrain_lhns[y,"FAFB.match"])
# y.match = y.match[!is.na(y.match)]
# y.match = read.neurons.catmaid.meta(y.match)
#
# ### Meta info
# mx = neuprint_get_meta(x)
# my = neuprint_get_meta(y)
# table(mx$cellBodyFiber)
# table(my$cellBodyFiber)
#
# ### CBFs:
# ### PDL13^pSLP2 PDL07^dLH PDL11^pSLP1 PDM30^SIPT3
# PDL13 = neuprint_read_neurons("PDL13")
# PDL13 = PDL13[names(PDL13)%in%hemibrain.lhn.bodyids]
# PDL11 = neuprint_read_neurons("PDL11")
# PDL11 = PDL11[names(PDL11)%in%hemibrain.lhn.bodyids]
# PDM30 = neuprint_read_neurons("PDM30")
# PDM30 = PDM30[names(PDM30)%in%hemibrain.lhn.bodyids]
# pd3_pd4.hemi = union(PDL13,PDL11,PDM30)
#
# ### Re-define some of these CBFs
# sd = setdiff(pd3_pd4, names(pd3_pd4.hemi))
# ds = setdiff(names(pd3_pd4.hemi),pd3_pd4)
# pd3_pd4 = unique(pd3_pd4, names(pd3_pd4.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% pd3_pd4)
df$cbf.change = FALSE
df$class = "LHN"
df$cell.type = NA
rownames(df) = df$bodyid

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "LHd2_dorsal"
df[x,"Hartenstein_Hemilineage"] = "DPLm2_dorsal"
df[y,"ItoLee_Hemilineage"] = "SLPpm1"
df[y,"Hartenstein_Hemilineage"] = "DPLm1"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### PD3 ####
############

#####
# e #
#####

# e1 = c("355816896", "5812980250", "356136008", "417190793") # dead
# df[e1,"cell.type"] = "PD3e1"

#####
# d #
#####

# d1 = c("356468264", "418888552", "418892691", "510623836")
# df[d1,"cell.type"] = "PD3d1"

#####
# c #
#####

c1= c("5813011024") # light = c("Cha-F-100103")
df[c1,"cell.type"] = "PD3c1"

#####
# b #
#####

b3 = c("326475920", "386821054", "390223560")
df[b3,"cell.type"] = "PD3b3"

b2 = c("295443724", "294432626")
df[b2,"cell.type"] = "PD3b2"

b1 = c("5812980270", "356486199", "326137566", "358865451")
df[b1,"cell.type"] = "PD3b1"

#####
# a #
#####

a1 = c("418865948", "356467849", "386825553", "479917037", "417186656", "480581806") # light = c("L876#7", "Cha-F-400165", "L876#4", "JJ64", "JJ78")
df[a1,"cell.type"] = "PD3a1"

a2 = c("480922968", "480577646", "479917027", "574364525", "386821054", "511608576","386821081") # light = c("L2385#1","L1749#3")
df[a2,"cell.type"] = "PD3a2"

a3 = c("386825636", "386825792", "572650358", "480577749","511616870") # light = c("Gad1-F-200150","L1749#9")
df[a3,"cell.type"] = "PD3a3"

a4 = c("511271342", "386825720", "511267109", "480918798", "511267220",
      "356131764", "510926056", "448225646", "5813035164") # light = c("L2385#2","Gad1-F-100168")
df[a4,"cell.type"] = "PD3a4"

a5 = c("758178605", "417186612", "510934715") # light = c("L194#1", "L1749#10", "Cha-F-500011")
df[a5,"cell.type"] = "PD3a5"

# f1 = c("387516191", "510623727", "418897332")
# df[f1,"cell.type"] = "PD3f1"

# g1 = "5813012781"
# df[g1,"cell.type"] = "PD3g1"
#
# h1 = "294424196" # dead
# df[h1,"cell.type"] = "PD3h1"

############
### PD4 ####
############

#####
# a #
#####

b1 = c("5813012782", "607152422", "543053986", "604429310")
df[b1,"cell.type"] = "PD4b1"


#####
# a #
#####

c1 = "421641859" # Centrifugal-like
df[c1,"cell.type"] = "PD4c1"

#####
# e #
#####

cent12 = c("359214479", "359891881", "5813046968") # light = c("Gad1-F-100025", "Gad1-F-000285", "Gad1-F-100218")
df[cent12,"cell.type"] = "CENT12"

#####
# a #
#####

a1 = c("542656552", "573346248", "573354832", "574028395")
df[a1,"cell.type"] = "PD4a1"

a2 = c("542297875", "572650888")
df[a2,"cell.type"] = "PD4a2"

#####
# d #
#####

d1 = "510317265" #light  = c("Cha-F-000007", "Cha-F-000005", "Gad1-F-900054")
df[d1,"cell.type"] = "PD4d1"

d2 = c("547129228", "5813057881", "574351760")
df[d2,"cell.type"] = "PD4d2"

cent14 = "610601810"
df[cent14,"cell.type"] = "CENT14"

e1 = c("294786630", "295115794")
df[e1,"cell.type"] = "PD4e1"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)
df[pd4,"pnt"] = "LHPD4"

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/PD3_PD4_celltyping.csv", row.names = FALSE)

# Process
if(process){
  # Update googlesheet
  write_lhns(df = df, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))

  # Make 2D Images
  take_pictures(df)
}
