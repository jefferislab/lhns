# #################
# Process Raw Data #
###################


# Prepare data on Mike's splits
require(reshape2)
if(!exists("lh.mcfo")){
  stop("Please run processMCFO.R!")
}else if(!exists("lh.splits.dps")){
  stop("Please run processDolanSplits.R!")
}


################################################
# Read Dolan et al. 2018 split line information #
################################################

# Clean data of stray cell type
lh.mcfo.clean = subset(lh.mcfo,InLine==TRUE)
lh.splits.dps.clean = subset(lh.splits.dps,!old.cell.type%in%lh.mcfo[,"old.cell.type"])

# Get the projected number of neurons for each cell type, in each line
dcs = read.csv("data-raw/dolan_cells.csv")
dcs$ImageCode = NULL
dcs = aggregate(No_Cells ~ LineCode + old.cell.type, dcs, function(x) paste0(round(mean(x)),ifelse(!is.na(sd(x)),paste0("±",round(sd(x))),"")))
colnames(dcs) = c("LineCode","old.cell.type","no.cells")

# Work out metadata
d = read.csv("data-raw/SplitGAL4annotate.csv",header = TRUE)
colnames(d) = c("LineCode","genotype","AD","DBD","old.cell.type","num.lh.clusters","Ideal","Behaviour","MCFO","Polarity","Stablestock","VNC","ImagePath")
d[] = lapply(d, as.character)
dd = 1
while(dd < nrow(d)){
  ddd = d[dd,]
  if(is.na(ddd["num.lh.clusters"])&ddd[,"Stablestock"]==""){
    if(!is.na(is.na(ddd["old.cell.type"]))&ddd["old.cell.type"]!=""){
      dddd = d[dd-1,]
      dddd["old.cell.type"] = ddd["old.cell.type"]
      d[dd,] = as.vector(dddd)
    }else{
      d = d[-dd,]
      dd = dd - 1
    }
  }
  dd = dd + 1
}
d$genotype = gsub(".*GMR_|JRC_|B1_T1_","",gsub("*-.*|_AV_01*|_XD_01*|_42_R1_L19*","",d$genotype))
d = d[!duplicated(d),]
lh_line_info = merge(d,dcs,all.x=TRUE,all.y=TRUE)

# Get the neurotransmitter information from Mike
nts = read.csv("data-raw/NT_annotation_from_Mike.csv")
images2cluster = read.csv("data-raw/ImagesToCluster.csv")
images2cluster = images2cluster[,c("LineCode","Polarity","Neurotransmitter")]
lh_line_info = merge(lh_line_info,images2cluster,all.x=TRUE,all.y=TRUE)
no.nt.cell.type = gsub("\\(|\\)|/|\\.*","",subset(lh_line_info,is.na(Neurotransmitter))$old.cell.type)
errors = as.character(nts[match(as.character(no.nt.cell.type),nts$LHClusters),"NT"])
errors[is.na(errors)] = "Unknown"
lh_line_info$Neurotransmitter = as.character(lh_line_info$Neurotransmitter)
lh_line_info[is.na(lh_line_info$Neurotransmitter),]$Neurotransmitter = errors
lh_line_info = lh_line_info[!duplicated(lh_line_info),]

# Add in some awol lines
skipped.line = na.omit(as.character(unique(lh.splits.dps.clean[,"linecode"][!lh.splits.dps.clean[,"linecode"]%in%lh_line_info[,"LineCode"]])))

# Fix a few cell type mis-annotations
lh_line_info$old.cell.type[grepl("^1B$|\\(1B\\)",lh_line_info$old.cell.type)] = "1BX"

# Put in the cell types
lh_line_info[] = lapply(lh_line_info, as.character)
lh_line_info[is.na(lh_line_info)] = ""
lh_line_info$pnt = ""
lh_line_info$anatomy.group = ""
lh_line_info$cell.type = ""
for(l in 1:nrow(lh_line_info)){
  line = lh_line_info$LineCode[l]
  if(line%in%lh.mcfo.clean[,"linecode"]){
    s = subset(lh.mcfo.clean,linecode==line)
    for(o in unique(as.character(s[,"old.cell.type"]))){
      if(o%in%lh.mcfo.clean[,"old.cell.type"]){
        ss = subset(s,grepl(o,old.cell.type))[,c("pnt","anatomy.group","cell.type")]
        ss = ss[!duplicated(ss),]
        ss = apply(ss,2,function(x) paste(sort(na.omit(unique(x))),collapse="/"))
        lh_line_info[lh_line_info$LineCode==line&lh_line_info$old.cell.type==o,c("pnt","anatomy.group","cell.type")] =  as.vector(ss)
      }
    }
  }else if(line%in%lh.splits.dps.clean[,"linecode"]){
    s = subset(lh.splits.dps.clean,linecode==line)
    for(o in unique(as.character(s[,"old.cell.type"]))){
      if(o%in%lh.splits.dps.clean[,"old.cell.type"]|nrow(subset(lh_line_info,LineCode==line))==1){
        ss = subset(s,grepl(o,old.cell.type))[,c("pnt","anatomy.group","cell.type")]
        ss = ss[!duplicated(ss),]
        ss = apply(ss,2,function(x) paste(sort(na.omit(unique(x))),collapse="/"))
        lh_line_info[lh_line_info$LineCode==line&(lh_line_info$old.cell.type==o|nrow(subset(lh_line_info,LineCode==line))==1),c("pnt","anatomy.group","cell.type")] =  as.vector(ss)
      }
    }
  }
}


# Fill in some known cell types
unassigned = sort(unique(na.omit(subset(lh_line_info,is.na(cell.type))$old.cell.type)))
for(u in unassigned){
  if(u%in%lh.splits.dps.clean[,"old.cell.type"]){
    ss = as.data.frame(subset(lh.splits.dps.clean,old.cell.type==u)[,c("pnt","anatomy.group","cell.type")])
    ss = ss[!duplicated(ss),]
    ss = apply(ss,2,function(x) paste(sort(na.omit(unique(x))),collapse="/"))
    lh_line_info[lh_line_info$old.cell.type==u,c("pnt","anatomy.group","cell.type")] =  as.vector(ss)
  }
}


# Create and old to new cell.type mapping
most.lh = c(most.lhns,most.lhins)
old = sort(na.omit(unique(gsub("\\(|\\)|/[\\]","",sort(lh_line_info$old.cell.type)))))
old = old[!grepl("sleep|NotLH|\v|\\?| ",old)]
old = sort(old)
old = old[old!=""]
new = c()
types = c()
corelh = c()
for(o in old){
  cts = sort(na.omit(unique(subset(lh_line_info,old.cell.type==o)$cell.type)))
  cts = unique(unlist(strsplit(cts,"/")))
  cts = paste(sort(na.omit(unique(cts))),collapse="/")
  new = c(new,cts)
  t = paste(sort(unique(subset(most.lh,cell.type%in%unlist(strsplit(cts,"/")))[,"type"])),collapse="/")
  types = c(types,t)
  core = paste(sort(unique(subset(most.lh,cell.type%in%unlist(strsplit(cts,"/")))[,"coreLH"])),collapse="/")
  corelh = c(corelh,core)
}
old2new = data.frame(old=old,new=new, type=types, coreLH=corelh)
old2new[] = lapply(old2new, as.character)
# Add some manual assignments
old2new[old2new$old%in%c("151A"),"new"] = "VNC-PN1"
old2new[old2new$old%in%c("V2"),"new"] = "LO-PN2"
old2new[old2new$old%in%c("70E"),"new"] = "WED-PN4"
old2new[old2new$old%in%c("151A","V2","70E","PN","PPL2ab-PN1",
"VisualPN1","51C","51CB","151B","137","139","51B","70B","70C","70D"),"type"] = "IN"
old2new[old2new$old%in%c("16A","1C","85","142"),"type"] = "ON"
old2new[old2new$old%in%c("145","143","70A","70E","51B"),"type"] = "IN/ON"
old2new = rbind(old2new,data.frame(old="NP6099-TypeII",new=unique(subset(lh.mcfo.clean,linecode=="NP6099")[,"cell.type"]),type="ON",coreLH=TRUE))
old2new = rbind(old2new,data.frame(old="17B",new=unique(subset(lh.splits.dps,old.cell.type=="17B")[,"cell.type"]),type="ON",coreLH=TRUE))
write.csv(old2new,file="data-raw/oldCTs_to_newCTs.csv",row.names = FALSE,col.names=TRUE)

# Guess the cell types based on Mike's old.cell.type assignments
for(l in 1:nrow(lh_line_info)){
  lh_line_info[l,"old.cell.type"]
}

########
# Save #
########

devtools::use_data(lh_line_info,overwrite=TRUE)
