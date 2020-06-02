#######
# PV5 #
#######
if(!exists("process")){
  source("data-raw/hemibrain/startupHemibrain.R")
  process = TRUE
}
# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Group X
#LHPV5
x = c("728974338", "5812980156", "577546843", "727838223", "451355706",
      "573333903", "5813012375", "264779403", "546511447", "573683455",
      "573333284", "572651463", "609941228", "604368022", "696432315",
        "702010197",
      "700982749", "639958133", "264783939", "481268762", "573333575",
      "5813010200", "602999843", "608240515", "329220439", "633684017",
      "265120324", "696082279", "5813009281", "573670049", "579576294",
      "454706029", "265120223", "356823065", "486501502", "5813129400",
      "5901208687", "728625156")
# Group Y
y = c( "513050445", "705722260", "611274992", "699203489",
         "636798093", "361269751", "732354059", "455751103", "360254994",
         "391273276", "573328182", "485728655", "422640861", "424025668",
         "611620813", "768132738", "763034485", "423343583", "728836965",
         "422307542", "5813009429",  "580244333", "5813048099",
          "5812981168", "851027931", "5901203559", "634069028",
         "5813048346", "456083341", "912049625", "487795196", "513058708",
         "634741770", "794333532", "482974860", "641631962", "573005505",
         "5901196176", "487467388", "641631806", "484355342", "701577869",
         "697853509", "731917767", "730325440", "575750788", "5813047222")
# Group z
z = c("294787849", "579575594", "328611004", "642504699", "299082033",
 "541663112", "5813047130", "326159907", "359529027", "5813056026",
  "295805243", "296153261", "480931947", "573056433", "911012735",
  "5813010180", "5813094592", "573708714", "605063393", "5813083717",
  "729228602", "5901213816", "759582005", "880323994", "973047668",
  "5812980282", "390599254", "511267279", "572647105", "5813010159",
  "5813047174", "356144721",  "419216386", "451646125",
 "485387561","1005119041", "5812982844")
w = c("5813077562", "357224041")
pv5 = unique(c(x,y,z,w))

# cp2_dorsal = c("299082033",
#                "328611004",
#                "294787849",
#                "579575594",
#                "642504699")
# cp2_dorsal2 = c("5813077562", "357224041")
# cp3_b = c("541663112",
#           "5813047130",
#           "326159907",
#           "359529027",
#           "5813056026",
#           "295805243",
#           "296153261",
#           "480931947",
#           "573056433",
#           "911012735",
#           "5813010180",
#           "5813094592",
#           "573708714",
#           "605063393",
#           "5813083717",
#           "729228602",
#           "5901213816",
#           "759582005",
#           "880323994",
#           "973047668",
#           "5812980282",
#           "390599254",
#           "511267279",
#           "572647105",
#           "5813010159",
#           "5813047174")
# cp2_b = c("422307542",
#           "699203489",
#           "728836965",
#           "5813009429",
#           "487467388",
#           "580244333",
#           "697853509",
#           "5813047222",
#           "5813048099",
#           "360587642",
#           "361964245",
#           "611620813",
#           "763034485",
#           "768132738",
#           "573005505",
#           "575750788",
#           "701577869",
#           "705722260",
#           "851027931",
#           "482974860",
#           "484355342",
#           "513050445",
#           "513058708",
#           "611274992",
#           "634741770",
#           "730325440",
#           "731917767",
#           "794333532",
#           "5901196176",
#           "641631806",
#           "641631962",
#           "5812981168",
#           "5901203559",
#           "487795196",
#           "634069028",
#           "5813048346",
#           "456083341",
#           "912049625")

## The PV5 assembly contains 3 cell body fibre bundles and 3 hemlineages
mx = neuprint_get_meta(x)
table(mx$cellBodyFiber)
my = neuprint_get_meta(y)
table(my$cellBodyFiber)
mz = neuprint_get_meta(z)
table(mz$cellBodyFiber)

### CBFs:
### x: PDL05^SFS1 PDL08^pLH2 PDL19^SFS3 PDL23^pLH10 PDL14^pLH6
# PDL05 = neuprint_read_neurons("PDL05")
# PDL05 = PDL05[names(PDL05)%in%hemibrain.lhn.bodyids]
# PDL23 = neuprint_read_neurons("PDL23")
# PDL23 = PDL23[names(PDL23)%in%hemibrain.lhn.bodyids]
# PDL22 = neuprint_read_neurons("PDL22")
# PDL22 = PDL22[names(PDL22)%in%hemibrain.lhn.bodyids]
# PDL19 = neuprint_read_neurons("PDL19")
# PDL19 = PDL19[names(PDL19)%in%hemibrain.lhn.bodyids]
# pv5.hemi = c(PDL05,PDL23,PDL22,PDL19)
#
# ### Re-define some of these CBFs
# sd = setdiff(pv5, names(pv5.hemi))
# ds = setdiff(names(pv5.hemi),pv5)
# pv5 = unique(pv5, names(pv5.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% pv5)
df$cbf.change = FALSE
df$class = "LHN"
df$cell.type = NA
rownames(df) = df$bodyid

### Hemilineages:
#### ItoLee: Dl2_lateral, DL1_dorsal, DL2_medial
#### Hartenstein: CP3_lateral, CP2_dorsal, CP3_medial
df[x,"ItoLee_Hemilineage"] = "DL2_dorsal"
df[x,"Hartenstein_Hemilineage"] = "CP3_dorsal"
df[y,"ItoLee_Hemilineage"] = "DL1_dorsal"
df[y,"Hartenstein_Hemilineage"] = "CP2_dorsal"
df[z,"ItoLee_Hemilineage"] = "DL2_medial"
df[z,"Hartenstein_Hemilineage"] = "CP3_medial"
df[w,"ItoLee_Hemilineage"] = "primary"
df[w,"Hartenstein_Hemilineage"] = "primary"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### PV5x ###
############

#####
# a #
#####

a1= c("546511447", "573333903", "577546843","573333284", "573683455", "609941228", "604368022")
# light = c("Gad1-F-900137", "Gad1-F-500180", "Gad1-F-400275", "120708c1", "120813c0",
#           "Gad1-F-200403", "Gad1-F-200289", "Cha-F-400324", "Gad1-F-100357", "Gad1-F-200220",
#           "120628c1", "Cha-F-000427", "L378#2", "Gad1-F-100099", "L166#1", "L224#1", "Gad1-F-000338",
#           "Gad1-F-300298", "L224#3", "SS01372#1", "L166#5", "Cha-F-300204", "120216c0",
#           "120914c0", "130118c0", "Cha-F-100394", "Cha-F-300241", "Cha-F-400179", "Cha-F-500187", "Gad1-F-100093",
#           "Gad1-F-100247","Gad1-F-100322", "Gad1-F-400226", "Gad1-F-400226","Gad1-F-400335","Gad1-F-600214","L166#2",
#           "L166#3", "L224#2","L378#1","SS01372#2", "L166#6","SS01372#3")
df[a1,"cell.type"] = "PV5a1"

a2 = c("573670049", "579576294", "727838223", "696432315") # light = c("VGlut-F-400058", "L166#4", "Gad1-F-400304", "Gad1-F-200199","120712c1", "120619c1","120710c0",  "Cha-F-800011","Cha-F-100457", "120618c0","131118c3")
df[a2,"cell.type"] = "PV5a2"

a3 = c("264779403", "264783939", "481268762", "265120324", "265120223") # light = c("Gad1-F-700139", "Cha-F-500250", "Cha-F-700211",  "L163#1", "Gad1-F-000349","L163#2")
df[a3,"cell.type"] = "PV5a3"

a4 = c("5813009281", "5812980156") # light = c("Cha-F-200402", "Cha-F-500138")
df[a4,"cell.type"] = "PV5a4"

a5 = c("451355706", "572651463")
df[a5,"cell.type"] = "PV5a5"

#####
# d #
#####

d1 = c("5813010200", "602999843", "573333575", "329220439", "5813012375", "696082279") # light = c("Gad1-F-900098", "Gad1-F-300321","L1554#2","MB036B#1", "Gad1-F-100023", "L1554#1", "Cha-F-800045","160121c1", "Cha-F-200082")
df[d1,"cell.type"] = "PV5d1"

d2 = c("633684017")
df[d2,"cell.type"] = "PV5d2"

d3 = c("454706029")
df[d3,"cell.type"] = "PV5d3"


#####
# g #
#####

g1 = c("700982749", "728974338", "728625156","639958133", "702010197") # light = c("L374#3","L374#10","L374#2", "L374#4","Gad1-F-200177", "L374#9", "L374#5","L374#6",)
df[g1,"cell.type"] = "PV5g1"

g2 = c("486501502", "608240515", "5813129400", "5901208687")  # light = c("Gad1-F-300312", "L374#8")
df[g2,"cell.type"] = "PV5g2"

#####
# j #
#####

j1 = c("729228602", "5901213816")
df[j1,"cell.type"] = "PV5j1"

j2 = c("5812980282") # PV4c4 ["VGlut-F-800074"]
df[j2,"cell.type"] = "PV5j2"

j3 = c("759582005", "880323994")
df[j3,"cell.type"] = "PV5j3"

j4 = c("359529027", "326159907", "5813056026")
df[j4,"cell.type"] = "PV5j4"

j5 = c("541663112", "5813047130")
df[j5,"cell.type"] = "PV5j5"

f1 = "356823065"
df[f1,"cell.type"] = "PV5f1"

#####
# h #
#####

h1 = c("295805243", "911012735", "573056433", "5813094592", "480931947","5813010180", "296153261") # light = c("Gad1-F-900040")
df[h1,"cell.type"] = "PV5h1"

h2 = c("390599254", "511267279", "5813010159", "5813047174", "572647105")
df[h2,"cell.type"] = "PV5h2"

h3 = c("356144721", "419216386")
df[h3,"cell.type"] = "PV5h3"

h4 = c("605063393", "573708714", "5813083717")
df[h4,"cell.type"] = "PV5h4"

h5 = c("451646125")
df[h5,"cell.type"] = "PV5h5"

h6 = c("485387561")
df[h6,"cell.type"] = "PV5h6"


############
### PV5z ###
############

#####
# n #
#####

m1 = c("973047668","1005119041", "5812982844")
df[m1,"cell.type"] = "PV5m1"

#####
# e #
#####

e1 = c("328611004", "299082033") # light = c("TH-M-100016")
df[e1,"cell.type"] = "PV5e1"

e2 = "294787849"
df[e2,"cell.type"] = "PV5e2"

e3 = c("579575594", "642504699") # bilat
df[e3,"cell.type"] = "PV5e3"

############
### PV5y ###
############

#####
# k #
#####

# k1 = c("5813078563", "732034061","5813061116") # light = c("Gad1-F-300290","L528#1")
# df[k1,"cell.type"] = "PV5k1"

#####
# c #
#####

c2 = c("455751103", "485728655") # light = c("Cha-F-300025","L173#1","130605c1","Gad1-F-300155","Gad1-F-000125", "E0585-F-500009","E0585-F-300058", "Cha-F-100068", "130220c1", "130606c1", "130704c2","E0585-F-300069","121212c0","121213c0", "130313c1","130710c3", "E0585-F-300050")
df[c2,"cell.type"] = "PV5c2"

c1 = c("636798093", "422640861", "424025668", "699203489","422307542", "5813009429", "423343583", "728836965", "360254994", "361269751", "391273276", "573328182") # light = c("L1293#11", "L1293#8", "121227c2", "JJ137","Gad1-F-200232", "L1293#1", "L173#7", "L1293#2", "L173#2", "130711c1","E0585-F-500008", "E0585-F-400008", "E0585-F-300013", "E0585-F-300043", "E0585-F-300071","130816c2", "E0585-F-300052", "E0585-F-300073", "E0585-F-400013", "E0585-F-300020", "L1293#14","L178#2", "130208c1", "Gad1-F-200255", "L173#8", "L173#4", "130702c1", "130703c1","130712c1","130717c0", "130814c0", "Cha-F-000317",  "E0585-F-300033", "E0585-F-300040", "E0585-F-300047", "E0585-F-300070", "E0585-F-400002", "E0585-F-400005", "E0585-F-400011", "E0585-F-400025", "Gad1-F-000139", "Gad1-F-100003", "Gad1-F-900052", "L1293#10", "L1293#12","L1293#13","L1293#15", "L1293#3", "L1293#4", "L1293#5", "L1293#6", "L1293#7","L1293#9","L173#3","L173#5","L173#6","L173#9", "L178#1", "L178#3", "L178#4", "JJ98", "E0585-F-400018", "Cha-F-100141", "L1293#16","Cha-F-600051","JJ99","E0585-F-400009")
df[c1,"cell.type"] = "PV5c1"

c3 = c("768132738", "611620813", "763034485") # light = c("130617c3", "131126c3", "121217c0", "130211c3", "130617c3","131126c3", "131204c0", "JJ117", "JJ134")
df[c3,"cell.type"] = "PV5c3"

c4 = c("732354059")
df[c4,"cell.type"] = "PV5c4"

#####
# b #
#####

b1 = c("482974860", "731917767","5901196176", "634741770","513058708","730325440","513050445") # ] light = c("E0585-F-600002") light = c("Cha-F-100083", "Cha-F-200169") light = c("E0585-F-300063", "130425c1", "121130c0", "130213c0", "130214c1") # PV5b2? light = c("Cha-F-100264", "E0585-F-300066","E0585-F-400021", "E0585-F-400003")
df[b1,"cell.type"] = "PV5b1"

b2 = c("912049625", "456083341", "5812981168", "5901203559","487795196", "5813048346", "634069028") # light = c("Cha-F-700258", "Cha-F-700258", "Cha-F-700258")
df[b2,"cell.type"] = "PV5b2"

b3 = c("705722260", "575750788", "701577869", "851027931","573005505") # light = c("L849#2", "E0585-F-400028", "E0585-F-700002", "Cha-F-300342", "L849#1")
df[b3,"cell.type"] = "PV5b3"

b4 = c("611274992", "641631806", "641631962")
df[b4,"cell.type"] = "PV5b4"

b5 = c("484355342", "794333532") # light = c("E0585-F-400001")
df[b5,"cell.type"] = "PV5b5"

b6 = c("580244333", "487467388", "5813047222", "5813048099", "697853509") # new, but: light = c("Cha-F-200204", "E0585-F-700001", "E0585-F-800004")
df[b6,"cell.type"] = "PV5b6"


#####
# j #
#####

l1 = "357224041"
df[l1,"cell.type"] = "PV5l1"

#####
# l #
#####

i1 = "5813077562"
df[i1,"cell.type"] = "PV5i1"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)
df$pnt = names(sort(table(df$pnt),decreasing = TRUE)[1])

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/PV5_celltyping.csv", row.names = FALSE)

# Process
if(process){
  # Update googlesheet
  write_lhns(df = df, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))

  # Make 2D Images
  take_pictures(df)
}

###########
# example #
###########
#
# # Create folder
# folder = sprintf("data-raw/hemibrain/pnts/images/example/")
# dir.create(folder, recursive = TRUE)
#
# # Set colours
# reds = grDevices::colorRampPalette(colors = c(hemibrain_bright_colors["cerise"],"grey10"))
# oranges = grDevices::colorRampPalette(colors = c(hemibrain_bright_colors["orange"],"grey10"))
# blues = grDevices::colorRampPalette(colors = c(hemibrain_bright_colors["cyan"],"grey10"))
# greens = grDevices::colorRampPalette(colors = c(hemibrain_bright_colors["green"],"grey10"))
# purples = grDevices::colorRampPalette(colors = c(hemibrain_bright_colors["purple"],"grey10"))
#
# # Set view
# nat::nopen3d(userMatrix = structure(c(0.827756524085999, 0.134821459650993,
#                                       -0.544648587703705, 0, 0.557223737239838, -0.311243295669556,
#                                       0.769824028015137, 0, -0.0657294392585754, -0.940718233585358,
#                                       -0.332759499549866, 0, 0, 0, 0, 1), .Dim = c(4L, 4L)), zoom = 0.710681617259979,
#              windowRect = c(0L, 45L, 1178L, 875L))
#
# # Plot hemilineages
# clear3d();rgl::plot3d(hemibrain.surf, col="grey", alpha = 0.1)
# x = db[names(db)%in%x]
# y = db[names(db)%in%y]
# z = db[names(db)%in%z]
# plot3d(x, lwd = 2, soma = 200, col = oranges(length(x)+10)[1:length(x)])
# plot3d(y, lwd = 2, soma = 200, col = purples(length(y)+10)[1:length(y)])
# plot3d(z, lwd = 2, soma = 200, col = greens(length(z)+10)[1:length(z)])
# rgl.snapshot(file=paste0(folder,"PV5_hemilineages.png"))
#
# # Plot anatomy groups
# clear3d();rgl::plot3d(hemibrain.surf, col="grey", alpha = 0.1)
# a = neuprint_read_neurons(subset(df, grepl("LHPV5a",cell.type))$bodyid, OmitFailures = TRUE, heal = FALSE)
# b = neuprint_read_neurons(subset(df, grepl("LHPV5d",cell.type))$bodyid, OmitFailures = TRUE, heal = FALSE)
# c = neuprint_read_neurons(subset(df, grepl("LHPV5g",cell.type))$bodyid, OmitFailures = TRUE, heal = FALSE)
# plot3d(a, lwd = 2, soma = 200, col = reds(length(a)+5)[1:length(a)])
# plot3d(b, lwd = 2, soma = 200, col = blues(length(b)+5)[1:length(b)])
# plot3d(c, lwd = 2, soma = 200, col = greens(length(c)+5)[1:length(c)])
# rgl.snapshot(file=paste0(folder,"PV5_anatomy_groups.png"))
#
# # Plot cell types
# clear3d();rgl::plot3d(hemibrain.surf, col="grey", alpha = 0.1)
# adf = subset(df, grepl("LHPV5a",cell.type))
# adf$cell.type = gsub("[a-z]$","",adf$cell.type)
# cols = hemibrain_bright_colors
# for(i in 1:length(unique(adf$cell.type))){
#   col = cols[i]
#   ct = unique(adf$cell.type)[i]
#   ctyp = subset(adf, cell.type == ct)
#   ctype = a[as.character(ctyp$bodyid)]
#   plot3d(ctype, lwd = 2, soma = 200, col = col)
# }
# rgl.snapshot(file=paste0(folder,"PV5_cell_types.png"))
#
#
