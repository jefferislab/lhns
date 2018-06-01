require(reshape2)
line.cluster.clean = read.csv("data-raw/line_cluster.mer")
line.ag.full = dplyr::select(line.cluster.clean,LineShortName,isLH,AnatomyGroup,AnatomyGroup1,AnatomyGroup2,AnatomyGroup3)
line.ag.full = suppressWarnings(reshape2::melt(line.ag.full,id.vars=c("LineShortName","isLH"), na.rm=TRUE))
lhn.lines = line.ag.full[,c("LineShortName","isLH","value")]
colnames(lhn.lines) = c("LineShortName","type","anatomy.group")
devtools::use_data(lhn.lines,overwrite=TRUE)


"MB583B, 8C"
