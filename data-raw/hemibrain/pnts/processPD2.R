#######
# pd2 #
#######
source("data-raw/hemibrain/startupHemibrain.R")

# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
pd1 = x = c("5813035117", "325458991", "5813043073", "359568460", "5813009749",
            "330259272", "297520036", "420977956", "5813009497", "267223027",
            "297524212", "325460206", "5813047774")
pd2 = y = c("509924185", "456096712", "794088227", "733040015", "695465316",
      "510278853", "540972196", "675119034", "702692200", "5813058310",
      "893338749", "579234980", "510278421", "731689147", "644761952",
      "704798196", "263674097", "675800901", "676138357", "486850582",
      "5813099667", "264014957", "5812980658", "735772860", "549257678",
      "611323310", "643691163", "5813013630", "325743813", "831273322",
      "790982851", "790641825", "822358700", "947859021", "947862945",
      "612652688", "823015627", "704078253", "822358833", "947858895",
      "456096372", "424729434", "5812980308", "456096281", "5813010560",
      "456113323", "486807709", "640281116", "701327912", "391328156",
      "5813039932", "329254539", "424733177", "5813009670", "5813010846",
      "453053044", "453329254", "390641835", "449209892", "579911580",
      "387809633", "418511983", "388924424", "392368893",
      "482002172", "518598175", "418503161", "324721026", "328538408",
      "418516266", "540967864", "484735637", "361273559", "451995306",
      "356429209", "674096140", "423105632", "703702863", "456152222",
      "456152258", "547888586", "578914626", "417834021", "640963092",
      "449205611", "449205588", "768192947", "5813021728", "449209971",
      "642693620", "5813089504", "509928512", "548872750",
      "5813129453", "571666400", "640963556", "573337611",
      "571666434", "542634516", "573329304", "760268555", "448869118",
      "5813014640", "699178922")

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
### PDL06^aSLPF1 PDL07^dLH PDL15^aSLPF3
PDL06 = neuprint_read_neurons("PDL06")
PDL06 = PDL06[names(PDL06)%in%hemibrain.lhn.bodyids]
PDL07 = neuprint_read_neurons("PDL07")
PDL07 = PDL07[names(PDL07)%in%hemibrain.lhn.bodyids]
PDL15 = neuprint_read_neurons("PDL15")
PDL15 = PDL15[names(PDL15)%in%hemibrain.lhn.bodyids]
pd2.hemi = union(PDL06,PDL07,PDL15)

### Re-define some of these CBFs
sd = setdiff(pd2, names(pd2.hemi))
ds = setdiff(names(pd2.hemi),pd2)
pd2 = unique(pd2, names(pd2.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% pd2)
df$cbf.change = FALSE
df$cell.type = NA
rownames(df) = df$bodyid

### Wrong CBF
wrong1 = c("604398262")
df[wrong1,"cbf.change"] = "PDL16^pLH11"

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "VLPd&p1_posterior "
df[x,"Hartenstein_Hemilineage"] = "DPLl2_posterior"
df[y,"ItoLee_Hemilineage"] = "SLPad1_posterior"
df[y,"Hartenstein_Hemilineage"] = "DPLl3_posterior"

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

a1 = c("267223027", "297524212", "5813009497", "297520036", "330259272") # light = c("fru-M-600135")
df[a1,"cell.type"] = "PD2a1"

a2 = "389951232"
df[a2,"cell.type"] = "PD1a2"

b1 = c("5813035117", "325460206", "325458991", "5813009749")
df[f,"cell.type"] = "PD1b1"

c1 = "5813047774"
df[c1,"cell.type"] = "PD1c1"

############
### PD2y ###
############

a = c("456096372", "424729434", "5812980308", "5813010846")
df[a,"cell.type"] = "DPLl2_dorsal_a"

b = c("486807709", "456096712", "456096281", "5813010560")
df[b,"cell.type"] = "DPLl2_dorsal_b"

c = c("388924424", "392368893")
df[c,"cell.type"] = "DPLl2_dorsal_c"

d = c("424733177", "456113323", "329254539", "391328156", "5813039932")
df[d,"cell.type"] = "DPLl2_dorsal_d"

e = c("453053044", "453329254")
df[e,"cell.type"] = "DPLl2_dorsal_e"

f = c("387809633", "390641835", "449209892", "5813009670", "418511983",
      "579911580")
f.f = "Gad1-F-300303"
df[c(f,f.f),"cell.type"] = "DPLl2_dorsal_f"

g = c("5813129453", "699178922")
g.g = c("Gad1-F-500129","121018c0", "Gad1-F-500196", "JJ13")
df[c(g,g.g),"cell.type"] = "DPLl2_dorsal_g"

h = c("760268555", "448869118", "5813014640")
h.h = c("121225c0", "131014c3", "130612c0", "121017c0","121227c3", "130620c0",
        "131007c0")
df[c(h,h.h),"cell.type"] = "DPLl2_dorsal_h"

i = c("548872750", "509928512", "5813089504", "571666400")
i.i = c("120926c0","37G11#5","Cha-F-000421","Cha-F-800096","121015c0","121016c0",
        "120914c2","131009c4","L989#12", "L989#8","L989#2", "JJ11", "JJ14", "JJ88")
df[c(i,i.i),"cell.type"] = "DPLl2_dorsal_i"

j = c("571666400", "573329304", "573337611", "542634516", "571666434", "640963556")
j.j = c("Cha-F-600238", "Gad1-F-200234","5HT1A-F-300019", "5HT1A-F-300013","37G11#2",
        "L989#3", "L989#4","L991#1", "L989#13", "L989#10", "L989#14","37G11#6", "L991#3", "L991#4", "L989#6", "37G11#1",
        "L989#9", "L991#2", "37G11#4", "L989#5", "L991#5", "37G11#3", "L989#11",
        "L989#1", "L989#7","120806c0", "JJ8", "JJ90")
df[c(j,j.j),"cell.type"] = "DPLl2_dorsal_j"

k = c("790641825", "822358700", "5813013630", "733040015", "794088227",
      "325743813", "831273322")
df[k,"cell.type"] = "DPLl2_dorsal_k"

l = c("735772860", "486850582", "5813099667")
df[l,"cell.type"] = "DPLl2_dorsal_l"

m = c("612652688", "823015627", "549257678", "611323310", "643691163")
df[m,"cell.type"] = "DPLl2_dorsal_m"

n = c("790982851", "947858895")
df[n,"cell.type"] = "DPLl2_dorsal_n"

o = c("704078253", "947862945", "822358833", "947859021")
df[o,"cell.type"] = "DPLl2_dorsal_o"

p = c("5812980658", "263674097", "264014957")
df[p,"cell.type"] = "DPLl2_dorsal_o"

q = c("675800901", "676138357", "644761952", "704798196")
df[q,"cell.type"] = "DPLl2_dorsal_q"

r = c("328538408", "361273559")
df[r,"cell.type"] = "DPLl2_dorsal_r"

s = c("482002172", "451995306", "484735637")
df[s,"cell.type"] = "DPLl2_dorsal_s"

t = c("423105632", "518598175")
df[t,"cell.type"] = "DPLl2_dorsal_t"

u = "695465316"
df[u,"cell.type"] = "DPLl2_dorsal_u"

v = c("509924185", "674096140")
df[v,"cell.type"] = "DPLl2_dorsal_v"

w = "324721026"
df[w,"cell.type"] = "DPLl2_dorsal_w"

x = c("356429209", "418503161")
df[x,"cell.type"] = "DPLl2_dorsal_x"

y = c("702692200", "5813058310", "893338749")
df[y,"cell.type"] = "DPLl2_dorsal_y"

z = c("579234980", "510278421", "731689147")
z.z = c("Cha-F-300347","Gad1-F-200037")
df[c(z,z.z),"cell.type"] = "DPLl2_dorsal_z"

za = c("540972196", "510278853", "675119034")
df[za,"cell.type"] = "DPLl2_dorsal_za"

zb = c("418516266", "540967864", "703702863")
df[zb,"cell.type"] = "DPLl2_dorsal_zb"

zc = c("5813021728", "640963092", "449205588", "768192947", "417834021",
       "449205611")
z.c = ("Cha-F-100453")
df[c(zc,z.c),"cell.type"] = "DPLl2_dorsal_zc"

zd = c("547888586", "578914626", "449209971", "642693620")
df[zd,"cell.type"] = "DPLl2_dorsal_zd"

ze = c("456152222", "456152258")
df[ze,"cell.type"] = "DPLl2_dorsal_ze"

zf = c("640281116", "701327912")
df[zf,"cell.type"] = "DPLl2_dorsal_zf"



########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/pd2_celltyping.csv", row.names = FALSE)

# Make 2D Images
take_pictures(df, pnt="pd2")

# Update googlesheet
write_lhns(df = df, column = c("cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))
