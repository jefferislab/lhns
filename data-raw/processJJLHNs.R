library(elmr)

if(!exists("most.lhns")){
  stop("Please run processLHNs.R!")
}else if(!exists("most.lhins")){
  stop("Please run processLHNinputs.R!")
}

load("data-raw/jj.m.fcwb.rda")
df = jj.m.fcwb[,]
df$match = "UNKNOWN"
df$JJtype = "UNKNOWN"

#######################
# Find closest matches #
#######################

# ML1
df[c("JJ126"),]$JJtype = "ML1"
df["JJ126",]$match = "120816c1" # Closest FC: "Gad1-F-900037"

# ML2
df[c("JJ37"),]$JJtype = "ML2"
df["JJ37",]$match = "130726c1"

# ML3
df[c("JJ130","JJ133","JJ136","JJ26","JJ84"),]$JJtype = "ML3"
df["JJ130",]$match = "Gad1-F-200039"
df["JJ133",]$match = "Gad1-F-200039"
df["JJ136",]$match  = "Gad1-F-900037"
df["JJ26",]$match = "Gad1-F-900037"
df["JJ84",]$match = "Gad1-F-200039"

# ML4
df[c("JJ129","JJ25","JJ31","JJ33"),]$JJtype = "ML4"
df["JJ129",]$match = "Gad1-F-400233"
df["JJ25",]$match = "Gad1-F-400233"
df["JJ31",]$match = "Gad1-F-400233"
df["JJ33",]$match = "Gad1-F-400233"

# ML5
df[c("JJ27"),]$JJtype = "ML5"
df["JJ27",]$match = "120830c2" # UNCERTAIN

# ML6
df[c("JJ127"),]$JJtype = "ML6"
df["JJ127",]$match = "UNKNOWN" # Is this PD2?

# ML7
df[c("JJ132","JJ20"),]$JJtype = "ML7"
df["JJ132",]$match = "121129c0" # Closest FC: "Gad1-F-000249"
df["JJ20",]$match = "121129c0"

# ML8
df[c("JJ11","JJ14","JJ88"),]$JJtype = "ML8"
df["JJ11",]$match = "Cha-F-800096"
df["JJ14",]$match  = "5HT1A-F-300019?"
df["JJ88",]$match = "Cha-F-800096"

# ML9
df[c("JJ8","JJ90"),]$JJtype = "ML9"
df["JJ8",]$match = "5HT1A-F-300019"
df["JJ90",]$match = "5HT1A-F-300019"

# ML10
df[c("JJ32"),]$JJtype = "ML10"
df["JJ32",]$match = "Gad1-F-000249" # UNCERTAIN

# ML11
df[c("JJ13"),]$JJtype = "ML11"
df["JJ13",]$match = "Gad1-F-500129" # a1 version of Ban Sith?

# L1
df[c("JJ113","JJ114","JJ63","JJ67"),]$JJtype = "L1"
df["JJ113",]$match  = "Cha-F-000258" # "Cha-F-300272","Cha-F-100223
df["JJ114",]$match = "Cha-F-000258"
df["JJ63",]$match = "Cha-F-000258"
df["JJ67",]$match = "Cha-F-000258"

# L3
df[c("JJ141","JJ82"),]$JJtype = "L3"
df["JJ141",]$match = "Gad1-F-500140" # UNCERTAIN
df["JJ82",]$match = "Gad1-F-500140"

# L4
df[c("JJ119","JJ131"),]$JJtype = "L4"
df["JJ119",]$match = "UNKNOWN"
df["JJ131",]$match = "UNKNOWN"

# L5
df[c("JJ41"),]$JJtype = "L5"
df["JJ47",]$match = "UNKNOWN" # Is this even one neuron?

# L6 !
df[c("JJ140","JJ83","JJ120"),]$JJtype = "L6"
df["JJ140",]$match = "Gad1-F-000096" # correct anatomy group, incorrect cell type?
df["JJ83",]$match = "Gad1-F-000096" # correct anatomy group, incorrect cell type?
df["JJ120",]$match = "Gad1-F-000096" # correct anatomy group, incorrect cell type?

# L7
df[c("JJ46","JJ50"),]$JJtype = "L7"
df["JJ46",]$match = "VGlut-F-200319" # Also: "Cha-F-500272"
df["JJ50",]$match = "VGlut-F-200319"

# L8
df[c("JJ117","JJ134"),]$JJtype = "L8"
df["JJ117",]$match =  "121217c0"
df["JJ134",]$match = "121217c0"

# L9
df[c("JJ42","JJ135","JJ86"),]$JJtype = "L9"
df["JJ42",]$match = "Cha-F-300272"
df["JJ135",]$match = "Gad1-F-600106"
df["JJ86",]$match = "Gad1-F-600106" # UNSURE

# L11
df[c("JJ44","JJ121"),]$JJtype = "L11"
df["JJ44",]$match = "Gad1-F-800082"
df["JJ121",]$match = "Gad1-F-800082"

# L12
df[c("JJ43","JJ58"),]$JJtype = "L12"
df["JJ43",]$match = "Gad1-F-500363"
df["JJ58",]$match = "Gad1-F-500363"

#L13
df[c("JJ107","JJ108","JJ110","JJ111","JJ112","JJ115","JJ56","JJ57"),]$JJtype = "L13"
df["JJ107",]$match = "Cha-F-200185" # "Gad1-F-800082" ??
df["JJ108",]$match = "Cha-F-200185"
df["JJ110",]$match = "Cha-F-200185"
df["JJ111",]$match = "Cha-F-200185"
df["JJ112",]$match = "Cha-F-200185"
df["JJ115",]$match = "Cha-F-20018"
df["JJ56",]$match = "Cha-F-200185"
df["JJ57",]$match = "Cha-F-200185"

# L14
df[c("JJ81","JJ99"),]$JJtype = "L14"
df["JJ81",]$match = "Cha-F-100141"
df["JJ99",]$match = "Cha-F-100141"

# L15
df[c("JJ98","JJ100","JJ137"),]$JJtype = "L15"
df["JJ98",]$match = "Gad1-F-200232"
df["JJ100",]$match = "Gad1-F-200232"
df["JJ137",]$match = "Gad1-F-200232"

# local 1
df[c("JJ102","JJ124","JJ128"),]$JJtype = "Local1"
df["JJ102",]$match = "Cha-F-600207" # Different type from the other two??
df["JJ124",]$match = "Cha-F-000524"
df["JJ128",]$match = "Cha-F-000524"

# local 2
df[c("JJ142"),]$JJtype = "Local2"
df["JJ142",]$match = "UNKNOWN" # VGlut-F-300393"??

# Local 3
df[c("JJ139"),]$JJtype = "Local3"
df["JJ139",]$match = "VGlut-F-300393" # Phil Harris. Seems to be the same as local 5??

# Local 4
df[c("JJ92"),]$JJtype = "Local4"
df["JJ92",]$match  = "fru-F-600131"

# Local 5
df[c("JJ125","JJ66"),]$JJtype = "Local5"
df["JJ125",]$match = "VGlut-F-300393" # JJ neuron poorly registered? REALLY UNSURE
df["JJ66",]$match = "VGlut-F-300393"

# Local 6
df[c("JJ64","JJ78"),]$JJtype = "Local6"
df["JJ64",]$match = "Cha-F-400165"
df["JJ78",]$match  = "Cha-F-400165"

# Local 7
df[c("JJ76","JJ72","JJ123","JJ73","JJ40"),]$JJtype = "Local7"
df["JJ76",]$match = "Gad1-F-400436"
df["JJ72",]$match = "Gad1-F-400436"
df["JJ123",]$match = "fru-F-400486" #Same as "140213c1
df["JJ73",]$match = "fru-F-400486" # UNSURE
df["JJ40",]$match = "fru-F-400486" # UNSURE

# CML2 # I reckon CML1 and CML2 are pretty much the same? In the set, dendrites at different positions.
df[c("JJ55"),]$JJtype = "CML1"
df["JJ55",]$match = "Gad1-F-400255"

# CML2
df[c("JJ138","JJ30","JJ48","JJ53","JJ60","JJ85"),]$JJtype = "CML2"
df["JJ138",]$match = "Gad1-F-800107"
df["JJ30",]$match = "Gad1-F-800107"
df["JJ48",]$match = "Gad1-F-800107"
df["JJ53",]$match = "Gad1-F-800107"
df["JJ60",]$match = "Gad1-F-800107"
df["JJ85",]$match = "Gad1-F-800107"

# V1
df[c("JJ94"),]$JJtype = "V1"
df["JJ94",]$match = "Cha-F-100420"

# V2
df[c("JJ79"),]$JJtype = "V2"
df["JJ79",]$match = "Cha-F-200034"

# V3
df[c("JJ15","JJ16","JJ17","JJ22","JJ87"),]$JJtype = "V3"
df["JJ15",]$match = "Gad1-F-200387"
df["JJ16",]$match = "Gad1-F-200387"
df["JJ17",]$match = "Gad1-F-200387"
df["JJ22",]$match = "Gad1-F-200387"
df["JJ87",]$match = "Gad1-F-200387"

# MLV1
df[c("JJ41"),]$JJtype = "MLV1"
df["JJ41",]$match = "UNKNOWN"

# LV1
df[c("JJ95"),]$JJtype = "LV1"
df["JJ95",]$match = "Gad1-F-200137"

# Get the cell type and anatomy group info from most.lhns
ml = lhns::most.lhns[,c("anatomy.group","cell.type","type")]
df$anatomy.group = as.character(sapply(df$match,function(x) ml[x,]$pnt))
df$anatomy.group = as.character(sapply(df$match,function(x) ml[x,]$anatomy.group))
df$cell.type = as.character(sapply(df$match,function(x) ml[x,]$cell.type))
df$type = as.character(sapply(df$match,function(x) ml[x,]$type))
df$skeleton.type = "DyeFill"

# Re-attach data frame
jfw.lhns = jj.m.fcwb
attr(jfw.lhns,"df")  =  df


#####################
# Create neuronlistfh #
#####################


jfw.lhns = nlapply(jfw.lhns,nat::resample,stepsize = 1)
jfw.lhns = as.neuronlistfh(jfw.lhns,dbdir = 'inst/extdata/data/', WriteObjects="missing")
jfw.lhns.dps = nat::dotprops(lh.mcfo,OmitFailures=TRUE)
jfw.lhns.dps = as.neuronlistfh(jfw.lhns.dps,dbdir = 'inst/extdata/data/', WriteObjects="missing")


# #################
# Update Meta-Data #
###################

write.neuronlistfh(jfw.lhns, file='inst/extdata/jfw.lhns.rds',overwrite = TRUE)
write.neuronlistfh(jfw.lhns.dps, file='inst/extdata/jfw.lhns.dps.rds',overwrite = TRUE)


