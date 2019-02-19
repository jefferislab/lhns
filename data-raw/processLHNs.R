####################
# Process Raw Data #
####################
library(elmr)
library(catnat)

# Get Data
message("Reading in raw neuron skeleton data!")
load("data-raw/SF_dye_fills_FCWB.rda")
load("data-raw/Segmented_FlyCircuit_LHNs_FCWB.rda")
JFRCSH_clusters=read.neurons("data-raw/swc/Clusters_JFRCSH")
SF_clusters=read.neurons("data-raw/swc/Clusters_SF")
JFRCSH.DS_clusters=read.neurons("data-raw/swc/Clusters_JFRC2013DS")

# Get data together in FCWB brainspace
library(nat.flybrains)
JFRCSH_clusters.FCWB= nat.templatebrains::xform_brain(JFRCSH_clusters, sample=JFRC2, ref=FCWB)
JFRCSH.DS_clusters.FCWB= nat.templatebrains::xform_brain(JFRCSH.DS_clusters, sample=JFRC2013DS, ref=FCWB)
SF_clusters.FCWB= nat.templatebrains::xform_brain(SF_clusters, IS2, FCWB)
names(JFRCSH_clusters.FCWB)=sub("-000.swc","",x=names(JFRCSH_clusters.FCWB))
names(JFRCSH.DS_clusters.FCWB)=sub("-000.swc","",x=names(JFRCSH.DS_clusters.FCWB))
names(SF_clusters.FCWB)=sub("-000.swc","",x=names(SF_clusters.FCWB))

# Get MCFO skeletons
md.mcfo = nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('lh.mcfo.rds',package='lhns')))

# Create most.lhns
most.lhns= c(fc.lhns,dye.fills,JFRCSH_clusters.FCWB,JFRCSH.DS_clusters.FCWB,SF_clusters.FCWB,md.mcfo)

# Prepare meta data frame
df = most.lhns[,c("id","sex","LH_side")]
df[] = lapply(df, as.character)

# Sort out ids
df$id = names(most.lhns)
df[grepl("^1",rownames(df)),]$id = paste0("nm20",rownames(df)[grepl("^1",rownames(df))])
df[names(md.mcfo),]$id = md.mcfo[,"file"]

# Add the empty slots
df$pnt=NA
df$anatomy.group=NA
df$cell.type = NA
df$type = NA
df$good.trace = TRUE

# Add skeleton types
df$skeleton.type = "FlyCircuit"
df[grepl("^1",rownames(df)),]$skeleton.type = "DyeFill"
df[names(md.mcfo),]$skeleton.type = "MCFO"
df[names(c(JFRCSH_clusters.FCWB,JFRCSH.DS_clusters.FCWB,SF_clusters.FCWB)),]$skeleton.type = "FijiTrace"


###### Bad Cells ######





badly.traced = c("5HT1A-F-200014", "Gad1-F-300266", "npf-F-000002", "VGlut-F-300400","Cha-F-200386",
                 "VGlut-F-900127", "VGlut-F-500145", "VGlut-F-500393",
                 "npf-F-300047", "npf-M-200017", "npf-M-300045",
                 "npf-M-300051", "Cha-F-800106", "fru-M-700211", "Gad1-F-500038",
                 "Gad1-F-200366", "Gad1-F-000381", "Gad1-F-000349", "fru-M-800040",
                 "fru-F-600043", "5HT1A-F-800008", "Cha-F-200378", "Cha-F-300146",
                 "Cha-F-400324", "VGlut-F-500032", "Cha-F-000395", "Cha-F-000515",
                 "Cha-F-800134", "Gad1-F-000101", "Cha-F-200357", "VGlut-F-500253","Gad1-F-200431", "Gad1-F-100264","Cha-F-600061","VGlut-F-500148",
                 "fru-F-500093", "Cha-F-400240","fru-M-200351",
                 "Cha-F-00048","fru-M-100206","Gad1-F-100225","Cha-F-700110")
df[names(c(JFRCSH_clusters.FCWB,JFRCSH.DS_clusters.FCWB,SF_clusters.FCWB)),]$good.trace = FALSE
df[badly.traced,]$good.trace = FALSE


###### Not LH proper ######





notLH = c("L1740#6","L1740#1", "L1740#5", "L1740#9", "L1740#10", "L16#10","L16#9","L16#4","L16#3","L2316#1","L2392#1","5HT1A-F-100016", "5HT1A-F-300001", "5HT1A-F-300035", "5HT1A-M-300003",
         "5HT1A-M-400013", "5HT1A-M-400022", "5HT1A-M-500012", "5HT1A-M-800011",
         "Cha-F-000152", "Cha-F-000428", "Cha-F-000432", "Cha-F-000452", "Cha-F-000086",# LH input?
         "Cha-F-000491", "Cha-F-000506", "Cha-F-100372", "Cha-F-100373",
         "Cha-F-100387", "Cha-F-100420", "Cha-F-100425", "Cha-F-200232",
         "Cha-F-200439", "Cha-F-300023", "Cha-F-300212", "Cha-F-300347",
         "Cha-F-300350", "Cha-F-300384", "Cha-F-400277", "Cha-F-400287",
         "Cha-F-400296", "Cha-F-400301", "Cha-F-400328", "Cha-F-500087",
         "Cha-F-500272", "Cha-F-500310", "Cha-F-600245", "Cha-F-600251",
         "Cha-F-700082", "Cha-F-700265", "Cha-F-700277", "Cha-F-800107",
         "Cha-F-800145", "E0585-F-000005", "E0585-F-000006", "E0585-F-200004",
         "E0585-F-300019", "E0585-F-400016", "E0585-F-600004", "E0585-F-600005",
         "fru-F-000125", "fru-F-000130", "fru-F-000155", "fru-F-000201",
         "fru-F-000227", "fru-F-100122", "fru-F-100125", "fru-F-300136",
         "fru-F-300158", "fru-F-300161", "fru-F-300189", "fru-F-300212",
         "fru-F-300225", "fru-F-400084", "fru-F-400339", "fru-F-400374",
         "fru-F-400494", "fru-F-400527", "fru-F-500116", "fru-F-500285",
         "fru-F-500333", "fru-F-500370", "fru-F-500371", "fru-F-500553",
         "fru-F-500557", "fru-F-500588", "fru-F-600297", "fru-F-700115",
         "fru-F-700234", "fru-F-700240", "fru-F-800103", "fru-M-000002",
         "fru-M-000022", "fru-M-000027", "fru-M-000032", "fru-M-000040",
         "fru-M-000042", "fru-M-000045", "fru-M-000050", "fru-M-000075",
         "fru-M-000133", "fru-M-000139", "fru-M-000167",
         "fru-M-000224", "fru-M-000227", "fru-M-000291", "fru-M-000339",
         "fru-M-000360", "fru-M-100025", "fru-M-100031", "fru-M-100056",
         "fru-M-100071", "fru-M-100136", "fru-M-100139", "fru-M-100193",
         "fru-M-100206", "fru-M-100290", "fru-M-100295", "fru-M-100332",
         "fru-M-100342", "fru-M-100344", "fru-M-100345", "fru-M-100387",
         "fru-M-200086", "fru-M-200113", "fru-M-200145", "fru-M-200156",
         "fru-M-200172", "fru-M-200228", "fru-M-200239", "fru-M-200260",
         "fru-M-200299", "fru-M-200302", "fru-M-200380", "fru-M-200400",
         "fru-M-200402", "fru-M-200431", "fru-M-200432", "fru-M-200444",
         "fru-M-200448", "fru-M-200458", "fru-M-200478", "fru-M-200490",
         "fru-M-200492", "fru-M-300002", "fru-M-300008", "fru-M-300015",
         "fru-M-300030", "fru-M-300038", "fru-M-300043", "fru-M-300049",
         "fru-M-300088", "fru-M-300111", "fru-M-300165", "fru-M-300186",
         "fru-M-300189", "fru-M-300226", "fru-M-300250", "fru-M-300251",
         "fru-M-300344", "fru-M-300362", "fru-M-300381", "fru-M-400067",
         "fru-M-400080", "fru-M-400107", "fru-M-400115", "fru-M-400214",
         "fru-M-400217", "fru-M-400224", "fru-M-400274", "fru-M-400295",
         "fru-M-400342", "fru-M-400371", "fru-M-400399", "fru-M-500009",
         "fru-M-500012", "fru-M-500075", "fru-M-500088", "fru-M-500089",
         "fru-M-500107", "fru-M-500221", "fru-M-500224", "fru-M-500259",
         "fru-M-500269", "fru-M-500270", "fru-M-500305", "fru-M-500318",
         "fru-M-500372", "fru-M-500381", "fru-M-500385", "fru-M-600026",
         "fru-M-600077", "fru-M-600210", "fru-M-700116", "fru-M-700135",
         "fru-M-700136", "fru-M-700247", "fru-M-800038", "fru-M-800059",
         "fru-M-800060", "fru-M-800088", "fru-M-800106", "fru-M-800150",
         "fru-M-900002", "fru-M-900027", "Gad1-F-000142", "Gad1-F-000176",
         "Gad1-F-000231", "Gad1-F-000275", "Gad1-F-000434",
         "Gad1-F-100110", "Gad1-F-100112", "Gad1-F-100150", "Gad1-F-100153",
         "Gad1-F-100211", "Gad1-F-100223", "Gad1-F-100258", "Gad1-F-100302",
         "Gad1-F-100358", "Gad1-F-200110", "Gad1-F-200169", "Gad1-F-200198",
         "Gad1-F-200213", "Gad1-F-200320", "Gad1-F-200380",
         "Gad1-F-200433", "Gad1-F-200458", "Gad1-F-200459", "Gad1-F-300190",
         "Gad1-F-300193", "Gad1-F-300212", "Gad1-F-300243", "Gad1-F-300311",
         "Gad1-F-400128", "Gad1-F-400144", "Gad1-F-400154", "Gad1-F-400161",
         "Gad1-F-400192", "Gad1-F-400220", "Gad1-F-400406", "Gad1-F-500112",
         "Gad1-F-500172", "Gad1-F-500192", "Gad1-F-500200", "Gad1-F-500201",
         "Gad1-F-500207", "Gad1-F-500302", "Gad1-F-500325", "Gad1-F-500326",
         "Gad1-F-500349", "Gad1-F-600108", "Gad1-F-600163", "Gad1-F-600221",
         "Gad1-F-600254", "Gad1-F-600260", "Gad1-F-600274", "Gad1-F-700145",
         "Gad1-F-800099", "Gad1-F-800120", "Gad1-F-800172", "Gad1-F-900064",
         "npf-F-000008", "npf-M-200001", "npf-M-200002", "npf-M-200004",
         "npf-M-200015", "npf-M-200016", "npf-M-200020", "npf-M-200027",
         "npf-M-200028", "npf-M-200036", "npf-M-200039", "npf-M-200043",
         "npf-M-200061", "npf-M-300037", "npf-M-400004", "npf-M-400010",
         "npf-M-800002", "npf-M-800005", "TH-F-300067", "TH-M-000016",
         "TH-M-000023", "TH-M-000032", "TH-M-000045", "TH-M-000048", "TH-M-100016",
         "TH-M-100042", "TH-M-100044", "TH-M-100062", "TH-M-100077", "TH-M-200009",
         "TH-M-200031", "TH-M-200037", "TH-M-200058", "TH-M-200060", "TH-M-200076",
         "TH-M-200087", "TH-M-300013", "TH-M-300023", "TH-M-300052", "TH-M-300053",
         "TH-M-300056", "TH-M-500000", "TH-M-500005", "TH-M-600000", "Trh-F-500222",
         "Trh-M-000109", "Trh-M-000174", "Trh-M-000175", "Trh-M-100052",
         "Trh-M-100082", "Trh-M-100087", "Trh-M-200030", "Trh-M-300024",
         "Trh-M-400020", "Trh-M-400045", "Trh-M-400120", "Trh-M-500055",
         "Trh-M-500078", "Trh-M-500101", "Trh-M-500128", "Trh-M-500142",
         "Trh-M-500144", "Trh-M-500155", "Trh-M-500168", "Trh-M-500183",
         "Trh-M-500187", "Trh-M-600063", "Trh-M-700010", "Trh-M-700035",
         "Trh-M-700040", "Trh-M-700054", "VGlut-F-000336", "VGlut-F-000454",
         "VGlut-F-200296", "VGlut-F-300515", "VGlut-F-500139", "VGlut-F-500325",
         "VGlut-F-600075", "VGlut-F-600076", "VGlut-F-600218", "VGlut-F-600694",
         "VGlut-F-700413", "VGlut-F-900053", "Cha-F-100357","Cha-F-000310","VGlut-F-500148")



###### PNT PV7 ######






pv7 = c("Cha-F-800039", "Gad1-F-200219")
pv7.a = "Cha-F-800039"
pv7.a.1 = "Cha-F-800039"
pv7.b  = pv7.b.1 = "Gad1-F-200219"

# Assign cell types
df[pv7.a.1,]$cell.type = "pv7a1"
df[pv7.b.1,]$cell.type = "pv7b1"





###### PNT pv9 ######





### pv9
pv9 = c("fru-M-600077", "fru-M-200410","Trh-F-100061", "Trh-F-100060",
        "Trh-M-100052", "Trh-F-000029","CL71R_47G10",
        "Trh-F-000040", "Trh-F-100057", "Trh-F-000002", "Trh-M-100075",
        "Trh-F-600087", "Trh-F-100091", "Trh-F-100072", "VGlut-F-200225",
        "fru-M-000012", "fru-M-300184", "fru-M-100059", "Trh-F-200008",
        "Trh-M-300118","Trh-M-100010","CL150R_JK733SF457")
pv9.a = c("Trh-F-100061", "Trh-F-100060", "Trh-M-100052", "Trh-F-000029",
          "Trh-F-000040", "Trh-F-100057", "Trh-F-000002", "Trh-M-100075",
          "Trh-F-600087", "Trh-F-100091", "Trh-F-100072", "VGlut-F-200225",
          "fru-M-000012", "fru-M-300184", "fru-M-100059", "Trh-F-200008",
          "Trh-M-300118")
pv9.a.1 = c("Trh-F-100061", "Trh-F-100060", "Trh-M-100052", "Trh-F-000029",
            "Trh-F-000040", "Trh-F-100057", "Trh-F-000002", "Trh-M-100075",
            "Trh-F-600087", "Trh-F-100091", "Trh-F-100072", "VGlut-F-200225",
            "fru-M-000012", "fru-M-300184", "fru-M-100059", "Trh-F-200008",
            "Trh-M-300118")
pv9.b = c("fru-M-600077","fru-M-200410")
pv9.b.1 = c("fru-M-600077","fru-M-200410")
pv9.c.1 =pv9.c= "Trh-M-100010"
pv9.d.1 = "CL150R_JK733SF457"
pv9.d.2 = "CL71R_47G10"
pv9.d=c(pv9.d.1,pv9.d.2)

# Assign cell types
df[pv9.a.1,]$cell.type = "pv9a1"
df[pv9.b.1,]$cell.type = "pv9b1"
df[pv9.c.1,]$cell.type = "pv9c1"
df[pv9.d.1,]$cell.type = "pv9d1"
df[pv9.d.2,]$cell.type = "pv9d2"





###### PNT pv8 ######





### pv8
pv8 = c("Gad1-F-700084", "VGlut-F-000090","fru-M-400051")
pv8.a  = pv8.a.1 = "Gad1-F-700084" # Remove? Badly traced. Soma uncertain.
pv8.b = pv8.b.1 = "fru-M-400051"
pv8.c = pv8.c.1 = "VGlut-F-000090" #dont plot

# Assign cell types
df[pv8.a.1,]$cell.type = "pv8a1"
df[pv8.b.1,]$cell.type = "pv8b1"
df[pv8.c.1,]$cell.type = "pv8c1"





###### PNT pv12 ######






### pv12
pv12 =  "Gad1-F-600202"
pv12.a = pv12.a.1 = c("Gad1-F-600202","L2033#1","L2033#2")

# Assign cell types
df[pv12.a.1,]$cell.type = "pv12a1"





###### PNT pv11 ######






### pv11
pv11 = c("Trh-M-400128","Gad1-F-600210")
pv11.a=c("Trh-M-400128","Gad1-F-600210")
pv11.a.1 = "Trh-M-400128"
pv11.a.2 = "Gad1-F-600210"

# Assign cell types
df[pv11.a.1,]$cell.type = "pv11a1"
df[pv11.a.2,]$cell.type = "pv11a2"





###### PNT pd7 ######





### pd7
pd7 = c("fru-F-400364", "fru-F-400339")
pd7.a = pd7.a.1 = "fru-F-400364"
pd7.b = pd7.b.1 ="fru-F-400339"

# Assign cell types
df[pd7.a.1,]$cell.type = "pd7a1"
df[pd7.b.1,]$cell.type = "pd7b1"





###### PNT pv10 ######






### pv10
pv10 =  c("Trh-M-400120","Cha-F-700278","Cha-F-700201", "Trh-M-200030","fru-M-200397","Gad1-F-700184",
         "Gad1-F-400411", "Cha-F-100449", "fru-F-100122",
         "Gad1-F-200151", "fru-M-900055", "fru-M-700194", "fru-M-400196",
         "fru-M-400164", "fru-M-400046", "fru-M-300203", "fru-M-200458",
         "fru-M-200074", "fru-M-100103", "Gad1-F-800099", "Gad1-F-200414",
         "Gad1-F-100290", "Cha-F-300297", "Cha-F-000303", "Trh-M-100020",
         "fru-M-900039", "fru-M-800141", "fru-M-700302", "fru-M-700217",
         "fru-M-600099", "fru-M-300235", "fru-M-300147", "fru-M-300088",
         "fru-M-200179", "fru-M-200153", "fru-M-000167", "fru-M-000022","fru-M-200380")
pv10.a = pv10.a.1 = c("fru-M-600099","fru-M-200153","fru-M-200074","fru-M-100103", "fru-M-800141","fru-M-400046"
                    ,"fru-M-300235", "fru-M-300203", "fru-M-200179","fru-M-200397")
pv10.b = pv10.b.1 = c("fru-M-400196", "fru-M-900055","fru-M-400164","fru-M-300147","fru-M-700194","fru-M-900039","fru-M-700302","fru-M-700217")
pv10.c.1 = c("Gad1-F-100290","Gad1-F-700184","Gad1-F-400411","Cha-F-000303","Gad1-F-200414","Cha-F-300297")
pv10.c.2=c("Cha-F-100449","Gad1-F-200151")
pv10.c=c(pv10.c.1,pv10.c.2)
pv10.d = pv10.d.1= c("fru-M-000022","fru-M-200458","fru-M-300088","fru-M-000167")
pv10.e = pv10.e.1 = c("Trh-M-200030","Trh-M-400120")
pv10.f = pv10.f.1 = "Trh-M-100020"
pv10.g = pv10.g.1 = c("fru-F-100122","fru-M-200380")
pv10.h = pv10.h.1 = "Gad1-F-800099"
pv10.i = pv10.i.1 = "Cha-F-700278"
pv10.j = pv10.j.1 = "Cha-F-700201"

# Assign cell types
df[pv10.a.1,]$cell.type = "pv10a1"
df[pv10.b.1,]$cell.type = "pv10b1"
df[pv10.c.1,]$cell.type = "pv10c1"
df[pv10.c.2,]$cell.type = "pv10c2"
df[pv10.d.1,]$cell.type = "pv10d1"
df[pv10.e.1,]$cell.type = "pv10e1"
df[pv10.f.1,]$cell.type = "pv10f1"
df[pv10.g.1,]$cell.type = "pv10g1"
df[pv10.h.1,]$cell.type = "pv10h1"
df[pv10.i.1,]$cell.type = "pv10i1"
df[pv10.j.1,]$cell.type = "pv10j1"





###### PNT pv5 ######





### pv5
pv5 = c("Gad1-F-000349","Cha-F-400324","E0585-F-300073","Gad1-F-900137", "Gad1-F-900098", "Gad1-F-800215", "Gad1-F-700139",
        "Gad1-F-500244", "Gad1-F-500180", "Gad1-F-400275", "Gad1-F-300321",
        "Gad1-F-300243", "Gad1-F-300163", "Gad1-F-300155", "Gad1-F-200403",
        "Gad1-F-200289", "Gad1-F-200232", "Cha-F-100398",
        "Cha-F-200402", "Cha-F-500250", "Cha-F-700211", "Cha-F-700258",
        "E0585-F-300013", "E0585-F-300033", "E0585-F-300040", "E0585-F-300047",
        "E0585-F-300050", "E0585-F-300058", "E0585-F-300063", "E0585-F-300066",
        "E0585-F-300071",  "E0585-F-400005", "E0585-F-400008",
        "E0585-F-400013", "E0585-F-400015", "E0585-F-400018", "E0585-F-400025",
        "E0585-F-400028", "E0585-F-500000", "E0585-F-500001", "E0585-F-500010",
        "E0585-F-800001", "E0585-F-800004", "Gad1-F-000139", "Gad1-F-000155",
        "Gad1-F-000393", "Gad1-F-100091", "Gad1-F-100093", "Gad1-F-100099",
        "Gad1-F-100247", "Gad1-F-100357", "Cha-F-300025", "Cha-F-600051",
        "Cha-F-500138", "Cha-F-300204", "Cha-F-300241", "Cha-F-200169",
        "Cha-F-800045", "Cha-F-100141", "Cha-F-200204",
        "Cha-F-500187", "VGlut-F-400058", "Gad1-F-100023","TH-M-200014",
        "Gad1-F-700165", "Gad1-F-600214", "Gad1-F-400335", "Gad1-F-400304",
        "Gad1-F-400226", "Gad1-F-400166", "Gad1-F-300298", "Gad1-F-300184",
        "Gad1-F-200362", "Gad1-F-200255", "Gad1-F-200220", "Gad1-F-200199",
        "Cha-F-000427", "Cha-F-100394", "Cha-F-100457", "Cha-F-600232",
        "E0585-F-300020", "E0585-F-300043", "E0585-F-300052", "E0585-F-300064",
        "E0585-F-300069", "E0585-F-300070", "E0585-F-400003", "E0585-F-400009",
        "E0585-F-400011", "E0585-F-400021", "E0585-F-400029", "E0585-F-500008",
        "E0585-F-500009", "E0585-F-700001", "E0585-F-800003", "Gad1-F-000125",
        "Gad1-F-000338", "Gad1-F-100211", "Gad1-F-100322", "Cha-F-200082",
        "Cha-F-100068", "Cha-F-100083", "Cha-F-400179","E0585-F-700002",
        "Gad1-F-900040", "Gad1-F-900052", "Gad1-F-100003", "TH-M-300021", "TH-M-100016", "Cha-F-300342",
        "TH-M-000023", "fru-M-200172","E0585-F-400002", "E0585-F-400001","Cha-F-800011","E0585-F-600002","Cha-F-100264",
        "Cha-F-100398","Gad1-F-200362","Gad1-F-300312","Gad1-F-200177","120216c0",
        "120618c0", "120628c1", "120708c1","Gad1-F-300290",
        "120712c1",  "130213c0","130214c1","130425c1","120813c0", "130118c0","120619c1", "120710c0", "120914c0", "121130c0", "121212c0",
        "121213c0", "121217c0", "121227c2", "130208c1", "130211c3", "130220c1",
        "130313c1", "130605c1", "130606c1", "130617c3", "130702c1",
        "130703c1", "130704c2", "130710c3", "130711c1", "130712c1", "130717c0",
        "130814c0", "130816c2", "131118c3", "131126c3", "131204c0","120605c0",
        "131212c0", "160121c1","Cha-F-700170","Cha-F-400240","Gad1-F-400162","Cha-F-000317")
pv5.a.1 = c("120216c0", "120628c1", "120708c1", "120813c0", "120914c0",
            "130118c0", "Cha-F-000427", "Cha-F-100394", "Cha-F-200402", "Cha-F-300241",
            "Cha-F-400179", "Cha-F-400324", "Cha-F-500187", "Gad1-F-000338",
            "Gad1-F-100093", "Gad1-F-100099", "Gad1-F-100247", "Gad1-F-100322",
            "Gad1-F-100357", "Gad1-F-200220", "Gad1-F-200289", "Gad1-F-200403",
            "Gad1-F-300298", "Gad1-F-400226", "Gad1-F-400275", "Gad1-F-400335",
            "Gad1-F-500180", "Gad1-F-600214", "Gad1-F-900137", "L166#1",
            "L166#2", "L166#3", "L166#5", "L166#6", "L224#1", "L224#2", "L224#3",
            "L378#1", "L378#2", "SS01372#1", "SS01372#2", "SS01372#3")
pv5.a.2 = c("Gad1-F-500244","Cha-F-800011","Gad1-F-500244", "Cha-F-800011","120712c1" ,"L166#4","Cha-F-100457" ,
            "Gad1-F-300184" ,"Gad1-F-400304", "Gad1-F-200199","VGlut-F-400058", "120619c1", "120710c0", "L291#1")
pv5.a.3 = c("Gad1-F-700139","Gad1-F-000349","Cha-F-500250","Cha-F-700211","L163#1","L163#2")
pv5.a.4 = c("Gad1-F-100091","Cha-F-500138")
pv5.a= c(pv5.a.1,pv5.a.2,pv5.a.3,pv5.a.4)
pv5.b.1=c("Gad1-F-000155", "E0585-F-400002", "Cha-F-100083", "Gad1-F-100023",
          "E0585-F-300073", "120618c0","120605c0", "131118c3", "160121c1", "Cha-F-200082",
          "Cha-F-300204", "Cha-F-200169", "Cha-F-800045", "Gad1-F-900098",
          "Gad1-F-300321","L1554#1","L1554#2","MB036B#1")
pv5.b.2 = c("121130c0", "Cha-F-700258", "E0585-F-300063", "130213c0",
            "E0585-F-300066","E0585-F-300064","E0585-F-400029","130214c1",
            "E0585-F-400003","E0585-F-400021","Cha-F-100264","130425c1")
pv5.b.3 = c("E0585-F-700001", "E0585-F-800004", "E0585-F-400015",
            "E0585-F-800001", "E0585-F-500010", "Cha-F-200204", "Cha-F-300342",
            "E0585-F-400028","E0585-F-700002","L849#1", "L849#2")
pv5.b.4 = c("Cha-F-600232")
pv5.b.5 = c("E0585-F-400001")
pv5.b.6 = c("E0585-F-800003","Gad1-F-900040")
pv5.b=c(pv5.b.2,pv5.b.1,pv5.b.3,pv5.b.4,pv5.b.5,pv5.b.6)
pv5.c.1=c("Cha-F-000317","Gad1-F-200232", "E0585-F-300013", "E0585-F-300033", "E0585-F-300040",
          "E0585-F-300047", "E0585-F-300071",
          "Gad1-F-000139", "Cha-F-600051",
          "E0585-F-300020", "E0585-F-300052",
          "E0585-F-300070", "E0585-F-500008",
          "Gad1-F-900052", "Gad1-F-100003", "130605c1",
          "130702c1","E0585-F-300043", "130703c1","130712c1",
          "130717c0","130814c0","130710c3","E0585-F-400025", "E0585-F-400005", "E0585-F-400008","E0585-F-400013",
          "Gad1-F-200255","E0585-F-400011","130208c1","130711c1","130816c2",
          "L173#8", "L173#7", "L173#9","L1293#14", "L1293#15","L178#2", "L178#1", "L178#3","L178#4",
      "L173#2", "L173#3", "L1293#1", "L1293#3", "L1293#5", "L1293#6","L173#5", "L173#6",
      "E0585-F-400009", "E0585-F-400018",
      "Cha-F-100141", "121227c2", "L1293#7", "L1293#8", "L1293#9","L1293#16",
      "L1293#12", "L1293#13", "L1293#2", "L1293#11", "L173#1","L1293#4","L1293#10","L173#4")#23,33,23,24
pv5.c.2 = c("E0585-F-500009", "Gad1-F-000125",  "Cha-F-100068",
            "130220c1", "130313c1","130605c1","130704c2","130710c3",
             "E0585-F-300050", "Gad1-F-300155",
            "E0585-F-300058", "121212c0", "130606c1", "Cha-F-300025", "E0585-F-300069", "121213c0",
            "Cha-F-700170","130710c3","130605c1", "L173#1")
pv5.c.3 = c("121217c0", "130211c3","130617c3","131126c3", "131204c0", "131212c0")
pv5.c=c(pv5.c.2,pv5.c.1,pv5.c.3)
pv5.d.1 =c("Gad1-F-800215","Gad1-F-300163","E0585-F-600002" )
pv5.d.2 = c("Gad1-F-200362")
pv5.d.3=c("Gad1-F-000393")
pv5.d = c(pv5.d.1,pv5.d.2,pv5.d.3)
pv5.e.1 = c("TH-M-300021","TH-M-200014") # PPL1-a'3
pv5.e.2 = c("TH-M-100016", "TH-M-000023")
pv5.e.3 = "Gad1-F-400166"
pv5.e = c(pv5.e.1,pv5.e.2,pv5.e.3)
pv5.f = pv5.f.1 = c("Gad1-F-300243", "E0585-F-500000", "E0585-F-500001","Gad1-F-400162")
pv5.g.1 = c("L374#3", "L374#5", "L374#6",  "L374#2", "L374#4",
            "L374#9", "L374#10", "Gad1-F-200177")
pv5.g.2 = c("L374#8", "Gad1-F-300312")
pv5.g.3 = c("Cha-F-100398","Gad1-F-700165")
pv5.g=c(pv5.g.1,pv5.g.2,pv5.g.3) #3E
pv5.h = pv5.h.1 = "Gad1-F-100211"
pv5.i = pv5.i.1 = "fru-M-200172" # check other pnts
pv5.j = pv5.j.1 = "Cha-F-400240"
pv5.k = pv5.k.1 = c("Gad1-F-300290","L528#1")


# Assign cell types
df[pv5.a.1,]$cell.type = "pv5a1"
df[pv5.a.2,]$cell.type = "pv5a2"
df[pv5.a.3,]$cell.type = "pv5a3"
df[pv5.a.4,]$cell.type = "pv5a4"
df[pv5.b.1,]$cell.type = "pv5b1"
df[pv5.b.2,]$cell.type = "pv5b2"
df[pv5.b.3,]$cell.type = "pv5b3"
df[pv5.b.4,]$cell.type = "pv5b4"
df[pv5.b.5,]$cell.type = "pv5b5"
df[pv5.b.6,]$cell.type = "pv5b6"
df[pv5.c.1,]$cell.type = "pv5c1"
df[pv5.c.2,]$cell.type = "pv5c2"
df[pv5.c.3,]$cell.type = "pv5c3"
df[pv5.d.1,]$cell.type = "pv5d1"
df[pv5.d.2,]$cell.type = "pv5d2"
df[pv5.d.3,]$cell.type = "pv5d3"
df[pv5.e.1,]$cell.type = "pv5e1" #PPl1-a'3
df[pv5.e.2,]$cell.type = "pv5e2" #PPl1-a'3?
df[pv5.e.3,]$cell.type = "pv5e3" #PPl1-a'3?
df[pv5.f.1,]$cell.type = "pv5f1"
df[pv5.g.1,]$cell.type = "pv5g1"
df[pv5.g.2,]$cell.type = "pv5g2"
df[pv5.g.3,]$cell.type = "pv5g3"
df[pv5.h.1,]$cell.type = "pv5h1"
df[pv5.i.1,]$cell.type = "pv5i1"
df[pv5.j.1,]$cell.type = "pv5j1"
df[pv5.k.1,]$cell.type = "pv5k1"



###### PNT pv3 ######



### pv3
pv3  = c("Gad1-F-700071", "Gad1-F-300161", "5HT1A-M-300003", "Gad1-F-500252","Cha-F-700277","CL123R_70G02", "Cha-F-000350","Gad1-F-600301","Gad1-F-000101")
pv3.a.1 = c("Gad1-F-300161","Gad1-F-000101","CL123R_70G02")
pv3.a.2 = c("Gad1-F-600301")
pv3.a=c(pv3.a.1,pv3.a.2)
pv3.b = pv3.b.1 = "Gad1-F-500252"
pv3.c = pv3.c.1 = c("Cha-F-000350")
pv3.d = pv3.d.1 = c("Cha-F-700277","Cha-F-100320")
pv3.e = pv3.e.1 = "5HT1A-M-300003"
pv3.f = pv3.f.1 = "Gad1-F-700071"




# Assign cell types
df[pv3.a.1,]$cell.type = "pv3a1"
df[pv3.a.2,]$cell.type = "pv3a2"
df[pv3.b.1,]$cell.type = "pv3b1"
df[pv3.c.1,]$cell.type = "pv3c1"
df[pv3.d.1,]$cell.type = "pv3d1"
df[pv3.e.1,]$cell.type = "pv3e1"
df[pv3.f.1,]$cell.type = "pv3f1"





###### PNT pv4 ######





### pv4
pv4  = c("130205c2", "130219c0", "130312c1", "130408c0", "130411c2",
         "130619c0", "130625c0", "130627c0", "130703c0", "130704c1", "130724c0",
         "130821c0", "130826c0", "130829c0", "130829c1", "130911c0", "130911c2",
         "130912c0", "130912c1", "130913c0", "130923c0", "130925c2", "131212c1",
         "140117c2", "140206c2", "140207c0", "140211c0", "140212c0", "5HT1A-F-300030",
         "5HT1A-F-300034", "Cha-F-000485", "Cha-F-000507", "Cha-F-100028",
         "Cha-F-100221", "Cha-F-100278", "Cha-F-100412", "Cha-F-100456",
         "Cha-F-200398", "Cha-F-300186", "Cha-F-300212", "Cha-F-300221",
         "Cha-F-400138", "Cha-F-400318", "Cha-F-500234", "Cha-F-500298",
         "Cha-F-500303", "Cha-F-600207", "Cha-F-600209", "Cha-F-600226",
         "Cha-F-600243", "Cha-F-600269", "Cha-F-700255", "Cha-F-800106",
         "Cha-F-800134", "Cha-F-900046", "CL100R_26C12", "CL29GR_JRC_IS23354-000.swc",
         "CL97R_26C12", "CL98R_26G09", "E0585-F-300056", "fru-F-100052",
         "fru-F-400011", "fru-F-400180", "fru-F-400219", "fru-F-500177",
         "fru-F-500479", "fru-M-200253", "fru-M-200351", "fru-M-500368",
         "Gad1-F-000201", "Gad1-F-000274", "Gad1-F-000381", "Gad1-F-100132",
         "Gad1-F-100154", "Gad1-F-100178", "Gad1-F-100338", "Gad1-F-100345",
         "Gad1-F-200322", "Gad1-F-200395", "Gad1-F-300135", "Gad1-F-300148",
         "Gad1-F-400027", "Gad1-F-400124", "Gad1-F-500023", "Gad1-F-500038",
         "Gad1-F-500171", "Gad1-F-500178", "Gad1-F-500281", "Gad1-F-500338",
         "Gad1-F-600125", "Gad1-F-600205", "Gad1-F-600252", "Gad1-F-700108",
         "Gad1-F-700258", "Trh-F-000048", "VGlut-F-000390", "VGlut-F-200590",
         "VGlut-F-300393", "VGlut-F-300574", "VGlut-F-400084", "VGlut-F-400195",
         "VGlut-F-400240", "VGlut-F-400394", "VGlut-F-500046", "VGlut-F-500243",
         "VGlut-F-500253", "VGlut-F-500323", "VGlut-F-500399", "VGlut-F-500411",
         "VGlut-F-500419", "VGlut-F-500442", "VGlut-F-500444", "VGlut-F-500445",
         "VGlut-F-600030", "VGlut-F-600075", "VGlut-F-600090", "VGlut-F-600311",
         "VGlut-F-600752", "VGlut-F-600764", "VGlut-F-700001", "VGlut-F-700084",
         "VGlut-F-700260", "VGlut-F-700280", "VGlut-F-700342", "VGlut-F-700430",
         "VGlut-F-700436", "VGlut-F-700503", "VGlut-F-700602", "VGlut-F-800064",
         "VGlut-F-800068", "VGlut-F-800074", "VGlut-F-900028")
# Behaviour: L1475, L1477, L542, L1354
pv4.a.1 = c("fru-F-500177","fru-F-400219","fru-F-500479","fru-F-400011","L1467#8","L1467#9","L1467#13", "L1473#7","L1473#11",
            "L1473#12", "L234#2", "L234#3", "L542#3", "L542#4", "L1467#25", "L1467#26", "L1467#27","L1473#5","L234#1","L1735#9")
pv4.a.2 = c("130625c0","130619c0","Cha-F-500234","fru-M-500368", "L1385#21", "L1467#11", "L1473#3","L1475#5", "L1475#6",
            "L1473#8","L1735#4","L1467#2","L1467#16", "L1467#20", "L1473#6",  "L1735#2","L1467#18","L1467#19","L1467#22","L1735#8",
            "L1467#10","L1749#1","L1473#4","L1473#9","L542#1","L1467#21","L1749#2", "L1749#4","L1749#5","L1749#8","L1473#10") # Physiology 39
pv4.a.3 = c("130408c0","130411c2","Gad1-F-000381","Cha-F-100412","L1735#11","L1354#1", "L1354#2","L1467#6","L1467#23",
            "L1475#1","L1475#2","L1475#3","L1475#7","L1475#8","L1475#9","L1735#1","L1735#3","L1477#1") # Physiology 26. No front arc.
pv4.a.4 = c("130724c0","130219c0","130703c0","VGlut-F-600752","L1475#4","L542#2",
            "L1467#1","L1475#13","L1467#7","L1354#4","L1467#5","L1477#3",
            "L1467#22",  "L954#1", "L954#2","Cha-F-300186", "Gad1-F-100345",
            "Gad1-F-000201","VGlut-F-700436","L1749#11","L1354#3","L1475#10", "L1475#11", "L1475#12") # Physiology 25. Plunging axon.
pv4.a.5=c("VGlut-F-500253","VGlut-F-600090","VGlut-F-700430","130704c1","L1477#2",
          "L1735#5","L1467#24","L1735#6","L1735#7","L1735#10","L1735#12", "L784#1", "L1467#14") # Upper axon split type. Split axon.
pv4.a.6 = c("fru-F-400180","Gad1-F-600205", "Cha-F-300221", "Gad1-F-200395","130913c0","130912c0", "130911c2","Gad1-F-100132")
pv4.a.7 = c("L1473#2","130826c0", "130829c0", "130925c2", "130821c0", "130911c0","130829c1","Cha-F-900046",
            "Cha-F-700255","130205c2", "Gad1-F-100338", "L1473#1","L629#7")
pv4.a.8 = c("Gad1-F-400124","Cha-F-800134","Gad1-F-500038","Cha-F-100456","Gad1-F-500281")
pv4.a.9 = c("Cha-F-100221", "Gad1-F-500178", "5HT1A-F-300030", "5HT1A-F-300034")
pv4.a.10 = c("Gad1-F-700108","130627c0","Cha-F-600207")
pv4.a.11 = c("VGlut-F-300393","Cha-F-500303","Cha-F-600226")
pv4.a.12 = c("VGlut-F-400195","L1842#4","L1842#5","L1842#6","L1842#7")
pv4.a= c(pv4.a.1,pv4.a.2,pv4.a.3,pv4.a.4,pv4.a.5,pv4.a.6,pv4.a.7,pv4.a.8,pv4.a.9,pv4.a.10,pv4.a.11,pv4.a.12)
pv4.b.1 = c("VGlut-F-500411","VGlut-F-700602","Gad1-F-300148", "VGlut-F-600764","VGlut-F-300574", "VGlut-F-500243",
            "VGlut-F-500399", "VGlut-F-700084","Gad1-F-700258","140117c2","L1827#4","L1827#6","L1827#13")
pv4.b.2 = c("fru-M-200351","Gad1-F-100154","131212c1","E0585-F-300056","VGlut-F-500444","140207c0", "VGlut-F-400084", "Cha-F-100028",
            "Gad1-F-200322","140211c0","140206c2","L1827#5", "L1827#7","L1827#8", "L1827#9","L1827#10","L1827#11","L1827#12", "L1828#2")
pv4.b.3 = c("L509#1","L509#2")
pv4.b.4 = c("Gad1-F-300135")
pv4.b.5 = c("VGlut-F-800068")
pv4.b= c(pv4.b.1,pv4.b.2,pv4.b.3,pv4.b.4,pv4.b.5)
pv4.c.1 = c("VGlut-F-500046","VGlut-F-600030","Gad1-F-400027","VGlut-F-700503",
            "VGlut-F-400240","VGlut-F-700280","VGlut-F-800064","VGlut-F-700342",
            "Gad1-F-000274","VGlut-F-500419", "L2316#2", "L2392#2", "L2392#3","L2392#4", "L2392#5")
pv4.c.2=c("fru-M-200253","Gad1-F-100178","L1842#1","L1842#2","L1842#3") # Some somas wrong
pv4.c.3= c("VGlut-F-500442","VGlut-F-500445","VGlut-F-900028","L1397#1", "L1397#2", "L1397#3","L1959#1")
pv4.c.4=c("VGlut-F-800074")
pv4.c.5 = "VGlut-F-600311"
pv4.c.6 = "Cha-F-600243"
# PV4c7 in Paavo's EM
pv4.c=c(pv4.c.1,pv4.c.2,pv4.c.3,pv4.c.4,pv4.c.5,pv4.c.6)
pv4.d.1 =c("Cha-F-600269", "Cha-F-000485", "Gad1-F-500338", "Cha-F-200398","130923c0","Cha-F-000507","140212c0",
           "L2233#1", "L2233#2", "L2233#3", "L2233#4")
pv4.d.2 =c("Gad1-F-500171","Gad1-F-500023","Cha-F-100278","Cha-F-800106","VGlut-F-500323")
pv4.d.3 =c("130912c1","L979#4","L979#5")
pv4.d.4 = c("Cha-F-600209","Gad1-F-600252","L979#1","L979#2","L979#3","L979#6","L979#7")
pv4.d.5 ="Gad1-F-600125"
pv4.d.6 ="VGlut-F-400394"
pv4.d = c(pv4.d.1,pv4.d.2,pv4.d.3,pv4.d.4,pv4.d.5,pv4.d.6)
pv4.e.1 = c("VGlut-F-700001","VGlut-F-600075","Cha-F-300212","VGlut-F-700260")
pv4.e.2 = c("Cha-F-400138","VGlut-F-200590","Trh-F-000048")
pv4.e.3 =c("Cha-F-500298")
#pv4.e.4=c("CL100R_26C12")
pv4.e = c(pv4.e.1,pv4.e.2,pv4.e.3)
pv4.f = pv4.f.1 = c("130312c1","Cha-F-400318","L1467#15","L1467#17")
pv4.g = pv4.g.1 = c("VGlut-F-000390")
pv4.h = pv4.h.1 = "fru-F-100052"
pv4.i = pv4.i.1 = "CL98R_26G09"
pv4.j = pv4.j.1 = "CL97R_26C12"
pv4.k = pv4.k.1 = "CL29GR_JRC_IS23354-000.swc"


# Assign cell types
df[pv4.a.1,]$cell.type = "pv4a1"
df[pv4.a.2,]$cell.type = "pv4a2"
df[pv4.a.3,]$cell.type = "pv4a3"
df[pv4.a.4,]$cell.type = "pv4a4"
df[pv4.a.5,]$cell.type = "pv4a5"
df[pv4.a.6,]$cell.type = "pv4a6"
df[pv4.a.7,]$cell.type = "pv4a7"
df[pv4.a.8,]$cell.type = "pv4a8"
df[pv4.a.9,]$cell.type = "pv4a9"
df[pv4.a.10,]$cell.type = "pv4a10"
df[pv4.a.11,]$cell.type = "pv4a11"
df[pv4.a.12,]$cell.type = "pv4a12"
df[pv4.b.1,]$cell.type = "pv4b1"
df[pv4.b.2,]$cell.type = "pv4b2"
df[pv4.b.3,]$cell.type = "pv4b3"
df[pv4.b.4,]$cell.type = "pv4b4"
df[pv4.b.5,]$cell.type = "pv4b5"
df[pv4.c.1,]$cell.type = "pv4c1"
df[pv4.c.2,]$cell.type = "pv4c2"
df[pv4.c.3,]$cell.type = "pv4c3"
df[pv4.c.4,]$cell.type = "pv4c4"
df[pv4.c.5,]$cell.type = "pv4c5"
df[pv4.c.6,]$cell.type = "pv4c6"
df[pv4.d.1,]$cell.type = "pv4d1"
df[pv4.d.2,]$cell.type = "pv4d2"
df[pv4.d.3,]$cell.type = "pv4d3"
df[pv4.d.4,]$cell.type = "pv4d4"
df[pv4.d.5,]$cell.type = "pv4d5"
df[pv4.d.6,]$cell.type = "pv4d6"
df[pv4.e.1,]$cell.type = "pv4e1"
df[pv4.e.2,]$cell.type = "pv4e2"
df[pv4.e.3,]$cell.type = "pv4e3"
df[pv4.f.1,]$cell.type = "pv4f1"
df[pv4.g.1,]$cell.type = "pv4g1"
df[pv4.h.1,]$cell.type = "pv4h1"
df[pv4.i.1,]$cell.type = "pv4i1"
df[pv4.j.1,]$cell.type = "pv4j1"
df[pv4.k.1,]$cell.type = "pv4k1"



###### PNT PV6 ######



pv6 = c("Cha-F-200186","CL29CR_30H02","CL29CR_14B11","Cha-F-000395", "CL29FR_IS24835","Gad1-F-900064")
pv6.a.1 = c("L62#1","CL29CR_30H02","CL29CR_14B11") # in Mike's lines L62
pv6.a.2 = c("Cha-F-200186")
pv6.a.3 = c("L2193#2", "L2193#3","L2185#2", "L2193#4", "L2193#1", "L2185#1", "L2193#5")
pv6.a = c(pv6.a.1,pv6.a.2,pv6.a.3)
# pv6a3 is Dr. Caligari in Paavo's paper
pv6.b = pv6.b.1 = c("L1827#1","L1827#2")
pv6.c = pv6.c.1 = c("L2220#1","L2220#2", "L2220#3","L2220#4")
pv6.d.1 = "CL29FR_IS24835"
pv6.d=c(pv6.d.1)
pv6.e = pv6.e.1 = "Gad1-F-900064"


# Assign cell types
df[pv6.a.1,]$cell.type = "pv6a1"
df[pv6.a.2,]$cell.type = "pv6a2"
df[pv6.a.3,]$cell.type = "pv6a3"
df[pv6.b.1,]$cell.type = "pv6b1"
df[pv6.c.1,]$cell.type = "pv6c1"
df[pv6.d.1,]$cell.type = "pv6d1"
df[pv6.d.2,]$cell.type = "pv6d2"
df[pv6.e.1,]$cell.type = "pv6e1"



###### PNT pv2 ######




### pv2
pv2 = c("Gad1-F-600088","Gad1-F-800194","Gad1-F-500328","Gad1-F-400232",
        "Gad1-F-100074","CL52R_11E08","CL123R_70G02","CL133R_39D07",
        "5HT1A-M-100027", "Gad1-F-800092", "Gad1-F-700138",
        "Cha-F-300168", "Cha-F-400222", "Cha-F-000242",
        "Gad1-F-800126", "Gad1-F-500266", "Cha-F-200448","Cha-F-600097",
        "5HT1A-M-200001","5HT1A-F-100028","131030c0",
        "131031c1","CL135R_10A11", "131028c0","ICL151B_IS24671", "131122c1")
pv2.a.1 = c("5HT1A-M-200001", "Cha-F-300168", "5HT1A-F-100028","5HT1A-M-100027",
  "L258#2", "L258#4", "L259#5", "L259#2", "L259#4", "L258#5","131030c0", "131028c0",
  "L258#15", "L258#18", "L258#11", "L258#10", "L258#12", "L259#1",
  "L259#3", "L258#14", "L258#16", "L258#6", "L258#8",
   "L258#13", "L258#1", "L258#3", "L258#17") # Punch
mb.c1 = c("L1900#1","L1900#2")
pv2.a.2 = c("Cha-F-400222","L568#2", "Gad1-F-400232", "L568#6", "Cha-F-000242", "L1385#18")
pv2.a.3 = "Gad1-F-600088"
pv2.a=c(pv2.a.1,pv2.a.2,pv2.a.3)
pv2.b.1 = c("Gad1-F-700138","131031c1","Cha-F-000110","L258#7","L258#9","L2013#2")
pv2.b=c(pv2.b.1)
pv2.c = pv2.c.1 = c("L1328#3", "L1328#4","Gad1-F-800194","L1328#5", "L1328#6", "L1328#1", "L1328#2","Gad1-F-400232", "Cha-F-000242")
pv2.d.1 =  c("Gad1-F-800092","131122c1", "L1955#1","L1847#1")
pv2.d.2 = "Gad1-F-100074"
pv2.d.3 ="CL133R_39D07"
pv2.d=c(pv2.d.1,pv2.d.2,pv2.d.3)
pv2.e = pv2.e.1 = "Gad1-F-500328"
pv2.f = pv2.f.1 = "Cha-F-600097"
pv2.g = pv2.g.1 = c("Gad1-F-500266", "Cha-F-200448")
pv2.h = pv2.h.1 = "Gad1-F-800126"# Could be its own tract
pv2.i = pv2.i.1 = "ICL151B_IS24671"
pv2.j = pv2.j.1 = "CL52R_11E08"
pv2.k = pv2.k.1 = "CL135R_10A11"

# Assign cell types
df[mb.c1,]$cell.type = "MB-C1"
df[pv2.a.1,]$cell.type = "pv2a1"
df[pv2.a.2,]$cell.type = "pv2a2"
df[pv2.a.3,]$cell.type = "pv2a3"
df[pv2.b.1,]$cell.type = "pv2b1"
df[pv2.c.1,]$cell.type = "pv2c1"
df[pv2.d.1,]$cell.type = "pv2d1"
df[pv2.d.2,]$cell.type = "pv2d2"
df[pv2.d.3,]$cell.type = "pv2d3"
df[pv2.d.1,]$cell.type = "pv2d1"
df[pv2.e.1,]$cell.type = "pv2e1"
df[pv2.f.1,]$cell.type = "pv2f1"
df[pv2.g.1,]$cell.type = "pv2g1"
df[pv2.h.1,]$cell.type = "pv2h1"
df[pv2.i.1,]$cell.type = "pv2i1"
df[pv2.j.1,]$cell.type = "pv2j1"
df[pv2.k.1,]$cell.type = "pv2k1"




###### PNT pv1 ######





### pv1
pv1 = c("TH-M-000013", "CL143R_MB583B",
         "TH-M-000071", "Trh-M-000025", "Cha-F-000461",
        "TH-F-000011", "TH-F-000012",
        "Gad1-F-500089","TH-F-300078","Gad1-F-500325","Cha-F-000278","Cha-F-500094",
        "Cha-F-000310", "fru-F-000126", "fru-M-800060", "TH-M-000030","fru-F-000125") # "Cha-F-000310" is a centrifugal
pv1.a.1 = c("Cha-F-000461","TH-F-000012","TH-M-000013","TH-M-000030")
pv1.a.2 = "Cha-F-000310"
pv1.a=c(pv1.a.1)
pv1.b = c("TH-M-000071","TH-F-300078","Gad1-F-500089","TH-F-000011","Trh-M-000025")
pv1.b.1 = "TH-M-000071"
pv1.b.2 = "TH-F-300078"
pv1.b.3 = "Gad1-F-500089"
pv1.b.4 = "TH-F-000011"
pv1.b.5 = "Trh-M-000025"
pv1.c = pv1.c.1 = "Cha-F-000278" # Could be its own tract?
pv1.d = pv1.d.1 = "Cha-F-500094" # Could be its own tract?
pv1.e = pv1.e.1 = "Gad1-F-500325"
pv1.f = pv1.f.1 = "fru-F-000126" # Could be its own tract?
pv1.g = pv1.g.1 = "fru-M-800060" # Could be its own tract?
pv1.h = pv1.h.1 = "fru-F-000125" # Could be its own tract?
pv1.i = pv1.i.1 = "CL143R_MB583B"
# PV1J1 nad PV1K1 in Paavo's EM data

# Assign cell types
df[pv1.a.1,]$cell.type = "pv1a1"
df[pv1.b.1,]$cell.type = "pv1b1"
df[pv1.b.2,]$cell.type = "pv1b2"
df[pv1.b.3,]$cell.type = "pv1b3"
df[pv1.b.4,]$cell.type = "pv1b4"
df[pv1.b.5,]$cell.type = "pv1b5"
df[pv1.c.1,]$cell.type = "pv1c1"
df[pv1.d.1,]$cell.type = "pv1d1"
df[pv1.e.1,]$cell.type = "pv1e1"
df[pv1.f.1,]$cell.type = "pv1f1"
df[pv1.g.1,]$cell.type = "pv1g1"
df[pv1.h.1,]$cell.type = "pv1h1"
df[pv1.i.1,]$cell.type = "pv1i1"





###### PNT pd6 ######





pd6 = c("Trh-F-000061", "Trh-M-600117", "Trh-M-600108", "Trh-M-200113",
        "Trh-M-200014", "Trh-M-700039","Gad1-F-200110", "fru-M-500259", "VGlut-F-900053", "VGlut-F-000454",
        "Cha-F-500087", "Cha-F-600179", "VGlut-F-000336", "fru-F-000130",
        "VGlut-F-300515","fru-M-500095")
pd6a = c("fru-M-500259", "VGlut-F-900053","VGlut-F-000454","Cha-F-500087", "Cha-F-600179",
         "VGlut-F-000336", "fru-F-000130", "VGlut-F-300515","Gad1-F-200110")
pd6.a.1 = c("fru-M-500259", "VGlut-F-900053","VGlut-F-000454","Cha-F-500087", "Cha-F-600179",
            "VGlut-F-000336", "fru-F-000130", "VGlut-F-300515")
pd6.a.2 = "Gad1-F-200110"
pd6.a = c( pd6.a.1, pd6.a.2)
pd6.b = pd6.b.1 = c("Trh-M-700039","Trh-F-000061", "Trh-M-600108", "Trh-M-200113")
pd6.c = pd6.c.1 = "Trh-M-600117"
pd6.d = pd6.d.1 = "Trh-M-200014"
pd6.e = pd6.e.1 = "fru-M-500095"

# Assign cell types
df[pd6.a.1,]$cell.type = "pd6a1"
df[pd6.a.2,]$cell.type = "pd6a2"
df[pd6.b.1,]$cell.type = "pd6b1"
df[pd6.c.1,]$cell.type = "pd6c1"
df[pd6.d.1,]$cell.type = "pd6d1"
df[pd6.e.1,]$cell.type = "pd6e1"





###### PNT pd5 ######





### pd5
pd5 = c("Gad1-F-100015")
pd5.a = pd5.a.1 = c("Gad1-F-100015") # New tract?
# Assign cell types
df[pd5.a.1,]$cell.type = "pd5a1"





###### PNT pd4 ######





### pd4
pd4 = c("Cha-F-000413", "Cha-F-500201", "Cha-F-700283","Gad1-F-000285",
        "Gad1-F-100218","Gad1-F-100025", "fru-F-000092",
        "VGlut-F-300425", "VGlut-F-100282", "fru-F-000098","Cha-F-400309",
        "fru-M-000015", "Cha-F-000005","fru-M-500020",
        "Cha-F-000007", "Cha-F-000531", "Cha-F-300350", "fru-F-300195",
        "VGlut-F-300438", "VGlut-F-100068","Gad1-F-900054","fru-M-000077")
pd4.a.1 = c("Cha-F-000413","VGlut-F-300425","VGlut-F-100068")
pd4.a.2 = c("VGlut-F-100282","VGlut-F-300438")
pd4.a.3 = c("fru-F-000098","fru-M-000077")
pd4.a.4 = c("Gad1-F-200241","L1539#2")
pd4.a.5 = c("fru-F-000092")
pd4.a=c(pd4.a.1,pd4.a.2,pd4.a.3,pd4.a.4,pd4.a.5)
pd4.b= pd4.b.1 = c("fru-M-000015", "Cha-F-500201", "Cha-F-000531")
pd4.c = c("Cha-F-700283","fru-F-300195")
pd4.c.1 = "Cha-F-700283"
pd4.c.2 = "fru-F-300195"
pd4.d = pd4.d.1 = c("Cha-F-000005","Gad1-F-900054","Cha-F-000007") # "Cha-F-000007" duplicated
pd4.e = pd4.e.1 = c("Gad1-F-000285", "Gad1-F-100218","Gad1-F-100025")
pd4.f = pd4.f.1 = "Cha-F-300350"
pd4.g = pd4.g.1 = "fru-M-500020"
pd4.h = pd4.h.1 = "Cha-F-400309"
pd4.i = pd4.i.1 = "fru-F-000092"

# Assign cell types
df[pd4.a.1,]$cell.type = "pd4a1"
df[pd4.a.2,]$cell.type = "pd4a2"
df[pd4.a.3,]$cell.type = "pd4a3"
df[pd4.a.4,]$cell.type = "pd4a4"
df[pd4.a.5,]$cell.type = "pd4a5"
df[pd4.b.1,]$cell.type = "pd4b1"
df[pd4.c.1,]$cell.type = "pd4c1"
df[pd4.c.2,]$cell.type = "pd4c2"
df[pd4.d.1,]$cell.type = "pd4d1"
df[pd4.e.1,]$cell.type = "pd4e1"
df[pd4.f.1,]$cell.type = "pd4f1"
df[pd4.g.1,]$cell.type = "pd4g1"
df[pd4.h.1,]$cell.type = "pd4h1"
df[pd4.i.1,]$cell.type = "pd4i1"






###### PNT pd3 ######





### pd3
pd3 = c("Cha-F-100103","Cha-F-400165","Cha-F-500011","Gad1-F-100168", "Gad1-F-200150","Gad1-F-400320","CL153R_IS24693")
pd3.a.1 = c("L1749#10", "L194#1", "Cha-F-400165", "Cha-F-500011","L876#4", "L876#7")#116, new tract! LHd2 neuroblast.
pd3.a.2 = c("L1749#3", "L2385#1", "L2385#2")
pd3.a.3 = c("Gad1-F-100168", "Gad1-F-200150","L1749#9","L1749#9","L1749#7")
pd3.a=c(pd3.a.1,pd3.a.2,pd3.a.3)
pd3.b = pd3.b.1 = "L1749#6"
pd3.c = pd3.c.1 = "Cha-F-100103" # correct attribution?
pd3.d = pd3.d.1 = "Gad1-F-400320" # correct attribution?
pd3.e = pd3.e.1 = "CL153R_IS24693"
# PD3f1 in Paavo's EM

# Assign cell types
df[pd3.a.1,]$cell.type = "pd3a1"
df[pd3.a.2,]$cell.type = "pd3a2"
df[pd3.a.3,]$cell.type = "pd3a3"
df[pd3.b.1,]$cell.type = "pd3b1"
df[pd3.c.1,]$cell.type = "pd3c1"
df[pd3.d.1,]$cell.type = "pd3d1"
df[pd3.e.1,]$cell.type = "pd3e1"




###### PNT pd2 ######






### pd2
pd2 = c("fru-M-000179","Gad1-F-500129", "Gad1-F-300303", "Gad1-F-200234", "5HT1A-F-300019",
        "Cha-F-000421", "Cha-F-100453", "Cha-F-800096",
        "fru-M-600135", "Gad1-F-100258", "Cha-F-000256",
        "fru-M-200206", "Gad1-F-500196", "5HT1A-F-300013", "Cha-F-600238",
        "Gad1-F-200037","Cha-F-600032",   "fru-M-000344",   "Gad1-F-500258",
        "VGlut-F-200258","fru-M-700108","121015c0", "121016c0", "121017c0",
        "121018c0", "121225c0","131007c0","121227c3", "130612c0", "131009c4",
        "131014c3","120806c0","120914c2","120926c0","130620c0","fru-F-600242",
        "Cha-F-200325","fru-F-500330","Cha-F-400224","fru-F-200100","fru-F-600136")
pd2.a.1 = c("Cha-F-600238", "Gad1-F-200234","5HT1A-F-300019", "5HT1A-F-300013","37G11#2", "L989#3", "L989#4","L991#1", "L989#13", "L989#10", "L989#14","37G11#6", "L991#3", "L991#4", "L989#6", "37G11#1",
  "L989#9", "L991#2", "37G11#4", "L989#5", "L991#5", "37G11#3", "L989#11", "L989#1", "L989#7","120806c0")
pd2.a.2 = c("130620c0", "130620c0", "121018c0", "121225c0", "130612c0",
            "131014c3", "121017c0", "121227c3","131007c0")
pd2.a.3=c("Gad1-F-500129","Gad1-F-500196")
pd2.a.4 = c("Cha-F-100453")
pd2.a.5 = c("Gad1-F-100258")
pd2.a.6 = c("Gad1-F-300303")  # Amadan
pd2.a.7 = c("Gad1-F-200037")
pd2.a=c(pd2.a.1,pd2.a.2,pd2.a.3,pd2.a.4,pd2.a.5,pd2.a.6,pd2.a.7)
pd2.b=pd2.b.1 = c("120926c0","37G11#5","Cha-F-000421","Cha-F-800096","121015c0","121016c0",
                  "120914c2","131009c4","L989#12", "L989#8","L989#2")
pd2.c.1 = c("VGlut-F-200258","Cha-F-600032","Gad1-F-500258")
pd2.c.2 = c("Cha-F-000256")
pd2.c = c(pd2.c.1,pd2.c.2)
pd2.d.1 = c("fru-M-700108","fru-M-200206","fru-M-000344","fru-F-500330","Cha-F-400224","fru-F-200100")
pd2.d.2 = "fru-F-600242"
# in Mike's split
pd2.d = c(pd2.d.1,pd2.d.2)
pd2.e.1 = c("fru-F-600136", "L16#6", "L16#8")
pd2.e.2 = c("L16#7", "L16#1", "L16#2", "L16#5", "L16#6", "L16#8")
pd2.e = c(pd2.e.1,pd2.e.2)
pd2.f= pd2.f.1 = c("MB072C#1") #pd2f1 in Mike's splits
pd2.g =  pd2.g.1 ="Cha-F-200325"
pd2.h = pd2.h.1 = "fru-M-600135"
pd2.i = pd2.i.1 = "fru-M-000179"

# Assign cell types
df[pd2.a.1,]$cell.type = "pd2a1"
df[pd2.a.2,]$cell.type = "pd2a2"
df[pd2.a.3,]$cell.type = "pd2a3"
df[pd2.a.4,]$cell.type = "pd2a4"
df[pd2.a.5,]$cell.type = "pd2a5"
df[pd2.a.6,]$cell.type = "pd2a6"
df[pd2.a.7,]$cell.type = "pd2a5"
df[pd2.b.1,]$cell.type = "pd2b1"
df[pd2.c.1,]$cell.type = "pd2c1"
df[pd2.c.2,]$cell.type = "pd2c2"
df[pd2.d.1,]$cell.type = "pd2d1"
df[pd2.d.2,]$cell.type = "pd2d2"
df[pd2.e.1,]$cell.type = "pd2e1"
df[pd2.e.2,]$cell.type = "pd2e2"
df[pd2.f.1,]$cell.type = "pd2f1"
df[pd2.g.1,]$cell.type = "pd2g1"
df[pd2.h.1,]$cell.type = "pd2h1"
df[pd2.i,]$cell.type = "pd2i1"



###### PNT pd1 ######





### pd1
pd1 = c("fru-M-100313", "VGlut-F-400655", "VGlut-F-200053","VGlut-F-100022")
pd1.a = pd1.a.1 = c("fru-M-100313","VGlut-F-400655","VGlut-F-200053","VGlut-F-100022")
# Assign cell types
df[pd1.a.1,]$cell.type = "pd1a1"





###### PNT AV3 ######





# av3
av3= c("Gad1-F-000132","Cha-F-000174","VGlut-F-700360","VGlut-F-600716","VGlut-F-200441","Cha-F-200387",
       "VGlut-F-300265","VGlut-F-400112","Cha-F-600218","Gad1-F-000203","Cha-F-000470",
       "VGlut-F-800054","VGlut-F-500832","VGlut-F-500109","VGlut-F-600223","VGlut-F-800057")
av3.a.1=c("Cha-F-000174","VGlut-F-700360","VGlut-F-600716",
          "VGlut-F-300265","VGlut-F-400112","Cha-F-600218","Gad1-F-000203",
          "VGlut-F-800054","VGlut-F-500832","VGlut-F-500109","L1117#1")
av3.a.2=c("Cha-F-200387","Gad1-F-000132")
av3.a=c(av3.a.1,av3.a.2)
av3.b=av3.b.1=c("VGlut-F-600223","VGlut-F-800057")
av3.c=av3.c.1=c("Cha-F-000470")
av3.d.1 = "Cha-F-000395"
av3.d.2 = ("VGlut-F-200441")
av3.d = c(av3.d.1,av3.d.2)
# AV3.e.1 is Ouroborus

# Assign cell types
df[av3.a.1,]$cell.type = "av3a1"
df[av3.a.2,]$cell.type = "av3a2"
df[av3.b.1,]$cell.type = "av3b1"
df[av3.c.1,]$cell.type = "av3c1"
df[av3.d.1,]$cell.type = "av3d1"



###### PNT AV7 ######






### av7
av7 = c("Cha-F-700110",  "Gad1-F-200237", "Gad1-F-100225", "Cha-F-000432",  "Cha-F-500243", "fru-M-200393")

av7.a = av7.a.1 = c("Cha-F-700110", "L2001#4", "L2001#5","L2001#10", "L2001#6", "L2001#7","L2002#2", "L2001#3", "L2001#8", "L2001#9", "L2002#1", "L2001#1",
  "L2001#2", "Gad1-F-200237", "Gad1-F-100225")
av7.b = av7.b.1 = c("Cha-F-000432","Cha-F-500243")
av7.c = av7.c.1 = c("fru-M-200393")


# Assign cell types
df[av7.a.1,]$cell.type = "av7a1"
df[av7.b.1,]$cell.type = "av7b1"
df[av7.c.1,]$cell.type = "av7c1"



###### PNT AV4 ######





###  AV4 tract skeletons
av4 = c("Gad1-F-100077", "Cha-F-000193", "fru-F-500592",
        "Gad1-F-200137", "Gad1-F-400432","Cha-F-700114","fru-M-500251",
        "Cha-F-200276", "Cha-F-000481", "Cha-F-400293", "Cha-F-200385",
        "Gad1-F-700151", "Gad1-F-200155", "fru-F-600131", "fru-F-500181",
        "Gad1-F-000079", "Cha-F-600124", "Cha-F-500116", "fru-F-600129",
        "fru-F-500205", "fru-F-500357", "Cha-F-600191", "fru-M-700164",
        "fru-F-500229","Gad1-F-700104", "Cha-F-000524", "Gad1-F-100190",
        "Cha-F-700026", "Trh-M-500176", "fru-F-200122",
        "fru-F-500032", "fru-F-700136", "fru-F-500183",
        "Gad1-F-000006","fru-F-500099",
        "Gad1-F-600241", "Gad1-F-800028", "fru-F-400486", "Trh-F-300041",
        "fru-M-400293", "fru-F-500089", "Gad1-F-400436", "fru-F-500355",
        "Cha-F-200329",  "Gad1-F-200127",
        "Gad1-F-200163", "Cha-F-700025", "fru-F-400039", "fru-M-200048",
        "fru-M-800189", "fru-M-700174", "fru-F-800071",
        "fru-M-700052", "Gad1-F-700106", "fru-M-100096", "Gad1-F-700224",
        "fru-F-300099", "5HT1A-M-300006", "fru-M-300432","fru-M-300124",
        "fru-M-500115", "Cha-F-200282","131002c2", "131003c0", "131003c1",
        "131007c1", "131008c0", "131009c0", "131011c0", "131014c2", "131016c1",
        "131113c0", "131123c1", "140117c1", "140213c1", "140618c0", "160201c1",
        "160211c1","Cha-F-200357","Gad1-F-600140", "Gad1-F-200366", "5HT1A-F-800008", "Cha-F-000515",
        "Cha-F-200378", "Cha-F-300146", "fru-F-600043","Gad1-F-100051",
        "fru-M-700211", "fru-M-800040","VGlut-F-200021","VGlut-F-200382","fru-F-500093")

# Decide cell types
av4.a.1 = c("fru-M-700211","fru-M-700174", "131016c1", "131002c2", "140117c1","Gad1-F-600241", "Cha-F-200282", "fru-F-200122", "131003c0",
            "fru-F-500183", "fru-M-200048", "fru-F-500032", "fru-F-700136","Cha-F-300146","Gad1-F-700104", "fru-F-600131", "fru-F-500229",
            "fru-M-200048", "L1479#1", "fru-M-700211", "fru-M-500115", "fru-M-700164","Gad1-F-200163",
            "Gad1-F-800028","Trh-F-300041","L788#2", "L788#1", "L788#3")
av4.a.2 = c("L1385#26", "Cha-F-200385", "Cha-F-000524","Gad1-F-000079", "Cha-F-600191")
av4.a.3 = c("L240#17", "L240#14", "L240#16", "L240#3", "L240#2", "L240#4",
            "L240#10", "L240#11", "L1046#8", "L240#1","Gad1-F-700106", "L1385#10",
            "Trh-M-500176", "L1046#7", "L1046#10", "L240#6", "L1046#4","L247#1", "L240#18", "L240#21", "L247#2", "L247#3", "L247#6",
        "L240#20", "L240#19", "L240#22", "L247#4", "L247#5", "L240#5",
      "L240#23", "L240#13", "L240#15", "L240#24")
av4.a.4 = c("L1046#11", "L1046#12", "Gad1-F-400436", "L240#7", "L240#8","L1046#5", "L1046#3", "L240#12","Cha-F-000481","L2098#1","L2098#2")
av4.a.5 = c("131008c0", "131014c2", "131113c0")
av4.a.6 = c("Cha-F-700026", "Gad1-F-100190")
av4.a.7 = c("Gad1-F-200155","Gad1-F-700151")
av4.a = c(av4.a.1,av4.a.2,av4.a.3,av4.a.4,av4.a.5,av4.a.6,av4.a.7)
av4.b.1  = c("fru-F-500181", "fru-F-500205", "fru-F-500357", "fru-M-700052",
                   "fru-F-600129", "fru-M-100096", "fru-F-500099", "fru-M-800040",
                   "fru-M-800189", "fru-F-800071", "fru-F-600043", "Cha-F-700025",
                   "fru-F-400039")
av4.b.2 = c("Cha-F-000515", "Gad1-F-700224", "Cha-F-600124","Gad1-F-000006")
av4.b.3 = c("L568#3", "L568#1", "L568#7","Cha-F-400293")
av4.b.4 = c("L1385#22", "L1385#23","L1385#3", "L1385#9", "L1385#5", "L1385#12", "L1385#14", "L1385#6", "L1385#7",
            "Gad1-F-200366", "L1385#11", "L1385#27","L787#1","L787#3","L1385#17", "L1385#20")
av4.b.5 = c("5HT1A-M-300006", "140618c0", "160211c1", "160201c1","Gad1-F-100077", "Gad1-F-600140")
av4.b.6 = c("L1385#24", "L1385#25") # Unsure
av4.b.7 = c("L1385#1", "L1385#2", "L1385#4","Cha-F-500116") # Unsure of tract
av4.b.8 = c("131009c0", "131007c1", "131011c0","Gad1-F-100051")
av4.b.9 = "5HT1A-F-800008"
av4.b = c(av4.b.1,av4.b.2,av4.b.3,av4.b.4,av4.b.5,av4.b.6,av4.b.7,av4.b.8,av4.b.9)

av4.c.1 = c("Cha-F-700114", "fru-M-300124", "fru-F-500093", "L421#7", "L421#9",
      "L421#4", "131003c1", "131123c1", "140213c1", "L421#5", "L421#1",
      "L421#3", "L421#12", "L421#8", "L421#13", "L421#11", "Cha-F-200276","Cha-F-000193")
av4.c.2 = c("L421#2", "L421#6", "fru-F-400486", "L568#5", "L421#14")
av4.c.3 = c("Gad1-F-400432", "fru-M-400293",  "Gad1-F-200137", "Cha-F-200329","fru-F-500355")
av4.c.4 = c("L1385#8", "Gad1-F-200127","Cha-F-200378")
av4.c = c(av4.c.1,av4.c.2,av4.c.3,av4.c.4)

av4.d = av4.d.1 = c("fru-M-300432","VGlut-F-200021","VGlut-F-200382")
av4.e = av4.e.1 = b = c("fru-F-500592","fru-F-300099")
av4.f= av4.f.1 = "L787#2"
av4.g = av4.g.1 = "fru-F-500089"
av4.h = av4.h.1 = "fru-M-500251"
# AV4i and AV4j in Paavo's data

# Assign cell types
df[av4.a.1,]$cell.type = "av4a1"
df[av4.a.2,]$cell.type = "av4a2"
df[av4.a.3,]$cell.type = "av4a3"
df[av4.a.4,]$cell.type = "av4a4"
df[av4.a.5,]$cell.type = "av4a5"
df[av4.a.6,]$cell.type = "av4a6"
df[av4.a.7,]$cell.type = "av4a7"
df[av4.b.1,]$cell.type = "av4b1"
df[av4.b.2,]$cell.type = "av4b2"
df[av4.b.3,]$cell.type = "av4b3"
df[av4.b.4,]$cell.type = "av4b4"
df[av4.b.5,]$cell.type = "av4b5"
df[av4.b.6,]$cell.type = "av4b6"
df[av4.b.7,]$cell.type = "av4b7"
df[av4.b.8,]$cell.type = "av4b8"
df[av4.b.9,]$cell.type = "av4b9"
df[av4.c.1,]$cell.type = "av4c1"
df[av4.c.2,]$cell.type = "av4c2"
df[av4.c.3,]$cell.type = "av4c3"
df[av4.c.4,]$cell.type = "av4c4"
df[av4.d.1,]$cell.type = "av4d1"
df[av4.e.1,]$cell.type = "av4e1"
df[av4.f.1,]$cell.type = "av4f1"
df[av4.g.1,]$cell.type = "av4g1"
df[av4.h.1,]$cell.type = "av4h1"



###### PNT AV5 ######





### AV5
av5 = c("TH-M-300052","VGlut-F-200146", "Cha-F-700219",  "VGlut-F-200058","Cha-F-300258",
        "Cha-F-700242","VGlut-F-100073","fru-M-200274","Gad1-F-100333","Cha-F-800067","Gad1-F-900076")
av5.a = av5.a.1 = c("Cha-F-700219","Cha-F-300258","Cha-F-700242","Cha-F-800067","Gad1-F-900076","L1594#1", "L1594#2")
av5.b =  av5.b.1 = c("VGlut-F-200146", "VGlut-F-200058","VGlut-F-100073")
av5.c =  av5.c.1 = "TH-M-300052"
av5.d=  av5.d.1 = c("Gad1-F-100333")
av5.e=  av5.e.1 = c("fru-M-200274")
av5.f = av5.f.1 = "Cha-F-100357"
av5.g = av5.g.1 = "Cha-F-200357" # bad trace


# Assign cell types
df[av5.a.1,]$cell.type = "av5a1"
df[av5.b.1,]$cell.type = "av5b1"
df[av5.c.1,]$cell.type = "av5c1"
df[av5.d.1,]$cell.type = "av5d1"
df[av5.e.1,]$cell.type = "av5e1"
df[av5.f.1,]$cell.type = "av5f1"
df[av5.g.1,]$cell.type = "av5g1"






###### PNT AV6 ######




### AV6
av6 = c("Cha-F-400277", "Cha-F-600105", "VGlut-F-100257", "Cha-F-700262",
        "Cha-F-000158", "Cha-F-400151", "Gad1-F-800082", "Cha-F-100427",
        "Gad1-F-500030", "Gad1-F-100097", "Gad1-F-800112", "Gad1-F-600143",
        "Gad1-F-500363", "Gad1-F-400255", "Cha-F-800078", "Cha-F-200185",
        "VGlut-F-200015", "Gad1-F-200144", "Gad1-F-800107", "Gad1-F-500140",
        "Gad1-F-200174", "Gad1-F-200156", "Cha-F-200454", "Cha-F-700236",
        "fru-F-400319", "VGlut-F-200375", "Gad1-F-600106", "130807c1",
        "130808c1", "130808c2", "130813c0", "130814c1", "130815c1", "130819c1",
        "130820c0", "130820c2", "130822c0", "140328c1", "140402c1", "140514c2",
        "130725c4", "Gad1-F-600096")
av6.a.1 = c("NP6099#1", "NP6099#2","Cha-F-400151", "Gad1-F-800082", "130814c1", "130808c1", "130819c1",
  "NP6099#6", "L1129#1", "L1129#5", "L1129#4", "Gad1-F-600143",
  "Gad1-F-500363", "Gad1-F-200156", "L1129#2", "L1129#3","130808c2", "130820c0", "130820c2", "Cha-F-000158", "130725c4",
  "130807c1", "130813c0", "130815c1", "130822c0", "140328c1", "140402c1",
  "140514c2", "Cha-F-800078", "NP6099#4", "NP6099#3", "NP6099#5")
av6.a.2 = c("Gad1-F-800112", "L271#2", "L1117#3", "L271#3", "L1117#2","Gad1-F-200144", "L271#4", "Cha-F-200185", "L271#1")
av6.a = c(av6.a.1,av6.a.2)
av6.b = av6.b.1 = c("Gad1-F-500140","Gad1-F-600106","L452#1", "L452#2", "L452#3", "L452#4","fru-F-400319","L452#5","L452#6","L452#7")
av6.c.1 = c("L2382#1", "L2382#2")
av6.c.2 = c("VGlut-F-100257", "VGlut-F-200375")
av6.c.3 = c("Cha-F-200454")
av6.c = c(av6.c.1,av6.c.2,av6.c.3)
av6.d.1 = c("Cha-F-100427","Cha-F-600105", "Cha-F-700262","Gad1-F-100097","Gad1-F-200174")
av6.d.2 = "Gad1-F-600096"
av6.d = c(av6.d.1,av6.d.2)
av6.e=av6.e.1 = c("Gad1-F-400255","Gad1-F-800107")
av6.f = av6.f.1 = "VGlut-F-200015"
av6.g = av6.g.1 = "Cha-F-700236"
av6.h = av6.h.1 = "Cha-F-400277"
av6.i = av6.i.1 = "Gad1-F-500030"

# Assign cell types
df[av6.a.1,]$cell.type = "av6a1"
df[av6.a.2,]$cell.type = "av6a2"
df[av6.b.1,]$cell.type = "av6b1"
df[av6.c.1,]$cell.type = "av6c1"
df[av6.c.2,]$cell.type = "av6c2"
df[av6.c.3,]$cell.type = "av6c3"
df[av6.d.1,]$cell.type = "av6d1"
df[av6.d.2,]$cell.type = "av6d2"
df[av6.e.1,]$cell.type = "av6e1"
df[av6.f.1,]$cell.type = "av6f1"
df[av6.g.1,]$cell.type = "av6g1"
df[av6.h.1,]$cell.type = "av6h1"
df[av6.i.1,]$cell.type = "av6i1"




###### PNT AV2 ######





### AV2
av2 = c("Gad1-F-100264","Gad1-F-800214", "Gad1-F-000096", "Gad1-F-500321", "Cha-F-000048",
        "Cha-F-500105", "Gad1-F-000240", "Gad1-F-600244", "fru-F-200126",
        "5HT1A-F-300031","fru-M-300456", "Gad1-F-300310","CL125R_87B06",
        "Cha-F-600183", "Cha-F-700299", "Gad1-F-700003","Gad1-F-800100",
        "Gad1-F-300218", "Gad1-F-600189", "fru-F-300169",
        "Gad1-F-600005", "Gad1-F-400156", "Cha-F-300136", "Cha-F-200034",
        "Cha-F-100444", "Cha-F-400280","Gad1-F-600114","Gad1-F-000298"
        ,"Cha-F-500135","Gad1-F-900160",
        "Gad1-F-000153","VGlut-F-200260","Gad1-F-200431","Cha-F-600061")
av2.a.1 = c("Gad1-F-800214","Gad1-F-600244","L629#1", "L629#2", "L629#5", "L629#3", "L629#4")
av2.a.2 = c("Cha-F-500105","Gad1-F-000096","L1385#16", "L876#6", "L876#2", "L876#5", "L876#1", "L876#3","Gad1-F-800100")
av2.a.3 = c("Gad1-F-000240","Cha-F-000048","fru-F-200126","Gad1-F-000298","L907#1")
av2.a.4 = c("L629#6", "L629#8")
av2.a=c(av2.a.1,av2.a.2,av2.a.3,av2.a.4)
av2.b.1 =  c("Cha-F-200034", "Cha-F-600183", "Cha-F-100444",
             "fru-F-300169","Cha-F-300136","Gad1-F-300310","L2087#2", "L2087#3", "L2088#1", "L2088#2", "L2088#3")
av2.b.2 = c("fru-M-300456","Gad1-F-300218","L2087#1","L2087#4")
av2.b.3 = c("5HT1A-F-300031", "Gad1-F-600005")
av2.b.4 = c("Gad1-F-700003")
av2.b.5 = c("Gad1-F-600189")
av2.b=c(av2.b.1,av2.b.2,av2.b.3,av2.b.4,av2.b.5 ) # different pnt? compare to neuroblast
av2.c.1 = c("Gad1-F-400156","Cha-F-400280","Cha-F-700299") # different pnt? (same as av2d)
av2.c = c(av2.c.1)
av2.d= av2.d.1 = "Gad1-F-500321"
av2.e = av2.e.1 = "Gad1-F-600114"
av2.f = av2.f.1 = c("Gad1-F-900160")
av2.g = av2.g.1 = "Cha-F-500135"
av2.h = av2.h.1 = "Gad1-F-000153"
av2.i = av2.i.1 = "VGlut-F-200260"
av2.j = av2.j.1 = "Gad1-F-100264" # dont use missregistration or different pnt probably the first
av2.k = av2.k.1 = "Gad1-F-200431"  # dont use
av2.l = av2.l.1 ="Cha-F-600061" # Dont plot
av2.m = av2.m.1 ="CL125R_87B06"

# Assign cell types
df[av2.a.1,]$cell.type = "av2a1"
df[av2.a.2,]$cell.type = "av2a2"
df[av2.a.3,]$cell.type = "av2a3"
df[av2.a.4,]$cell.type = "av2a4"
df[av2.b.1,]$cell.type = "av2b1"
df[av2.b.2,]$cell.type = "av2b2"
df[av2.b.3,]$cell.type = "av2b3"
df[av2.b.4,]$cell.type = "av2b4"
df[av2.b.5,]$cell.type = "av2b5"
df[av2.c.1,]$cell.type = "av2c1"
df[av2.d.1,]$cell.type = "av2d1"
df[av2.e.1,]$cell.type = "av2e1"
df[av2.f.1,]$cell.type = "av2f1"
df[av2.g.1,]$cell.type = "av2g1"
df[av2.h.1,]$cell.type = "av2h1"
df[av2.i.1,]$cell.type = "av2i1"
df[av2.j.1,]$cell.type = "av2j1"
df[av2.k.1,]$cell.type = "av2k1"
df[av2.l.1,]$cell.type = "av2l1"
df[av2.m.1,]$cell.type = "av2m1"




###### PNT AV1 ######





### AV1
av1 = c("Gad1-F-900217", "Gad1-F-800191", "Gad1-F-800137", "Gad1-F-700243",
        "Gad1-F-700100", "Gad1-F-600303", "Gad1-F-600174", "Gad1-F-500318",
        "Gad1-F-200387", "Cha-F-100370", "Cha-F-300352", "Cha-F-300357",
        "Cha-F-200351", "Cha-F-000347", "VGlut-F-400535", "VGlut-F-500378",
        "VGlut-F-700213", "VGlut-F-700266", "VGlut-F-600516", "VGlut-F-600598",
        "VGlut-F-500744", "VGlut-F-600713", "VGlut-F-600072", "VGlut-F-000366",
        "VGlut-F-600109", "VGlut-F-400166", "fru-M-100125", "Gad1-F-900205",
        "Gad1-F-600204", "Gad1-F-500105", "Gad1-F-200223", "5HT1A-F-800019",
        "Cha-F-400286", "Cha-F-700271", "Cha-F-800066", "fru-F-400357",
        "Cha-F-500001", "Cha-F-700112", "Cha-F-200201", "VGlut-F-300442",
        "VGlut-F-600228", "VGlut-F-500507", "VGlut-F-700284", "VGlut-F-500603",
        "VGlut-F-600739", "VGlut-F-600773", "VGlut-F-900129", "VGlut-F-700565",
        "VGlut-F-500847", "VGlut-F-200257", "VGlut-F-600059", "VGlut-F-600064",
        "VGlut-F-700009", "VGlut-F-600069", "VGlut-F-600078", "VGlut-F-600081",
        "VGlut-F-100009", "VGlut-F-500255", "VGlut-F-500269", "VGlut-F-500113",
        "VGlut-F-400241", "fru-F-600103", "Gad1-F-300038", "fru-M-600094")
av1.a.1 = c("Gad1-F-200387", "Gad1-F-800137", "Cha-F-700271", "VGlut-F-600069",
            "VGlut-F-500603", "VGlut-F-500744", "VGlut-F-600228", "VGlut-F-600516",
            "Cha-F-300357", "VGlut-F-700213", "VGlut-F-500378", "VGlut-F-500113",
            "VGlut-F-400535", "VGlut-F-500847", "VGlut-F-500255", "VGlut-F-500269",
            "VGlut-F-000366", "Gad1-F-600174", "Gad1-F-500105", "Cha-F-200201","L1989#4","L1990#4", "L1990#5",
            "L1990#8", "L1990#6", "L1990#7", "L1989#2", "L1989#1", "L1989#3", "L1990#3", "L1990#1", "L1990#2")
av1.a.2 = c("VGlut-F-500507","VGlut-F-700284", "VGlut-F-600598", "VGlut-F-600078", "VGlut-F-100009",
            "VGlut-F-400241", "Cha-F-100370","VGlut-F-700009", "VGlut-F-700266", "VGlut-F-600109", "Gad1-F-700100",
            "Gad1-F-700243", "VGlut-F-600072", "Gad1-F-800191", "fru-F-400357","fru-M-100125","Gad1-F-900205")
av1.a.3 = c("Gad1-F-600204","Gad1-F-500318",
            "VGlut-F-700565","5HT1A-F-800019","VGlut-F-600773","VGlut-F-600739","VGlut-F-600064","Cha-F-300352","Cha-F-200351",
            "Gad1-F-600303","Cha-F-800066","Gad1-F-900217","Cha-F-500001","fru-M-600094")
av1.a.4 = c("VGlut-F-600713","VGlut-F-900129","VGlut-F-600081")
av1.a.5 =c("Gad1-F-200223","fru-F-600103","Gad1-F-300038")
av1.a=c(av1.a.1,av1.a.2,av1.a.3,av1.a.4,av1.a.5)
av1.b = av1.b.1 = c("VGlut-F-400166","VGlut-F-300442","VGlut-F-200257","VGlut-F-600059")
av1.c = av1.c.1 = c("Cha-F-400286")
av1.d = av1.d.1 = c("Cha-F-700112")
av1.e = av1.e.1 = "Cha-F-000347"

# Assign cell types
df[av1.a.1,]$cell.type = "av1a1"
df[av1.a.2,]$cell.type = "av1a2"
df[av1.a.3,]$cell.type = "av1a3"
df[av1.a.4,]$cell.type = "av1a4"
df[av1.a.5,]$cell.type = "av1a5"
df[av1.b.1,]$cell.type = "av1b1"
df[av1.b.1,]$cell.type = "av1b1"
df[av1.c.1,]$cell.type = "av1c1"
df[av1.d.1,]$cell.type = "av1d1"
df[av1.e.1,]$cell.type = "av1e1"




###### PNT AD5 ######






### AD5
ad5 = "VGlut-F-200459"
ad5.a = ad5.a.1 = c("VGlut-F-200459") # This its own tract, reshuffle
# Assign cell types
df[ad5.a.1,]$cell.type = "ad5a1"





###### PNT AD4 ######





### AD4
ad4 = "fru-M-400351"
ad4.a = ad4.a.1 = c("fru-M-400351") # This its own tract, reshuffle
# Assign cell types
df[ad4.a.1,]$cell.type = "ad4a1"





###### PNT AD3 ######






### AD3
ad3 = c("Gad1-F-000108", "Cha-F-000533", "Cha-F-100001","Gad1-F-100124","Gad1-F-700066")
ad3.a = ad3.a.1 = "Gad1-F-000108"
ad3.b = ad3.b.1 = c("Cha-F-000533","L1828#1","L19#1", "L20#1", "L304#1")
ad3.c = ad3.c.1 = c("Cha-F-100001")
ad3.d = ad3.d.1 = "Gad1-F-100124"
ad3.e = ad3.e.1 = "Gad1-F-700066"

# Assign cell types
df[ad3.a.1,]$cell.type = "ad3a1"
df[ad3.b.1,]$cell.type = "ad3b1"
df[ad3.c.1,]$cell.type = "ad3c1"
df[ad3.d.1,]$cell.type = "ad3d1"
df[ad3.e.1,]$cell.type = "ad3e1"




###### PNT AD2 ######





### AD2
ad2 = c("fru-M-600162", "fru-F-500184", "fru-F-400325",
        "fru-F-400420", "fru-F-400067", "fru-M-400340", "fru-M-500191",
        "fru-F-500117", "fru-M-700010", "fru-M-500103","fru-F-700078","Cha-F-200386")
ad2.a.1 = c("fru-M-500103","fru-M-400340","fru-M-500191","fru-M-700010","fru-M-600162")
ad2.a.2 = "fru-M-600162"
ad2.a = c(ad2.a.1,ad2.a.2)
ad2.b = ad2.b.1 = c("fru-F-500184","fru-F-500117","fru-F-400067","fru-F-700078")
ad2.c = ad2.c.1 = c("fru-F-400325","fru-F-400420")
ad2.d = ad2.d.1 = "Cha-F-200386"
# Ad2e1 in Paavo's EM data

# Assign cell types
df[ad2.a.1,]$cell.type = "ad2a1"
df[ad2.a.2,]$cell.type = "ad2a2"
df[ad2.b.1,]$cell.type  = "ad2b1"
df[ad2.c.1,]$cell.type  = "ad2c1"
df[ad2.d.1,]$cell.type  = "ad2d1"





###### PNT AD1 ######





### AD1
ad1 = c("Cha-F-400246", "Cha-F-000258", "Gad1-F-900037", "fru-M-200239",
        "Gad1-F-300229", "VGlut-F-200392", "fru-F-300009", "fru-F-200156",
        "Cha-F-200360", "Gad1-F-700032", "Gad1-F-400233", "Gad1-F-200039",
        "Cha-F-100223", "Gad1-F-200247", "VGlut-F-400267",
        "Gad1-F-300262", "Gad1-F-500014", "Gad1-F-700076", "Gad1-F-200365",
        "VGlut-F-400170", "Gad1-F-400257", "Gad1-F-000249", "VGlut-F-400863",
        "VGlut-F-700522", "VGlut-F-500156", "VGlut-F-200319", "Cha-F-300272",
        "Cha-F-300384",
        "Gad1-F-600330","VGlut-F-800061","VGlut-F-600424","120704c1",
        "120726c3", "120730c0", "120813c1","Cha-F-700185",
        "120816c1", "120830c2", "120911c0", "120913c1", "120925c1", "121101c0",
        "121122c1", "121127c1", "121128c3", "121129c0", "121206c0", "130123c1",
        "130523c0", "130524c0", "130726c1", "130802c0", "130910c0",
        "140402c0", "140403c1", "140514c1", "140612c0", "140616c0","130711c3","120714c4",
        "130729c0", "130801c1","130731c1","Gad1-F-400155", "VGlut-F-500032", "Gad1-F-200033", "fru-M-300364")
ad1.a.1 = c("130123c1","130523c0", "130524c0","Cha-F-000258", "L1740#3", "L1740#7", "L1740#8", "L1740#11","L1740#2","L1739#1")
ad1.a.2 = c("VGlut-F-400170", "Cha-F-400246","140402c0", "140403c1","Gad1-F-400257", "121206c0", "L1812#1",
            "L1812#2","L1721#1","L1721#2", "L1721#3")
ad1.a.3 = c("Cha-F-100223", "VGlut-F-200319","Cha-F-300272","VGlut-F-400267","VGlut-F-600424","VGlut-F-700522") # Aspis in the EM
ad1.a.4 = c("120925c1", "121127c1", "121122c1", "121128c3")
ad1.a.5 = "Gad1-F-700076"
ad1.a.6 = "Cha-F-300384"
ad1.a.7= "Gad1-F-400155"
ad1.a.8 = "VGlut-F-800061"
ad1.a = c(ad1.a.1,ad1.a.2,ad1.a.3,ad1.a.4,ad1.a.5,ad1.a.6,ad1.a.7,ad1.a.8)
ad1.b.1 = c("130726c1", "130731c1", "130802c0", "130801c1","130729c0","120816c1",
            "120813c1", "120911c0", "120726c3", "130910c0", "140514c1", "121101c0")
ad1.b.2 = c("120704c1", "120730c0", "140616c0","140612c0","120714c4","Gad1-F-900037", "Gad1-F-200039","L1539#5", "L1539#7", "Gad1-F-200039",
            "L1539#3", "L1539#10", "L1539#8", "L1539#9","L1539#6","L2278#5", "L2278#6", "L1539#1", "L2278#1", "L2278#2", "L2278#3","L2278#4","L1539#4")
# ad1.b.3 in Wilson data
ad1.b = c(ad1.b.1,ad1.b.2)

ad1.c.1=c("Gad1-F-600330", "Gad1-F-400233", "120830c2",  "121129c0", "130711c3", "120913c1")
ad1.c.2=c("L494#1", "L494#2","L475#1", "L475#2","Gad1-F-300262","Gad1-F-500014")
ad1.c=c(ad1.c.1,ad1.c.2)

ad1.d = ad1.d.1 = c("L2446#1", "L2446#2")

ad1.e.1 = c("Gad1-F-300229","Cha-F-200360","fru-F-300009","Gad1-F-200365","L1614#1","L1827#3")
ad1.e.2 = c("Gad1-F-700032","fru-F-200156")
ad1.e.3 = "Gad1-F-000249"
ad1.e.4 = c("Gad1-F-200033","Cha-F-700185")
ad1.e = c(ad1.e.1,ad1.e.2,ad1.e.3,ad1.e.4)

ad1.f = ad1.f.1 = c("VGlut-F-500032","VGlut-F-400863","L1740#4")
ad1.g.1 = c("fru-M-300364","fru-M-200239")
ad1.g.2=c("131204c1")
ad1.g=c(ad1.g.1,ad1.g.2)
ad1.h = ad1.h.1 =  "VGlut-F-200392"
ad1.i = ad1.i.1 = "VGlut-F-500156"
ad1.j = ad1.j.1 = "Gad1-F-200247"

df[ad1.a.1,]$cell.type = "ad1a1"
df[ad1.a.2,]$cell.type = "ad1a2"
df[ad1.a.3,]$cell.type = "ad1a3"
df[ad1.a.4,]$cell.type = "ad1a4"
df[ad1.a.5,]$cell.type = "ad1a5"
df[ad1.a.6,]$cell.type = "ad1a6"
df[ad1.a.7,]$cell.type = "ad1a7"
df[ad1.a.8,]$cell.type = "ad1a8"
df[ad1.b.1,]$cell.type = "ad1b1"
df[ad1.b.2,]$cell.type = "ad1b2"
df[ad1.c.1,]$cell.type = "ad1c1"
df[ad1.c.2,]$cell.type = "ad1c2"
df[ad1.d.1,]$cell.type = "ad1d1"
df[ad1.e.1,]$cell.type = "ad1e1"
df[ad1.e.2,]$cell.type = "ad1e2"
df[ad1.e.3,]$cell.type = "ad1e3"
df[ad1.e.4,]$cell.type = "ad1e4"
df[ad1.f.1,]$cell.type= "ad1f1"
df[ad1.g.2,]$cell.type = "ad1g2"
df[ad1.g.1,]$cell.type = "ad1g1"
df[ad1.h.1,]$cell.type = "ad1h1"
df[ad1.i.1,]$cell.type = "ad1i1"
df[ad1.j.1,]$cell.type = "ad1j1"


###### Assign LHLNs and LHONs ######



lh.output.neurons = c("ad1a2", "ad1a1",  "ad1a3", "ad1a4", "ad1a5", "ad1a6",
                      "ad1a7", "ad1a8",  "ad1b1", "ad1b2", "ad1c1", "ad1c2",
                      "ad1c3", "ad1c4", "ad1d1", "ad1e1", "ad1e2", "ad1e3", "ad1e4",
                      "ad1g2", "ad1f1", "ad1g1", "ad1h1", "ad1i1", "ad1j1", "ad2a1", "ad2a2",
                      "ad2b1", "ad2c1", "ad2d1", "ad3a1", "ad3b1", "ad3c1", "ad3d1", "ad4a1",
                      "ad5a1", "av1a1", "av1a2", "av1a3", "av1a4", "av1a5", "av1c1",
                      "av1d1", "av1e1", "av2a1", "av2a2", "av2a3", "av2a4", "av2b1",
                      "av2b2", "av2b3", "av2b4", "av2b5", "av2c1", "av2d1", "av2e1",
                      "av2f1", "av2g1", "av2h1", "av2i1", "av2j1", "av2k1", "av2l1",
                      "av2m1", "av3a1", "av3a2", "av3b1", "av3c1", "av3d1", "av4b1",
                      "av4b2", "av4b3", "av4b4", "av4b5", "av4b6",
                      "av4b7", "av4b8", "av4b9", "av4c1", "av4c2", "av4c3","av4c4",
                      "av4d1", "av4e1", "av4f1", "av4g1", "av4h1", "av5f1", "av5a1",
                      "av5c1", "av5e1", "av6a1", "av6a2", "av6b1",  "av6c1",
                      "av6c2", "av6c3", "av6d1", "av6d2", "av6e1", "av6f1", "av6h1", "av6i1", "av7a1",
                      "av7b1", "av7c1",  "pd1a1", "pd2a1", "pd2a2", "pd2a3",
                      "pd2a4", "pd2a5", "pd2a6", "pd2b1", "pd2c1", "pd2c2", "pd2d1",
                      "pd2d2", "pd2e1", "pd2e2", "pd2f1", "pd2g1", "pd2h1", "pd2i1", "pd3b1", "pd3c1", "pd3d1","pd3e1", "pd4a1",
                      "pd4a2", "pd4a3", "pd4a4", "pd4b1", "pd4c1", "pd4c2", "pd4e1",
                      "pd4f1", "pd4g1", "pd4h1", "pd4i1", "pd5a1", "pd6a1", "pd6a2",
                      "pd6b1", "pd6c1", "pd6d1", "pd6e1", "pv11a1", "pv11a2", "pv12a1",
                      "pv1a1", "pv1b1", "pv1b2", "pv1b3", "pv1b4",
                      "pv1b5", "pv1c1", "pv1d1", "pv1e1", "pv1f1", "pv1g1", "pv1h1",
                      "pv1i1", "pv2b1", "pv2c1", "pv2d2", "pv2d3", "pv2d1", "pv2f1",
                      "pv2g1", "pv2h1", "pv2i1", "pv2j1", "pv2k1","pv3a1", "pv3a2",
                      "pv3b1", "pv3c1", "pv3d1", "pv3e1", "pv3f1", "pv4b1", "pv4b2",
                      "pv4b3", "pv4b4", "pv4b5", "pv4c1", "pv4c1", "pv4c3", "pv4c4",
                      "pv4c5", "pv4c6", "pv4d1", "pv4d1", "pv4d2", "pv4d3", "pv4d4",
                      "pv4d5", "pv4d6", "pv4e1", "pv4e2", "pv4e3",  "pv4f1",
                      "pv4g1", "pv4h1", "pv4i1", "pv4j1", "pv4k1",
                      "pv5a1", "pv5a2", "pv5a3", "pv5a4",  "pv5b1",'pv6a1',"pv6b1","pv6a2","pv6a3","pv6c1","pv6d2","pv6d1","pv6e1",
                      "pv5b2", "pv5b3", "pv5b4", "pv5b5", "pv5b6", "pv5c1", "pv5c2",
                      "pv5c3", "pv5c5", "pv5d1", "pv5d2", "pv5d3", "pv5e1", "pv5e2", "pv5e3", "pv5f1",
                      "pv5g1", "pv5g2", "pv5g3", "pv5h1", "pv5i1", "pv5j1", "pv5k1",
                      "pv7a1", "pv7b1", "pv8b1", "pv8c1", "pv9a1", "pv9b1",
                      "pv9c1", "pv9d1", "pv9d2", "pv10a1", "pv10b1", "pv10c1", "pv10c2",
                      "pv10d1", "pv10e1", "pv10f1", "pv10g1", "pv10h1", "pv10i1", "pv10j1", "pd7a1", "pd7b1")
lh.local.neurons = c("av1b1", "av4a1", "av4a10", "av4a2", "av4a3",
                     "av4a4", "av4a5", "av4a6", "av4a7",  "av5g1","pv2a3",
                     "av5b1", "av5d1", "av6g1", "pd3a1", "pd3a2", "pd3a3","pd4d1", "pv2a1",
                     "pv2a2", "pv2a4", "pv2e1",  "pv4a3", "pv4a1",
                     "pv4a10", "pv4a11", "pv4a12", "pv4a2", "pv4a2", "pv4a3",
                     "pv4a4", "pv4a5", "pv4a6", "pv4a7", "pv4a8", "pv4a9", "pv8a1", "pv4c2")
df[rownames(df)%in%notLH,]$type="notLH"
df[df$cell.type%in%lh.local.neurons,]$type="LN"
df[df$cell.type%in%lh.output.neurons,]$type="ON"
df[pv12.a,]$type="ON/IN"




#### Re-attach data frame ###



# Capitalise
df[,"cell.type"] = capitalise_cell_type_name(df[,"cell.type"])
df[,"pnt"] = process_lhn_name(df[,"cell.type"])$pnt
df[,"anatomy.group"] = process_lhn_name(df[,"cell.type"])$anatomy.group
notLH = c(notLH,badly.traced[!badly.traced%in%rownames(df,!is,.na(cell.type))])
df[notLH,]$pnt = df[notLH,]$anatomy.group = df[notLH,]$cell.type = df[notLH,]$type = "notLHproper"
df$sex[rownames(df)%in%c(names(md.mcfo),names(dye.fills))] = "F"
# Get core LHN designations
load('data-raw/Core_LHNs.rda')
df$mean.overlap = df$mean.dendritic.cable = df$mean.dendritic.cable.in.lh = df$proportion.dendritic.lh = df$skeleton.no = df$coreLH = NA
for(ct in df$cell.type){
  if(ct%in%corelhns$cell.type){
    row.in.cell.type = df$cell.type==ct
    row.in.cell.type[is.na(row.in.cell.type)] = FALSE
    df[row.in.cell.type,c("mean.overlap", "mean.dendritic.cable", "mean.dendritic.cable.in.lh", "proportion.dendritic.lh", "skeleton.no", "coreLH")] =
      subset(corelhns,cell.type==ct)[,c("mean.overlap", "mean.dendritic.cable", "mean.dendritic.cable.in.lh", "proportion.dendritic.lh", "skeleton.no", "coreLH")]
  }
}
# Assign some of the quirky ones
df[mb.c1,"anatomy.group"] = "MB-LH"
df[mb.c1,"pnt"] = "PV2"
# Order the data frame
df = df[,c("cell.type", "anatomy.group", "pnt",  "type", "skeleton.type", "id", "sex", "LH_side",
           "good.trace", "mean.overlap", "mean.dendritic.cable","mean.dendritic.cable.in.lh",
           "proportion.dendritic.lh", "skeleton.no","coreLH")]
# Attach the data frame
names_in_common=intersect(names(most.lhns), rownames(df))
most.lhns = most.lhns[names_in_common]
most.lhns[,]=df[names_in_common,]
most.lhns = most.lhns[!names(most.lhns)%in%names(most.lhins)] # Remove skeletons also in most.lhins
most.lhns = subset(most.lhns,skeleton.type!="FijiTrace"&!is.na(skeleton.type))


####################
# Update Meta-Data #
####################


most.lhns = as.neuronlistfh(most.lhns,dbdir = 'inst/extdata/data/', WriteObjects="missing")
most.lhns.dps = nat::dotprops(most.lhns,resample=1)
most.lhns.dps = as.neuronlistfh(most.lhns.dps,dbdir = 'inst/extdata/data/', WriteObjects="missing")


#####################
# Write neuronlistfh #
#####################


write.neuronlistfh(most.lhns, file='inst/extdata/most.lhns.rds',overwrite = TRUE)
write.neuronlistfh(most.lhns.dps, file='inst/extdata/most.lhns.dps.rds',overwrite = TRUE)



###########
# Old code #
###########


# s = pv4
# ss = "PV4"
# set = c(most.lhns[names(most.lhns)%in%unique(s)],subset(lh.mcfo,grepl(ss,cell.type)))
# set.dps = c(most.lhns.dps[s],subset(lh.mcfo.dps,grepl(ss,cell.type)))
# message(length(subset(lh.mcfo.dps,grepl(ss,cell.type))))
# nb = nblast_allbyall(set.dps)
# clust = nhclust(scoremat=nb)
# dkcs=colour_clusters(clust, h=0.75)
# g = 0;clear3d()
# g=g+1;message(g);clear3d();plot3d(FCWB);s=subset(clust,h=0.75, group=g);plot3d(set[s], soma=T,lwd=3);dput(s)
