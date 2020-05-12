########
# Misc #
########
source("data-raw/hemibrain/startupHemibrain.R")

# Groups
contra.axons = c("357862532", "456833888", "513102394", "391613951",
                 "795749639", "549506753", "5813055903","699557275",
                 "731690040", "915105102", "1319206553", "1320230145",
                 "549555922", "426152854", "549895478", "548545143", "418888248",
                 "1256110026", "1318188592", "1193072388", "5813061403",
                 "1290581653","457179265","457209648","457196444","457179265",
                 "457520178","519581562","550944712","550944744","5813078595",
                 "855138330",
                 "581975262","732289834","732626324","793728582","823390508","824371460")
ascending.axons = c("1011941063", "1100261649", "1756816808", "1787510154", "763686208",
                    "512048416","512377806","519236349","519240432",
                    "583042026","608166388","614059839","637487760","698508565",
                    "703317507","732319555","854430148","917471250")
mals = c("607131089", "703033179", "887165687", "610571450", "5812980330",
         "671600919", "671604934", "637850749", "666818214", "668876945",
         "732984478", "825061437", "611323175", "609867847", "486073415",
         "764399773")



# Just get neuron assigned objects around the LH
lh.info = neuprintr::neuprint_find_neurons(
  input_ROIs = "LH(R)",
  output_ROIs =  'LH(R)',
  all_segments = FALSE)
lh.info.neurons = subset(lh.info, neuronStatus!="Traced")$bodyid

# Not in main files
csvs = list.files("data-raw/hemibrain/pnts/csv/", full.names = TRUE)
hemibrain.master = data.frame()
for(csv in csvs){
  df = read.csv(file = csv)
  hemibrain.master = rbind(hemibrain.master,df)
}

# Find missing neurons
missing = setdiff(hemibrain.lhn.bodyids,hemibrain.master$bodyid)
missing = setdiff(missing, lh.info.neurons)

# examine these neurons
missing = neuprint_read_neurons(missing)



# pV6?
c5 = c("451646125", "485387561","511267279")


############
### PV4z ###
############



# PV2?
y = c("667857582", "451308547", "359560762", "392645639", "511685955",
      "635109166")
z =  c("451308547",
       "359560762")

# Av6?
c = "421646999"
df[c,"cell.type"] = "unknown5_c"

g = "823395525"
df[g,"cell.type"] = "unknown5_g"

b = "483708083"  # light= "Cha-F-700236"
df[c(b,b.b),"cell.type"] = "unknown5_b"



v = c("765028935", "765050884")



u = c("1290253312", "5813082781", "1226793835", "1352315133", "1041931156",
      "978855713")


# PV4
w = c("297917475", "296168382", "295814895", "5813098375", "326128466",
      "5901194027", "358541542", "449236636", "326159897", "295120601",
      "510956083", "327850917", "387538632", "541965840", "357522097",
      "510956058", "510952092", "510956443")



# Visual PNs
a = "5813054304" # What is the split?
df[a,"cell.type"] = "AV3a"

b = c("2064040127", "852738570")
b.b = "5HT1A-F-300001"
df[c(b,b.b),"cell.type"] = "AV3b"

c = "5813055495"
df[c,"cell.type"] = "AV3c"

d = "857456902"
df[d,"cell.type"] = "AV3d"

s = "5813078261"
df[s,"cell.type"] = "AV3s"

w = "5813056083"
df[w,"cell.type"] = "AV3w"

a = "5813054304"
df[a,"cell.type"] = "BLAl_medial_a"

b = c("2064040127", "852738570")
b.b = "5HT1A-F-300001"
df[c(b,b.b),"cell.type"] = "BLAl_medial_b"

c = "5813055495"
df[c,"cell.type"] = "BLAl_medial_c"

d = "857456902"
df[d,"cell.type"] = "BLAl_medial_d"

e = "453320313"
e.e = "E0585-F-000005"
df[c(e,e.e),"cell.type"] = "BLAl_medial_e"


