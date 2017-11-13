# Process FlyCircuit data




# Get data
load("data-raw/lh.inputs.rda")
df = lh.inputs[,]
df = df[,c("gene","sex","LH_side","glomerulus")]
df$anatomy.group = NA
df$modality = NA
df$type = "non-glomerular"
df$glomerulus = NA
df$tract = NA
df$neurotransmitter = NA
df$reference = NA
df$dendritic.location = NA
df$cell.body.position = NA
marta <- function(n){
  e = n[n%in%flycircuit::fc_neuron(names(flycircuit::fc_glom()))]
  names(e) = flycircuit::fc_glom()[flycircuit::fc_neuron(names(flycircuit::fc_glom()))%in%e]
  e
}




###### Assign Glomeruli ######




i = marta(names(lh.inputs))
# VAsomething appears to be VA4, VA4 appears to be something else, VA3 perhaps
g = grepl("VAsomething",names(i))
names(i[g]) = "VA4"
g = grepl("VA4",names(i))
names(i[g]) = "VM4"
df[i,]$glomerulus = names(i)
# Add notes from FlyCircuit




###### Assign mALT uPNs ######





ad.upns = c("fru-M-500154", "VGlut-F-400532", "fru-M-400041", "VGlut-F-700359",
            "VGlut-F-400402", "VGlut-F-200348", "VGlut-F-800046", "VGlut-F-500659",
            "VGlut-F-800075", "VGlut-F-700240", "VGlut-F-900052", "VGlut-F-200560",
            "VGlut-F-400668", "VGlut-F-500537", "VGlut-F-400023", "VGlut-F-700103",
            "VGlut-F-800097", "VGlut-F-500868", "VGlut-F-600746", "Gad1-F-500167",
            "VGlut-F-300450", "VGlut-F-500635", "VGlut-F-500016", "VGlut-F-500202",
            "VGlut-F-500727", "VGlut-F-000606", "fru-F-000079", "VGlut-F-600005",
            "VGlut-F-600375", "VGlut-F-700285", "fru-M-500171", "VGlut-F-600479",
            "VGlut-F-700109", "VGlut-F-500870", "VGlut-F-700331", "VGlut-F-600104",
            "VGlut-F-600314", "VGlut-F-600671", "VGlut-F-700210", "VGlut-F-700598",
            "VGlut-F-500447", "VGlut-F-600371", "VGlut-F-700215", "VGlut-F-800044",
            "VGlut-F-500864", "VGlut-F-700101", "VGlut-F-400432", "VGlut-F-700104",
            "VGlut-F-700209", "VGlut-F-400176", "VGlut-F-800104", "VGlut-F-100369",
            "VGlut-F-800211", "VGlut-F-500160", "VGlut-F-400444", "VGlut-F-800123",
            "VGlut-F-500257", "VGlut-F-700254", "VGlut-F-800031", "VGlut-F-600093",
            "VGlut-F-900102", "VGlut-F-400663", "VGlut-F-500298", "VGlut-F-400533",
            "VGlut-F-700075", "VGlut-F-800053", "VGlut-F-500022", "VGlut-F-500057",
            "VGlut-F-500058", "VGlut-F-600494", "VGlut-F-700245", "VGlut-F-800143",
            "VGlut-F-400260", "VGlut-F-500580", "VGlut-F-500548", "VGlut-F-700440",
            "VGlut-F-500333", "VGlut-F-400218", "VGlut-F-400719", "VGlut-F-800089",
            "VGlut-F-700107", "VGlut-F-800047", "VGlut-F-700147", "VGlut-F-500076",
            "VGlut-F-700323", "VGlut-F-600482", "VGlut-F-500237", "VGlut-F-500303",
            "VGlut-F-000391", "VGlut-F-500751", "VGlut-F-700124", "Cha-F-100073",
            "VGlut-F-800275", "VGlut-F-600353", "VGlut-F-900068", "VGlut-F-500118",
            "VGlut-F-700182", "VGlut-F-700504", "VGlut-F-500594", "VGlut-F-600327",
            "fru-F-700187", "Gad1-F-400075", "VGlut-F-600797", "VGlut-F-500828",
            "VGlut-F-700185", "VGlut-F-600471", "VGlut-F-500189", "VGlut-F-700287",
            "VGlut-F-400059", "VGlut-F-600405", "VGlut-F-500026", "VGlut-F-600011",
            "VGlut-F-400138", "VGlut-F-800102", "VGlut-F-400462", "VGlut-F-500839",
            "VGlut-F-700570", "VGlut-F-600145", "VGlut-F-700434", "VGlut-F-700439",
            "VGlut-F-700437", "fru-F-300093", "VGlut-F-700412", "VGlut-F-500248",
            "VGlut-F-900081", "fru-F-500103", "Gad1-F-400129", "VGlut-F-700301",
            "VGlut-F-300641", "VGlut-F-500178", "VGlut-F-700179", "VGlut-F-800048",
            "VGlut-F-500563", "VGlut-F-600146", "VGlut-F-800124", "VGlut-F-500143",
            "VGlut-F-500582", "VGlut-F-500334", "VGlut-F-600725", "VGlut-F-400531",
            "VGlut-F-500626", "VGlut-F-300646", "VGlut-F-700153", "VGlut-F-500772",
            "VGlut-F-600798", "VGlut-F-800118", "VGlut-F-500349", "VGlut-F-700152",
            "VGlut-F-800067", "VGlut-F-300495", "VGlut-F-700358", "VGlut-F-000106",
            "VGlut-F-600558", "VGlut-F-900125", "VGlut-F-500856", "VGlut-F-700123",
            "VGlut-F-300458", "VGlut-F-400280", "VGlut-F-600006", "VGlut-F-600016",
            "VGlut-F-100221", "VGlut-F-500602", "VGlut-F-600443", "VGlut-F-600251",
            "VGlut-F-500211", "VGlut-F-500075", "VGlut-F-700588", "VGlut-F-600232",
            "VGlut-F-500638", "VGlut-F-800121", "VGlut-F-500259", "VGlut-F-500377",
            "VGlut-F-600390", "VGlut-F-700008", "VGlut-F-500502", "VGlut-F-600018",
            "VGlut-F-600751", "VGlut-F-500103", "VGlut-F-600438", "fru-F-700239",
            "VGlut-F-600442", "VGlut-F-700464", "VGlut-F-600452", "VGlut-F-600459",
            "VGlut-F-400664", "VGlut-F-400522", "VGlut-F-500406", "VGlut-F-400730",
            "Gad1-F-900083", "Gad1-F-800206", "VGlut-F-500486", "VGlut-F-400791",
            "VGlut-F-600458", "Gad1-F-800115", "fru-F-400086", "VGlut-F-500781",
            "fru-F-400280", "fru-F-500512", "fru-F-500413", "fru-F-500463",
            "VGlut-F-600316", "VGlut-F-700597", "fru-F-300205", "fru-F-400474",
            "fru-M-500330", "fru-F-400416", "fru-F-400373", "fru-F-400451",
            "fru-F-800031", "VGlut-F-800295", "fru-F-400547", "fru-F-400367",
            "fru-F-500442", "fru-M-400381", "fru-M-400360", "fru-M-500340",
            "fru-M-400248", "VGlut-F-700530", "VGlut-F-700596", "fru-F-600030",
            "VGlut-F-500389", "VGlut-F-500429", "fru-F-400230", "VGlut-F-500146",
            "VGlut-F-600347", "VGlut-F-400739", "VGlut-F-600787", "fru-F-500290",
            "VGlut-F-100368", "fru-M-600008", "VGlut-F-200159", "VGlut-F-200559",
            "VGlut-F-500082", "VGlut-F-200565", "VGlut-F-800072", "VGlut-F-400695",
            "VGlut-F-600322", "VGlut-F-500450", "VGlut-F-500413", "VGlut-F-400677",
            "VGlut-F-600243", "Cha-F-700191", "VGlut-F-800071", "fru-F-500092",
            "VGlut-F-700056", "fru-F-400125", "VGlut-F-100376", "VGlut-F-700289",
            "fru-F-500096", "VGlut-F-700484", "VGlut-F-500420", "VGlut-F-700307",
            "fru-F-500247", "fru-F-600299", "Gad1-F-400173", "VGlut-F-400290",
            "fru-F-300017", "Gad1-F-100006", "Gad1-F-800180", "Gad1-F-800036",
            "Gad1-F-800136", "npf-F-300045", "fru-F-600230", "fru-F-600221",
            "fru-F-600245", "VGlut-F-600248", "VGlut-F-500455", "VGlut-F-700563",
            "VGlut-F-100378", "VGlut-F-500609", "VGlut-F-900060", "fru-F-500503",
            "fru-F-400041", "VGlut-F-600340", "Gad1-F-000432", "VGlut-F-600116",
            "fru-M-000266", "fru-M-500341", "fru-M-500382", "npf-M-300046",
            "npf-M-400000", "fru-M-500211", "fru-M-500214", "fru-M-400285",
            "fru-M-400387", "fru-M-800032", "VGlut-F-200567", "Gad1-F-500068",
            "VGlut-F-500516", "VGlut-F-900045", "VGlut-F-500424", "VGlut-F-700533",
            "VGlut-F-500607", "VGlut-F-700169", "VGlut-F-500107", "VGlut-F-600208",
            "fru-F-500505", "Gad1-F-000264", "npf-F-300012", "fru-F-500472",
            "VGlut-F-700221", "fru-M-400388", "fru-M-300154", "Gad1-F-000235",
            "Gad1-F-300015", "Gad1-F-200057", "VGlut-F-600082", "fru-F-300090",
            "npf-M-400023", "npf-M-100014", "npf-M-200050", "npf-M-100017",
            "npf-M-200047", "npf-M-100016", "npf-M-200045", "npf-M-200065",
            "npf-M-200046", "npf-M-200055", "npf-M-200031", "npf-M-200022",
            "npf-M-200032", "npf-F-200026", "VGlut-F-000055", "Cha-F-000484",
            "npf-M-100004", "npf-M-200021", "npf-M-100009", "npf-M-100011",
            "npf-M-100000", "npf-M-200049", "npf-M-100007", "npf-M-300047",
            "npf-M-100025", "VGlut-F-000126", "npf-F-200030", "npf-M-100010",
            "npf-M-200019", "Gad1-F-000167", "npf-F-300029", "npf-F-200020",
            "npf-F-200029", "npf-F-200027", "npf-F-200028", "npf-F-100004",
            "npf-F-300040", "Gad1-F-100134", "npf-F-200018", "npf-F-100003",
            "npf-F-200022", "npf-F-100009", "npf-F-100011", "npf-F-200019",
            "npf-F-200012", "npf-F-200032", "npf-F-200044", "VGlut-F-000593",
            "VGlut-F-200455", "Gad1-F-200073", "npf-F-000003", "npf-F-100012",
            "npf-F-200007", "npf-F-200013", "npf-F-200034", "npf-F-200003",
            "npf-F-200008", "npf-M-100001", "VGlut-F-200323", "npf-F-100010",
            "npf-F-000000", "npf-F-100007", "npf-F-100001", "npf-F-200001",
            "npf-F-200023", "npf-F-200043", "npf-F-000001", "npf-F-300003",
            "VGlut-F-000426", "npf-F-300001", "npf-F-100000", "npf-F-100008",
            "npf-F-200000", "npf-F-300030", "npf-F-200031", "npf-F-100002",
            "npf-F-200005", "npf-F-200041", "npf-F-200035", "npf-F-200042",
            "npf-F-100006", "npf-M-300052", "npf-M-200040", "npf-M-200066",
            "npf-M-100026", "npf-M-200025", "npf-M-200051", "npf-M-200054",
            "npf-M-200048", "npf-M-200011", "npf-M-200042", "npf-M-100021",
            "npf-M-200053", "npf-M-100027", "npf-M-200023", "npf-M-100005",
            "npf-M-100018", "npf-M-100008", "npf-M-200000", "npf-M-100003",
            "npf-M-100002", "npf-M-200018", "npf-M-100013", "npf-M-200057",
            "VGlut-F-000066", "npf-M-100028", "VGlut-F-400658", "VGlut-F-100381",
            "fru-F-800040", "VGlut-F-000656", "VGlut-F-100370", "VGlut-F-700547",
            "VGlut-F-200597", "VGlut-F-400875", "VGlut-F-700275", "fru-F-400050",
            "fru-F-800019", "VGlut-F-500357", "fru-F-500368", "VGlut-F-500586",
            "VGlut-F-700131", "VGlut-F-700165", "fru-F-900008", "VGlut-F-700321",
            "fru-F-400529", "VGlut-F-600409", "fru-M-400271", "fru-M-400377",
            "Gad1-F-300392", "fru-M-200339", "Gad1-F-400401", "Gad1-F-500217",
            "Gad1-F-100324", "Cha-F-500078", "Gad1-F-100146", "Gad1-F-800042",
            "VGlut-F-200566", "Cha-F-100059", "fru-M-400345", "npf-M-300050",
            "VGlut-F-000563", "Gad1-F-500158", "npf-M-300049", "fru-M-400042",
            "fru-M-300369", "fru-M-600062", "fru-M-500169", "fru-M-700196",
            "fru-M-500123", "fru-M-600215", "fru-M-700157", "fru-M-400355",
            "fru-M-400292", "fru-M-400313", "fru-F-400363", "fru-F-500571",
            "Gad1-F-400353", "fru-M-400130", "fru-F-600263", "fru-F-700165",
            "fru-F-500466", "fru-F-400276", "Gad1-F-500298", "VGlut-F-000035",
            "VGlut-F-500497", "VGlut-F-500169", "VGlut-F-500826", "VGlut-F-700539",
            "npf-F-200009", "npf-M-100006", "npf-M-100012", "npf-M-200038", "Cha-F-200397",
            "Cha-F-200265", "Gad1-F-300381", "fru-M-800212", "Gad1-F-000063",
            "fru-F-400444", "npf-M-200059", "VGlut-F-200029",
            "Gad1-F-000391", "fru-F-000183", "VGlut-F-400927", "fru-M-000325",
            "Gad1-F-000090")
l.upns = c("npf-M-300032", "VGlut-F-300491", "VGlut-F-600326", "fru-F-400149",
           "VGlut-F-700188", "Cha-F-500006", "VGlut-F-800329", "Gad1-F-200064",
           "Gad1-F-700275", "VGlut-F-800317", "Gad1-F-600446", "VGlut-F-000280",
           "VGlut-F-000655", "VGlut-F-700040", "Gad1-F-200010", "Gad1-F-500115",
           "npf-M-300027", "npf-M-300035", "npf-M-300008", "npf-M-400017",
           "fru-M-200319", "Gad1-F-100197", "Gad1-F-300005", "fru-M-100386",
           "VGlut-F-400869", "Gad1-F-000340", "Gad1-F-200328", "Gad1-F-300322",
           "fru-M-400216", "Gad1-F-300144", "Cha-F-800119", "Cha-F-000479",
           "VGlut-F-700515", "Gad1-F-000103", "VGlut-F-200188", "VGlut-F-600262",
           "VGlut-F-900046", "Cha-F-100085", "Gad1-F-600219", "fru-M-400327",
           "fru-F-700058", "VGlut-F-300622", "VGlut-F-700132", "VGlut-F-600767",
           "VGlut-F-700460", "VGlut-F-300629", "VGlut-F-300635", "VGlut-F-600492",
           "VGlut-F-600772", "VGlut-F-200598", "VGlut-F-800259", "VGlut-F-500774",
           "Cha-F-300415", "VGlut-F-600753", "VGlut-F-700494", "Gad1-F-400168",
           "Gad1-F-600296", "fru-F-700119", "VGlut-F-400067", "Gad1-F-700150",
           "fru-F-000120", "VGlut-F-600107", "npf-F-300042", "VGlut-F-400514",
           "VGlut-F-400008", "VGlut-F-200267", "VGlut-F-200047", "VGlut-F-600445",
           "fru-F-400468", "npf-M-200024", "npf-M-400020", "npf-M-300028",
           "npf-M-300006", "npf-M-400018", "GH146-M-400001", "VGlut-F-200574",
           "VGlut-F-600450", "npf-M-300041", "Gad1-F-900035", "Cha-F-300252",
           "fru-M-400325", "VGlut-F-400678", "fru-F-400051", "Cha-F-300104",
           "Gad1-F-000192", "fru-F-000025", "Gad1-F-400171", "fru-M-400223",
           "fru-M-400380", "npf-M-300048", "npf-M-100022", "npf-F-300020",
            "fru-M-600178",
           "Cha-F-300238",
           "VGlut-F-900120", "VGlut-F-400620", "VGlut-F-500461", "VGlut-F-200569", "VGlut-F-700463",
           "npf-M-200063", "fru-M-400375", "Cha-F-800120", "Gad1-F-100269",
           "Gad1-F-300329", "VGlut-F-500412", "VGlut-F-700167",
           "VGlut-F-200568", "VGlut-F-400000", "VGlut-F-300596", "VGlut-F-500431",
           "VGlut-F-600209", "VGlut-F-700465", "Gad1-F-300227", "Gad1-F-400346",
            "VGlut-F-400794", "VGlut-F-600175", "VGlut-F-300573",
           "fru-M-100396", "fru-M-100331")

bilateral.VL1.upns = c("Gad1-F-000286","Gad1-F-700120") # GNG cell body Vl1
bilateral.VP3.upns = c("Cha-F-000250",  "Gad1-F-200188") # GNG cell body VP3

# Meta Data
malt.upns = c(ad.upns,l.upns,bilateral.VL1.upns,bilateral.VP3.upns)
df[malt.upns,]$modality = "Olfactory"
df[malt.upns,]$reference = "Jefferis et al. 2007"
df[c(malt.upns,bilateral.VL1.upns,bilateral.VP3.upns),]$type = "uPN"
df[malt.upns,]$dendritic.location = "AL"
df[malt.upns,]$tract = "mALT"
df[malt.upns,]$neurotransmitter = "ACh"

df[c(ad.upns,l.upns),"anatomy.group"] = "AL-mALT-PN1"
df[c(bilateral.VL1.upns,bilateral.VP3.upns),"anatomy.group"] = "AL-mALT-PN2"

df[ad.upns,]$cell.body.position = "AD"
df[l.upns,]$cell.body.position = "L"
df[c(bilateral.VL1.upns,bilateral.VP3.upns),]$cell.body.position = "GNG"

df[c(bilateral.VL1.upns),]$glomerulus = "VL1"
df[c(bilateral.VP3.upns),]$glomerulus = "VP3"

df[c(bilateral.VP3.upns),]$modality = "Thermosensory"
df[bilateral.VP3.upns,]$reference = "Stocker et al. 1990"






###### Assign mALT mPNs ######






l.malt.mpns.pal.plp = c("VGlut-F-000463", "Cha-F-300107", "VGlut-F-700115", "Cha-F-000271",
                        "Cha-F-300036")
df[l.malt.mpns.pal.plp,"anatomy.group"] = "AL-mALT-PN4"

l.malt.mpns.pal = c("VGlut-F-500570", "VGlut-F-600525", "VGlut-F-700198", "VGlut-F-800095",
                    "VGlut-F-100367", "VGlut-F-600690", "VGlut-F-700154", "VGlut-F-600301",
                    "VGlut-F-600300", "VGlut-F-600783", "VGlut-F-900121", "VGlut-F-500077",
                    "VGlut-F-600668", "VGlut-F-700214", "VGlut-F-000485", "VGlut-F-600106",
                    "VGlut-F-600737", "VGlut-F-500094", "Gad1-F-300036", "VGlut-F-600641",
                    "Gad1-F-100061", "VGlut-F-600310", "Gad1-F-200107", "VGlut-F-700471",
                    "VGlut-F-800289", "VGlut-F-500786", "VGlut-F-500299", "VGlut-F-900113",
                    "VGlut-F-100264", "VGlut-F-700079", "VGlut-F-900112", "VGlut-F-600795",
                    "Cha-F-000239")
df[l.malt.mpns.pal,"anatomy.group"] = "AL-mALT-PN5"

ad.mpns.calyx = c("VGlut-F-500407", "Trh-F-000062", "VGlut-F-400407", "VGlut-F-400376",
                  "VGlut-F-600770", "VGlut-F-900059", "VGlut-F-300623", "fru-F-500176",
                  "VGlut-F-600245", "VGlut-F-800323", "VGlut-F-400434", "VGlut-F-600366",
                  "VGlut-F-500852", "VGlut-F-700567", "VGlut-F-500183", "VGlut-F-600253",
                  "VGlut-F-500471", "VGlut-F-700500", "VGlut-F-500085", "VGlut-F-600379",
                  "VGlut-F-700558", "VGlut-F-500667", "Cha-F-300016", "Gad1-F-500299"
) # AD cell body position. Calycal projection
ad.mpns.no.calyx = c("VGlut-F-500031", "VGlut-F-400662", "VGlut-F-300628", "Gad1-F-500312",
                     "fru-M-500036")
l.mpns.no.calyx = c("Cha-F-000353", "Gad1-F-000384","Cha-F-200388")
df[c(ad.mpns.calyx,ad.mpns.no.calyx,l.mpns.no.calyx),"anatomy.group"] = "AL-mALT-PN6"

l.mpns = c("fru-M-000134", "fru-M-400296", "Trh-F-600015", "VGlut-F-700476",
           "VGlut-F-900120", "VGlut-F-400620", "Cha-F-800120", "Gad1-F-100269",
           "Gad1-F-300329") # No Calyx Projection. V cell body location.
df[l.mpns,"anatomy.group"] = "AL-mALT-PN7"

l.mpns.claw = c("VGlut-F-500857", "VGlut-F-500358", "VGlut-F-600123", "VGlut-F-600384",
                "VGlut-F-600791", "VGlut-F-600748")
df[l.mpns.claw,"anatomy.group"] = "AL-mALT-PN8"

ad.mpns.sp = c("VGlut-F-700407", "VGlut-F-400370", "VGlut-F-200354", "5HT1A-F-400030","VGlut-F-300263")
df[ad.mpns.sp,"anatomy.group"] = "AL-mALT-PN9"

l.mpns.sp = c("Cha-F-300398", "Gad1-F-100169", "Cha-F-000183", "E0585-F-200014")
df[l.mpns.sp,"anatomy.group"] = "AL-mALT-PN10"

l.gng.mpns.sp = c("Gad1-F-400282", "5HT1A-F-800014", "VGlut-F-700270")
df[l.gng.mpns.sp,"anatomy.group"] = "AL-mALT-PN11"

# Meta data
malt.mpns = c(l.malt.mpns.pal, l.malt.mpns.pal.plp, ad.mpns.calyx,ad.mpns.no.calyx,l.mpns.no.calyx,l.mpns,l.mpns.claw,ad.mpns.sp,l.mpns.sp,l.gng.mpns.sp)
df[malt.mpns,]$modality = "Olfactory"
df[l.gng.mpns.sp,]$modality = "Olfactory+Gustatory"
df[c(l.malt.mpns.pal,l.malt.mpns.pal.plp),]$modality = "Thermosensory"
df[malt.mpns,]$reference = "ASB"
df[c(l.malt.mpns.pal, l.malt.mpns.pal.plp),]$reference = "Frank et al. 2015"
df[malt.mpns,]$type = "mPN"
df[malt.mpns,]$dendritic.location = "AL"
df[l.gng.mpns.sp,]$dendritic.location = "AL.GNG"
df[malt.mpns,]$tract = "mALT"
df[malt.mpns,]$neurotransmitter = "ACh"
df[c(l.malt.mpns.pal.plp,l.malt.mpns.pal,l.mpns.no.calyx,l.mpns,l.mpns.claw,l.mpns.sp,l.gng.mpns.sp),]$cell.body.position = "L"
df[c(ad.mpns.calyx,ad.mpns.no.calyx,ad.mpns.sp),]$cell.body.position = "AD"





###### Assign mALT Neuromodulators ######





al.ca.lh.malt = c("Trh-F-600017", "Gad1-F-800089", "Gad1-F-800106")
df[al.ca.lh.malt,"anatomy.group"] = "AL-mALT-5HT1"
df[al.ca.lh.malt,]$reference = "Tanaka et al. 2012"
df[al.ca.lh.malt,]$modality = "Neuromodulatory"
df[al.ca.lh.malt,]$tract = "mALT"
df[al.ca.lh.malt,]$dendritic.location = "AL"
df[al.ca.lh.malt,]$neurotransmitter = "5HT"
df[al.ca.lh.malt,]$cell.body.position = "L"

al.gng.ca.lh.malt = c("Tdc2-F-000007", "Tdc2-F-400026")
df[al.gng.ca.lh.malt,"anatomy.group"] = "AL.GNG-OA-VUMa2"
df[al.gng.ca.lh.malt,]$reference = "Busch et al. 2009"
df[al.gng.ca.lh.malt,]$modality = "Neuromodulatory"
df[al.gng.ca.lh.malt,]$tract = "mALT"
df[al.gng.ca.lh.malt,]$dendritic.location = "Eosophagus"
df[al.gng.ca.lh.malt,]$neurotransmitter = "Oct"
df[al.gng.ca.lh.malt,]$cell.body.position = "GNG"





###### Assign mlALT PNs ######





mlalt.upns = c("Gad1-F-500077", "VGlut-F-400917", "VGlut-F-800247", "fru-F-300036",
               "5-HT1B-M-300003", "Gad1-F-400088","fru-F-500420", "Gad1-F-000185", "Cha-F-500249", "Gad1-F-200451")
df[mlalt.upns,"anatomy.group"] = "AL-mlALT-PN1"

mlalt.mpns = c("VGlut-F-300636", "VGlut-F-700218", "VGlut-F-400167", "VGlut-F-600556",
               "VGlut-F-400263", "VGlut-F-700473", "Trh-F-600066", "VGlut-F-500817",
               "Trh-F-600007", "VGlut-F-700076", "VGlut-F-400225", "VGlut-F-500114",
               "VGlut-F-700559", "VGlut-F-700420", "fru-F-700180", "Trh-F-900010",
               "VGlut-F-700523", "VGlut-F-900124", "fru-F-500222", "fru-F-700150",
               "VGlut-F-400165", "VGlut-F-300532", "Trh-F-600014", "Trh-F-600084",
               "VGlut-F-200517", "VGlut-F-800270", "Trh-F-600095", "Trh-F-000032",
               "VGlut-F-600669", "VGlut-F-300274", "Trh-F-600092", "Trh-F-500004",
               "VGlut-F-400178", "VGlut-F-700022", "Trh-F-500077", "VGlut-F-500824",
               "Trh-F-500152", "Trh-F-600108", "VGlut-F-700410", "VGlut-F-500848",
               "Trh-F-500046", "VGlut-F-600023", "fru-F-600120", "VGlut-F-600757",
               "Trh-F-500059", "VGlut-F-200315", "VGlut-F-500761", "Trh-F-500199",
               "VGlut-F-400172", "VGlut-F-500205", "Trh-F-500049", "Trh-F-300080",
               "Trh-F-500061", "Trh-F-600072", "Trh-F-800002", "Trh-F-600104",
               "Trh-F-900031", "VGlut-F-500787", "Trh-F-700019", "VGlut-F-700569",
               "VGlut-F-700428", "Trh-M-900023", "Trh-M-600114", "fru-M-400109",
               "Trh-M-700027", "Trh-M-700084", "Trh-M-500061", "Trh-M-400028",
               "fru-M-400087", "Trh-M-500165", "Trh-M-600062", "Trh-M-900035",
               "fru-M-800089", "fru-M-300273", "fru-M-800076", "fru-M-000089",
               "Trh-M-600105", "Trh-F-600090", "Trh-M-600014", "Trh-M-900034",
               "Trh-M-500007", "Trh-M-700005", "Trh-M-600032", "Trh-M-500053",
               "Trh-M-400043", "Trh-M-500005", "VGlut-F-100246", "Trh-F-500114",
               "Trh-F-600077", "VGlut-F-500687", "fru-F-500211", "Trh-M-600013",
               "Trh-M-900012", "Cha-F-000093", "GH146-M-300000", "Gad1-F-500088",
               "Trh-F-400014", "VGlut-F-400096", "VGlut-F-500230", "VGlut-F-500473",
               "VGlut-F-500829", "Trh-F-400030", "VGlut-F-600060", "VGlut-F-200571",
               "VGlut-F-700514", "Gad1-F-300091", "VGlut-F-400634", "VGlut-F-800128",
               "VGlut-F-800257", "VGlut-F-700243", "VGlut-F-500199", "Gad1-F-900027",
               "VGlut-F-800284", "VGlut-F-700501", "GH146-M-300001", "VGlut-F-500300",
               "VGlut-F-500721", "VGlut-F-500092", "VGlut-F-000575", "VGlut-F-500809",
               "VGlut-F-700552", "VGlut-F-800290", "VGlut-F-400086", "VGlut-F-700269",
               "Trh-M-400074", "Trh-M-600076", "Trh-M-700024", "Trh-M-500106",
               "Trh-M-400040", "Trh-M-500043", "Trh-M-700025", "Trh-M-500018",
               "Trh-M-700069", "Trh-M-500146", "Trh-M-400082", "Trh-M-500094",
               "Trh-M-500180", "Trh-M-700009", "Trh-M-700058", "Trh-F-700038",
               "Trh-F-400067", "Trh-F-700032", "Trh-F-500211", "VGlut-F-400151",
               "Trh-F-400000", "Trh-F-500135", "VGlut-F-300627", "Trh-F-500220",
               "Trh-F-700021", "VGlut-F-500039", "Trh-F-500200", "VGlut-F-500038",
               "VGlut-F-800276", "Trh-F-700034", "Trh-F-500213", "VGlut-F-400408",
               "Trh-F-500217", "VGlut-F-400111", "VGlut-F-700044", "VGlut-F-600691",
               "Trh-F-500124", "Trh-F-500036", "Trh-F-500027", "Trh-F-600011",
               "Trh-F-700035", "VGlut-F-500197","5HT1A-M-300002", "Gad1-F-100151", "Gad1-F-700193", "Gad1-F-300166",
               "Gad1-F-700238", "Gad1-F-500168", "Gad1-F-600191", "VGlut-F-600553",
               "VGlut-F-700267", "fru-F-500439", "Gad1-F-400339", "fru-M-100354",
               "fru-M-700209", "fru-M-700289", "fru-M-000258", "fru-M-600160",
               "fru-M-600175", "fru-M-600150", "fru-M-100310", "fru-M-800120",
               "fru-M-800128", "fru-M-400267", "fru-M-500395", "fru-F-800076",
               "Cha-F-100467", "fru-F-400442", "Gad1-F-000163", "Gad1-F-200348",
               "Gad1-F-100111", "Gad1-F-800133", "5HT1A-F-400013", "Gad1-F-300324",
               "Gad1-F-400219", "Gad1-F-300281", "Gad1-F-400395", "VGlut-F-400720",
               "Gad1-F-300249", "Gad1-F-700134", "Gad1-F-100234", "5HT1A-M-600017",
               "Gad1-F-500128", "Gad1-F-900162", "Gad1-F-000395", "VGlut-F-500551",
               "fru-M-600148", "fru-F-500485", "fru-F-500412", "Gad1-F-600294",
               "5HT1A-F-600006", "fru-F-600185", "Gad1-F-400314","Cha-F-300458","Gad1-F-900093",
               "5HT1A-M-600015", "VGlut-F-300564","Gad1-F-300382")
df[mlalt.mpns,"anatomy.group"] = "AL-mlALT-PN2"

al.mlpn3 = c("GH146-M-000001", "GH146-F-300000", "GH146-M-400000")
df[al.mlpn3,"anatomy.group"] = "AL-mlALT-PN3"

# Meta data
mlalt.mpns = c(mlalt.upns,mlalt.mpns,al.mlpn3)
df[mlalt.mpns,]$modality = "Olfactory"
df[mlalt.mpns,]$reference = "Strutz et al. 2014"
df[mlalt.mpns,]$type = "mPN"
df[mlalt.upns,]$type = "uPN"
df[mlalt.mpns,]$dendritic.location = "AL"
df[mlalt.mpns,]$cell.body.position = "V"
df[mlalt.mpns,]$tract = "mlALT"
df[mlalt.mpns,]$neurotransmitter = "GABA"





###### Assign lALT PNs ######





lalt.uni = "Gad1-F-200095" #V
df[lalt.uni,"anatomy.group"] = "AL-lALT-PN1"
df[lalt.uni,"glomerulus"] = "V"

lalt.mpns2 = c("Trh-M-000170", "Trh-M-000008", "Trh-M-000070", "VGlut-F-100003",
               "Trh-M-000172", "Trh-M-100037", "Trh-F-000043", "Trh-F-000041",
               "VGlut-F-000430", "VGlut-F-000624", "Trh-F-100037", "Trh-F-100038",
               "Trh-F-000008", "Trh-F-000009", "Trh-F-100032", "VGlut-F-000259",
               "VGlut-F-000370", "Gad1-F-000431", "VGlut-F-100272", "VGlut-F-100184",
               "5HT1A-F-100004", "5HT1A-F-100032", "Cha-F-500056", "Gad1-F-200299")
df[lalt.mpns2,"anatomy.group"] = "AL-lALT-PN2"

lalt.mpns3 ="Cha-F-900038"
df[lalt.mpns3,"anatomy.group"] = "AL-lALT-PN3"

lalt.mpns5 = c("Trh-M-200074", "Gad1-F-400223", "fru-M-200462", "Cha-F-500003",
               "Gad1-F-200342", "fru-F-000086", "fru-F-000197", "GH146-M-000000",
               "Gad1-F-400131", "fru-M-000094", "fru-M-400192")
df[lalt.mpns5,"anatomy.group"] = "AL-lALT-PN5"

from.contra.lalt = c("Trh-M-000103", "Trh-M-200128",
                     "Trh-M-100007", "Trh-M-100003", "Trh-M-100095")
df[from.contra.lalt,"anatomy.group"] = "AL-lALT-PN6"

from.contra.ipsi.lalt = c("VGlut-F-200051", "VGlut-F-200077")
df[from.contra.ipsi.lalt,"anatomy.group"] = "AL-lALT-PN7"

# Meta data
lalt.pns = c(lalt.uni,lalt.mpns2,lalt.mpns3,lalt.mpns5,from.contra.lalt,from.contra.ipsi.lalt)
df[lalt.pns,]$modality = "Olfactory"
df[lalt.mpns5,]$modality = "Thermosensory"
df[lalt.pns,]$reference = "Tanaka et al. 2012"
df[lalt.mpns5,]$reference = "Frank et al. 2015"
df[lalt.pns,]$type = "mPN"
df[c(lalt.uni,lalt.mpns5),]$type = "uPN"
df[lalt.pns,]$dendritic.location = "AL"
df[lalt.pns,]$cell.body.position = "L"
df[lalt.pns,]$tract = "lALT"
df[lalt.pns,]$neurotransmitter = "ACh"
df[lalt.uni,]$glomerulus = "V"
df[lalt.uni,]$reference = "Lin et al. 2015"










###### Assign tALT PNs ######






v.glom.upns = c("fru-M-000035", "VGlut-F-200269") # last two are V. tALT?
df[v.glom.upns,"anatomy.group"] = "AL-t1ALT-PN1"

talt.mpns = c("Cha-F-300207",   "Cha-F-300191",  "VGlut-F-100267", "VGlut-F-000276" ,"VGlut-F-100102")
df[talt.mpns,"anatomy.group"] = "AL-t3ALT-PN2"

talt.sp = ("VGlut-F-000189")
df[talt.sp,"anatomy.group"] = "AL-t3ALT-PN3"

talt.pn4 = c("VGlut-F-300085", "VGlut-F-300235", "VGlut-F-300555", "VGlut-F-300575",
             "VGlut-F-500322", "VGlut-F-200386", "VGlut-F-300327")
df[talt.pn4,"anatomy.group"] = "AL-t3ALT-PN4"

# Meta data
talt.pns = c(v.glom.upns,talt.mpns,talt.sp,talt.pn4)
df[talt.pns,]$modality = "Olfactory"
df[talt.mpns,]$modality = "Thermosensory"
df[talt.pns,]$reference = "ASB"
df[c(v.glom.upns),]$reference = "Tanaka et al. 2012"
df[talt.pns,]$type = "mPN"
df[talt.pns,]$dendritic.location = "AL"
df[talt.pns,]$cell.body.position = "L"
df[talt.pn4,]$cell.body.position = "AD"
df[talt.pns,]$tract = "t3ALT"
df[talt.pns,]$tract = "tALT"
df[talt.pns,]$neurotransmitter = "ACh"

df[talt.mpns,]$modality = "Thermosensory"
df[c(v.glom.upns),]$glomerulus = "V"
df[c(v.glom.upns),]$reference = "Lin et al. 2015"







###### Assign Gustatory PNs ######





gust.malt = c("5HT1A-F-400025", "5HT1A-F-800022")
df[gust.malt,"anatomy.group"] = "GNG-mALT-PN1"

gust.lalt = c("fru-F-000219","fru-M-300287","fru-M-300451","fru-M-800005","fru-M-100062","fru-M-800155", "fru-M-600165","fru-M-200364")
df[gust.lalt,"anatomy.group"] = "GNG-lALT-PN1"

gusts.talt = c("Cha-F-400018","VGlut-F-300341","VGlut-F-000295","VGlut-F-500260","VGlut-F-100128")
df[gusts.talt,"anatomy.group"] = "GNG-t3ALT-PN1"

gusts.central = c("fru-M-300314")
df[gusts.central,"anatomy.group"] = "GNG-Central-PN1"

mAL = c("fru-F-600207","Gad1-F-600213","Gad1-F-400450","fru-M-600142","fru-M-700040","fru-M-000273","fru-M-500159","fru-M-400140","fru-M-500247","fru-M-000152")
df[mAL,"anatomy.group"] = "mAL-PN"

# Meta data
gusts = c(gust.malt,gust.lalt,lalt.mpns3,gusts.talt,gusts.central,mAL)
df[gusts,]$modality = "Gustatory"
df[gusts,]$reference = "ASB"
df[gusts,]$dendritic.location = "AL"
df[gusts,]$cell.body.position = "L"
df[gust.malt,]$tract = "mALT"
df[gust.lalt,]$tract = "lALT"
df[gusts.talt,]$tract = "t3ALT"
df[gusts.central,]$tract = "Central"
df[mAL,]$tract = "mAL"
df[gusts,]$neurotransmitter = "ACh"
df[mAL,]$neurotransmitter = "GABA"
df[mAL,]$reference ="Kimura et al. 2010"





###### Assign Other LH inputs ######





###

wedge.pn = c("VGlut-F-600117", "Gad1-F-100133", "VGlut-F-500810",
             "VGlut-F-100375", "fru-M-300059", "Cha-F-000514", "Cha-F-600036")
df[wedge.pn,"anatomy.group"] = "AMMC-PN1"
df[wedge.pn,]$modality = "Mechanosensation"
df[wedge.pn,]$reference = "ASB"
df[wedge.pn,]$dendritic.location = "WED"
df[wedge.pn,]$cell.body.position = "WED"
df[wedge.pn,]$tract = "WEDT"
df[wedge.pn,]$neurotransmitter = "Unknown"

###

mbonap3 =  c("Gad1-F-700088", "E0585-F-200005", "Gad1-F-400293", "Cha-F-800086")
mbonap2ap3 = c("Gad1-F-400259","E0585-F-200015","E0585-F-300042")
mbonap= c(mbonap3,mbonap2ap3)
df[mbonap2ap3,"anatomy.group"] = "MBON-a'2-a'3"
df[mbonap3,"anatomy.group"] = "MBON-a'2-a'3"
df[mbonap,"anatomy.group"] = "Centrofugal"
df[mbonap,]$modality = "Centrofugal"
df[mbonap,]$reference = "ASB"
df[mbonap3,]$reference = "Aso et al. 2014"
df[mbonap,]$dendritic.location = "MB"
df[mbonap,]$cell.body.position = "SP"
df[mbonap,]$tract = "Centrofugal"
df[mbonap,]$neurotransmitter = "ACh"

###

centrofugal = c("VGlut-F-200116","Gad1-F-700066")
df[centrofugal,"anatomy.group"] = "Centrofugal"
df[centrofugal,]$modality = "Centrofugal"
df[centrofugal,]$reference = "ASB"
df[centrofugal,]$dendritic.location = "SP"
df[centrofugal,]$cell.body.position = "SP"
df[centrofugal,]$tract = "Centrofugal"
df[centrofugal,]$neurotransmitter = "Unknown"

###

unknowns = c("fru-M-300418", "fru-M-800154", "TH-M-100006", "TH-M-000001",
             "TH-M-100010", "fru-M-700238", "TH-M-300030", "TH-M-100000",
             "fru-M-500333", "fru-M-200392", "TH-M-100083", "TH-M-000063",
             "TH-M-000064", "TH-M-200055", "TH-M-100005", "TH-M-300036", "TH-F-200113",
             "TH-M-100021", "TH-M-200011", "TH-M-800000", "TH-M-100080", "TH-M-200053",
             "TH-M-200025", "TH-M-200047", "TH-F-000005", "TH-F-300048", "TH-F-000007",
             "TH-F-100061", "TH-F-000098", "TH-F-500002", "TH-F-000102", "TH-F-200129",
             "TH-F-000066", "TH-F-000081", "fru-F-400501", "TH-F-300015",
             "TH-F-100097", "fru-M-400054", "fru-M-100262", "fru-F-700132",
             "VGlut-F-100132", "VGlut-F-800203", "VGlut-F-100147", "VGlut-F-400519",
             "fru-F-100083", "VGlut-F-000200", "TH-F-000086", "TH-F-100101",
             "TH-F-100111", "TH-F-000095", "TH-F-100105", "TH-F-100108", "TH-F-200018",
             "TH-F-100103", "TH-M-300008", "TH-F-100047", "TH-F-000062", "TH-M-100041",
             "TH-F-200011", "TH-F-100073", "TH-F-000104", "TH-F-000067", "TH-F-000076",
             "TH-F-100090", "TH-F-100045", "TH-F-300004", "TH-F-100065", "TH-F-200025",
             "TH-F-000003", "TH-F-000044", "TH-F-000096", "TH-F-200035", "TH-F-100037",
             "TH-F-200019", "TH-M-100008", "TH-F-300006", "TH-F-100003", "TH-M-000059",
             "TH-M-500002", "TH-M-100058", "TH-M-000024", "TH-M-000000", "TH-M-200056",
             "TH-M-100071", "TH-M-300041", "TH-M-200036", "TH-M-500001", "TH-M-000065",
             "TH-M-100003", "TH-M-000031", "TH-M-400002", "TH-M-100012", "TH-M-000002",
             "TH-M-100033", "TH-M-000069", "TH-M-200062", "TH-M-300020", "fru-F-500552",
             "fru-M-800167", "fru-M-100135", "fru-M-200484", "fru-M-600171",
             "fru-M-100392", "fru-M-200422", "fru-M-400364", "fru-M-200246",
             "fru-M-600093")
df[unknowns,"anatomy.group"] = "Expansive-Putative"
df[unknowns,]$modality = "Unknown"
df[unknowns,]$reference = "ASB"
df[unknowns,]$dendritic.location = "Uncertain"
df[unknowns,]$cell.body.position = "PD6"
df[unknowns,]$tract = "Uncertain"
df[unknowns,]$neurotransmitter = "Unknown"






###### Assign not proper LH input ######





notLHPNproper = c("VGlut-F-300371","fru-M-300137","fru-M-600016","fru-M-000092", "fru-M-400395", "npf-F-000009","Gad1-F-200162","Cha-F-900049","Cha-F-000324","Gad1-F-500304","Gad1-F-500108",
                  "fru-F-100103","Gad1-F-100227","fru-M-900056","TH-F-100094","fru-F-200195","fru-M-400235","Gad1-F-800188","fru-M-300291","Gad1-F-600120",
                  "fru-M-500164", "Trh-M-200073", "Cha-F-700234", "Gad1-F-500259","npf-M-400021","VGlut-F-000488","VGlut-F-300369","GH146-M-400001","VGlut-F-000344","VGlut-F-000547") #Some suspected developmental wiring errors
df[notLHPNproper,"anatomy.group"] = "notLHproper"
df[notLHPNproper,]$modality = "Unknown"
df[notLHPNproper,]$reference = "ASB"
df[notLHPNproper,]$dendritic.location = "Uncertain"
df[notLHPNproper,]$cell.body.position = "PD6"
df[notLHPNproper,]$tract = "Uncertain"
df[notLHPNproper,]$neurotransmitter = "Unknown"







###### Re-attach data.frame ######





df$anatomy.group = factor(df$anatomy.group,levels = sort(unique(df$anatomy.group)))
attr(lh.inputs,"df") = df






###### Generate new object ######





### save
devtools::use_data(lh.inputs,overwrite=TRUE)





