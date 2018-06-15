# #################
# Process Raw Data #
###################
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
most.lhns= c(fc.lhns,dye.fills,JFRCSH_clusters.FCWB,JFRCSH.DS_clusters.FCWB,SF_clusters.FCWB)

# Prepare meta data frame
df = most.lhns[,c("id","sex","LH_side")]
df$id = names(most.lhns)
df$id[is.na(df$id)] = "dyefill"
df$pnt=NA
df$anatomy.group=NA
df$cell.type = NA
df$type = NA
df$coreLH= TRUE
df$good.trace = TRUE
df$dendritic.cable.in.lh = NA
df$dendritic.cable = NA




###### Bad Cells ######





badly.traced = c("5HT1A-F-200014", "Gad1-F-300266", "npf-F-000002", "VGlut-F-300400","Cha-F-200386",
                 "VGlut-F-900127", "VGlut-F-500145", "VGlut-F-500393",
                 "npf-F-300047", "npf-M-200017", "npf-M-300045",
                 "npf-M-300051", "Cha-F-800106", "fru-M-700211", "Gad1-F-500038",
                 "Gad1-F-200366", "Gad1-F-000381", "Gad1-F-000349", "fru-M-800040",
                 "fru-F-600043", "5HT1A-F-800008", "Cha-F-200378", "Cha-F-300146",
                 "Cha-F-400324", "VGlut-F-500032", "Cha-F-000395", "Cha-F-000515",
                 "Cha-F-800134", "Gad1-F-000101", "Cha-F-200357", "VGlut-F-500253","Gad1-F-200431", "Gad1-F-100264", "Cha-F-100357", "Cha-F-600061","VGlut-F-500148",
                 "fru-F-500093", "Cha-F-400240",
                 "Cha-F-00048","fru-M-100206")
df[names(c(JFRCSH_clusters.FCWB,JFRCSH.DS_clusters.FCWB,SF_clusters.FCWB)),]$good.trace = FALSE
df[badly.traced,]$good.trace = FALSE


###### Not LH proper ######





notLH = c("5HT1A-F-100016", "5HT1A-F-300001", "5HT1A-F-300035", "5HT1A-M-300003",
         "5HT1A-M-400013", "5HT1A-M-400022", "5HT1A-M-500012", "5HT1A-M-800011",
         "Cha-F-000152", "Cha-F-000428", "Cha-F-000432", "Cha-F-000452",
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
         "VGlut-F-700413", "VGlut-F-900053")
df[unique(notLH),]$pnt = df[notLH,]$anatomy.group = df[notLH,]$cell.type = df[notLH,]$type = "notLHproper"





###### PNT pv7 ######






pv7 = c("Cha-F-800039", "Gad1-F-200219")
df[unique(pv7),]$pnt = "pv7"
pv7.a = "Cha-F-800039"
pv7.a.1 = "Cha-F-800039"
pv7.b  = "Gad1-F-200219"
pv7.b.1 = "Gad1-F-200219"
df[pv7.a,]$anatomy.group = "pv7a"
df[pv7.b,]$anatomy.group = "pv7b"
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
df[unique(pv9),]$pnt = "pv9"
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
df[pv9.a,]$anatomy.group = "pv9a"
df[pv9.b,]$anatomy.group = "pv9b"
df[pv9.c,]$anatomy.group = "pv9c"
df[pv9.d,]$anatomy.group = "pv9d"
df[pv9.a.1,]$cell.type = "pv9a1"
df[pv9.b.1,]$cell.type = "pv9b1"
df[pv9.c.1,]$cell.type = "pv9c1"
df[pv9.d.1,]$cell.type = "pv9d1"
df[pv9.d.2,]$cell.type = "pv9d2"





###### PNT pv8 ######





### pv8
pv8 = c("Gad1-F-700084", "VGlut-F-000090","fru-M-400051")
df[unique(pv8),]$pnt = "pv8"
pv8.a  = pv8.a.1 = "Gad1-F-700084" # Remove? Badly traced. Soma uncertain.
pv8.b = pv8.b.1 = "fru-M-400051"
pv8.c = pv8.c.1 = "VGlut-F-000090" #dont plot
df[pv8.a,]$anatomy.group = "pv8a"
df[pv8.b,]$anatomy.group = "pv8b"
df[pv8.c,]$anatomy.group = "pv8c"
df[pv8.a.1,]$cell.type = "pv8a1"
df[pv8.b.1,]$cell.type = "pv8b1"
df[pv8.c.1,]$cell.type = "pv8c1"





###### PNT pv12 ######






### pv12
pv12 =  "Gad1-F-600202"
df[unique(pv12),]$pnt = "pv12"
pv12.a = pv12.a.1 = "Gad1-F-600202"
df[pv12.a,]$anatomy.group = "pv12a"
df[pv12.a.1,]$cell.type = "pv12a1"





###### PNT pv11 ######






### pv11
pv11 = c("Trh-M-400128","Gad1-F-600210")
df[unique(pv11),]$pnt = "pv11"
pv11.a=c("Trh-M-400128","Gad1-F-600210")
pv11.a.1 = "Trh-M-400128"
pv11.a.2 = "Gad1-F-600210"
df[pv11.a,]$anatomy.group = "pv11a"
df[pv11.a.1,]$cell.type = "pv11a1"
df[pv11.a.2,]$cell.type = "pv11a2"





###### PNT PD7 ######





### pd7
pd7 = c("fru-F-400364", "fru-F-400339")
df[unique(pd7),]$pnt = "pd7"
pd7.a = pd7.a.1 = "fru-F-400364"
pd7.b = pd7.b.1 ="fru-F-400339"

df[pd7.a,]$anatomy.group = "pd7a"
df[pd7.b,]$anatomy.group = "pd7b"
df[pd7.a.1,]$anatomy.group = "pd7a1"
df[pd7.b.1,]$anatomy.group = "pd7b1"





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
df[unique(pv10),]$pnt = "pv10"
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
df[pv10.a,]$anatomy.group = "pv10a"
df[pv10.b,]$anatomy.group = "pv10b"
df[pv10.c,]$anatomy.group = "pv10c"
df[pv10.d,]$anatomy.group = "pv10d"
df[pv10.e,]$anatomy.group = "pv10e"
df[pv10.f,]$anatomy.group = "pv10f"
df[pv10.g,]$anatomy.group = "pv10g"
df[pv10.h,]$anatomy.group = "pv10h"
df[pv10.i,]$anatomy.group = "pv10i"
df[pv10.j,]$anatomy.group = "pv10j"
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





###### PNT PV5 ######





### PV5
pv5 = c("Gad1-F-000349","Cha-F-400324","Gad1-F-200177","E0585-F-300073","Gad1-F-900137", "Gad1-F-900098", "Gad1-F-800215", "Gad1-F-700139",
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
df[unique(pv5),]$pnt = "pv5"
pv5.a.1 = c("Cha-F-400324","Gad1-F-500180", "Cha-F-200402", "Gad1-F-500244","Cha-F-800011","Gad1-F-100093", "Gad1-F-200403", "Gad1-F-100247", "Gad1-F-400335",
            "Gad1-F-000338", "Gad1-F-400226", "Cha-F-000427", "Gad1-F-200289",
            "Gad1-F-400275", "Cha-F-500187", "Cha-F-300241", "Gad1-F-300298",
            "Gad1-F-100322", "Gad1-F-900137", "Gad1-F-100357",
            "120914c0","120813c0","120712c1",
            "120628c1","120708c1")
pv5.a.2 = c("Cha-F-100457", "Gad1-F-300184", "Cha-F-400179", "Gad1-F-400304",
            "Gad1-F-200199", "Cha-F-100394", "Gad1-F-600214", "Gad1-F-200220")
pv5.a.3 = c("VGlut-F-400058", "Gad1-F-100099","120216c0",
            "120619c1","120710c0","130118c0")
pv5.a.4 = c("Gad1-F-700139","Gad1-F-000349","Cha-F-500250","Cha-F-700211")
pv5.a.5 = c("Gad1-F-100091","Cha-F-500138")
pv5.a= c(pv5.a.1,pv5.a.2,pv5.a.3,pv5.a.4,pv5.a.5)
pv5.b.1=c("Gad1-F-000155", "E0585-F-400002", "Cha-F-100083", "Gad1-F-100023",
          "E0585-F-300073", "120618c0","120605c0", "131118c3", "160121c1", "Cha-F-200082",
          "Cha-F-300204", "Cha-F-200169", "Cha-F-800045", "Gad1-F-900098",
          "Gad1-F-300321")
pv5.b.2 = c("121130c0", "Cha-F-700258", "E0585-F-300063", "130213c0",
            "E0585-F-300066","E0585-F-300064","E0585-F-400029","130214c1",
            "E0585-F-400003","E0585-F-400021","Cha-F-100264","130425c1")
pv5.b.3 = c("E0585-F-700001", "E0585-F-800004", "E0585-F-400015",
            "E0585-F-800001", "E0585-F-500010", "Cha-F-200204", "Cha-F-300342")
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
          "130717c0","130814c0","130710c3","Cha-F-700170","E0585-F-400025", "E0585-F-400005", "E0585-F-400008","E0585-F-400013",
          "Gad1-F-200255","E0585-F-400011","130208c1","130711c1","130816c2")
pv5.c.2 = c("E0585-F-500009", "Gad1-F-000125", "E0585-F-400009", "Cha-F-100068", "130220c1", "130313c1","130605c1","130704c2","130710c3",
            "E0585-F-400018", "Cha-F-100141", "E0585-F-300050", "Gad1-F-300155",
            "E0585-F-300058", "121212c0", "130606c1", "Cha-F-300025", "E0585-F-300069", "121213c0","121227c2")
pv5.c.3 = c("121217c0", "130211c3","130617c3","131126c3", "131204c0", "131212c0")
pv5.c=c(pv5.c.2,pv5.c.1,pv5.c.3)
pv5.d.1 =c("Gad1-F-800215","Gad1-F-300163","E0585-F-600002" )
pv5.d.2 = c("Gad1-F-200362")
pv5.d.3=c("Gad1-F-000393")
pv5.d = c(pv5.d.1,pv5.d.2,pv5.d.3)
pv5.e.1 = c("TH-M-300021","TH-M-200014") #PPL1-a'3
pv5.e.2 = c("TH-M-100016", "TH-M-000023")
pv5.e.3 = "Gad1-F-400166"
pv5.e = c(pv5.e.1,pv5.e.2,pv5.e.3)
pv5.f = pv5.f.1 = c("Gad1-F-300243", "E0585-F-500000", "E0585-F-500001","Gad1-F-400162")
pv5.g.1 = "Gad1-F-200177"
pv5.g.2 ="Gad1-F-300312"
pv5.g.3 = c("Cha-F-100398","Gad1-F-700165")
pv5.g=c(pv5.g.1,pv5.g.2,pv5.g.3) #3E
pv5.h = pv5.h.1 = c("E0585-F-400028","E0585-F-700002")
pv5.i = pv5.i.1 = "fru-M-200172" # check other pnts
pv5.j = pv5.j.1 = "Gad1-F-100211"
pv5.k = pv5.k.1 = c("Gad1-F-300290")
pv5.l = pv5.l.1 = "Cha-F-400240"
df[pv5.a,]$anatomy.group = "pv5a"
df[pv5.b,]$anatomy.group = "pv5b"
df[pv5.c,]$anatomy.group = "pv5c"
df[pv5.d,]$anatomy.group = "pv5d"
df[pv5.e,]$anatomy.group = "pv5e"
df[pv5.f,]$anatomy.group = "pv5f"
df[pv5.g,]$anatomy.group = "pv5g"
df[pv5.h,]$anatomy.group = "pv5h"
df[pv5.i,]$anatomy.group = "pv5i"
df[pv5.j,]$anatomy.group = "pv5j"
df[pv5.k,]$anatomy.group = "pv5k"
df[pv5.l,]$anatomy.group = "pv5l"



df[pv5.a.1,]$cell.type = "pv5a1"
df[pv5.a.2,]$cell.type = "pv5a2"
df[pv5.a.3,]$cell.type = "pv5a3"
df[pv5.a.4,]$cell.type = "pv5a4"
df[pv5.a.5,]$cell.type = "pv5a5"
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
df[pv5.e.2,]$cell.type = "pv5e1" #PPl1-a'3?
df[pv5.e.3,]$cell.type = "pv5e1" #PPl1-a'3?
df[pv5.f.1,]$cell.type = "pv5f1"
df[pv5.g.1,]$cell.type = "pv5g1"
df[pv5.g.2,]$cell.type = "pv5g2"
df[pv5.g.3,]$cell.type = "pv5g3"
df[pv5.h.1,]$cell.type = "pv5h1"
df[pv5.i.1,]$cell.type = "pv5i1"
df[pv5.j.1,]$cell.type = "pv5j1"
df[pv5.k.1,]$cell.type = "pv5k1"
df[pv5.l.1,]$cell.type = "pv5l1"





###### PNT PV3 ######



### pv3
pv3  = c("Gad1-F-700071", "Gad1-F-300161", "5HT1A-M-300003", "Gad1-F-500252","Cha-F-700277","CL123R_70G02", "Cha-F-000350","Gad1-F-600301","Gad1-F-000101")
df[unique(pv3),]$pnt = "pv3"
pv3.a.1 = c("Gad1-F-300161","Gad1-F-000101","CL123R_70G02")
pv3.a.2 = c("Gad1-F-600301")
pv3.a=c(pv3.a.1,pv3.a.2)
pv3.b = pv3.b.1 = "Gad1-F-500252"
pv3.c = pv3.c.1 = c("Cha-F-000350")
pv3.d = pv3.d.1 = c("Cha-F-700277","Cha-F-100320")
pv3.e = pv3.e.1 = "5HT1A-M-300003"
pv3.f = pv3.f.1 = "Gad1-F-700071"




df[pv3.a,]$anatomy.group = "pv3a"
df[pv3.b,]$anatomy.group = "pv3b"
df[pv3.c,]$anatomy.group = "pv3c"
df[pv3.d,]$anatomy.group = "pv3d"
df[pv3.e,]$anatomy.group = "pv3e"
df[pv3.f,]$anatomy.group = "pv3f"
df[pv3.a.1,]$cell.type = "pv3a1"
df[pv3.a.2,]$cell.type = "pv3a2"
df[pv3.b.1,]$cell.type = "pv3b1"
df[pv3.c.1,]$cell.type = "pv3c1"
df[pv3.d.1,]$cell.type = "pv3d1"
df[pv3.e.1,]$cell.type = "pv3e1"
df[pv3.f.1,]$cell.type = "pv3f1"





###### PNT PV4 ######





### pv4
c("130205c2", "130219c0", "130312c1", "130408c0", "130411c2",
  "130619c0", "130625c0", "130627c0", "130703c0", "130704c1", "130724c0",
  "130821c0", "130826c0", "130829c0", "130829c1", "130911c0", "130911c2",
  "130912c0", "130912c1", "130913c0", "130923c0", "130925c2", "131212c1",
  "140117c2", "140206c2", "140207c0", "140211c0", "140212c0", "5HT1A-F-300030",
  "5HT1A-F-300034", "Cha-F-000485", "Cha-F-000507", "Cha-F-100028",
  "Cha-F-100221", "Cha-F-100278", "Cha-F-100412", "Cha-F-100456",
  "Cha-F-200398", "Cha-F-300186", "Cha-F-300212", "Cha-F-300221",
  "Cha-F-400138", "Cha-F-400318", "Cha-F-500234", "Cha-F-500298",
  "Cha-F-500303", "Cha-F-600207", "Cha-F-600209", "Cha-F-600226",
  "Cha-F-600226", "Cha-F-600243", "Cha-F-600269", "Cha-F-700255",
  "Cha-F-800106", "Cha-F-800134", "Cha-F-900046", "CL100R_26C12",
  "CL29GR_JRC_IS23354-000.swc", "CL97R_26C12", "CL98R_26G09", "E0585-F-300056",
  "fru-F-100052", "fru-F-400011", "fru-F-400180", "fru-F-400219",
  "fru-F-500177", "fru-F-500479", "fru-M-200253", "fru-M-200351",
  "fru-M-500368", "Gad1-F-000201", "Gad1-F-000274", "Gad1-F-000381",
  "Gad1-F-100132", "Gad1-F-100154", "Gad1-F-100178", "Gad1-F-100338",
  "Gad1-F-100345", "Gad1-F-200322", "Gad1-F-200395", "Gad1-F-300135",
  "Gad1-F-300148", "Gad1-F-400027", "Gad1-F-400124", "Gad1-F-500023",
  "Gad1-F-500038", "Gad1-F-500171", "Gad1-F-500178", "Gad1-F-500281",
  "Gad1-F-500338", "Gad1-F-600125", "Gad1-F-600205", "Gad1-F-600205",
  "Gad1-F-600252", "Gad1-F-700108", "Gad1-F-700258", "Trh-F-000048",
  "VGlut-F-000390", "VGlut-F-200590", "VGlut-F-300393", "VGlut-F-300574",
  "VGlut-F-400084", "VGlut-F-400195", "VGlut-F-400240", "VGlut-F-400394",
  "VGlut-F-500046", "VGlut-F-500243", "VGlut-F-500253", "VGlut-F-500323",
  "VGlut-F-500399", "VGlut-F-500399", "VGlut-F-500411", "VGlut-F-500419",
  "VGlut-F-500442", "VGlut-F-500444", "VGlut-F-500445", "VGlut-F-600030",
  "VGlut-F-600075", "VGlut-F-600090", "VGlut-F-600311", "VGlut-F-600752",
  "VGlut-F-600764", "VGlut-F-700001", "VGlut-F-700084", "VGlut-F-700260",
  "VGlut-F-700280", "VGlut-F-700342", "VGlut-F-700430", "VGlut-F-700436",
  "VGlut-F-700503", "VGlut-F-700602", "VGlut-F-800064", "VGlut-F-800068",
  "VGlut-F-800074", "VGlut-F-900028")
df[unique(pv4),]$pnt = "pv4"
pv4.a.1 = c("fru-F-500177","fru-F-400219","fru-F-500479","fru-F-400011")# No branch type
pv4.a.2 = c("130625c0","130619c0","Cha-F-500234","fru-M-500368") # Physiology 39
pv4.a.3 = c("130408c0","130411c2","Gad1-F-000381","Cha-F-100412") # Physiology 26. Not front arc.
pv4.a.4 = c("130724c0","130219c0","130703c0","VGlut-F-600752") # Physiology 25. Plunging axon. Split axon.
pv4.a.5=c("VGlut-F-500253","VGlut-F-600090","VGlut-F-700430","130704c1") # Upper axon split type
pv4.a.6 = c("fru-F-400180","Gad1-F-600205", "Cha-F-300221", "Gad1-F-200395","130913c0","130912c0", "130911c2","Gad1-F-100132")
pv4.a.7 = c("Cha-F-300186", "Gad1-F-100345","Gad1-F-000201","VGlut-F-700436") # Upper axon type ... same as a4?
pv4.a.8 = c("Gad1-F-400124","Cha-F-800134","Gad1-F-500038","Cha-F-100456","Gad1-F-500281")
pv4.a.9 = c("130826c0", "130829c0", "130925c2", "130821c0", "130911c0","130829c1","Cha-F-900046", "Cha-F-700255","130205c2", "Gad1-F-100338")
pv4.a.10 = c("Cha-F-100221", "Gad1-F-500178", "5HT1A-F-300030", "5HT1A-F-300034")
pv4.a.11 = c("Gad1-F-700108","130627c0","Cha-F-600207")
pv4.a.12 = c("VGlut-F-300393","Cha-F-500303","Cha-F-600226")
pv4.a.13 = "VGlut-F-400195"
pv4.a= c(pv4.a.1,pv4.a.2,pv4.a.3,pv4.a.4,pv4.a.5,pv4.a.6,pv4.a.7,pv4.a.8,pv4.a.9,pv4.a.10,pv4.a.11,pv4.a.12,pv4.a.13)
pv4.b.1 = c("VGlut-F-500411","VGlut-F-700602","Gad1-F-300148", "VGlut-F-600764","VGlut-F-300574", "VGlut-F-500243","VGlut-F-500399", "VGlut-F-700084","140117c2")
pv4.b.2 = c("VGlut-F-800068","Gad1-F-100154","131212c1","E0585-F-300056","VGlut-F-500444","140207c0", "VGlut-F-400084", "Cha-F-100028","Gad1-F-200322","140211c0","140206c2")
pv4.b.3 = c("fru-M-200351","Gad1-F-600252")
pv4.b.4 = c("Gad1-F-300135")
pv4.b= c(pv4.b.1,pv4.b.2,pv4.b.3,pv4.b.4)
pv4.c.1 = c("VGlut-F-500046","VGlut-F-600030","Gad1-F-400027","VGlut-F-700503",
            "VGlut-F-400240","VGlut-F-700280","VGlut-F-800064","VGlut-F-700342",
            "Gad1-F-000274","VGlut-F-500419")
pv4.c.2=c("fru-M-200253","Gad1-F-100178","Gad1-F-700258")
pv4.c.3= c("VGlut-F-500445","VGlut-F-500442","VGlut-F-900028")
pv4.c.4=c("VGlut-F-800074")
pv4.c.5 = "VGlut-F-600311"
pv4.c.6 = "Cha-F-600243"
pv4.c=c(pv4.c.1,pv4.c.2,pv4.c.3,pv4.c.4,pv4.c.5,pv4.c.6)
pv4.d.1 =c("Cha-F-600269", "Cha-F-000485", "Gad1-F-500338", "Cha-F-200398","130923c0","Cha-F-000507","140212c0")
pv4.d.2 =c("Gad1-F-500171","Gad1-F-500023","Cha-F-100278","Cha-F-800106","VGlut-F-500323")
pv4.d.3 =c("130912c1")
pv4.d.4 ="Cha-F-600209"
pv4.d.5 ="Gad1-F-600125"
pv4.d.6 ="VGlut-F-400394"
pv4.d = c(pv4.d.1,pv4.d.2,pv4.d.3,pv4.d.4,pv4.d.5,pv4.d.6)
pv4.e.1 = c("VGlut-F-700001","VGlut-F-600075","Cha-F-300212","VGlut-F-700260")
pv4.e.2 = c("Cha-F-400138","VGlut-F-200590","Trh-F-000048")
pv4.e.3 =c("Cha-F-500298")
#pv4.e.4=c("CL100R_26C12")
pv4.e = c(pv4.e.1,pv4.e.2,pv4.e.3)
pv4.f = pv4.f.1 = c("130312c1","Cha-F-400318")
pv4.g.1 = c("VGlut-F-000390")
pv4.g=c(pv4.g.1)
pv4.h = pv4.h.1 = "fru-F-100052"
pv4.i = pv4.i.1 = "CL98R_26G09"
pv4.j = pv4.j.1 = "CL97R_26C12"
pv4.k = pv4.k.1 = "CL29GR_JRC_IS23354-000.swc"

df[pv4.a,]$anatomy.group = "pv4a"
df[pv4.b,]$anatomy.group = "pv4b"
df[pv4.c,]$anatomy.group = "pv4c"
df[pv4.d,]$anatomy.group = "pv4d"
df[pv4.e,]$anatomy.group = "pv4e"
df[pv4.f,]$anatomy.group = "pv4f"
df[pv4.g,]$anatomy.group = "pv4g"
df[pv4.h,]$anatomy.group = "pv4h"
df[pv4.i,]$anatomy.group = "pv4i"
df[pv4.j,]$anatomy.group = "pv4j"
df[pv4.k,]$anatomy.group = "pv4k"


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
df[pv4.a.13,]$cell.type = "pv4a13"
df[pv4.b.1,]$cell.type = "pv4b1"
df[pv4.b.2,]$cell.type = "pv4b3"
df[pv4.b.3,]$cell.type = "pv4b4"
df[pv4.b.4,]$cell.type = "pv4b2"
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
df[unique(pv6),]$pnt = "pv6"
pv6.a.1 = c("CL29CR_30H02","CL29CR_14B11") # in Mike's lines L62
pv6.a.2 = c("Cha-F-200186")
pv6.a = c(pv6.a.1,pv6.a.2)
# PV6a3 is Dr. Caligari in Paavo's paper
pv6.b.1 = "Cha-F-000395"
pv6.b.2 = "CL29FR_IS24835"
pv6.b=c(pv6.b.1,pv6.b.2)
pv6.c = pv6.c.1 = "Gad1-F-900064"
# PV6d1 in Mike's split L1827
df[pv6.a,]$anatomy.group = "pv6a"
df[pv6.b,]$anatomy.group = "pv6b"
df[pv6.a.1,]$cell.type = "pv6a1"
df[pv6.b.1,]$cell.type = "pv6b1"



###### PNT PV2 ######




### PV2
pv2 = c("Gad1-F-600088","Gad1-F-800194","Gad1-F-500328","Gad1-F-400232",
        "Gad1-F-100074","CL52R_11E08","CL123R_70G02","CL133R_39D07",
        "5HT1A-M-100027", "Gad1-F-800092", "Gad1-F-700138", "Cha-F-000086",
        "Cha-F-300168", "Cha-F-400222", "Cha-F-000242",
        "Gad1-F-800126", "Gad1-F-500266", "Cha-F-200448","Cha-F-600097",
        "5HT1A-M-200001","5HT1A-F-100028","131030c0",
        "131031c1","CL135R_10A11", "131028c0","ICL151B_IS24671", "131122c1")
df[unique(pv2),]$pnt = "pv2"
pv2.a.1 = c("5HT1A-M-200001", "Cha-F-300168", "5HT1A-F-100028","5HT1A-M-100027","131030c0", "131028c0")
pv2.a.2 = c("Cha-F-400222","Gad1-F-800194")
pv2.a.3 = c("Gad1-F-400232", "Cha-F-000242")
pv2.a.4 = "Gad1-F-600088"
pv2.a=c(pv2.a.1,pv2.a.2,pv2.a.3,pv2.a.4)
pv2.b.1 = c("Gad1-F-700138","131031c1","Cha-F-000110")
pv2.b=c(pv2.b.1)
pv2.c.1 =  c("Gad1-F-800092")
pv2.c.2 = "Gad1-F-100074"
pv2.c.3 ="CL133R_39D07"
pv2.c=c(pv2.c.1,pv2.c.2,pv2.c.3)
pv2.d = pv2.d.1 = "Gad1-F-500328"
pv2.e = pv2.e.1 = "Cha-F-000086"
pv2.f = pv2.f.1 = "ICL151B_IS24671"
pv2.g = pv2.g.1 = c("Gad1-F-500266", "Cha-F-200448")
pv2.h = pv2.h.1 = "Gad1-F-800126"# Could be its own tract
pv2.i = pv2.i.1 = "Cha-F-600097"
pv2.j = pv2.j.1 = "CL52R_11E08"
pv2.k = pv2.k.1 = "CL135R_10A11"

df[pv2.a,]$anatomy.group = "pv2a"
df[pv2.b,]$anatomy.group = "pv2b"
df[pv2.c,]$anatomy.group = "pv2c"
df[pv2.d,]$anatomy.group = "pv2d"
df[pv2.e,]$anatomy.group = "pv2e"
df[pv2.f,]$anatomy.group = "pv2f"
df[pv2.g,]$anatomy.group = "pv2g"#dont use for plotting
df[pv2.h,]$anatomy.group = "pv2h"
df[pv2.i,]$anatomy.group = "pv2i"
df[pv2.j,]$anatomy.group = "pv2j"
df[pv2.k,]$anatomy.group = "pv2k"



df[pv2.a.1,]$cell.type = "pv2a1"
df[pv2.a.2,]$cell.type = "pv2a2"
df[pv2.a.3,]$cell.type = "pv2a3"
df[pv2.a.4,]$cell.type = "pv2a4"
df[pv2.b.1,]$cell.type = "pv2b1"
df[pv2.c.1,]$cell.type = "pv2c1"
df[pv2.c.2,]$cell.type = "pv2c2"
df[pv2.c.3,]$cell.type = "pv2c3"
df[pv2.d.1,]$cell.type = "pv2d1"
df[pv2.e.1,]$cell.type = "pv2e1"
df[pv2.f.1,]$cell.type = "pv2f1"
df[pv2.g.1,]$cell.type = "pv2g1"
df[pv2.h.1,]$cell.type = "pv2h1"
df[pv2.i.1,]$cell.type = "pv2i1"
df[pv2.j.1,]$cell.type = "pv2j1"
df[pv2.k.1,]$cell.type = "pv2k1"





###### PNT PV1 ######





### PV1
pv1 = c("TH-M-200033", "TH-M-200079", "TH-M-300048", "TH-M-000013", "CL143R_MB583B",
        "TH-M-000042", "TH-M-000071", "Trh-M-000025", "Cha-F-000461",
        "TH-F-000011", "TH-F-000012", "TH-M-200035","Gad1-F-500004",
        "Gad1-F-500089","TH-F-300078","Gad1-F-500325","Cha-F-000278","Cha-F-500094",
        "Cha-F-000310", "fru-F-000126", "fru-M-800060", "TH-M-000030","fru-F-000125")
df[unique(pv1),]$pnt = "pv1"
pv1.a.1 = c("Gad1-F-500004","TH-M-200079","TH-M-300048","TH-M-000042","TH-M-200033","TH-M-200035")
pv1.a.2 = c( "Cha-F-000310","Cha-F-000461","TH-F-000012","TH-M-000013","TH-M-000030")
pv1.a.3 = "Cha-F-000310"
pv1.a=c(pv1.a.1,pv1.a.2,pv1.a.3)
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
df[pv1.a,]$anatomy.group = "pv1a"
df[pv1.b,]$anatomy.group = "pv1b"
df[pv1.c,]$anatomy.group = "pv1c"
df[pv1.d,]$anatomy.group = "pv1d"
df[pv1.e,]$anatomy.group = "pv1e"
df[pv1.f,]$anatomy.group = "pv1f"
df[pv1.g,]$anatomy.group = "pv1g"
df[pv1.h,]$anatomy.group = "pv1h"
df[pv1.i,]$anatomy.group = "pv1i"
df[pv1.a.1,]$cell.type = "pv1a1"
df[pv1.a.2,]$cell.type = "pv1a2"
df[pv1.a.3,]$cell.type = "pv1a3"
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





###### PNT PD6 ######





pd6 = c("Trh-F-000061", "Trh-M-600117", "Trh-M-600108", "Trh-M-200113",
        "Trh-M-200014", "Trh-M-700039","Gad1-F-200110", "fru-M-500259", "VGlut-F-900053", "VGlut-F-000454",
        "Cha-F-500087", "Cha-F-600179", "VGlut-F-000336", "fru-F-000130",
        "VGlut-F-300515","fru-M-500095")
df[unique(pd6),]$pnt = "pd6"
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
df[pd6.a,]$anatomy.group = "pd6a"
df[pd6.b,]$anatomy.group = "pd6b"
df[pd6.c,]$anatomy.group = "pd6c"
df[pd6.d,]$anatomy.group = "pd6d"
df[pd6.e,]$anatomy.group = "pd6e"
df[pd6.a.1,]$cell.type = "pd6a1"
df[pd6.a.2,]$cell.type = "pd6a2"
df[pd6.b.1,]$cell.type = "pd6b1"
df[pd6.c.1,]$cell.type = "pd6c1"
df[pd6.d.1,]$cell.type = "pd6d1"
df[pd6.e.1,]$cell.type = "pd6e1"





###### PNT PD5 ######





### pd5
pd5 = c("Gad1-F-100015")
df[unique(pd5),]$pnt = "pd5"
pd5.a = pd5.a.1 = c("Gad1-F-100015") # New tract?
df[pd5.a,]$anatomy.group = "pd5a"
df[pd5.a.1,]$cell.type = "pd5a1"





###### PNT PD4 ######





### pd4
pd4 = c("Cha-F-000413", "Cha-F-500201", "Cha-F-700283","Gad1-F-000285",
        "Gad1-F-100218","Gad1-F-100025", "fru-F-000092",
        "VGlut-F-300425", "VGlut-F-100282", "fru-F-000098","Cha-F-400309",
        "fru-M-000015", "Cha-F-000005","fru-M-500020",
        "Cha-F-000007", "Cha-F-000531", "Cha-F-300350", "fru-F-300195",
        "VGlut-F-300438", "VGlut-F-100068","Gad1-F-900054","fru-M-000077")
df[unique(pd4),]$pnt = "pd4"
pd4.a.1 = c("Cha-F-000413","VGlut-F-300425","VGlut-F-100068")
pd4.a.2 = c("VGlut-F-100282","VGlut-F-300438")
pd4.a.3 = c("fru-F-000098","fru-M-000077")
pd4.a.4 = "Gad1-F-200241"
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

df[pd4.a,]$anatomy.group = "pd4a"
df[pd4.b,]$anatomy.group = "pd4b"
df[pd4.c,]$anatomy.group = "pd4c"
df[pd4.d,]$anatomy.group = "pd4d"
df[pd4.e,]$anatomy.group = "pd4e"
df[pd4.f,]$anatomy.group = "pd4f"
df[pd4.g,]$anatomy.group = "pd4g"
df[pd4.h,]$anatomy.group = "pd4h"
df[pd4.i,]$anatomy.group = "pd4i"


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






###### PNT PD3 ######





### PD3
pd3 = c("Cha-F-100103","Cha-F-400165","Cha-F-500011","Gad1-F-100168", "Gad1-F-200150","Gad1-F-400320","CL153R_IS24693")
df[unique(pd3),]$pnt = "pd3"
pd3.a.1 = c("Cha-F-400165","Cha-F-500011")#116, new tract! LHd2 neuroblast.
pd3.a.2 = c("Gad1-F-100168", "Gad1-F-200150")
# pd3.a.3 in Mike's lines 116A
# pd3.a.4 in Mike's lines 116A
pd3.a=c(pd3.a.1,pd3.a.2)
pd3.b = pd3.b.1 = "Cha-F-100103" # correct attribution?
pd3.c = pd3.c.1 = "Gad1-F-400320" # correct attribution?
pd3.d = pd3.d.1 = "CL153R_IS24693"

df[pd3.a,]$anatomy.group = "pd3a"
df[pd3.b,]$anatomy.group = "pd3b"
df[pd3.c,]$anatomy.group = "pd3c"
df[pd3.d,]$anatomy.group = "pd3d"

df[pd3.a.1,]$cell.type = "pd3a1"
df[pd3.a.2,]$cell.type = "pd3a2"
df[pd3.b.1,]$cell.type = "pd3b1"
df[pd3.c.1,]$cell.type = "pd3c1"
df[pd3.d.1,]$cell.type = "pd3d1"






###### PNT PD2 ######






### PD2
pd2 = c("fru-M-000179","Gad1-F-500129", "Gad1-F-300303", "Gad1-F-200234", "5HT1A-F-300019",
        "Cha-F-000421", "Cha-F-100453", "Cha-F-800096",
        "fru-M-600135", "Gad1-F-100258", "Cha-F-000256",
        "fru-M-200206", "Gad1-F-500196", "5HT1A-F-300013", "Cha-F-600238",
        "Gad1-F-200037","Cha-F-600032",   "fru-M-000344",   "Gad1-F-500258",
        "VGlut-F-200258","fru-M-700108","121015c0", "121016c0", "121017c0",
        "121018c0", "121225c0","131007c0","121227c3", "130612c0", "131009c4",
        "131014c3","120806c0","120914c2","120926c0","130620c0","fru-F-600242",
        "Cha-F-200325","fru-F-500330","Cha-F-400224","fru-F-200100","fru-F-600136")
df[unique(pd2),]$pnt = "pd2"
pd2.a.1 = c("Cha-F-600238", "Gad1-F-200234","5HT1A-F-300019", "5HT1A-F-300013")
pd2.a.2 = c("130620c0", "130620c0", "121018c0", "121225c0", "130612c0",
            "131014c3", "121017c0", "121227c3","131007c0")
pd2.a.3=c("Gad1-F-500129","Gad1-F-500196","120806c0")
pd2.a.4 = c("Cha-F-100453")
pd2.a.5 = c("Gad1-F-100258")
pd2.a.6 = c("Gad1-F-300303")  # Amadan
pd2.a.7 = c("Gad1-F-200037")
pd2.a=c(pd2.a.1,pd2.a.2,pd2.a.3,pd2.a.4,pd2.a.5,pd2.a.6,pd2.a.7)
pd2.b=pd2.b.1 = c("120926c0","Cha-F-000421","Cha-F-800096","121015c0","121016c0",
                  "120914c2","131009c4")
pd2.c.1 = c("VGlut-F-200258","Cha-F-600032","Gad1-F-500258")
pd2.c.2 = c("Cha-F-000256")
pd2.c = c(pd2.c.1,pd2.c.2)
pd2.d.1 = c("fru-M-700108","fru-M-200206","fru-M-000344","fru-F-500330","Cha-F-400224","fru-F-200100")
pd2.d.2 = "fru-F-600242"
# in Mike's split
pd2.d = c(pd2.d.1,pd2.d.2)
pd2.e = pd2.e.1 = "fru-F-600136"
pd2.f = pd2.f.1 = "fru-M-000179"
pd2.g =  pd2.g.1 ="Cha-F-200325"
pd2.h = pd2.h.1 = "fru-M-600135"
# In Mike's splits: PD2e2

df[pd2.a,]$anatomy.group = "pd2a"
df[pd2.b,]$anatomy.group = "pd2b"
df[pd2.c,]$anatomy.group = "pd2c"
df[pd2.d,]$anatomy.group = "pd2d"
df[pd2.e,]$anatomy.group = "pd2e"
df[pd2.f,]$anatomy.group = "pd2f"
df[pd2.g,]$anatomy.group = "pd2g"
df[pd2.h,]$anatomy.group = "pd2h"

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
df[pd2.f.1,]$cell.type = "pd2f1"
df[pd2.g.1,]$cell.type = "pd2g1"
df[pd2.h.1,]$cell.type = "pd2h1"



###### PNT PD1 ######





### PD1
pd1 = c("fru-M-100313", "VGlut-F-400655", "VGlut-F-200053","VGlut-F-100022")
df[unique(pd1),]$pnt = "pd1"
pd1.a = pd1.a.1 = c("fru-M-100313","VGlut-F-400655","VGlut-F-200053","VGlut-F-100022")
df[pd1.a,]$anatomy.group = "pd1a"
df[pd1.a.1,]$cell.type = "pd1a1"





###### PNT AV3 ######





# av3
av3= c("Gad1-F-000132","Cha-F-000174","VGlut-F-700360","VGlut-F-600716","VGlut-F-200441","Cha-F-200387",
       "VGlut-F-300265","VGlut-F-400112","Cha-F-600218","Gad1-F-000203","Cha-F-000470",
       "VGlut-F-800054","VGlut-F-500832","VGlut-F-500109","VGlut-F-600223","VGlut-F-800057")
av3.a.1=c("Cha-F-000174","VGlut-F-700360","VGlut-F-600716",
          "VGlut-F-300265","VGlut-F-400112","Cha-F-600218","Gad1-F-000203",
          "VGlut-F-800054","VGlut-F-500832","VGlut-F-500109")
av3.a.2=c("Cha-F-200387","Gad1-F-000132")
av3.a=c(av3.a.1,av3.a.2)
av3.b=av3.b.1=c("VGlut-F-600223","VGlut-F-800057")
av3.c=av3.c.1=c("Cha-F-000470")
av3.d=av3.d.1 =("VGlut-F-200441")

df[unique(av3),]$pnt = "av3"

df[av3.a,]$anatomy.group = "av3a"
df[av3.b,]$anatomy.group = "av3b"
df[av3.c,]$anatomy.group = "av3c"
df[av3.d,]$anatomy.group = "av3d"

df[av3.a.1,]$cell.type = "av3a1"
df[av3.a.2,]$cell.type = "av3a2"
df[av3.b.1,]$cell.type = "av3b1"
df[av3.c.1,]$cell.type = "av3c1"
df[av3.d.1,]$cell.type = "av3d1"





###### PNT AV7 ######






### av7
av7 = c("Cha-F-700110",  "Gad1-F-200237", "Gad1-F-100225", "Cha-F-000432",  "Cha-F-500243", "fru-M-200393")
df[unique(av7),]$pnt = "av7"
av7.a = av7.a.1 = c("Cha-F-700110","Gad1-F-200237")
av7.b = av7.b.1 = c("Cha-F-000432","Cha-F-500243")
av7.c = av7.c.1 = c("fru-M-200393")
av7.d = av7.d.1 = "Gad1-F-100225"
df[av7.a,]$anatomy.group = "av7a"
df[av7.b,]$anatomy.group = "av7b"
df[av7.c,]$anatomy.group = "av7c"
df[av7.d,]$anatomy.group = "av7d"
df[av7.a.1,]$cell.type = "av7a1"
df[av7.b.1,]$cell.type = "av7b1"
df[av7.c.1,]$cell.type = "av7c1"
df[av7.d.1,]$cell.type = "av7d1"





###### PNT AV4 ######





### av4
av4 = c("Gad1-F-900076","Gad1-F-100077", "Cha-F-000193", "fru-F-500592",
        "Gad1-F-200137", "Gad1-F-400432","Cha-F-700114","fru-M-500251",
        "Cha-F-200276", "Cha-F-000481", "Cha-F-400293", "Cha-F-200385",
        "Gad1-F-700151", "Gad1-F-200155", "fru-F-600131", "fru-F-500181",
        "Gad1-F-000079", "Cha-F-600124", "Cha-F-500116", "fru-F-600129",
        "fru-F-500205", "fru-F-500357", "Cha-F-600191", "fru-M-700164",
        "fru-F-500229","Gad1-F-700104", "Cha-F-000524", "Gad1-F-100190",
        "Cha-F-700026", "Trh-M-500176", "fru-F-200122",
        "fru-F-500032", "fru-F-700136", "fru-F-500183",
        "Gad1-F-000006","fru-F-500099","Cha-F-800067",
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
        "fru-M-700211", "fru-M-800040","Cha-F-100357","VGlut-F-200021","VGlut-F-200382","fru-F-500093")
df[unique(av4),]$pnt = "av4"
av4.a.1 = c("fru-M-700211","fru-M-700174", "131016c1", "131002c2", "140117c1","Gad1-F-600241", "Cha-F-200282", "fru-F-200122", "131003c0",
            "fru-F-500183", "fru-M-200048", "fru-F-500032", "fru-F-700136")
av4.a.2 = c("Cha-F-000524", "Cha-F-200385", "Gad1-F-700106", "Cha-F-600191",
            "Gad1-F-000079")
av4.a.3 = c("Gad1-F-600241","Cha-F-200282", "Cha-F-300146")
av4.a.4 = c("Gad1-F-200163", "Gad1-F-800028","Trh-F-300041")
av4.a.5 = c("Gad1-F-400436","Cha-F-000481","Trh-M-500176")
av4.a.6 = c("Gad1-F-700104", "fru-F-600131", "fru-F-500229")
av4.a.7 = c("fru-M-500115", "fru-M-700164")
av4.a.8 = "Cha-F-500116"
av4.a.9 = c("131008c0", "131014c2", "131113c0")
av4.a.10 = c("Gad1-F-200155","Gad1-F-700151")
av4.a.11 = c("Cha-F-200329", "Gad1-F-200137")
av4.a = c(av4.a.1,av4.a.2,av4.a.3,av4.a.4,av4.a.5,av4.a.6,av4.a.7,av4.a.8,av4.a.9,av4.a.10,av4.a.11)
av4.b.1  = c("fru-F-500181", "fru-F-500205", "fru-F-500357",
             "fru-M-700052", "fru-F-600129","fru-M-100096","fru-F-500099", "fru-M-800040",
             "fru-M-800189", "fru-F-800071")
av4.b.2 = c("Cha-F-000515", "Gad1-F-700224", "Cha-F-600124","Gad1-F-000006","Cha-F-800067")
av4.b.3= c("5HT1A-M-300006","140618c0","160211c1","Gad1-F-100077","160201c1")
av4.b.4 = c("fru-M-300432","VGlut-F-200021","VGlut-F-200382")
av4.b.5  = c("fru-F-600043", "Cha-F-700025", "fru-F-400039")
av4.b.6 =c("131009c0", "131007c1", "131011c0","Gad1-F-100051")
av4.b.7=c("Cha-F-400293","Gad1-F-200366")
av4.b.8 = c("Gad1-F-100190", "Cha-F-700026")
av4.b.9 ="5HT1A-F-800008"
av4.b.10 =c("Gad1-F-900076", "Gad1-F-600140")
av4.b.11="Cha-F-200378"
av4.b = c(av4.b.1,av4.b.2,av4.b.3,av4.b.4,av4.b.5,av4.b.6,av4.b.7,av4.b.8,av4.b.9,av4.b.10,av4.b.11)
av4.c.1 = c("Cha-F-000193","Cha-F-200276", "131003c1","131123c1" ,"140213c1","fru-F-400486", "fru-F-500093")
av4.c.2 = c("fru-F-500355","fru-M-400293","Gad1-F-400432")
av4.c.3 = "Gad1-F-200127"
av4.c = c(av4.c.1,av4.c.2,av4.c.3)
av4.d = av4.d.1 = c("fru-F-500592","fru-F-300099")
av4.e.1 = c("fru-M-300124")
av4.e.2 = "fru-F-500089"
av4.e= c(av4.e.1,av4.e.2)
av4.f = av4.f.1 = "Cha-F-200357"  # bad trace
av4.g = av4.g.1 = "Cha-F-100357"
av4.h = av4.h.1 = "Cha-F-700114"
av4.i = av4.i.1 = "fru-M-500251"
df[av4.a,]$anatomy.group = "av4a"
df[av4.b,]$anatomy.group = "av4b"
df[av4.c,]$anatomy.group = "av4c"
df[av4.d,]$anatomy.group = "av4d"
df[av4.e,]$anatomy.group = "av4e"
df[av4.f,]$anatomy.group = "av4f"
df[av4.g,]$anatomy.group = "av4g"
df[av4.h,]$anatomy.group = "av4h"
df[av4.i,]$anatomy.group = "av4i"
df[av4.b.1,]$cell.type = "av4b1"
df[av4.b.2,]$cell.type = "av4b2"
df[av4.b.3,]$cell.type = "av4b3"
df[av4.b.4,]$cell.type = "av4b4"
df[av4.b.5,]$cell.type = "av4b5"
df[av4.b.6,]$cell.type = "av4b6"
df[av4.b.7,]$cell.type = "av4b7"
df[av4.b.8,]$cell.type = "av4b8"
df[av4.b.9,]$cell.type = "av4b9"
df[av4.b.10,]$cell.type = "av4b10"
df[av4.b.11,]$cell.type = "av4b11"

df[av4.a.1,]$cell.type = "av4a1"
df[av4.a.2,]$cell.type = "av4a2"
df[av4.a.3,]$cell.type = "av4a3"
df[av4.a.4,]$cell.type = "av4a4"
df[av4.a.5,]$cell.type = "av4a5"
df[av4.a.6,]$cell.type = "av4a6"
df[av4.a.7,]$cell.type = "av4a7"
df[av4.a.8,]$cell.type = "av4a8"
df[av4.a.9,]$cell.type = "av4a9"
df[av4.a.10,]$cell.type = "av4a10"
df[av4.a.11,]$cell.type = "av4a11"
df[av4.c.1,]$cell.type = "av4c1"
df[av4.c.2,]$cell.type = "av4c2"
df[av4.c.3,]$cell.type = "av4c3"
df[av4.d.1,]$cell.type = "av4d1"
df[av4.e.1,]$cell.type = "av4e1"
df[av4.e.2,]$cell.type = "av4e2"
df[av4.f.1,]$cell.type = "av4f1"
df[av4.g.1,]$cell.type = "av4g1"
df[av4.h.1,]$cell.type = "av4h1"
df[av4.i.1,]$cell.type = "av4i1"





###### PNT AV5 ######





### av5
av5 = c("TH-M-300052","VGlut-F-200146", "Cha-F-700219",  "VGlut-F-200058","Cha-F-300258",
        "Cha-F-700242","VGlut-F-100073","fru-M-200274","Gad1-F-100333")
df[unique(av5),]$pnt = "av5"
av5.a = av5.a.1 = c("Cha-F-700219","Cha-F-300258","Cha-F-700242") # change to 6
av5.b =  av5.b.1 = c("VGlut-F-200146", "VGlut-F-200058","VGlut-F-100073") # change to 6
av5.c =  av5.c.1 = "TH-M-300052" # change to 6
av5.d=  av5.d.1 = c("Gad1-F-100333")
av5.e=  av5.e.1 = c("fru-M-200274")
df[av5.a,]$anatomy.group = "av5a"
df[av5.b,]$anatomy.group = "av5b"
df[av5.c,]$anatomy.group = "av5c"
df[av5.d,]$anatomy.group = "av5d"
df[av5.e,]$anatomy.group = "av5e"
df[av5.a.1,]$cell.type = "av5a1"
df[av5.b.1,]$cell.type = "av5b1"
df[av5.c.1,]$cell.type = "av5c1"
df[av5.d.1,]$cell.type = "av5d1"
df[av5.e.1,]$cell.type = "av5e1"





###### PNT AV6 ######





### av6
av6 = c("Cha-F-400277",  "Cha-F-600105", "VGlut-F-100257","Cha-F-700262","Cha-F-000158",
        "Cha-F-400151","Gad1-F-800082","Cha-F-400277", "Cha-F-700262", "Cha-F-000158",
        "Cha-F-100427","Gad1-F-500030","Gad1-F-100097","Gad1-F-800112","Gad1-F-600143",
        "Gad1-F-500363", "Gad1-F-400255", "Cha-F-800078", "Cha-F-200185",
        "VGlut-F-200015", "Gad1-F-200144", "Gad1-F-800107",
        "Gad1-F-500140", "Gad1-F-200174", "Gad1-F-200156", "Cha-F-200454",
        "Cha-F-700236", "fru-F-400319","VGlut-F-200375","Gad1-F-600106","130807c1",
        "130808c1", "130808c2", "130813c0", "130814c1",
        "130815c1", "130819c1", "130820c0", "130820c2", "130822c0", "140328c1",
        "140402c1", "140514c2","130725c4","Gad1-F-600096")
df[unique(av6),]$pnt = "av6"
av6.a.1 = c("140328c1","140402c1","140514c2","130807c1","130813c0","130815c1","130822c0","130808c2","130820c0","130820c2","Gad1-F-800112","fru-F-400319","Cha-F-200185", "Gad1-F-200144","Gad1-F-200156","Cha-F-400151","Cha-F-000158","130725c4")
av6.a.2 = c("130814c1","130808c1","130819c1","Gad1-F-600143","Gad1-F-500363","Cha-F-800078","Gad1-F-800082")
av6.a = c(av6.a.1,av6.a.2)
av6.b.1 = c("Cha-F-100427","Cha-F-600105", "Cha-F-700262","Gad1-F-100097","Gad1-F-200174")
av6.b.2 = "Gad1-F-600096"
av6.b = c(av6.b.1,av6.b.2)
av6.c.1 = c("VGlut-F-200375","VGlut-F-100257")
av6.c.2 = c("Cha-F-200454")
# AV6c3 in Mike's lines
av6.c = c(av6.c.1,av6.c.2)
av6.d=av6.d.1 = c("Gad1-F-400255","Gad1-F-800107")
av6.e = av6.e.1 = c("Gad1-F-500140","Gad1-F-600106")
av6.f = av6.f.1 = "VGlut-F-200015"
av6.g = av6.g.1 = "Cha-F-700236"
av6.h = av6.h.1 = "Cha-F-400277"
av6.i = av6.i.1 = "Gad1-F-500030"
df[av6.a,]$anatomy.group = "av6a"
df[av6.b,]$anatomy.group = "av6b"
df[av6.c,]$anatomy.group = "av6c"
df[av6.d,]$anatomy.group = "av6d"
df[av6.e,]$anatomy.group = "av6e"
df[av6.f,]$anatomy.group = "av6f"
df[av6.g,]$anatomy.group = "av6g"
df[av6.h,]$anatomy.group = "av6h"
df[av6.i,]$anatomy.group = "av6i"
df[av6.a.1,]$cell.type = "av6a1"
df[av6.a.2,]$cell.type = "av6a2"
df[av6.b.1,]$cell.type = "av6b1"
df[av6.b.2,]$cell.type = "av6b2"
df[av6.c.1,]$cell.type = "av6c1"
df[av6.c.2,]$cell.type = "av6c2"
df[av6.d.1,]$cell.type = "av6d1"
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
df[unique(av2),]$pnt = "av2"
av2.a.1 = c("Gad1-F-000240","Cha-F-000048","fru-F-200126","Gad1-F-000298")
av2.a.2 = c("Gad1-F-800214","Gad1-F-600244")
av2.a.3 = c("Cha-F-500105","Gad1-F-000096")
av2.a.4=c("Gad1-F-800100")
av2.a=c(av2.a.1,av2.a.2,av2.a.3,av2.a.4)
av2.b.1 =  c("Cha-F-200034", "Cha-F-600183", "Cha-F-100444",
             "fru-F-300169","Cha-F-300136","Gad1-F-300310")
av2.b.2 = c("5HT1A-F-300031", "Gad1-F-600005")
av2.b.3 = c("fru-M-300456","Gad1-F-300218")
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
df[av2.a,]$anatomy.group = "av2a"
df[av2.b,]$anatomy.group = "av2b"
df[av2.b,]$anatomy.group = "av2b"
df[av2.c,]$anatomy.group = "av2c"
df[av2.d,]$anatomy.group = "av2d"
df[av2.e,]$anatomy.group = "av2e"
df[av2.f,]$anatomy.group = "av2f"
df[av2.g,]$anatomy.group = "av2g"
df[av2.h,]$anatomy.group = "av2h"
df[av2.i,]$anatomy.group = "av2i"
df[av2.j,]$anatomy.group = "av2j"
df[av2.k,]$anatomy.group = "av2k"
df[av2.l,]$anatomy.group = "av2l"
df[av2.m,]$anatomy.group = "av2m"

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
df[unique(av1),]$pnt = "av1"
av1.a.1 = c("Gad1-F-200387", "Gad1-F-800137", "Cha-F-700271", "VGlut-F-600069",
            "VGlut-F-500603", "VGlut-F-500744", "VGlut-F-600228", "VGlut-F-600516",
            "Cha-F-300357", "VGlut-F-700213", "VGlut-F-500378", "VGlut-F-500113",
            "VGlut-F-400535", "VGlut-F-500847", "VGlut-F-500255", "VGlut-F-500269",
            "VGlut-F-000366", "Gad1-F-600174", "Gad1-F-500105", "Cha-F-200201")
av1.a.2 = c("VGlut-F-500507","VGlut-F-700284", "VGlut-F-600598", "VGlut-F-600078", "VGlut-F-100009",
            "VGlut-F-400241", "Cha-F-100370",
            "VGlut-F-700009", "VGlut-F-700266", "VGlut-F-600109", "Gad1-F-700100",
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
df[av1.a,]$anatomy.group = "av1a"
df[av1.b,]$anatomy.group = "av1b"
df[av1.b,]$anatomy.group = "av1b"
df[av1.c,]$anatomy.group = "av1c"
df[av1.d,]$anatomy.group = "av1d"
df[av1.e,]$anatomy.group = "av1e"
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
df[unique(ad5),]$pnt = "ad5"
ad5.a = ad5.a.1 = c("VGlut-F-200459") # This its own tract, reshuffle
df[ad5.a,]$anatomy.group = "ad5a"
df[ad5.a.1,]$cell.type = "ad5a1"





###### PNT AD4 ######





### AD4
ad4 = "fru-M-400351"
df[unique(ad4),]$pnt = "ad4"
ad4.a = ad4.a.1 = c("fru-M-400351") # This its own tract, reshuffle
df[ad4.a,]$anatomy.group = "ad4a"
df[ad4.a.1,]$cell.type = "ad4a1"





###### PNT AD3 ######






### AD3
ad3 = c("Gad1-F-000108", "Cha-F-000533", "Cha-F-100001","Cha-F-200386","Gad1-F-100124","Gad1-F-700066")
df[unique(ad3),]$pnt = "ad3"
ad3.a = ad3.a.1 = "Gad1-F-000108"
ad3.b = ad3.b.1 = "Cha-F-000533"
ad3.c = ad3.c.1 = c("Cha-F-100001")
ad3.d = ad3.d.1 = "Gad1-F-100124"
ad3.e = ad3.e.1 = "Gad1-F-700066"

df[ad3.a,]$anatomy.group = "ad3a"
df[ad3.b,]$anatomy.group = "ad3b"
df[ad3.c,]$anatomy.group = "ad3c"
df[ad3.d,]$anatomy.group = "ad3d"
df[ad3.e,]$anatomy.group = "ad3e"

df[ad3.a.1,]$cell.type = "ad3a1"
df[ad3.b.1,]$cell.type = "ad3b1"
df[ad3.c.1,]$cell.type = "ad3c1"
df[ad3.d.1,]$cell.type = "ad3d1"
df[ad3.e.1,]$cell.type = "ad3e1"




###### PNT AD2 ######





### AD2
ad2 = c("fru-M-600162", "fru-F-500184", "fru-F-400325",
        "fru-F-400420", "fru-F-400067", "fru-M-400340", "fru-M-500191",
        "fru-F-500117", "fru-M-700010", "fru-M-500103","fru-F-700078")
df[unique(ad2),]$pnt = "ad2"
ad2.a.1 = c("fru-M-500103","fru-M-400340","fru-M-500191","fru-M-700010","fru-M-600162")
ad2.a.2 = "fru-M-600162"
ad2.a = c(ad2.a.1,ad2.a.2)
ad2.b = ad2.b.1 = c("fru-F-500184","fru-F-500117","fru-F-400067","fru-F-700078")
ad2.c = ad2.c.1 = c("fru-F-400325","fru-F-400420")

df[ad2.a,]$anatomy.group = "ad2a"
df[ad2.b,]$anatomy.group = "ad2b"
df[ad2.c,]$anatomy.group = "ad2c"

df[ad2.a.1,]$cell.type = "ad2a1"
df[ad2.a.2,]$cell.type = "ad2a2"
df[ad2.b.1,]$cell.type  = "ad2b1"
df[ad2.c.1,]$cell.type  = "ad2c1"






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
df[unique(ad1),]$pnt = "ad1"
ad1.a = c("Cha-F-100223","VGlut-F-200319","Cha-F-000258","VGlut-F-400863",
          "Cha-F-300272","VGlut-F-400267","VGlut-F-800061","Cha-F-300384",
          "VGlut-F-600424","VGlut-F-700522","Gad1-F-700076","Gad1-F-400257","Gad1-F-400155",
          "Cha-F-400246","140402c0","140403c1","121206c0","120925c1",
          "121127c1","121122c1","121128c3","130123c1","130523c0","130524c0")
ad1.a.1 = c("130123c1","130523c0", "130524c0","Cha-F-000258")
ad1.a.2 = c("120925c1", "121127c1", "121122c1", "121128c3")
ad1.a.3 = c("Cha-F-100223", "VGlut-F-200319","Cha-F-300272","VGlut-F-400267","VGlut-F-600424","VGlut-F-700522") # Aspis in the EM
ad1.a.4 = c("VGlut-F-400170", "Cha-F-400246","140402c0", "140403c1","Gad1-F-400257", "121206c0")
ad1.a.5 = "Gad1-F-700076"
ad1.a.6 = "Cha-F-300384"
ad1.a.7= "Gad1-F-400155"
ad1.a.8 = "VGlut-F-800061"
ad1.a = c(ad1.a.1,ad1.a.2,ad1.a.3,ad1.a.4,ad1.a.5,ad1.a.6,ad1.a.7,ad1.a.8)
ad1.b.1 = c("130726c1", "130731c1", "130802c0", "130801c1","130729c0","120816c1",
            "120813c1", "120911c0", "120726c3", "130910c0", "140514c1", "121101c0")
ad1.b.2 = c("120704c1", "120730c0", "140616c0","140612c0","120714c4","Gad1-F-900037", "Gad1-F-200039")
# ad1.b.3 in Wilson data
ad1.b = c(ad1.b.1,ad1.b.2)

ad1.c.1=c("Gad1-F-600330", "Gad1-F-400233", "Gad1-F-300262", "Gad1-F-500014",
        "120830c2",  "121129c0", "130711c3", "120913c1")
ad1.c.2=c("Gad1-F-600330")
ad1.c=c(ad1.c.1,ad1.c.2)

#AD1d1 in Mike's split lines

ad1.e.1 = c("Gad1-F-300229","Cha-F-200360","fru-F-300009","Gad1-F-200365")
ad1.e.2 = c("Gad1-F-700032","fru-F-200156")
ad1.e.3 = "Gad1-F-000249"
ad1.e.4 = c("Gad1-F-200033","Cha-F-700185")
ad1.e = c(ad1.e.1,ad1.e.2,ad1.e.3,ad1.e.4)

ad1.f = ad1.f.1 = c("VGlut-F-500032","VGlut-F-400863")
ad1.g.1 = c("fru-M-300364","fru-M-200239")
ad1.g.2=c("131204c1")
ad1.g=c(ad1.g.1,ad1.g.2)
ad1.h = ad1.h.1 =  "VGlut-F-200392"
ad1.i = ad1.i.1 = "VGlut-F-500156"
ad1.j = ad1.j.1 = "Gad1-F-200247"

df[ad1.a,]$anatomy.group = "ad1a"
df[ad1.b,]$anatomy.group = "ad1b"
df[ad1.c,]$anatomy.group = "ad1c"
df[ad1.e,]$anatomy.group = "ad1d"
df[ad1.e,]$anatomy.group = "ad1e"
df[ad1.f,]$anatomy.group = "ad1f"
df[ad1.g,]$anatomy.group = "ad1g"
df[ad1.h,]$anatomy.group = "ad1h"
df[ad1.i,]$anatomy.group = "ad1i"
df[ad1.j,]$anatomy.group = "ad1j"
df[ad1.a.2,]$cell.type = "ad1a2"
df[ad1.a.3,]$cell.type = "ad1a3"
df[ad1.a.4,]$cell.type = "ad1a4"
df[ad1.a.5,]$cell.type = "ad1a5"
df[ad1.a.6,]$cell.type = "ad1a6"
df[ad1.a.7,]$cell.type = "ad1a7"
df[ad1.a.8,]$cell.type = "ad1a8"
df[ad1.a.10,]$cell.type = "ad1a1"
df[ad1.b.1,]$cell.type = "ad1b1"
df[ad1.b.2,]$cell.type = "ad1b2"
df[ad1.c.1,]$cell.type = "ad1c1"
df[ad1.c.2,]$cell.type = "ad1c2"
df[ad1.e.1,]$cell.type = "ad1e1"
df[ad1.e.2,]$cell.type = "ad1e2"
df[ad1.e.3,]$cell.type = "ad1e3"
df[ad1.e.4,]$cell.type = "ad1e4"
df[ad1.e.1,]$cell.type = "ad1e1"
df[ad1.f.1,]$cell.type= "ad1f1"
df[ad1.g.2,]$cell.type = "ad1g2"
df[ad1.g.1,]$cell.type = "ad1g1"
df[ad1.h.1,]$cell.type = "ad1h1"
df[ad1.i.1,]$cell.type = "ad1i1"
df[ad1.j.1,]$cell.type = "ad1j1"




###### Assign CORE LH ######





# Add back to data frame
names_in_common=intersect(names(most.lhns), rownames(df))
most.lhns = most.lhns[names_in_common]
most.lhns[,]=df[names_in_common,]

# Get scores
load('data-raw/LHN_PN_Overlap_Scores.rda')
#lhns.pn.overlap.matrix = LHN_PN_Full_Overlap_Scores
i = intersect(colnames(lhns.pn.overlap.matrix),names(most.lhns))
lhns.chosen = most.lhns[i]
colnames(lhns.pn.overlap.matrix) = lhns.chosen[,"cell.type"]
lhns.pn.overlap.matrix = t(apply(t(lhns.pn.overlap.matrix), 2, function(x) tapply(x, colnames(lhns.pn.overlap.matrix), mean, na.rm = TRUE)))

# Decide
d = catnat::dendritic_cable(lhns.chosen,mixed=TRUE)
d.data.skels = summary(d)$cable.length
message("Pruning neurons to LH!")
d.lh.skels = unlist(nlapply(d,function(x) tryCatch(summary(prune_in_volume(x,neuropil="LH_R",brain=nat.flybrains::FCWBNP.surf))$cable.length,error = function(e) 0)))
names(d.lh.skels) = names(d.data.skels) = lhns.chosen[names(d),"cell.type"]
d.lh = tapply(d.lh.skels, names(d.lh.skels), mean, na.rm = TRUE)
d.data = tapply(d.data.skels, names(d.data.skels), mean, na.rm = TRUE)
o.d = lhns.pn.overlap.matrix[,names(d.lh)]
skeleton.no = c(table(d[,"cell.type"]))[colnames(o.d)]
df.decision = data.frame(ct = colnames(o.d), overlap = colSums(o.d), proportion.dendritic.lh = d.lh/d.data,skeleton.no=skeleton.no)

# Add in cable length info
df[names(d),]$dendritic.cable = d.data.skels
df[names(d),]$dendritic.cable.in.lh = d.lh.skels

# Chop!
poss_non_core_lh=subset(df.decision,overlap<50000 & proportion.dendritic.lh<0.15)$ct
notLHcore = rownames(subset(df,cell.type%in%poss_non_core_lh))

# Assign non-core neurons
df[c(notLH,notLHcore),]$coreLH = FALSE





###### Assign LHLNs and LHONs ######





lh.output.neurons = c("ad1a2", "ad1a1",  "ad1a3", "ad1a4", "ad1a5", "ad1a6",
                      "ad1a7", "ad1a8",  "ad1b1", "ad1b2", "ad1c1", "ad1c2",
                      "ad1c3", "ad1c4", "ad1e1", "ad1e2", "ad1e3", "ad1e4", "ad1e1",
                      "ad1g2", "ad1f1", "ad1g1", "ad1h1", "ad1i1", "ad1j1", "ad2a1", "ad2a2",
                      "ad2b1", "ad2c1", "ad3a1", "ad3b1", "ad3c1", "ad3d1", "ad4a1",
                      "ad5a1", "av1a1", "av1a2", "av1a3", "av1a4", "av1a5", "av1c1",
                      "av1d1", "av1e1", "av2a1", "av2a2", "av2a3", "av2a4", "av2b1",
                      "av2b2", "av2b3", "av2b4", "av2b5", "av2c1", "av2d1", "av2e1",
                      "av2f1", "av2g1", "av2h1", "av2i1", "av2j1", "av2k1", "av2l1",
                      "av2m1", "av3a1", "av3a2", "av3b1", "av3c1", "av3d1", "av4b1",
                      "av4b10", "av4b11", "av4b2", "av4b3", "av4b4", "av4b5", "av4b6",
                      "av4b7", "av4b8", "av4b9", "av4c1", "av4c2", "av4c3",
                      "av4d1", "av4e1", "av4e2", "av4f1", "av4g1", "av4i1", "av5a1",
                      "av5c1", "av5e1", "av6a1", "av6a2", "av6b1", "av6b2", "av6c1",
                      "av6c2", "av6d1", "av6e1", "av6f1", "av6h1", "av6i1", "av7a1",
                      "av7b1", "av7c1", "av7d1", "pd1a1", "pd2a1", "pd2a2", "pd2a3",
                      "pd2a4", "pd2a5", "pd2a6", "pd2b1", "pd2c1", "pd2c2", "pd2d1",
                      "pd2d2", "pd2e1", "pd2f1", "pd2g1", "pd2h1", "pd3b1", "pd3c1", "pd3d1", "pd4a1",
                      "pd4a2", "pd4a3", "pd4a4", "pd4b1", "pd4c1", "pd4c2", "pd4e1",
                      "pd4f1", "pd4g1", "pd4h1", "pd4i1", "pd5a1", "pd6a1", "pd6a2",
                      "pd6b1", "pd6c1", "pd6d1", "pd6e1", "pv11a1", "pv11a2", "pv12a1",
                      "pv1a1", "pv1a2", "pv1a3", "pv1b1", "pv1b2", "pv1b3", "pv1b4",
                      "pv1b5", "pv1c1", "pv1d1", "pv1e1", "pv1f1", "pv1g1", "pv1h1",
                      "pv1i1", "pv2b1", "pv2c1", "pv2c2", "pv2c3", "pv2d1", "pv2f1",
                      "pv2g1", "pv2h1", "pv2i1", "pv2j1", "pv2k1", "pv3a1", "pv3a2",
                      "pv3b1", "pv3c1", "pv3d1", "pv3e1", "pv3f1", "pv4b1", "pv4b2",
                      "pv4b3", "pv4b4", "pv4c1", "pv4c1", "pv4c2", "pv4c3", "pv4c4",
                      "pv4c5", "pv4c6", "pv4d1", "pv4d1", "pv4d2", "pv4d3", "pv4d4",
                      "pv4d5", "pv4d6", "pv4e1", "pv4e2", "pv4e3",  "pv4f1",
                      "pv4g1", "pv4h1", "pv4i1", "pv4j1", "pv4k1",
                      "pv5a1", "pv5a2", "pv5a3", "pv5a4", "pv5a5", "pv5b1",
                      "pv5b2", "pv5b3", "pv5b4", "pv5b5", "pv5b6", "pv5c1", "pv5c2",
                      "pv5c3", "pv5c5", "pv5d1", "pv5d2", "pv5d3", "pv5e1", "pv5f1",
                      "pv5g1", "pv5g2", "pv5g3", "pv5h1", "pv5i1", "pv5j1", "pv5k1",
                      "pv5l1", "pv7a1", "pv7b1", "pv8b1", "pv8c1", "pv9a1", "pv9b1",
                      "pv9c1", "pv9d1", "pv9d2", "pv10a1", "pv10b1", "pv10c1", "pv10c2",
                      "pv10d1", "pv10e1", "pv10f1", "pv10g1", "pv10h1", "pv10i1", "pv10j1", "pd7a1", "pd7b1")
lh.local.neurons = c("av1b1", "av4a1", "av4a10", "av4a10", "av4a11", "av4a2", "av4a3",
                     "av4a4", "av4a5", "av4a6", "av4a7", "av4a8", "av4a9", "av4h1",
                     "av5b1", "av5d1", "av6g1", "pd3a1", "pd3a2", "pd4d1", "pv2a1",
                     "pv2a2", "pv2a3", "pv2a4", "pv2e1",  "pv4a3", "pv4a1",
                     "pv4a10", "pv4a11", "pv4a12", "pv4a13", "pv4a2", "pv4a2", "pv4a3",
                     "pv4a4", "pv4a5", "pv4a6", "pv4a7", "pv4a8", "pv4a9", "pv8a1")
df[rownames(df)%in%notLH,]$type="notLH"
df[df$cell.type%in%lh.local.neurons,]$type="LN"
df[df$cell.type%in%lh.output.neurons,]$type="ON"




#### Assign skeleton origins and re-attach data.frame ###



df$skeleton.type = "FlyCircuit"
df[grepl("^1",rownames(df)),]$skeleton.type = "DyeFill"
df[names(c(JFRCSH_clusters.FCWB,JFRCSH.DS_clusters.FCWB,SF_clusters.FCWB)),]$skeleton.type = "LightTrace"
names_in_common=intersect(names(most.lhns), rownames(df))
most.lhns = most.lhns[names_in_common]
most.lhns[,]=df[names_in_common,]



###### Generate Primary Neurite Tracts ######

# Capitalise
most.lhns[,"cell.type"] = capitalise_cell_type_name(most.lhns[,"cell.type"])
most.lhns[,"anatomy.group"] = capitalise_cell_type_name(most.lhns[,"anatomy.group"])
most.lhns[,"pnt"] = capitalise_cell_type_name(most.lhns[,"pnt"])
most.lhns = most.lhns[!names(most.lhns)%in%names(most.lhins)] # Remove skeletons also in most.lhins

### Make a model of all the tracts that can be viewed easily
pnts = sort(unique(most.lhns[,"pnt"]))
pnts = pnts[pnts!="notLHproper"]
message("Finding primary.neurite.tracts for all neurons!")
most.lhns.pnts = catnat::primary.neurite(most.lhns)
message("Making average primary.neurite.tracts!")
primary.neurite.tracts = nlapply(pnts,function(z) catnat::average.tracts(subset(most.lhns.pnts,pnt==z),mode=1))
names(primary.neurite.tracts) = pnts
attr(primary.neurite.tracts,"df") = data.frame(pnt=names(primary.neurite.tracts))


###### Generate data objects ######



############
# Save data #
############

message("Saving data!")
devtools::use_data(primary.neurite.tracts,overwrite=TRUE,compress=TRUE) # Save PNT, averaged structures

# #################
# Update Meta-Data #
###################


most.lhns = as.neuronlistfh(most.lhns,dbdir = 'inst/extdata/data/', WriteObjects="missing")
most.lhns.dps = nat::dotprops(most.lhns,resample=1)
most.lhns.dps = as.neuronlistfh(most.lhns.dps,dbdir = 'inst/extdata/data/', WriteObjects="missing")


#####################
# Write neuronlistfh #
#####################


write.neuronlistfh(most.lhns, file='inst/extdata/most.lhns.rds',overwrite = TRUE)
write.neuronlistfh(most.lhns.dps, file='inst/extdata/most.lhns.dps.rds',overwrite = TRUE)
