####################
# Process Raw Data #
####################

# Prepare data on Mike's splits
require(reshape2)
require(dplyr)
require(hemibrainr)
if(!exists("lh.mcfo")){
  stop("Please run processMCFO.R!")
}else if(!exists("lh.splits.dps")){
  stop("Please run processDolanSplits.R!")
}

################################################
# Read Dolan et al. 2019 split line information #
################################################

# Clean data of stray cell type
lh.mcfo.clean = subset(lh.mcfo,InLine==TRUE & cell.type != "notLHproper")
lh.splits.dps.clean = subset(lh.splits.dps,!old.cell.type%in%lh.mcfo[,"old.cell.type"] & cell.type != "notLHproper")

# Get the projected number of neurons for each cell type, in each line
dcs = read.csv("data-raw/csv/dolan_cells.csv")
dcs$ImageCode = NULL
dcs = aggregate(No_Cells ~ LineCode + old.cell.type, dcs, function(x) paste0(round(mean(x)),ifelse(!is.na(sd(x)),paste0("±",round(sd(x))),"")))
colnames(dcs) = c("linecode","old.cell.type","no.cells")
nts = read.csv("data-raw/csv/NT_annotation_from_Mike.csv")
stainings = merge(dcs,nts,all.x=TRUE,all.y=TRUE)
stainings[] = lapply(stainings, as.character)

# Work out metadata
d = read.csv("data-raw/csv/SplitGAL4annotate.csv",header = TRUE)
colnames(d) = c("linecode","genotype","AD","DBD","old.cell.type","num.lh.clusters","ideal",
                "behaviour","MCFO","polarity","stablestock","VNC","ImagePath")
d[] = lapply(d, as.character)
d$linecode[d$linecode==""] = d$linecode[sapply(which(d$linecode==""), function(x) max(which(d$linecode!="")[which(d$linecode!="")<=x]))]
p <- function(v) {
  Reduce(f=function(...) paste(...,sep="/"), v)
}
d %>%
  dplyr::left_join(x=d,y=stainings, by=NULL) %>%
  dplyr::filter(old.cell.type!="") %>%
  dplyr::mutate(old.cell.type=replace(old.cell.type, old.cell.type=="NotPaper", "Unclassified")) %>%
  dplyr::mutate(AD=replace(AD, is.na(AD), "GAL4")) %>%
  dplyr::mutate(DBD=replace(DBD, is.na(DBD), "GAL4")) %>%
  dplyr::group_by(linecode) %>%
  dplyr::summarise(genotype = dplyr::first(gsub(".*GMR_|JRC_|B1_T1_","",gsub("*-.*|_AV_01*|_XD_01*|_42_R1_L19*","",genotype[genotype!=""]))),
            AD = dplyr::first(AD[AD!=""]),
            DBD = dplyr::first(DBD[DBD!=""]),
            old.cell.type = p(old.cell.type),
            num.lh.clusters = mean(as.numeric(num.lh.clusters),na.rm=TRUE),
            no.cells = ifelse(sum(!is.na(no.cells))==0,"",p(no.cells[!is.na(no.cells)])),
            neurotransmitter = ifelse(sum(!is.na(NT))==0,"",p(NT[!is.na(NT)])),
            ideal = dplyr::first(ideal[ideal!=""]),
            behaviour = dplyr::first(behaviour[behaviour!=""]),
            MCFO = dplyr::first(MCFO[MCFO!=""]),
            polarity = dplyr::first(polarity[polarity!=""]),
            stablestock = dplyr::first(stablestock[stablestock!=""]),
            VNC = dplyr::first(VNC[VNC!=""])
            ) -> lh_line_info
lh_line_info = as.data.frame(lh_line_info)
rownames(lh_line_info) = lh_line_info$linecode

# Fix some malformed field
lh_line_info$old.cell.type = gsub("\v","",lh_line_info$old.cell.type)
lh_line_info$old.cell.type = gsub("\\/\\(7\\)","",lh_line_info$old.cell.type)
lh_line_info$old.cell.type = gsub("\\/\\(8A\\)","",lh_line_info$old.cell.type)
lh_line_info$old.cell.type = gsub("\\/\\(\\?\\)\\/150","",lh_line_info$old.cell.type)

# Hmm, some AWOL lines
skipped.line = na.omit(as.character(unique(lh.splits.dps.clean[,"linecode"][!lh.splits.dps.clean[,"linecode"]%in%lh_line_info[,"linecode"]])))

# Fix a few cell type mis-annotations
lh_line_info$old.cell.type[grepl("^1B$|\\(1B\\)",lh_line_info$old.cell.type)] = "1BX"

# Put in the cell types
lh_line_info[] = lapply(lh_line_info, as.character)
lh_line_info[is.na(lh_line_info)] = ""
lh_line_info$pnt = ""
lh_line_info$anatomy.group = ""
lh_line_info$cell.type = ""
for(l in 1:nrow(lh_line_info)){
  line = lh_line_info$linecode[l]
  if(line%in%lh.mcfo.clean[,"linecode"]){
    s = subset(lh.mcfo.clean,linecode==line)
    for(o in unique(as.character(s[,"old.cell.type"]))){
      if(o%in%lh.mcfo.clean[,"old.cell.type"]){
        hit = lh_line_info$linecode==line #&lh_line_info$old.cell.type==o
        ss = subset(s,grepl(o,old.cell.type))[,c("cell.type")]
        olds = unlist(strsplit( lh_line_info[hit,"cell.type"],split = "/"))
        ss = unique(c(olds, ss))
        ss = ss[!duplicated(ss)&!is.na(ss)&ss!=""]
        ss = sort(ss)
        ags = unique(process_lhn_name(ss)$anatomy.group)
        ags = ags[!is.na(ags)]
        pnts = unique(process_lhn_name(ss)$pnt)
        pnts = pnts[!is.na(pnts)]
        ss = gsub("^/|/$","",paste(ss,sep="/",collapse="/"))
        ags = gsub("^/|/$","",paste(ags,sep="/",collapse="/"))
        pnts = gsub("^/|/$","",paste(pnts,sep="/",collapse="/"))
        lh_line_info[hit,"cell.type"] =  ss
        lh_line_info[hit,"anatomy.group"] =  ags
        lh_line_info[hit,"pnt"] =  pnts
      }
    }
  }
  if(line%in%lh.splits.dps.clean[,"linecode"]){
    s = subset(lh.splits.dps.clean,linecode==line)
    for(o in unique(as.character(s[,"old.cell.type"]))){
      if(o%in%lh.splits.dps.clean[,"old.cell.type"]|nrow(subset(lh_line_info,linecode==line))==1){
        hit = lh_line_info$linecode==line #&lh_line_info$old.cell.type==o
        ss = subset(s,grepl(o,old.cell.type))[,c("cell.type")]
        olds = unlist(strsplit( lh_line_info[hit,"cell.type"],split = "/"))
        ss = unique(c(olds, ss))
        ss = ss[!duplicated(ss)&!is.na(ss)&ss!=""]
        ss = sort(ss)
        ags = unique(process_lhn_name(ss)$anatomy.group)
        ags = ags[!is.na(ags)]
        pnts = unique(process_lhn_name(ss)$pnt)
        pnts = pnts[!is.na(pnts)]
        ss = gsub("^/|/$","",paste(ss,sep="/",collapse="/"))
        ags = gsub("^/|/$","",paste(ags,sep="/",collapse="/"))
        pnts = gsub("^/|/$","",paste(pnts,sep="/",collapse="/"))
        lh_line_info[hit,"cell.type"] =  ss
        lh_line_info[hit,"anatomy.group"] =  ags
        lh_line_info[hit,"pnt"] =  pnts
      }
    }
  }
}

# Fix L1000
## Old, AV6b1, new, 4902612
lh_line_info[lh_line_info$old.cell.type=="27C","cell.type"] = "LHAV6b1"

# Create an old to new cell.type mapping
most.lh = nat::union(subset(most.lhns, cell.type!="notLHproper"),most.lhins)
old = sort(na.omit(unique(gsub("\\(|\\)|/[\\]","",sort(unlist(strsplit(lh_line_info$old.cell.type,"/")))))))
old = old[!grepl("sleep|NotLH|\v|\\?| ",old)]
old = sort(old)
old = old[old!=""]
new = c()
types = c()
corelh = c()
meta = most.lh[,c("cell.type","type","coreLH")]
meta = meta[!is.na(rownames(meta))&!is.na(meta$cell.type)&meta$cell.type!="notLHproper",]
meta = dplyr::distinct(meta)
meta = meta[!duplicated(meta$cell.type),]
rownames(meta) = meta$cell.type
for(o in old){
  cts = sort(na.omit(unique(subset(lh_line_info,old.cell.type==o)$cell.type)))
  cts.sep = unique(unlist(strsplit(cts,"/")))
  cts = paste(sort(na.omit(unique(cts.sep))),collapse="/")
  new = c(new,cts)
  t = paste(meta[cts.sep,"type"],collapse="/")
  types = c(types,t)
  core = paste(meta[cts.sep,"coreLH"],collapse="/")
  corelh = c(corelh,core)
}
old2new = data.frame(old.cell.type=old,cell.type=new, type=types, coreLH=corelh)
old2new[] = lapply(old2new, as.character)
# Add some manual assignments
old2new[old2new$cell.type%in%c("PD2e2","AV6c1"),"coreLH"] = FALSE
old2new[old2new$cell.type%in%c("AD1d1"),"coreLH"] = TRUE
old2new[old2new$old.cell.type%in%c("151A"),"cell.type"] = "VNC-PN1"
old2new[old2new$old.cell.type%in%c("V2"),"cell.type"] = "LO-PN2"
old2new[old2new$old.cell.type%in%c("70E"),"cell.type"] = "WEDPN4"
old2new[old2new$old.cell.type%in%c("151A","V2","70E","PN","PPL2ab-PN1","VisualPN1","51C","51CB","151B","137","139","51B","70B","70C","70D"),"type"] = "IN"
old2new[old2new$old.cell.type%in%c("16A","1C","85","142"),"type"] = "ON"
old2new[old2new$old.cell.type%in%c("145","143","70A","70E","51B"),"type"] = "IN/ON"
old2new = rbind(old2new,data.frame(old.cell.type="NP6099-TypeII",cell.type=unique(subset(lh.mcfo.clean,linecode=="NP6099")[,"cell.type"]),type="ON",coreLH=TRUE))
old2new = rbind(old2new,data.frame(old.cell.type="17B",cell.type=unique(subset(lh.splits.dps,old.cell.type=="17B")[,"cell.type"]),type="ON",coreLH=TRUE))
old2new = merge(old2new,stainings,all.x=TRUE,all.y=FALSE)
old2new[is.na(old2new)] = ""
write.csv(old2new,file="data-raw/csv/oldCTs_to_newCTs.csv",row.names = FALSE)
cell_type_summary = old2new
cell_type_summary = cell_type_summary[cell_type_summary$cell.type!="",]
cell_type_summary = cell_type_summary[order(cell_type_summary$cell.type),]
cell_type_summary = change_nonascii(cell_type_summary)

# Guess the cell types based on Mike's old.cell.type assignments
lh_line_info$type = ""
for(l in 1:nrow(lh_line_info)){
  o = sort(na.omit(unique(gsub("\\(|\\)|/[\\]","",sort(unlist(strsplit(lh_line_info[l,"old.cell.type"],"/")))))))
 if(lh_line_info[l,"cell.type"]==""){
    olds = unlist(strsplit( lh_line_info[l,"cell.type"],split = "/"))
    ss = unlist(strsplit(subset(old2new,old.cell.type%in%o)$cell.type,split = "/"))
    ss = unique(ss, olds)
    ss = ss[!duplicated(ss)&!is.na(ss)&ss!=""]
    ss = sort(ss)
    ags = unique(process_lhn_name(ss)$anatomy.group)
    ags = ags[!is.na(ags)]
    pnts = unique(process_lhn_name(ss)$pnt)
    pnts = pnts[!is.na(pnts)]
    ss = gsub("^/|/$","",paste(ss,sep="/",collapse="/"))
    ags = gsub("^/|/$","",paste(ags,sep="/",collapse="/"))
    pnts = gsub("^/|/$","",paste(pnts,sep="/",collapse="/"))
    lh_line_info[l,"cell.type"] = ss
    lh_line_info[l,"anatomy.group"] =  ags
    lh_line_info[l,"pnt"] =  pnts
  }
}
lh_line_info = lh_line_info.orig = lh_line_info[order(lh_line_info$cell.type),]
lh_line_info = change_nonascii(lh_line_info)

# Manually fix a few missing types
lh_line_info$cell.type[lh_line_info$old.cell.type=="51C"] = "AVLP560"

########
# Save #
########

lh_line_info[is.na(lh_line_info)]=""
usethis::use_data(lh_line_info,overwrite=TRUE)
usethis::use_data(cell_type_summary,overwrite=TRUE)

##################################################################
# Make concise spreadsheets comparing cell types across datasets #
##################################################################

# # Concise spreadsheet
# require(dplyr)
# cts = subset(jfw.lhns[,],!is.na(cell.type))
# cts = subset(cts,cell.type!="notLHproper")
# cts = cts[,c("JJtype","cell.type")]
# cts = dplyr::distinct(cts)
# cts = cts[order(cts$JJtype,decreasing=FALSE),]
#
# # Do the same for Shahar's dye fills
# dfills = subset(most.lhns,skeleton.type =="DyeFill"& good.trace==TRUE)[,]
# dfills.cts = unique(dfills$cell.type)
# cts$Frechter = FALSE
# cts[cts$cell.type%in%dfills.cts,]$Frechter = TRUE
# dfills.cts.not.in.jj = data.frame(JJtype = FALSE, cell.type = dfills.cts[!dfills.cts%in%cts$cell.type], Frechter = TRUE)
# cts = rbind(cts,dfills.cts.not.in.jj)
#
# # Add in the split info
# in.mcfo = sapply(lh.splits.dps[,"old.cell.type"],function(oct) grepl(oct,unique(lh.mcfo[,"old.cell.type"])))
# mt = merge(lh.splits.dps[in.mcfo,],subset(lh.mcfo,InLine==TRUE)[,],all.x=TRUE,all.y=TRUE)
# mt = subset(mt, type%in%c("LN","ON"))
# mt = mt[,c("old.cell.type","cell.type")]
# mt = dplyr::distinct(mt)
# cts = merge(cts,mt,all.x = TRUE, all.y = TRUE)
# cts = as.matrix(cts)
# cts[is.na(cts)|cts==""] = FALSE
# cts = as.data.frame(cts)
#
# # Save info
# colnames(cts) = c("cell.type", "Jeanne", "Frechter", "Dolan")
# cts = cts[,c("cell.type", "Frechter", "Dolan", "Jeanne")]
# cts = cts[order(cts$cell.type,decreasing = FALSE),]
# cts$datasets = unlist(sapply(1:nrow(cts),function(x) paste(c("F","D","J")[cts[x,][-1]!=FALSE],collapse="") ))
# cts = dplyr::distinct(cts)
# write.csv(cts,"data-raw/csv/ASB_bridging_celltypes.csv")
#
# # Neurons types that have changed name between hemibrain and frechter.
# mcfo.select = subset(lh.mcfo, lh.mcfo[,]$InLine==TRUE)
# dfills.select = subset(most.lhns, skeleton.type=="DyeFill")
# important = nat::union(mcfo.select,dfills.select)
# important=subset(important,
#                  !is.na(cell.type)
#                  | !cell.type%in%c("uncertain","notLHproper","none")
#                  | frechter.cell.type%in%c("uncertain","notLHproper","none"))
# changed = subset(important[,], name.change | connectivity.type == "uncertain")
# changed = changed[,c("hemibrain.match","cell.type","frechter.cell.type")]
# colnames(changed) = c("bodyid","cell_type","synonym")
# in1 = changed$cell_type %in% dfills.select[,]$cell.type
# in2 = changed$cell_type %in% mcfo.select[,]$cell.type
# changed$synonym[in1] = paste0(changed$synonym[in1]," (Frechter et al, eLife, 2019)")
# changed$synonym[in2] = paste0(changed$synonym[in2]," (Dolan et al, eLife, 2019)")
# other = subset(lh.splits.dps[,],name.change |  connectivity.type == "uncertain")
# other = other[,c("hemibrain.match","cell.type","frechter.cell.type")]
# colnames(other) = c("bodyid","cell_type","synonym")
# other = other[sapply(1:nrow(other), function(x) ifelse(grepl("/",other$cell_type[x]),
#                                                        !grepl(other$synonym[x],other$cell_type[x]),
#                                                        TRUE)),]
# other$synonym = paste0(other$synonym," (Dolan et al, eLife, 2019)")
# changed = rbind(changed, other)
# changed = aggregate(list(synonym = changed$synonym),
#                     list(cell_type = changed$cell_type,
#                          bodyid = changed$bodyid),
#                     function(x) names(sort(table(x),decreasing = TRUE))[1])
# jj = subset(jfw.lhns, !is.na(hemibrain.match))
# jj = jj[,c("hemibrain.match","cell.type","JJtype")]
# colnames(jj) = c("bodyid","cell_type","synonym")
# jj$synonym = paste0(jj$synonym," (Jeanne et al, Neuron, 2018)")
# changed = rbind(changed, jj)
# changed = aggregate(list(synonym = changed$synonym),
#                     list(bodyid = changed$bodyid),
#                     function(x) paste(unique(x),collapse ='; '))
# notinc = c("PD2a1/b1","Calyx","MB","WED","PV4a1","AL-","PD2a1","AV6a1","PV2a1","AV4a1","AD1b1","AV1a1","notLHproper","PV4a2")
# changed = changed[!grepl(paste(notinc,collapse="|"),changed$synonym),]
# write.csv(changed, file = "data-raw/csv/hemibrain_frechter_changes.csv", row.names = FALSE)






