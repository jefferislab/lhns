# Prepare data on Mike's splits
load('data-raw/dolan_splits_dotprops.rda')
if(!exists("lhn.lines")){
  stop("Please run processLHNlines.R!")
}else if(!exists("most.lhns")){
  stop("Please run processLHNs.R!")
}else if(!exists("lh.inputs")){
  stop("Please run processLHNinputs.R!")
}





# Initial data processing
nts = read.csv("data-raw/NT_annotation_from_Mike.csv")
# Transform into FCWB space
dolan.splits = nat::nlapply(dolan.splits,nat.templatebrains::xform_brain,sample = nat.flybrains::JFRC2013,reference= nat.flybrains::FCWB,OmitFailures = T)
md = dolan.splits[,]
colnames(md) = c("miketype","old.cell.type","line")
md$match = NA
# Assing NT info
md$neurotransmitter = as.character(sapply(dolan.splits[,"cell.type"],function(x) nts[x,]$NT))
# Assign some anatomy groups from Shahar's filemaker document
md$anatomy.group = NA
ags = sapply(md$cell.type,function(x) unique(subset(lhn.lines,Cluster==as.character(x))$value)[1] )
ags = ifelse(ags=="",NA,ags)
md$anatomy.group = ags






### Assign most similar FlyCircuit neuron





md["JRC_SS04972-20150929_33_A5",]$match ="Cha-F-600209"
md["JRC_SS16373-20160518_31_E4",]$match = "Cha-F-300357"
md["JRC_SS16345-20160518_31_D4",]$match  ="VGlut-F-700430"
md["JRC_SS04718-20151231_33_F4",]$match  = "E0585-F-300040"
md["JRC_SS04949-20150828_31_J3",]$match="fru-M-200351"
md["JRC_SS04970-20151014_33_A1",]$match = "Cha-F-500234"
md["JRC_SS16036-20151231_33_D5",]$match = "E0585-F-300050"
md["GMR_25B07_AV_01-20150626_32_C1",]$match = "Cha-F-500250"
md["GMR_30E03_XD_01-20150706_31_B5",]$match = "Cha-F-100427"
md["GMR_47B03_AV_01-20150626_32_I1",]$match = "Gad1-F-200366"
md["GMR_47B03_AV_01-20150626_32_I3",]$match = "Gad1-F-200366"
md["GMR_47B03_AV_01-20150626_32_I4",]$match = "Gad1-F-200366"
md["GMR_MB583B-20150828_31_A1",]$match = "Gad1-F-500004" # Similar, but not the same....? OR IS IT? ASK MIKE
md["GMR_MB583B-20150828_31_A2",]$match = "Gad1-F-500004" # Contamination in line
md["GMR_MB583B-20150828_31_A6",]$match = "Gad1-F-500004" # Similar, but not the same....? OR IS IT? ASK MIKE
md["GMR_SS00502-20150814_31_I1",]$match = "Trh-M-400020" # "Trh-M-400020" # But it's input??? # Trh-F-500222 # Trh-M-500187
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
md["JRC_SS04956-20150828_31_D1",]$match = "PD2a1b1"
md["JRC_SS04956-20150828_31_D2",]$match= "Pd2a1b1"
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
md["JRC_SS15112-20160622_32_A4",]$match = "Gad1-F-200177" # Should it be "Gad1-F-200177"
md["JRC_SS15112-20160622_32_B2",]$match = "Gad1-F-200177"
md["JRC_SS15125-20160422_32_C1",]$match = "Gad1-F-100168"
md["JRC_SS15125-20160422_32_C3",]$match = "Gad1-F-100168"
md["JRC_SS15125-20160422_32_D1",]$match = "Gad1-F-100168"
md["JRC_SS15126-20151007_31_F5",]$match = "Cha-F-200454" # OR Cha-F-200454? "av6c" DUNNO MAN JST. MIGHT BE NEW.
md["JRC_SS15267-20160427_32_I3",]$match="Gad1-F-500252" # Input apparently
md["JRC_SS16036-20151231_33_D1",]$match = "E0585-F-300069"
md["JRC_SS16036-20151231_33_D4",]$match = "E0585-F-300069"
md["JRC_SS16036-20151231_33_D4",]$match = "E0585-F-300069" # Not sure
md["JRC_SS16059-20151111_32_G1",]$match = "PD2a1b1"
md["JRC_SS16345-20160518_31_C2",]$match = "VGlut-F-700430"
md["JRC_SS16345-20160518_31_C3",]$match  = "VGlut-F-700430"
md["JRC_SS16373-20160518_31_E1",]$match = "Cha-F-300357"
md["JRC_SS16373-20160518_31_F1",]$match = "Cha-F-300357"
md["JRC_SS16583-20160525_31_G1",]$match = "Cha-F-500105" # Maybe
md["JRC_SS16571-20160504_31_B1",]$match =  "Cha-F-000507"
md["JRC_SS16583-20160525_31_G1",]$match = "Gad1-F-100077"
md["JRC_SS16583-20160525_31_H1",]$match = "Gad1-F-100077"
md["JRC_SS16786-20151202_33_I1",]$match = "Cha-F-200282"
md["JRC_SS16787-20151231_33_G2",]$match = "E0585-F-300073"
md["JRC_SS16787-20151231_33_G4",]$match = "E0585-F-300073"
md["JRC_SS16979-20151231_33_H1",]$match = "Gad1-F-100077"
md["JRC_SS16979-20151231_33_H2",]$match = "Gad1-F-100077"
md["JRC_SS16979-20151231_33_H4",]$match = "Gad1-F-100077"
md["JRC_SS16980-20151231_33_I2",]$match = "Gad1-F-300163"
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
md["GMR_30E03_XD_01-20150706_31_B4",]$match = "Cha-F-700219"
md["GMR_41H09_AV_01-20150626_32_D1",]$match = "Trh-F-500222"
md["GMR_53B06_AV_01-20150619_32_I1",]$match = "Gad1-F-900137"
md["GMR_53B06_AV_01-20150619_32_I2",]$match = "Gad1-F-500244"
md["GMR_53B06_AV_01-20150619_32_I3",]$match = "Gad1-F-500244"
md["GMR_MB036B-20160415_31_I1",]$match = "Gad1-F-900098"
md["GMR_MB036B-20160415_31_I2",]$match = "Gad1-F-900098"
md["GMR_MB036B-20160415_31_I3",]$match = "Gad1-F-900098"
md["GMR_MB380B-20150814_31_B6",]$match = "Gad1-F-700138" # MB C1?
md["GMR_MB380B-20151014_33_D1",]$match = "Gad1-F-700138"# MB C1?
md["GMR_MB380B-20151014_33_D4",]$match = "Gad1-F-700138"# MB C1?
md["GMR_SS01371-20150814_31_F1",]$match = "Gad1-F-700076" # NEW LHN? THIS ISN'T A GOOD MATCH
md["GMR_SS01371-20150814_31_F4",]$match = "Gad1-F-700076" # NEW LHN? THIS ISN'T A GOOD MATCH
md["GMR_SS01371-20150814_31_F6",]$match = "Gad1-F-700076" # NEW LHN? THIS ISN'T A GOOD MATCH
md["JRC_SS03237-20151014_32_B1",]$match = "Gad1-F-300290"
md["JRC_SS03237-20151014_32_B2",]$match = "Gad1-F-300290"
md["JRC_SS03237-20151014_32_B3",]$match = "Gad1-F-300290"
md["JRC_SS03799-20151014_32_F3",]$match = "Gad1-F-900217"
md["JRC_SS03799-20151014_32_F4",]$match = "Gad1-F-900217"
md["JRC_SS03799-20151014_32_F5",]$match = "Gad1-F-900217"
md["JRC_SS03799-20151014_32_F5",]$match = "Gad1-F-900217"
md["JRC_SS03799-20151014_32_F6",]$match = "Gad1-F-900217"
md["JRC_SS03800-20151111_32_E4",]$match = "Gad1-F-700243"
md["JRC_SS03800-20151111_32_E5",]$match = "Gad1-F-700243"
md["JRC_SS04028-20151007_31_H2",]$match = "Cha-F-200282"
md["JRC_SS04028-20151007_31_H4",]$match = "Cha-F-200282"
md["JRC_SS03788-20160621_33_B3",]$match = "New:PVLP Projection"
md["JRC_SS04948-20150828_31_F1",]$match = "E0585-F-400028"
md["JRC_SS04948-20150828_31_F3",]$match = "E0585-F-400028"
md["JRC_SS04955-20150821_31_B1",]$match = "5HT1A-M-100027"
md["JRC_SS04959-20151007_31_A1",]$match = "Cha-F-000533"
md["JRC_SS04959-20151007_31_A5",]$match = "Cha-F-000533"
md["JRC_SS04971-20150821_31_I1",]$match = "Cha-F-100370"
md["JRC_SS04973-20150828_31_B1",]$match = "Cha-F-700219" # Maybe
md["JRC_SS15113-20151007_31_B1",]$match = "Cha-F-000533"
md["JRC_SS22613-20160621_33_G2",]$match = "Gad1-F-900037" # NEW LHN? THIS ISN'T A GOOD MATCH
md["JRC_SS22613-20160621_33_G4",]$match = "Gad1-F-900037" # NEW LHN? THIS ISN'T A GOOD MATCH
md["JRC_SS22613-20160621_33_G5",]$match = "Gad1-F-900037" # NEW LHN? THIS ISN'T A GOOD MATCH
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
md["JRC_SS24794-20160629_32_E2",]$match = "Cha-F-200454"
md["JRC_SS24794-20160629_32_F1",]$match = "Cha-F-200454"





### Assign to input neurons ###




md["GMR_16H04_AV_01-20150619_32_B1",]$match = "Cha-F-000086"
md["GMR_16H04_AV_01-20150619_32_B3",]$match = "Cha-F-000086"
md["JRC_SS04960-20150929_33_C2",]$match = "VGlut-F-500810"
md["JRC_SS04960-20150929_33_C3",]$match = "VGlut-F-500810"
md["JRC_SS03797-20160621_33_C3",]$match = "New:Wedge Projection"
md["JRC_SS03797-20160621_33_D1",]$match = "New:Wedge Projection"
md["JRC_SS03797-20160621_33_C6",]$match = "New:Wedge Projection"
md["JRC_SS03801-20151111_32_F3",]$match = "New:Wedge Projection" # Hmm, is present in most.lhns....
md["JRC_SS15300-20160525_31_E1",]$match = "Trh-F-500222"
md["JRC_SS15300-20160525_31_E2",]$match = "Trh-F-500222" # Hmm, is present in most.lhns....
md["JRC_SS15297-20160309_31_J4",]$match = "Cha-F-000086"
md["GMR_SS00502-20150814_31_I4",]$match = "Trh-M-400020" # Hmm, is present in most.lhns....
md["GMR_SS00502-20150814_31_I6",]$match = "Trh-M-400020" # Hmm, is present in most.lhns....
md["JRC_SS04962-20150828_31_C5",]$match = "Trh-F-100038"
md["GMR_MB295B-20150814_31_A3",]$match =  "Trh-F-100038" # Actually, quite different
md["JRC_SS04962-20150828_31_C3",]$match = "Trh-F-100038" # Actually, quite different
md["GMR_MB390B-20150814_31_C2",]$match =   "E0585-F-200014" # Quite far from completely the same
md["GMR_SS00502-20150814_31_I4",]$match= "Trh-M-400020" # i think there are two cell types in this line, this oen and the one above.
md["GMR_SS01262-20150814_31_H2",]$match =  "E0585-F-200014" # Hm, same as above
md["GMR_MB390B-20150814_31_C4",]$match =  "E0585-F-200014" # Hm, same as above
md["GMR_SS01331-20150814_31_G4",]$match = "Trh-M-000008"
md["GMR_SS01331-20150814_31_G5",]$match  ="VGlut-F-100003"
md["GMR_SS01331-20150814_31_G6",]$match = "E0585-F-200014" # Could also be Gad1-F-100169. More definite situation than the above
md["JRC_SS03788-20160621_33_A5",]$match = "New:PVLP Projection"
md["JRC_SS03788-20160621_33_A1",]$match = "New:PVLP Projection"
md["JRC_SS03801-20151111_32_F4",]$match = "New:Wedge Projection"
md["JRC_SS03801-20151111_32_F5",]$match = "New:Wedge Projection"
md["JRC_SS04960-20150929_33_C1",]$match = "VGlut-F-500810"






### Relate this information back to most.lhns ###




df.a = most.lhns[,c("anatomy.group","cell.type","type")]
df.b = data.frame(anatomy.group=lh.inputs[,c("anatomy.group")],cell.type=lh.inputs[,c("anatomy.group")], type = "IN")
rownames(df.b) = names(lh.inputs)
df = rbind(df.b,df.a[!rownames(df.a)%in%rownames(df.b),])
md$anatomy.group = as.character(sapply(md$match,function(x) df[x,]$anatomy.group))
md$cell.type = as.character(sapply(md$match,function(x) df[x,]$cell.type))
md$type = as.character(sapply(md$match,function(x) df[x,]$type))


# Some fixes
md[c("JRC_SS22377-20160622_32_C4"),]$anatomy.group = "PD2a1b1"
md[c("JRC_SS04956-20150828_31_D2"),]$anatomy.group = "PD2a1b1"
md[c("JRC_SS16059-20151111_32_G1"),]$anatomy.group = "PD2a1b1"
md[c("JRC_SS22377-20160622_32_C4"),]$cell.type = "PD2a1b1"
md[c("JRC_SS04956-20150828_31_D2"),]$cell.type = "PD2a1b1"
md["JRC_SS16059-20151111_32_G1",]$cell.type = "PD2a1b1"

md[c("GMR_MB380B-20150814_31_B6"),]$anatomy.group = "MB-C1"
md[c("GMR_MB380B-20151014_33_D1"),]$anatomy.group = "MB-C1"
md[c("GMR_MB380B-20151014_33_D4"),]$anatomy.group = "MB-C1"
md[c("GMR_MB380B-20151014_33_D1"),]$cell.type = "MB-C1"
md["GMR_MB380B-20151014_33_D4",]$cell.type =  "MB-C1"
md[c("GMR_MB380B-20151014_33_D4"),]$cell.type = "MB-C1"


### Save ###




attr(dolan.splits,"df") = md
lh.splits = dolan.splits
devtools::use_data(lh.splits,overwrite=TRUE, compress = FALSE)
#  Trh-M-500183 same as Trh-M-400020??
# Mike's 1C and 3b are actually two cell types





