# Calculate overlap scores between light level skeletons
library(catnat)
library(scales)
library(ggplot2)
library(reshape2)
library(ggrepel)
library(ggpubr)

# Get the inputs LH axons
olf.pns = subset(lhns::most.lhins,grepl("Olf",modality))
all.inputs = c(olf.pns,lhns::pn.axons.light)
points  = nat::xyzmatrix(all.inputs)
inlh = pointsinside(points,surf = subset(FCWBNP.surf,"LH_R"))
points = points[inlh,]
inputs.termini = nat::nlapply(all.inputs, nat::prune, target = points, keep = 'near', maxdist = 5,OmitFailures=T) # Consider overlap within 5 um of the LH

# Get the LH arbour of neurons in most.lhns, by removing the primary neurite
lhns.arbour = catnat::primary.neurite(most.lhns, keep.pnt = FALSE)
points=nat::xyzmatrix(lhns.arbour)
inlh = pointsinside(points,surf = subset(FCWBNP.surf,"LH_R"))
points = points[inlh,]
lhns.putative.dendrites = nat::nlapply(most.lhns, nat::prune, target = points, keep = 'near', maxdist = 5,OmitFailures=T) # Consider overlap within 5 um of the LH

# Calculate overlap scores
score.matrix = catnat::overlap.connectivity.matrix(neurons=inputs.termini,targets=lhns.putative.dendrites,delta=1,neuropil = NULL)

# Designate the not LH group
notLHproper = colnames(score.matrix)[colSums(score.matrix)<6000]

# Save the score matrix
lhns.pn.overlap.matrix = score.matrix
save(lhns.pn.overlap.matrix,file='data-raw/LHN_PN_Overlap_Scores.rda')

# Calculate the core LHNs
i = intersect(colnames(lhns.pn.overlap.matrix),names(most.lhns))
lhns.chosen = most.lhns[i]
colnames(lhns.pn.overlap.matrix) = lhns.chosen[colnames(lhns.pn.overlap.matrix),"cell.type"]
lhns.pn.overlap.matrix = t(apply(t(lhns.pn.overlap.matrix), 2, function(x) tapply(x, colnames(lhns.pn.overlap.matrix), mean, na.rm = TRUE)))

# Get LH dendrite
lhns = most.lhns
correct.mcfo.d <- function(neuron, as3d){
  in.lh = alphashape3d::inashape3d(points=nat::xyzmatrix(neuron$d),as3d=as3d)
  neuron$d$Label = 2
  neuron$d$Label[in.lh] = 3
  neuron
} # All the MCFO data for LHNs have dendrite in the LH, so let's do a quick fix to that effect. Should segment them better later
lhns.mcfo = nlapply(subset(lhns,skeleton.type=="MCFO"), correct.mcfo.d,as3d=LHR)
lhns = c(subset(lhns,skeleton.type!="MCFO"),lhns.mcfo)
lhns.dendrites = dendritic_cable(lhns, mixed = TRUE) # LH dendrites now also expanding outside of the LH
left.out = setdiff(names(lhns.dendrites),names(most.lhns)) # Most of these are notLH

# Decide
d.data.skels = summary(lhns.dendrites)$cable.length
d.lh.skels = unlist(nlapply(lhns.dendrites,function(x) tryCatch(summary(prune_in_volume(x,neuropil="LH_R",brain=nat.flybrains::FCWBNP.surf))$cable.length,error = function(e) 0)))
names(d.lh.skels) = names(d.data.skels) = lhns.dendrites[,"cell.type"]
d.lh = tapply(d.lh.skels, names(d.lh.skels), mean, na.rm = TRUE)
d.data = tapply(d.data.skels, names(d.data.skels), mean, na.rm = TRUE)
skeleton.no = c(table(lhns.dendrites[,"cell.type"]))[colnames(lhns.pn.overlap.matrix)]
df.decision = data.frame(cell.type = names(d.data),
                         anatomy.group = process_lhn_name(names(d.data))$anatomy.group,
                         pnt = process_lhn_name(names(d.data))$pnt,
                         mean.overlap = colSums(lhns.pn.overlap.matrix)[names(d.data)],
                         mean.dendritic.cable = d.data, mean.dendritic.cable.in.lh = d.lh, proportion.dendritic.lh = d.lh/d.data,skeleton.no=skeleton.no[names(d.data)])

# Assign non-core neurons
poss_non_core_lh = as.character(subset(df.decision,mean.overlap<20000 & proportion.dendritic.lh<0.5)$cell.type)
poss_core_lh = setdiff(unique(df.decision$cell.type),poss_non_core_lh)
not_in_analysis = setdiff(unique(most.lhns[,"cell.type"]),df.decision$cell.type)

# Assign non-core neurons
df.decision$coreLH = FALSE
df.decision[poss_core_lh,]$coreLH = TRUE

# Save!
corelhns = df.decision
save(corelhns,file='data-raw/Core_LHNs.rda')

# Save overlap scores!
devtools::use_data(lhns.pn.overlap.matrix,overwrite=TRUE)


####################################################################################
# Plot out this analysis highliting targetting groups in Frechter and Dolan et al. #
####################################################################################


# Which anatomy groups are in our lines?
line.cluster.clean = read.csv("/GD/LMBD/Papers/2015lhns/fig/screen/line_cluster.mer") # Is this file now just totally wrong?
line.ag.full = dplyr::select(line.cluster.clean,LineShortName,Cluster,isLH,pnt,cluste_neurite,AnatomyGroup,AnatomyGroup1,AnatomyGroup2,AnatomyGroup3)%>%melt(id.vars=c("LineShortName","Cluster","isLH", "pnt","cluste_neurite"), na.rm=TRUE)
cts.in = unique(subset(df.decision,anatomy.group%in%capitalise_cell_type_name(line.ag.full$value))$cell.type)
cts.in = as.character(cts.in[!is.na(cts.in)])

# Which are in the MCFO data?
df.decision$InLines = df.decision$cell.type%in%unique(c(subset(lh.mcfo,InLine==TRUE)[,"cell.type"],lh.splits.dps[,"cell.type"]))

# Generate figure for Frechter et al. 2018
pdf(file='/GD/LMBD/Papers/2015lhns/fig/Alex/images/core.decision.boundaries-1.pdf',width=10,height=5)
# Visualise decision boundaries
dye.fills.ct = unique(subset(most.lhns,skeleton.type=="DyeFill")[,"cell.type"])
dye.fills.ct = dye.fills.ct[!is.na(dye.fills.ct)]
dye.fill.points = subset(df.decision,cell.type%in%dye.fills.ct)
cts.in.points = subset(df.decision,cell.type%in%cts.in)
ppl1ap3 = subset(df.decision,cell.type%in%"PV5e1")
pd2.data = subset(df.decision,grepl("PD2",cell.type))
pd2labels = pd2.data$cell.type
names(pd2labels) = pd2.data$cell.type
ggplot(df.decision, aes(x= mean.overlap, y=proportion.dendritic.lh, size = skeleton.no)) +
  geom_point(color = "grey", alpha = 0.5)+
  #geom_smooth()+
  scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x)))+
  #annotation_logticks(base=10,sides="b") +
  #coord_trans(x="log10") +
  geom_vline(xintercept = c(20000), color = "red")+
  geom_hline(yintercept = c(0.5), color = "red")+
  geom_point(data=cts.in.points, color = "chartreuse2", alpha = 0.5) +
  geom_point(data=pd2.data, pch=21,color="deepskyblue4") +
  geom_point(data=dye.fill.points, color="darkgreen", alpha = 0.5) +
  geom_point(data=ppl1ap3, color="orange", alpha = 0.5) +
  geom_label_repel(data = pd2.data, label = pd2labels,fill="deepskyblue4",color = "white", fontface = "bold",size=3)+
  geom_label_repel(data = ppl1ap3, label = "PPL1-a'3",fill="orange",color = "white", fontface = "bold",size=3)+
  theme_minimal()+
  theme(panel.grid.minor=element_blank())+
  ylab("")+
  xlab("")+
  guides(colour=FALSE)
dev.off()


# Generate a figure for Dolan et al. 2018
pdf(file='/GD/LMBD/Papers/2018lhsplitcode/Fig_Alex/Figure1/splitlines_in_lhn_dendrite_analysis.pdf',width=10,height=5)
# Marginal density plot of x (top panel) and y (right panel)
xplot <- ggdensity(df.decision, "mean.overlap", fill = "InLines",color = "InLines",
                   palette = c("grey","chartreuse3"))+
          scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),labels = trans_format("log10", math_format(10^.x)))+
         guides(fill = FALSE, color = FALSE)
yplot <- ggdensity(df.decision, "proportion.dendritic.lh", fill = "InLines",color = "InLines",
                   palette = c("grey","chartreuse3"))+
          rotate()+
          guides(fill = FALSE, color = FALSE)
yplot <- yplot + clean_theme()
xplot <- xplot + clean_theme()
# Plot dendrite analysis plotting the cell types in split lines
plot <- ggplot(df.decision, aes(x=mean.overlap, y=proportion.dendritic.lh, size = 3, color=InLines)) +
  geom_point(alpha = 0.5)+
  scale_color_manual(values=c("grey","chartreuse3"))+
  #geom_smooth()+
  scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x)))+
  #annotation_logticks(base=10,sides="b") +
  #coord_trans(x="log10") +
  geom_segment(aes(x = 20000,  xend = 20000, y=0, yend=0.5),lwd=1, color = "red")+
  geom_segment(aes(x = 0,  xend = 20000, y=0.5, yend=0.5),lwd=1, color = "red")+
  theme_minimal()+
  theme(panel.grid.minor=element_blank())+
  ylab("")+
  xlab("")+
  guides(fill = FALSE, color = FALSE, size = FALSE)
# Arranging the plot
ggarrange(xplot, NULL, plot, yplot,
          ncol = 2, nrow = 2,  align = "hv",
          widths = c(2, 1), heights = c(1, 2),
          common.legend = TRUE)
dev.off()




