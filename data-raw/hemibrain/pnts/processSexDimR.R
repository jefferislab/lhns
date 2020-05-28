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
             "545453209", "578530106", "672653737")
asp = y = c("485430434", "855414220", "641278400", "887148641", "949534412",
            "610916994", "485775679", "485430336", "5813115796", "421992069",
            "329919036", "421650982", "421318649", "5813055904", "761661626",
            "578189576", "582027317", "581013183")
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
df$class[bodyid %in% asp] = "aSP"
df$class[bodyid %in% mals] = "GNGPN"
df$cell.type = NA
rownames(df) = df$bodyid

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "VLPl&p1_posterior"
df[x,"Hartenstein_Hemilineage"] = "BLVp2_posterior"
df[y,"ItoLee_Hemilineage"] = "SIPp1"
df[y,"Hartenstein_Hemilineage"] = "DPMpl2"


##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### PV7 ####
############

a1 = c("392645639", "451308547")
df[a1,"cell.type"] = "PV7a1"

a2 = c("635109166", "511685955")
df[a2,"cell.type"] = "PV7a2"

b1 = "359560762"
df[b1,"cell.type"] = "PV7b1"

c1 = "667857582"
df[c1,"cell.type"] = "PV7c1"

############
### PV8 ####
############

a1 = "480258208"
df[a1,"cell.type"] = "PV8a1"

b1 = "728205616"
df[b1,"cell.type"] = "PV8b1"

c1 = "694818168"
df[c1,"cell.type"] = "PV8c1"

d1 = "694126781"
df[d1,"cell.type"] = "PV8d1"

#############
### PV11 ####
#############

# a1 = c("483337285", "543718301")
# df[a1,"cell.type"] = "PV11a1"

a1 = c("422997837", "482356368", "482684855")
df[a1,"cell.type"] = "PV11a1"

#############
### PV10 ####
#############

a1 = c("387952104", "451049385")
# light = c("Gad1-F-400411","Cha-F-100449", "Gad1-F-100290",
#         "Cha-F-300297", "Gad1-F-200414", "Cha-F-000303","Gad1-F-200151")
df[a1,"cell.type"] = "PV10a1"

b1 = "604709727" # Centrifugal-like
df[b1,"cell.type"] = "PV10b1"

c1 = "544361987"
df[c1,"cell.type"] = "PV10c1"

d1 = "423748579"
df[d1,"cell.type"] = "PV10d1"

# e1 = "883479122" # dead
# df[e1,"cell.type"] = "PV10e1"

############
### PV9 ####
############

DNp44 = "542751938"
df[DNp44,"cell.type"] = "DNp44"

a1 =  "602476655"
df[a1,"cell.type"] = "PV9a1"

#############
### PV12 ####
#############

a1 = c("480590566", "574688051")
df[a1,"cell.type"] = "PV12a1"

# a1 = c("5813021882", "5813021874")
# df[a1,"cell.type"] = "PV13a1"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)
df["602476655","pnt"] = "LHPV9"

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/PV_other_celltyping.csv", row.names = FALSE)

# Process
if(process){
  # Update googlesheet
  write_lhns(df = df, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))

  # Make 2D Images
  take_pictures(df)
}
