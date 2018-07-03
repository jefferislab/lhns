####################
# Process Raw Data #
###################


# Prepare data on Mike's splits
if(!exists("most.lhns")){
  stop("Please run processLHNs.R!")
}else if(!exists("most.lhins")){
  stop("Please run processLHNinputs.R!")
}


###### Read data from NRRD files ######

# ## Get the data from _skel.nrrd files:
# path = "/Volumes/Neuronaut1/LHsplits/skels/"
# lfs = list.files(path, recursive = TRUE)
# files = unlist(sapply(lfs, function(x) strsplit(x,"/")[[1]][4]))
# paths = list.files("/Volumes/Neuronaut1/LHsplits/skels/",recursive=TRUE)
# df = data.frame(file = files)
# type = c()
# cell.type = c()
# compartment = c()
# for(l in files){
#   l = gsub("_skel.nrrd","",l)
#   p = paths[grepl(l,paths)]
#   p = unlist(strsplit(p,"/"))
#   type = c(type,p[1])
#   cell.type = c(cell.type,p[2])
#   compartment = c(compartment,strsplit(p[4],"_")[[1]][2])
# }
# df$type = type
# df$old.cell.type = cell.type
# df$compartment = compartment
# splits = nlapply(paste0(path,lfs),dotprops, OmitFailures = FALSE)
# made.it = sapply(splits, attr, "file")
# did.not.make.it = lfs[!lfs%in%made.it] # Why?
# did.not.make.it = strsplit(did.not.make.it,"/")[[1]][6]
# df = subset(df, file!=did.not.make.it)
# attr(splits,"df") = df[,-1]


###### Load data and transform to appropriate brainspace ######

# # Or load directly
# load('data-raw/dolan_splits_1_dotprops.rda')
# load('data-raw/dolan_splits_2_dotprops.rda')
# splits = c(splits1,splits2)
# files = names(splits)
# names(splits) = unlist(sapply(files, function(x) paste(strsplit(as.character(x), "~|-")[[1]][1:2],collapse="-")))
#
# # Add more meta-data on line information
# a = read.csv("/GD/LMBD/Papers/2018lhsplitcode/Data/Case4_Viewer.csv",header = TRUE) # Update directory
# b = read.csv("/GD/LMBD/Papers/2018lhsplitcode/Data/Polarity_Viewer.csv",header = TRUE) # Update directory
# colnames(a) = colnames(b) = c("linecode","imagecode")
# c = merge(a,b,all.x = TRUE, all.y=TRUE)
# d = read.csv("/GD/LMBD/Papers/2018lhsplitcode/Data/SplitGAL4annotate.csv",header = TRUE)
# colnames(d) = c("linecode","imagecode","AD","DBD","clusters","num.clusters","Behaviour","Polarity","MCFO","stablestock","VNC")
# mf = data.frame()
# for(i in c$imagecode){
#   l = as.character(subset(c,imagecode==i)$linecode)
#   f = subset(d,linecode==l)[,c(-1,-2)]
#   if(nrow(f)>=1){
#     m = cbind(subset(c,imagecode==i),f)
#     mf = rbind(mf,m)
#   }
# }
# mf = mf[!duplicated(mf$imagecode),]
# rownames(mf) = mf$imagecode
# split.codes = unlist(sapply(names(splits), function(x) paste(unlist(strsplit(x,"_"))[-1:-2],collapse="_")))
# mf = mf[split.codes,]
# mf$neurotransmitter = splits[,]$NT
# mf$compartment = splits[,]$seg.type
# mf$old.cell.type = splits[,]$cell.type
# attr(splits,"df") = mf
#
# # Organise data
# dolan.splits.j = nat::nlapply(splits,nat.templatebrains::xform_brain,sample = nat.flybrains::JFRC2013,reference= nat.flybrains::FCWB,OmitFailures = T) # 4 lost...
# # dolan.splits.axons = dolan.splits.j[names(dolan.splits.j)%in%rownames(subset(splits[,],compartment=="axon|axonmemb"))]
# # dolan.splits.dendrites = dolan.splits.j[names(dolan.splits.j)%in%rownames(subset(splits[,],compartment=="dendrite|memb"))]
# dolan.splits =  subset(dolan.splits.j,compartment=="whole")
# attr(dolan.splits,"df") = subset(attr(dolan.splits.j,"df"),compartment=="whole")
# names(dolan.splits) = unlist(sapply(names(dolan.splits), function(x) paste(unlist(strsplit(x,"_"))[-1:-2],collapse="_")))
# # names(dolan.splits.axons) = unlist(sapply(names(dolan.splits.axons), function(x) paste(unlist(strsplit(x,"_"))[-1:-2],collapse="_")))
# # names(dolan.splits.dendrites) = unlist(sapply(names(dolan.splits.dendrites), function(x) paste(unlist(strsplit(x,"_"))[-1:-2],collapse="_")))
# dolan.splits.1 = dolan.splits[1:(length(dolan.splits)/2)]
# dolan.splits.2 = dolan.splits[((length(dolan.splits)/2)+1):length(dolan.splits)]
# save(dolan.splits.1,file = paste0(getwd(),"/data-raw/segmented.splits.1.dps.rda"))
# save(dolan.splits.2,file = paste0(getwd(),"/data-raw/segmented.splits.2.dps.rda"))

###### Make assignments for the segmented split line data ######


# Load the data made by the commented-out code above
load("data-raw/segmented.splits.1.dps.rda")
load("data-raw/segmented.splits.2.dps.rda")
dolan.splits = c(dolan.splits.1,dolan.splits.2)

# Initial data processing
nts = read.csv("data-raw/NT_annotation_from_Mike.csv")
# Get ready to collect info
md = dolan.splits[,]
md$match = NA
# Assing NT info
#md$NT = as.character(sapply(dolan.splits[,"clusters"],function(x) nts[x,]$NT))
# Assign some anatomy groups from Shahar's filemaker document
# md$anatomy.group = NA
# ags = sapply(md$imagecode,function(x) lhn.lines[unlist(sapply(lhn.lines$LineShortName,grepl,as.character(x))),]$anatomy.group[1] )
# ags = ifelse(ags=="",NA,ags)
# md$anatomy.group = ags


# LHNs

md["JRC_SS04972-20150929_33_A5",]$match ="Cha-F-600209"
md["JRC_SS16373-20160518_31_E4",]$match = "VGlut-F-600069"
md["JRC_SS16345-20160518_31_D4",]$match  ="VGlut-F-700430"
md["JRC_SS04718-20151231_33_F4",]$match  = "E0585-F-300040"
md["JRC_SS04949-20150828_31_J3",]$match="fru-M-200351"
md["JRC_SS04970-20151014_33_A1",]$match = "Cha-F-500234"
md["JRC_SS16036-20151231_33_D5",]$match = "E0585-F-300050"
md["GMR_25B07_AV_01-20150626_32_C1",]$match = "Cha-F-500250"
md["GMR_47B03_AV_01-20150626_32_I1",]$match = "Gad1-F-200366"
md["GMR_47B03_AV_01-20150626_32_I3",]$match = "Gad1-F-200366"
md["GMR_47B03_AV_01-20150626_32_I4",]$match = "Gad1-F-200366" # retired?
md["GMR_MB583B-20150828_31_A1",]$match = "Gad1-F-500004" # Similar, but not the same....? OR IS IT? ASK MIKE
md["GMR_MB583B-20150828_31_A2",]$match = "Gad1-F-500004" # Contamination in line
md["GMR_MB583B-20150828_31_A6",]$match = "Gad1-F-500004" # Similar, but not the same....? OR IS IT? ASK MIKE
#md["GMR_SS00502-20150814_31_I1",]$match = "Trh-M-400020" # "Trh-M-400020" # But it's input??? # Trh-F-500222 # Trh-M-500187 # Retired
md["JRC_SS03232-20151007_31_J1",]$match = "E0585-F-400028"
md["JRC_SS03773-20160415_31_G1",]$match = "Gad1-F-300148"
md["JRC_SS03773-20160415_31_G2",]$match  = "Gad1-F-300148" # Should be output, check that this is so
md["JRC_SS03773-20160415_31_G3",]$match  = "VGlut-F-600764"
md["JRC_SS03776-20151014_32_E1",]$match =  "Gad1-F-700071"
md["JRC_SS03783-20151231_33_A1",]$match = "fru-M-200351"
md["JRC_SS03783-20151231_33_A3",]$match  = "fru-M-200351"
md["JRC_SS03802-20160415_31_C1",]$match = "Gad1-F-100345"
md["JRC_SS04718-20151231_33_F1",]$match = "E0585-F-300040"
md["JRC_SS04718-20151231_33_F2",]$match= "E0585-F-300040"
md["JRC_SS04718-20151231_33_F2",]$match = "E0585-F-300040"
md["JRC_SS04951-20150929_33_B1",]$match="Cha-F-600032"
md["JRC_SS04951-20150929_33_B1",]$match ="Cha-F-500250"
md["JRC_SS04951-20150929_33_B4",]$match = "Cha-F-500250"
md["JRC_SS04956-20150828_31_D1",]$match = "PD2a1/b1"
md["JRC_SS04956-20150828_31_D2",]$match= "PD2a1/b1"
md["JRC_SS04957-20150828_31_E1",]$match="Cha-F-600207"
md["JRC_SS04957-20150828_31_E6",]$match = "Cha-F-600207"
md["JRC_SS04957-20160415_31_E3",]$match = "Cha-F-600207"
md["JRC_SS04964-20150821_31_H1",]$match= "Gad1-F-100345"
md["JRC_SS04964-20150821_31_H2",]$match = "Gad1-F-100345"
md["JRC_SS04969-20150821_31_E3",]$match = "Gad1-F-700071"
md[ "JRC_SS04969-20150821_31_E4",]$match = "Gad1-F-700071"
md["JRC_SS04970-20151014_33_A5",]$match = "Cha-F-500234"
md["JRC_SS04970-20151014_33_A6",]$match="Cha-F-500234"
md["JRC_SS04972-20150929_33_A4",]$match = "Cha-F-600209" # But possibly Gad1-F-300135? Check MD type
md["JRC_SS04972-20150929_33_A2",]$match= "Cha-F-600209" # But possibly Gad1-F-300135? Check MD type
md["JRC_SS15112-20160622_32_A2",]$match = "Gad1-F-200177"
md["JRC_SS15112-20160622_32_A4",]$match = "Gad1-F-200177" # Should it be "Gad1-F-200177"?
md["JRC_SS15112-20160622_32_B2",]$match = "Gad1-F-200177"
md["JRC_SS15125-20160422_32_C1",]$match = "Gad1-F-100168"
md["JRC_SS15125-20160422_32_C3",]$match = "Gad1-F-100168"
md["JRC_SS15125-20160422_32_D1",]$match = "Gad1-F-100168"
md["JRC_SS15267-20160427_32_I3",]$match="Gad1-F-500252" # Input apparently
md["JRC_SS16036-20151231_33_D1",]$match = "E0585-F-300069"
md["JRC_SS16036-20151231_33_D4",]$match = "E0585-F-300069"
md["JRC_SS16036-20151231_33_D4",]$match = "E0585-F-300069" # Not sure
md["JRC_SS16059-20151111_32_G1",]$match = "PD2a1/b1"
md["JRC_SS16345-20160518_31_C2",]$match = "VGlut-F-700430"
md["JRC_SS16345-20160518_31_C3",]$match  = "VGlut-F-700430"
md["JRC_SS16373-20160518_31_E1",]$match = "VGlut-F-600069"
md["JRC_SS16373-20160518_31_F1",]$match = "VGlut-F-600069"
md["JRC_SS16571-20160504_31_B1",]$match =  "Cha-F-000507"
md["JRC_SS16583-20160525_31_G1",]$match = "131007c1"
md["JRC_SS16583-20160525_31_H1",]$match = "131007c1"
md["JRC_SS16583-20160525_31_G3",]$match = "131007c1" # Looks a bit different. Fails to transform to FCWB.
md["JRC_SS16786-20151202_33_I1",]$match = "Cha-F-200282"
md["JRC_SS16787-20151231_33_G2",]$match = "E0585-F-400021"
md["JRC_SS16787-20151231_33_G4",]$match = "E0585-F-400021"
md["JRC_SS16979-20151231_33_H1",]$match = "Gad1-F-200366"
md["JRC_SS16979-20151231_33_H2",]$match = "Gad1-F-200366"
md["JRC_SS16979-20151231_33_H4",]$match = "Gad1-F-200366"
md["JRC_SS16980-20151231_33_I2",]$match = "E0585-F-400021"
md["JRC_SS22377-20160622_32_C4",]$match = "VGlut-F-400863"
md["JRC_SS22377-20160622_32_D4",]$match = "VGlut-F-400863"
md["JRC_SS22377-20160622_32_D6",]$match = "VGlut-F-400863"
md["JRC_SS24820-20160621_33_E1",]$match = "VGlut-F-700280"
md["JRC_SS24820-20160621_33_F2",]$match =  "VGlut-F-700280"
md["JRC_SS24820-20160621_33_F4",]$match = "VGlut-F-700280"
md["GMR_16H04_AV_01-20150619_32_C1",]$match = "5HT1A-M-100027"
md["GMR_16H04_AV_01-20150619_32_C3",]$match = "5HT1A-M-100027"
md["GMR_17B08_AV_01-20150619_32_D2",]$match = "E0585-F-300071"
md["GMR_17B08_AV_01-20150619_32_D4",]$match = "Gad1-F-200232"
md["GMR_17B08_AV_01-20150619_32_D5",]$match = "Gad1-F-200232"
md["GMR_22A12_AV_01-20150626_32_J1",]$match = "Cha-F-400165"
md["GMR_22A12_AV_01-20150626_32_J3",]$match = "Cha-F-400165"
md["GMR_22A12_AV_01-20150626_32_J4",]$match = "Cha-F-400165"
md["GMR_25B07_AV_01-20150706_31_F5",]$match = "E0585-F-400021"
md["GMR_53B06_AV_01-20150619_32_I1",]$match = "Gad1-F-900137"
md["GMR_53B06_AV_01-20150619_32_I2",]$match = "Gad1-F-500244"
md["GMR_53B06_AV_01-20150619_32_I3",]$match = "Gad1-F-500244"
md["GMR_MB036B-20160415_31_I1",]$match = "Gad1-F-900098"
md["GMR_MB036B-20160415_31_I2",]$match = "Gad1-F-900098"
md["GMR_MB036B-20160415_31_I3",]$match = "Gad1-F-900098"
md["GMR_MB380B-20150814_31_B6",]$match = "Gad1-F-700138" # MB C1?
md["GMR_MB380B-20151014_33_D1",]$match = "Gad1-F-700138"# MB C1?
md["GMR_MB380B-20151014_33_D4",]$match = "Gad1-F-700138"# MB C1?
md["GMR_SS01371-20150814_31_F1",]$match = "AD1d1" # NEW LHN
md["GMR_SS01371-20150814_31_F4",]$match = "AD1d1" # NEW LHN
md["GMR_SS01371-20150814_31_F6",]$match = "AD1d1" # NEW LHN
md["JRC_SS22613-20160621_33_G2",]$match = "Gad1-F-900037" # MEDIUM MATCH
md["JRC_SS22613-20160621_33_G4",]$match = "Gad1-F-900037" # MEDIUM MATCH
md["JRC_SS22613-20160621_33_G5",]$match = "Gad1-F-900037" # MEDIUM MATCH
md["JRC_SS03237-20151014_32_B1",]$match = "Gad1-F-300290"
md["JRC_SS03237-20151014_32_B2",]$match = "Gad1-F-300290"
md["JRC_SS03237-20151014_32_B3",]$match = "Gad1-F-300290"
md["JRC_SS03799-20151014_32_F3",]$match = "Gad1-F-900217"
md["JRC_SS03799-20151014_32_F4",]$match = "Gad1-F-900217"
md["JRC_SS03799-20151014_32_F5",]$match = "Gad1-F-900217"
md["JRC_SS03799-20151014_32_F5",]$match = "Gad1-F-900217"
# md["JRC_SS03799-20151014_32_F6",]$match = "Gad1-F-900217" # retired
md["JRC_SS03800-20151111_32_E4",]$match = "Cha-F-100370"
md["JRC_SS03800-20151111_32_E5",]$match = "Cha-F-100370"
md["JRC_SS04028-20151007_31_H2",]$match = "Cha-F-200282"
md["JRC_SS04028-20151007_31_H4",]$match = "Cha-F-200282"
md["JRC_SS03788-20160621_33_B3",]$match = "Gad1-F-500328"
md["JRC_SS04948-20150828_31_F1",]$match = "E0585-F-400028"
md["JRC_SS04948-20150828_31_F3",]$match = "E0585-F-400028"
md["JRC_SS04955-20150821_31_B1",]$match = "5HT1A-M-100027"
md["JRC_SS04959-20151007_31_A1",]$match = "Cha-F-000533"
md["JRC_SS04959-20151007_31_A5",]$match = "Cha-F-000533"
md["JRC_SS04971-20150821_31_I1",]$match = "Cha-F-100370"
md["JRC_SS04973-20150828_31_B1",]$match = "Cha-F-700219" # Maybe
md["JRC_SS15113-20151007_31_B1",]$match = "Cha-F-000533"
md["JRC_SS22675-20160622_32_F1",]$match = "Gad1-F-200365"
md["JRC_SS22675-20160622_32_G1",]$match = "Gad1-F-200365"
md["JRC_SS22675-20160622_32_G4",]$match = "Gad1-F-200365"
md["JRC_SS22713-20160622_32_I1",]$match= "Gad1-F-400257"
md["JRC_SS22713-20160622_32_I3",]$match = "Gad1-F-400257"
md["JRC_SS22713-20160622_32_I4",]$match = "Gad1-F-400257"
md["JRC_SS23087-20160621_33_H2",]$match = "Gad1-F-800092"
md["JRC_SS23087-20160621_33_I1",]$match = "Gad1-F-800092"
md["JRC_SS23087-20160621_33_I4",]$match = "Gad1-F-800092"
md["JRC_SS23097-20160629_31_C1",]$match = "Gad1-F-200237"
md["JRC_SS23097-20160629_31_C3",]$match = "Gad1-F-200237"
md["JRC_SS23097-20160629_31_D3",]$match = "Gad1-F-200237"
md["JRC_SS23107-20160629_31_E6",]$match = "Gad1-F-600202"
md["JRC_SS23107-20160629_31_F6",]$match = "Gad1-F-600202"
md["JRC_SS23112-20160629_31_H1",]$match = "Gad1-F-600202"
md["JRC_SS04965-20151111_32_A1",]$match= "Cha-F-000515"
md["JRC_SS04965-20151111_32_A2",]$match= "Cha-F-000515"
md["JRC_SS04965-20160525_31_C2",]$match= "Cha-F-000515"
md["JRC_SS04973-20150828_31_B1",]$match= "fru-F-700136"
md["JRC_SS04973-20150828_31_B3",]$match= "fru-F-700136"
md["JRC_SS04973-20160518_31_A3",]$match= "fru-F-700136"
md["JRC_SS16038-20151111_32_D2",]$match= "Gad1-F-800028" # Definitely need MCFO
md["JRC_SS16038-20151111_32_D3",]$match= "Gad1-F-800028" # Several possibilities:Gad1-F-200163, Gad1-F-800028 Cha-F-200385
md["JRC_SS16038-20170214_31_A2",]$match= "Gad1-F-800028" # Several possibilities:Gad1-F-200163, Gad1-F-800028 Cha-F-200385
md["JRC_SS16353-20160923_31_H4",]$match= "5HT1A-M-100027"
md["JRC_SS21825-20160928_31_A2",]$match= "5HT1A-M-100027"
md["JRC_SS21825-20160928_31_A3",]$match= "5HT1A-M-100027"
md["JRC_SS16986-20161207_31_F2",]$match= "Cha-F-800067"
md["JRC_SS16986-20161207_31_F6",]$match= "Cha-F-800067"
md["JRC_SS16986-20161207_31_G1",]$match= "Cha-F-800067"
md["JRC_SS22549-20170103_33_F3",]$match="Gad1-F-600143"
md["JRC_SS22549-20170103_33_F4",]$match="Gad1-F-600143"
md["JRC_SS22549-20170103_33_G1",]$match="Gad1-F-600143"
md["JRC_SS22732-20170214_31_C1",]$match="Gad1-F-300148"
md["JRC_SS22732-20170214_31_C2",]$match="Gad1-F-300148"
md["JRC_SS22732-20170214_31_D3",]$match="Gad1-F-300148"
md["JRC_SS16571-20160504_31_B1",]$match= "Cha-F-200186"
md["JRC_SS23170-20160622_31_F3",]$match= "Cha-F-200186"
md["JRC_SS23170-20160622_31_F5",]$match= "Cha-F-200186"
md["JRC_SS23187-20160622_31_G2",]$match="Cha-F-200398"
md["JRC_SS23187-20160622_31_G4",]$match="Cha-F-200398"
md["JRC_SS23187-20160622_31_H3",]$match="Cha-F-200398"
md["JRC_SS23354-20160824_31_F5",]$match="VGlut-F-900028"
md["JRC_SS23354-20170104_33_D2",]$match="VGlut-F-900028"
md["JRC_SS23354-20170104_33_D4",]$match="VGlut-F-900028"
md["JRC_SS23807-20160812_32_A2",]$match="Gad1-F-700258"
md["JRC_SS23807-20160812_32_A3",]$match="Gad1-F-700258"
md["JRC_SS23807-20160812_32_A6",]$match="Gad1-F-700258"
md["JRC_SS24155-20161207_32_H2",]$match="5HT1A-F-300030"
md["JRC_SS24155-20161207_32_H4",]$match="5HT1A-F-300030"
md["JRC_SS24155-20161207_32_H6",]$match="5HT1A-F-300030"
md["JRC_SS24177-20160622_31_A1",]$match ="Gad1-F-300218"
md["JRC_SS24177-20160622_31_A2",]$match ="Gad1-F-300218"
md["JRC_SS24177-20160622_31_B1",]$match ="Gad1-F-300218"
md["JRC_SS16364-20151202_33_H1",]$match = "fru-F-200126"
md["GMR_MB072C-20150814_31_D4",]$match= "PD2f1"
md["GMR_MB072C-20150814_31_D5",]$match= "PD2f1"
md["GMR_MB072C-20161019_32_E1",]$match= "PD2f1"
md["GMR_MB242A-20161019_32_G5",]$match= "MBON-Calyx"
md["GMR_MB242A-20161019_32_H2",]$match= "MBON-Calyx"
md["GMR_MB242A-20161019_32_H6",]$match= "MBON-Calyx"
md["JRC_SS03226-20161123_33_A4",]$match= "PV6a1"
md["JRC_SS03226-20161123_33_B3",]$match= "PV6a1"
md["JRC_SS03226-20161123_33_B5",]$match= "PV6a1"
md["JRC_SS24794-20160629_32_F1",]$match = "AV6c1"
md["JRC_SS15126-20151007_31_F5",]$match = "AV6c1"
md["JRC_SS24794-20160629_32_E2",]$match = "AV6c1"
md["GMR_30E03_XD_01-20150706_31_B5",]$match = "AV6b3"
md["GMR_30E03_XD_01-20150706_31_B4",]$match = "AV6b3"

### LH input

md["GMR_16H04_AV_01-20150619_32_B1",]$match = "Cha-F-000086"
md["GMR_16H04_AV_01-20150619_32_B3",]$match = "Cha-F-000086"
md["JRC_SS04960-20150929_33_C2",]$match = "VGlut-F-500810"
md["JRC_SS04960-20150929_33_C3",]$match = "VGlut-F-500810"
md["JRC_SS03797-20160621_33_C3",]$match = "WED-PN"
md["JRC_SS03797-20160621_33_D1",]$match = "WED-PN"
md["JRC_SS03797-20160621_33_C6",]$match = "WED-PN"
md["JRC_SS03801-20151111_32_F3",]$match = "WED-PN" # Hmm, is present in most.lhns....
md["JRC_SS15297-20160309_31_J4",]$match = "Cha-F-000086"
# md["GMR_SS00502-20150814_31_I4",]$match = "Trh-M-400020" # Hmm, is present in most.lhns.... # retired
# md["GMR_SS00502-20150814_31_I6",]$match = "Trh-M-400020" # Hmm, is present in most.lhns.... # retired
md["JRC_SS04962-20150828_31_C5",]$match = "Trh-F-100038"
md["GMR_MB295B-20150814_31_A3",]$match =  "Trh-F-100038" # Actually, quite different
md["JRC_SS04962-20150828_31_C3",]$match = "Trh-F-100038" # Actually, quite different
md["GMR_MB390B-20150814_31_C2",]$match =   "E0585-F-200014" # Quite far from completely the same
md["GMR_SS01262-20150814_31_H2",]$match =  "E0585-F-200014" # Hm, same as above
md["GMR_MB390B-20150814_31_C4",]$match =  "E0585-F-200014" # Hm, same as above
md["GMR_SS01331-20150814_31_G4",]$match = "Trh-M-000008"
md["GMR_SS01331-20150814_31_G5",]$match  ="VGlut-F-100003"
md["GMR_SS01331-20150814_31_G6",]$match = "E0585-F-200014" # Could also be Gad1-F-100169. More definite situation than the above
md["JRC_SS03788-20160621_33_A5",]$match = "Gad1-F-500328"
md["JRC_SS03788-20160621_33_A1",]$match = "Gad1-F-500328"
md["JRC_SS03801-20151111_32_F4",]$match = "WED-PN"
md["JRC_SS03801-20151111_32_F5",]$match = "WED-PN"
md["JRC_SS04960-20150929_33_C1",]$match = "VGlut-F-500810"
md["GMR_SS01159-20161207_32_F6",]$match= "VNC-PN1"
md["GMR_SS01159-20161207_32_G1",]$match= "VNC-PN1"
md["GMR_SS01159-20161207_32_G5",]$match= "VNC-PN1"
md["JRC_SS24671-20170308_32_A1",]$match= "fru-M-600165"
md["JRC_SS24671-20170308_32_A4",]$match= "fru-M-600165"
md["JRC_SS24671-20170308_32_A6",]$match= "fru-M-600165"
md["JRC_SS04924-20160812_32_D2",]$match= "LO-PN1"
md["JRC_SS04924-20160812_32_E1",]$match= "LO-PN1"
md["JRC_SS04924-20160812_32_E4",]$match= "LO-PN1"
md["JRC_SS15129-20161207_31_A1",]$match= "LO-PN2"
md["JRC_SS15129-20161207_31_A3",]$match= "LO-PN2"
md["JRC_SS15129-20161207_31_A4",]$match= "LO-PN2"
md["JRC_SS15267-20160427_32_H1",]$match= "PLP-PN1"
md["JRC_SS15267-20160427_32_H2",]$match= "PLP-PN1"
md["JRC_SS15267-20160427_32_I3",]$match= "PLP-PN1"
md["JRC_SS15300-20160525_31_E1",]$match = "Trh-F-500222"
md["JRC_SS15300-20160525_31_E2",]$match = "Trh-F-500222"
md["GMR_41H09_AV_01-20150626_32_D1",]$match = "Trh-F-500222"








### Relate this information back to most.lhns ###



df.a = most.lhns[,c("pnt","anatomy.group","cell.type","type")]
df.b = data.frame(pnt = most.lhins[,c("tract")],anatomy.group= most.lhins[,c("anatomy.group")],cell.type= most.lhins[,c("anatomy.group")], type = "IN")
rownames(df.b) = names(most.lhins)
df = rbind(df.b,df.a[!rownames(df.a)%in%rownames(df.b),])
md$pnt = as.character(sapply(md$match,function(x) df[x,]$pnt))
md$anatomy.group = as.character(sapply(md$match,function(x) df[x,]$anatomy.group))
md$cell.type = as.character(sapply(md$match,function(x) df[x,]$cell.type))
md$type = as.character(sapply(md$match,function(x) df[x,]$type))




# Some manual fixes



md[c("JRC_SS04956-20150828_31_D1",
     "JRC_SS04956-20150828_31_D2",
     "JRC_SS16059-20151111_32_G1"),]$pnt = "PD2"
md[c("JRC_SS04956-20150828_31_D1",
     "JRC_SS04956-20150828_31_D2",
     "JRC_SS16059-20151111_32_G1"),]$anatomy.group = "PD2a/b"
md[c("JRC_SS04956-20150828_31_D1",
     "JRC_SS04956-20150828_31_D2",
     "JRC_SS16059-20151111_32_G1"),]$cell.type = "PD2a1/b1"
md[c("JRC_SS04956-20150828_31_D1",
     "JRC_SS04956-20150828_31_D2",
     "JRC_SS16059-20151111_32_G1"),]$type = "ON"

md[c("JRC_SS24794-20160629_32_F1",
     "JRC_SS15126-20151007_31_F5",
     "JRC_SS24794-20160629_32_E2"),]$pnt = "AV6"
md[c("JRC_SS24794-20160629_32_F1",
     "JRC_SS15126-20151007_31_F5",
     "JRC_SS24794-20160629_32_E2"),]$anatomy.group = "AV6c"
md[c("JRC_SS24794-20160629_32_F1",
     "JRC_SS15126-20151007_31_F5",
     "JRC_SS24794-20160629_32_E2"),]$cell.type = "AV6c1"
md[c("JRC_SS24794-20160629_32_F1",
     "JRC_SS15126-20151007_31_F5",
     "JRC_SS24794-20160629_32_E2"),]$type = "ON"

md[c("GMR_30E03_XD_01-20150706_31_B4",
     "GMR_30E03_XD_01-20150706_31_B5"),]$pnt = "AV6"
md[c("GMR_30E03_XD_01-20150706_31_B4",
     "GMR_30E03_XD_01-20150706_31_B5"),]$anatomy.group = "AV6b"
md[c("GMR_30E03_XD_01-20150706_31_B4",
     "GMR_30E03_XD_01-20150706_31_B5"),]$cell.type = "AV6b3"
md[c("GMR_30E03_XD_01-20150706_31_B4",
     "GMR_30E03_XD_01-20150706_31_B5"),]$type = "ON"

md[c("GMR_SS01371-20150814_31_F1",
     "GMR_SS01371-20150814_31_F4",
     "GMR_SS01371-20150814_31_F6"),]$pnt = "AD1"
md[c("GMR_SS01371-20150814_31_F1",
     "GMR_SS01371-20150814_31_F4",
     "GMR_SS01371-20150814_31_F6"),]$anatomy.group = "AD1d"
md[c("GMR_SS01371-20150814_31_F1",
     "GMR_SS01371-20150814_31_F4",
     "GMR_SS01371-20150814_31_F6"),]$cell.type = "AD1d1"
md[c("GMR_SS01371-20150814_31_F1",
     "GMR_SS01371-20150814_31_F4",
     "GMR_SS01371-20150814_31_F6"),]$type = "ON"

md[c("JRC_SS03226-20161123_33_A4",
     "JRC_SS03226-20161123_33_B3",
     "JRC_SS03226-20161123_33_B5"),]$pnt = "PV6"
md[c("JRC_SS03226-20161123_33_A4",
     "JRC_SS03226-20161123_33_B3",
     "JRC_SS03226-20161123_33_B5"),]$anatomy.group = "PV6a"
md[c("JRC_SS03226-20161123_33_A4",
     "JRC_SS03226-20161123_33_B3",
     "JRC_SS03226-20161123_33_B5"),]$cell.type = "PV6a1"
md[c("JRC_SS03226-20161123_33_A4",
     "JRC_SS03226-20161123_33_B3",
     "JRC_SS03226-20161123_33_B5"),]$type = "ON"

md[c("GMR_MB072C-20150814_31_D4",
     "GMR_MB072C-20150814_31_D5",
     "GMR_MB072C-20161019_32_E1"),]$pnt = "PD2"
md[c("GMR_MB072C-20150814_31_D4",
     "GMR_MB072C-20150814_31_D5",
     "GMR_MB072C-20161019_32_E1"),]$anatomy.group = "PD2f"
md[c("GMR_MB072C-20150814_31_D4",
     "GMR_MB072C-20150814_31_D5",
     "GMR_MB072C-20161019_32_E1"),]$cell.type = "PD2f1"
md[c("GMR_MB072C-20150814_31_D4",
     "GMR_MB072C-20150814_31_D5",
     "GMR_MB072C-20161019_32_E1"),]$type = "ON"

md[c("GMR_MB380B-20150814_31_B6"),]$anatomy.group = "MB-C1"
md[c("GMR_MB380B-20151014_33_D1"),]$anatomy.group = "MB-C1"
md[c("GMR_MB380B-20151014_33_D4"),]$anatomy.group = "MB-C1"
md[c("GMR_MB380B-20150814_31_B6"),]$cell.type = "MB-C1"
md["GMR_MB380B-20151014_33_D1",]$cell.type =  "MB-C1"
md[c("GMR_MB380B-20151014_33_D4"),]$cell.type = "MB-C1"

md[c("GMR_MB242A-20161019_32_G5"),]$anatomy.group = "MBON-Calyx"
md[c("GMR_MB242A-20161019_32_H2"),]$anatomy.group = "MBON-Calyx"
md[c("GMR_MB242A-20161019_32_H6"),]$anatomy.group = "MBON-Calyx"
md[c("GMR_MB242A-20161019_32_G5"),]$cell.type = "MBON-Calyx"
md["GMR_MB242A-20161019_32_H2",]$cell.type =  "MBON-Calyx"
md[c("GMR_MB242A-20161019_32_H6"),]$cell.type = "MBON-Calyx"

md["JRC_SS03797-20160621_33_C6",]$cell.type = "WED-PN1"
md["JRC_SS03797-20160621_33_C6",]$cell.type = "WED-PN1"
md["JRC_SS03797-20160621_33_C6",]$cell.type = "WED-PN1"
md["GMR_MB295B-20150814_31_A3",]$cell.type = "WED-PN5"
md["JRC_SS04962-20150828_31_C3",]$cell.type = "WED-PN5"
md["JRC_SS04962-20150828_31_C5",]$cell.type = "WED-PN5"
md["JRC_SS03801-20151111_32_F4",]$cell.type = "WED-PN3"
md["JRC_SS03801-20151111_32_F5",]$cell.type = "WED-PN3"
md["JRC_SS03801-20151111_32_F3",]$cell.type = "WED-PN3"
md["JRC_SS03797-20160621_33_C3",]$cell.type = "WED-PN2"
md["JRC_SS03797-20160621_33_D1",]$cell.type = "WED-PN2"
md["JRC_SS03797-20160621_33_C6",]$cell.type = "WED-PN2"
md["GMR_SS01159-20161207_32_F6",]$cell.type = "VNC-PN1" # Previous: "TPN-2"
md["GMR_SS01159-20161207_32_G1",]$cell.type = "VNC-PN1"
md["GMR_SS01159-20161207_32_G5",]$cell.type = "VNC-PN1"
md["JRC_SS24671-20170308_32_A1",]$cell.type = "GNG-PN1"
md["JRC_SS24671-20170308_32_A4",]$cell.type = "GNG-PN1" # Previous: "TPN-1"
md["JRC_SS24671-20170308_32_A6",]$cell.type = "GNG-PN1"
md["JRC_SS04924-20160812_32_D2",]$cell.type = "LO-PN1" # Previous: "VPN-1"
md["JRC_SS04924-20160812_32_E1",]$cell.type = "LO-PN1"
md["JRC_SS04924-20160812_32_E4",]$cell.type = "LO-PN1"
md["JRC_SS15129-20161207_31_A1",]$cell.type = "LO-PN2" # Previous: "VPN-2"
md["JRC_SS15129-20161207_31_A3",]$cell.type = "LO-PN2"
md["JRC_SS15129-20161207_31_A4",]$cell.type = "LO-PN2"
md["JRC_SS15267-20160427_32_H1",]$cell.type= "PLP-PN1"
md["JRC_SS15267-20160427_32_H2",]$cell.type= "PLP-PN1"
md["JRC_SS15267-20160427_32_I3",]$cell.type = "PLP-PN1"
md["JRC_SS15300-20160525_31_E1",]$cell.type = "AVLP-PN1"
md["JRC_SS15300-20160525_31_E2",]$cell.type = "AVLP-PN1"
md["GMR_41H09_AV_01-20150626_32_D1",]$cell.type = "AVLP-PN1"

md[grepl("PN",md$cell.type),]$type = "IN"
#md[grepl("notLHproper",md$cell.type),]$type = "notLHproper"
md[grepl("MBON-Calyx|MB-C1",md$cell.type),]$type = "ON"


# 145 is both an input and output neuron
md[c("JRC_SS23107-20160629_31_E6", "JRC_SS23107-20160629_31_F6",
     "JRC_SS23112-20160629_31_H1"),]$type = "ON/IN"

# There appear to be 'new old names' in Mike's filemaker DB, so we need to add those in here
#md[md$cell.type=="GNG-PN2","linecode"] = "L2387"


### Save ###


# Sort
md$file = rownames(md)
attr(dolan.splits,"df") = md
dolan.splits[,"skeleton.type"] = "ConfocalStack"
lhon.splits.dps = dolan.splits[rownames(subset(md,type=="ON"))]
lhln.splits.dps = dolan.splits[rownames(subset(md,type=="LN"))]
lhin.splits.dps = dolan.splits[rownames(subset(md,type%in%c("IN","ON/IN")))]
lh.splits.dps = c(lhon.splits.dps,lhln.splits.dps,lhin.splits.dps)


# #################
# Update Meta-Data #
###################


lhon.splits.dps = as.neuronlistfh(lhon.splits.dps,dbdir = 'inst/extdata/data/', WriteObjects="missing")
lhln.splits.dps = as.neuronlistfh(lhln.splits.dps,dbdir = 'inst/extdata/data/', WriteObjects="missing")
lhin.splits.dps = as.neuronlistfh(lhin.splits.dps,dbdir = 'inst/extdata/data/', WriteObjects="missing")


#####################
# Write neuronlistfh #
#####################


write.neuronlistfh(lhon.splits.dps, file='inst/extdata/lhon.splits.dps.rds',overwrite = TRUE,compress=TRUE)
write.neuronlistfh(lhln.splits.dps, file='inst/extdata/lhln.splits.dps.rds',overwrite = TRUE,compress=TRUE)
write.neuronlistfh(lhin.splits.dps, file='inst/extdata/lhin.splits.dps.rds',overwrite = TRUE,compress=TRUE)


# # Which have already been labelled?
# noms = names(lh.splits)
# in.named.set = names(dolan.splits)[names(dolan.splits)%in%noms]
# not.in.named.set  = names(dolan.splits)[!names(dolan.splits)%in%noms]

# ### Delete after use
# plot3d(dolan.splits)
# s=select3d()
# split.clean = nlapply(dolan.splits[not.in.named.set],subset,s)
# result = res = nblast(split.clean, lhns::most.lhns.dps)

# ## OLD CODE
# # Assign Cell type
# nopen3d()
# cts = unique(as.character(dolan.splits[not.in.named.set][,]$old.cell.type))
# for(r in cts[10:22]){
#   clear3d()
#   message(r)
#   neurons = subset(dolan.splits,old.cell.type==r)
#   print(names(neurons))
#   plot3d(neurons,lwd=1)
#   plot3d(FCWB)
#   #plot3d(dolan.splits.axons[names(neurons)],lwd=3)
#   scr = sort(rowSums(res[,names(neurons)]),decreasing = TRUE)
#   n = nlscan(names(scr),db = lhns::most.lhns,col="black",lwd=3,soma=T)
#   print(n)
# }
