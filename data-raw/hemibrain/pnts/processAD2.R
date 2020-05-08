#######
# AD2 #
#######
source("data-raw/hemibrain/startupHemibrain.R")

# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
x = c("578189576",
      "582027317",
      "5813008942",
      "421654726",
      "795745097",
      "453708274",
      "5813055904",
      "487148422","795745097", "767433432", "790629881", "391652073", "359913281",
  "727153132", "328543082",
  "547443555", "391976125", "733986433",
  "484355636", "637483692", "453333562",
  "390612328", "454347852", "546464512",
  "578189576", "421318649", "328861072", "357859600", "453708274",
  "761661626","605762571", "5813014526", "5813047371", "703387200",
  "516832391", "642948546", "422674339", "547103110", "421668365", "5813010770", "390909624", "484359384",
  "7112579848")
y = c("1103076052", "796733296", "891914014", "670219670", "639875892",
         "608840926", "922608418",
         "1012298719", "891577717", "891577867", "977201905", "574027813",
         "760272462", "576843029", "666136034", "573713481", "917497441",
         "950233506",
         "361968122", "330604760", "390952738",  "5813020846",
         "541347811", "361351171", "604070433", "788519447", "885163107")
z = c("702364805", "706831482")
ad2 = c(x, y, z)

### Get FAFB assigned hemilineage information
x.match = unique(hemibrain_lhns[x,"FAFB.match"])
x.match = x.match[!is.na(x.match)]
x.match = read.neurons.catmaid.meta(x.match)
y.match = unique(hemibrain_lhns[y,"FAFB.match"])
y.match = y.match[!is.na(y.match)]
y.match = read.neurons.catmaid.meta(y.match)

### Meta info
mx = neuprint_get_meta(x)
my = neuprint_get_meta(y)
table(mx$cellBodyFiber)
table(my$cellBodyFiber)

### CBFs:
### ADL14^dAOTU2 ADL18^dAOTU3 ADL12^dAOTU1
ADL14 = neuprint_read_neurons("ADL14")
ADL14 = ADL14[names(ADL14)%in%lhn.ids]
ADL18 = neuprint_read_neurons("ADL18")
ADL18 = ADL18[names(ADL18)%in%lhn.ids]
ADL12 = neuprint_read_neurons("ADL12")
ADL12 = ADL12[names(ADL12)%in%lhn.ids]
ad2.hemi = c(ADL14,ADL18, ADL12)

### Re-define some of these CBFs
sd = setdiff(ad2, names(ad2.hemi))
ds = setdiff(names(ad2.hemi),ad2)
ad2 = unique(ad2, names(ad2.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% ad2)
df$cbf.change = FALSE
df$cell.type = NA
rownames(df) = df$bodyid

### Wrong CBF
wrong1 = c("")
df[wrong1,"cbf.change"] = ""

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

a1 = c("421318649", "761661626") # light = c("fru-M-500103", "fru-F-400325", "fru-F-400420")
df[a1,"cell.type"] = "AD2a1"

b1 = c("767433432", "790629881", "727153132", "795745097", "421654726") # light = c("fru-F-500117", "fru-F-400067", "fru-F-500116", "fru-F-500184","fru-F-700078")
df[b1,"cell.type"] = "AD2b1"

b2 = c("642948546", "391652073", "328543082", "359913281") # light = c("VGlut-F-500148")
df[b1,"cell.type"] = "AD2b2"

b3 = c("421668365", "5813010770")
df[b3,"cell.type"] = "AD2b3"

c1 = c("5813055904", "578189576")
df[c1,"cell.type"] = "AD2c1"

d1 = c("487148422")
df[d1,"cell.type"] = "AD2d1"

f1 = "702364805"
df[f1,"cell.type"] = "DPLl3_anterior_a"

g1 = c("454347852", "546464512")
df[g1,"cell.type"] = "AD2g2"

g2 = c("547443555", "733986433")
df[g2,"cell.type"] = "DPLl3_anterior_m"

g3 = c("547103110", "5813047371")
df[g3,"cell.type"] = "AD2g3"

g4 = "453333562"
df[g4,"cell.type"] = "AD2g4"

g5 = "7112579848"
df[g5,"cell.type"] = "AD2g5"

h1 = c("484355636", "637483692","390909624", "484359384")
df[h1,"cell.type"] = "AD2h1"

############
### ad2y ###
############

e1 = "390952738"
df[e1,"cell.type"] = "AD2e1"

e2 = "330604760"
df[e2,"cell.type"] = "AD2e2"

e3 = "361968122"
df[e3,"cell.type"] = "AD2e3"

j1 = "706831482"
df[j1,"cell.type"] = "AD2j1"

i1 = c("576843029", "573713481")
df[i1,"cell.type"] = "AD2i1"

i2 = c("666136034", "917497441")
df[i2,"cell.type"] = "AD2i2"

i3 = c("788519447", "574027813", "760272462")
df[i3,"cell.type"] = "AD2i3"

i4 = "670219670"
df[i4,"cell.type"] = "AD2i4"

i5 = c("891577867", "1012298719")
df[i5,"cell.type"] = "AD2i5"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/ad2_celltyping.csv", row.names = FALSE)

# Make 2D Images
take_pictures(df, pnt="ad2")

# Update googlesheet
write_lhns(df = df, column = c("cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))


##########
# Issues #
##########

# "483336652"

