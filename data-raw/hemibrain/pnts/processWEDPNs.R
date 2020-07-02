##########
# WEDPNs #
##########
if(!exists("process")){
  source("data-raw/hemibrain/startupHemibrain.R")
  process = TRUE
}
# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
x = c("5813015982", "2214846055", "1069223047", "1440645010",
         "2030342003", "2214504597", "5813013913",
         "1006854683", "5813020138", "916828438", "853726809", "915451074",
          "973765182", "5813032740", "885788485", "1607155570", "5812991267", "5812991215")
y = c("1193378968", "1040609241",  "1573741727", "5813056323")
z = c("1131310385", "1005490210", "856131667","912390224", "1286134810", "1318870786", "5813033483", "1501371238",
      "880668750", "974460512", "942725696", "1318184105", "1595477160",
      "701328333", "732357920", "912044495","885794269","1819957885","1163367993")
w = c("1539309050", "2061028219", "1067215615","5813055629", "1565802648", "2096914287", "1040609541","947858407", "2096909904",
      "2065533721",
      "5813133489",
      "2123096640",
      "5813054019",
      "5813056696",
      "5901203887")
u = c("1630048134","1508615283")
v = c("698970725", "886134689")
i = c("5813041468", "1098928012")
WEDPNs = c(x,y,z,w,u,v,i)

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
# w.match = unique(hemibrain_lhns[w,"FAFB.match"])
# w.match = w.match[!is.na(w.match)]
# w.match = read.neurons.catmaid.meta(w.match)
#
# ### Meta info
# mx = neuprint_get_meta(x)
# my = neuprint_get_meta(y)
# mz = neuprint_get_meta(z)
# mw = neuprint_get_meta(w)
# table(mx$cellBodyFiber)
# table(my$cellBodyFiber)
# table(mz$cellBodyFiber)
# table(mw$cellBodyFiber)
#
# ### CBFs:
# ### AVL01^aVLPT3 AVL09^aVLPT1
# AVL01 = neuprint_read_neurons("AVL01")
# AVL01 = AVL01[names(AVL01)%in%lhn.ids]
# AVL09 = neuprint_read_neurons("AVL09")
# AVL09 = AVL09[names(AVL09)%in%lhn.ids]
# WEDPNs.hemi = c(AVL01,AVL09)
#
# ### Re-define some of these CBFs
# sd = setdiff(WEDPNs, names(WEDPNs.hemi))
# ds = setdiff(names(WEDPNs.hemi),WEDPNs)
# WEDPNs = unique(WEDPNs, names(WEDPNs.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% WEDPNs)
df$cbf.change = FALSE
df$class = "WEDPN"
df$cell.type = NA
rownames(df) = df$bodyid

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "WEDa2"
df[x,"Hartenstein_Hemilineage"] = "BAlp3"
df[y,"ItoLee_Hemilineage"] = "primary"
df[y,"Hartenstein_Hemilineage"] = "primary"
df[u,"ItoLee_Hemilineage"] = "ALlv1"
df[u,"Hartenstein_Hemilineage"] = "BAlp4"
df[v,"ItoLee_Hemilineage"] = "LHp2_lateral"
df[v,"Hartenstein_Hemilineage"] = "DPLp1_lateral"
df[w,"ItoLee_Hemilineage"] = "WEDd1"
df[w,"Hartenstein_Hemilineage"] = "DALd"
df[i,"ItoLee_Hemilineage"] = "primary"
df[i,"Hartenstein_Hemilineage"] = "primary"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhins.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

#############
### WEDPN ###
#############

#####
# x #
#####

wp1a = c("1440645010",  "2214504597", "1069223047", "2030342003") # light = c("Gad1-F-100133", "VGlut-F-500810", "VGlut-F-100375", "VGlut-F-600117","L112#1","L112#2","L112#3","L112#4","L770#1","L770#2","L772#1","L772#2","L984#1","L984#2","L984#3","L984#4","L984#5","L984#6","L984#7","L984#8","L984#9")
df[wp1a,"cell.type"] = "WEDPN1A"

wp1b = "2214846055"
df[wp1b,"cell.type"] = "WEDPN1B"

wp2a = c("973765182", "885788485", "915451074") # mising
df[wp2a,"cell.type"] = "WEDPN2A"

wp2b = c("853726809", "916828438")
df[wp2b,"cell.type"] = "WEDPN2B"

wp3 = c("5813013913", "5813020138", "1006854683") # light = c("Cha-F-600036","fru-M-300059","L1524#1","L1524#2","L1518#1","L1518#2","L1518#3","L1518#4","L1518#5", "L1949#3","L1668#1", "L1668#2", "L1668#3", "L1668#4","L1949#1", "L1949#2","L452#2")
df[wp3,"cell.type"] = "WEDPN3"

wp4 = "5813032740"
df[wp4,"cell.type"] = "WEDPN4"

wp5 = c( "1573741727") # light= c("L1337#1","L1337#2","L1337#4","L1337#7","L1337#8")
df[wp5,"cell.type"] = "WEDPN5"

#####
# y #
#####

wp7a = c("5813056323", "5813015982", "1163367993")  #light = c("L1337#3","L1337#5","L1337#6")
df[wp7a,"cell.type"] = "WEDPN7A"

wp7b = c("1040609241", "1193378968",
        "885794269", "1819957885")
df[wp7b,"cell.type"] = "WEDPN7B"

wp7c = c("1607155570", "5812991267", "5812991215")
df[wp7c,"cell.type"] = "WEDPN7C"

#####
# z #
#####

wp6a = c("1131310385", "1005490210", "856131667")
df[wp6a,"cell.type"] = "WEDPN6A"

wp6b = c("1286134810", "1318870786", "5813033483", "1501371238")
df[wp6b,"cell.type"] = "WEDPN6B"

wp6c = c("1318184105", "1595477160")
df[wp6c,"cell.type"] = "WEDPN6C"

#####
# w #
#####

wp8a = c("1539309050", "2123096640", "5813054019", "5813056696", "5901203887")
df[wp8a,"cell.type"] = "WEDPN8A"

wp8b = c("2061028219", "1067215615")
df[wp8b,"cell.type"] = "WEDPN8B"

wp8c = c("5813055629", "1565802648", "2096914287", "947858407", "2096909904", "2065533721", "5813133489")
df[wp8c,"cell.type"] = "WEDPN8C"

wp8d = c("1508615283", "1040609541")
df[wp8d,"cell.type"] = "WEDPN8D"

#####
# u #
#####

wp9 = "1630048134"
df[wp9,"cell.type"] = "WEDPN9"

wp10a = c("5813041468")
df[wp10a,"cell.type"] = "WEDPN10A"

wp10b = "1098928012"
df[wp10b,"cell.type"] = "WEDPN10B"

wp12 = "698970725"
df[wp12,"cell.type"] = "WEDPN12"

wp11 = "886134689"
df[wp11,"cell.type"] = "WEDPN11"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)
df$pnt ="LHWEDT"

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/WEDPN_celltyping.csv", row.names = FALSE)

# Process
if(process){
  # Make 2D Images
  take_pictures(df)

  # Update googlesheet
  write_lhns(df = df, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))
}

