#########
# PV7/8 #
#########
if(!exists("process")){
  source("data-raw/hemibrain/startupHemibrain.R")
  process = TRUE
}
# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
mals = x = c("1472676490", "887519423", "5813017614", "5813057615", "642723975",
             "887165687", "703033179", "607131089", "486073415", "638882263",
             "763686208", "670915068", "700235813", "671255587", "825061437",
             "637850749", "666818214", "732984478", "764399773", "889911741",
             "1014733888", "580209760", "577473231", "953004705", "735073668",
             "735415046", "671604934", "671600919", "734724111", "921969761",
             "578189223", "5812980516", "610571450", "5812980330", "668876945",
             "703351975", "609867847", "667840305", "670914976", "360958913",
             "390616496", "452694446", "5813089487", "1142002856", "1485786914",
             "545453209", "578530106", "672653737", "611323175", "5812996641")
y = c("421318649", "5813055904", "761661626", "578189576", "582027317",
      "581013183","767433432",
      "453708274",
      "790629881",
      "727153132",
      "795745097","5813008942",
       "453035422",
       "765072733",
       "483042692")
z = c("485430434", "855414220", "641278400", "887148641", "949534412",
      "610916994", "485775679", "485430336", "5813115796", "421992069",
      "329919036", "421650982")
asp = c(y,z)
sexdim = c(mals, asp)

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

### Set-up data.frame
df = subset(namelist, bodyid %in% sexdim)
df$cbf.change = FALSE
df$class[df$bodyid %in% asp] = "aSP"
df$class[df$bodyid %in% mals] = "GNGPN"
df$cell.type = NA
rownames(df) = df$bodyid

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "CREa1_ventral"
df[x,"Hartenstein_Hemilineage"] = "BAmd1_ventral"
df[y,"ItoLee_Hemilineage"] = "SLPad1_anterior"
df[y,"Hartenstein_Hemilineage"] = "DPLl3_anterior"
df[z,"Hartenstein_Hemilineage"] = "DPLal2_medial"
df[z,"ItoLee_Hemilineage"] = "LHl2_medial"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### mAL ####
############

a = "1472676490"
df[a,"cell.type"] = "mALa"

b = "887519423"
df[b,"cell.type"] = "mALb"

c = c("5813017614","5813057615")
df[c,"cell.type"] = "mALc"

d = c("642723975","887165687","703033179")
df[d,"cell.type"] = "mALd"

e = c("607131089", "486073415")
df[e,"cell.type"] = "mALe"

f = c("638882263", "763686208")
df[f,"cell.type"] = "mALf"

g = c("670915068","700235813","671255587","825061437","637850749","666818214","732984478")
df[g,"cell.type"] = "mALg"

h  = c("764399773", "889911741", "1014733888")
df[h,"cell.type"] = "mALh"

i = c("580209760", "577473231")
df[i,"cell.type"] = "mALi"

j = c("953004705","735073668","735415046","671604934","671600919","734724111", "921969761")
df[j,"cell.type"] = "mALj"

k = c("578189223","5812980516","610571450", "5812980330","668876945","703351975")
df[k,"cell.type"] = "mALk"

l = c("609867847","667840305","670914976")
df[l,"cell.type"] = "mALl"

m = c("360958913","390616496","452694446","5813089487","1142002856","1485786914")
df[m,"cell.type"] = "mALm"

n = "545453209"
df[n,"cell.type"] = "mALn"

o = c("578530106", "672653737")
df[o,"cell.type"] = "mALo"

x = c("611323175","5812996641")
df[x,"cell.type"] = "mALx"

############
### aSP ####
############

f1 =c("421318649",
      "5813055904",
      "761661626",
      "581013183")
df[f1,"cell.type"] = "aSP-f1"

f2 = c("578189576",
       "582027317")
df[f2,"cell.type"] = "aSP-f2"

f3 =c("767433432",
      "453708274",
      "790629881",
      "727153132",
      "795745097")
df[f3,"cell.type"] = "aSP-f3"

f4 = c("5813008942",
       "453035422",
       "765072733",
       "483042692")
df[f4,"cell.type"] = "aSP-f4"

a = c("485430434",
      "887148641",
      "949534412",
      "610916994",
      "485775679")
df[a,"cell.type"] = "aSP-g1a"

b = c("855414220",
      "641278400",
      "5813115796",
      "421992069")
df[b,"cell.type"] = "aSP-g1b"

ta = c("329919036")
df[ta,"cell.type"] = "aSP-g2a"

tb = c("485430336","421650982")
df[tb,"cell.type"] = "aSP-g2b"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)
df$connectivity.type = df$cell.type
df[y,"pnt"] = "LHAD2"
df[z,"pnt"] = "LHAD1"
df[mals,"pnt"] = "mAL"

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/sexdim_celltyping.csv", row.names = FALSE)

# Process
if(process){
  # Update googlesheet
  write_lhns(df = df, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))

  # Make 2D Images
  take_pictures(df)
}
