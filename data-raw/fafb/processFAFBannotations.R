# Load packages
library(natverse)
library(hemibrainr)

# Get meta
em.lh.meta.orig = read.csv("data-raw/csv/em_papers_lh_cell_types.csv")
skids = as.character(em.lh.meta.orig$skid)
rownames(em.lh.meta.orig) = skids

# Add missing synonyms
# lm.matches = lm_matches()
# jj.matches = lm.matches[grepl("JJ",rownames(lm.matches)),]
# for(j in rownames(jj.matches)){
#   ct = jj.matches[j,"cell.type"]
#   if(ct %in% em.lh.meta.orig$cell_type){
#     jt = jfw.lhns[j,"JJtype"]
#     syns = unique(em.lh.meta.orig[em.lh.meta.orig$cell_type==ct,"other_names"])
#     syns = strsplit(syns,split=";|; ")
#     syns = unlist(syns)
#     syns = syns[syns!="none"]
#     syns = unique(c(syns, paste0(jt," (Jeanne et al 2018)")))
#     syns = paste(syns, collapse = "; ")
#     em.lh.meta.orig[em.lh.meta.orig$cell_type==ct,"other_names"] = syns
#   }
# }

# Get old frechter type
most.lh = nat::union(most.lhns, most.lhins)
em.lh.meta.orig$frechter.cell.type = most.lh[em.lh.meta.orig$closest_light_match,"frechter.cell.type"]
em.lh.meta.orig$frechter.cell.type[em.lh.meta.orig$LM_match_quality!="cell.type"] = ""
em.lh.meta.orig$frechter.cell.type[is.na(em.lh.meta.orig$frechter.cell.type)] = ""
em.lh.meta.orig$frechter.cell.type[em.lh.meta.orig$frechter.cell.type=="notLHproper"] = ""

# Get meta annotations
mnames = catmaid_query_meta_annotations("neuron name")

# For neuron in skids
## Set annotions
### Make sure certain annotations are unique
new.names = papers = citations = statuses = cell.types = cats = matches = synonyms = c()
for(sk in skids){

  # Get annotations
  a = catmaid_get_annotations_for_skeletons(sk)
  p = a$annotation[grepl("Paper: |paper: ",a$annotation)]
  p = p[grepl("Huoviala|Dolan|Frechter|Bates|Marin", p)] # only touch 'our' papers
  c = a$annotation[grepl("Citation: |citation: ",a$annotation)]
  ct = a$annotation[grepl("Cell_type: |cell_type: ",a$annotation)]
  n = a$annotation[grepl("New_name: |new_name: |name: |Name:",a$annotation)]
  n = c(n, a$annotation[a$id%in%mnames$id])
  s = a$annotation[grepl("Status: |status: ",a$annotation)]
  cat = catmaid::catmaid_get_neuronnames(sk)
  syn = a$id[grepl("Synonym: |synonym: ",a$annotation)]

  # remove annotions
  if(length(n)){
    tryCatch(catmaid::catmaid_remove_annotations_for_skeletons(skids = sk, annotations = n, force = TRUE),
             error = function(e) NULL)
  }
  if(length(s)){
    tryCatch(catmaid::catmaid_remove_annotations_for_skeletons(skids = sk, annotations = s, force = TRUE),
    error = function(e) NULL)
  }
  if(length(ct)){
    tryCatch(catmaid::catmaid_remove_annotations_for_skeletons(skids = sk, annotations = ct, force = TRUE),
    error = function(e) NULL)
  }
  if(length(p)){
    tryCatch(catmaid::catmaid_remove_annotations_for_skeletons(skids = sk, annotations = p, force = TRUE),
    error = function(e) NULL)
  }
  if(length(syn)){
    tryCatch(catmaid::catmaid_remove_annotations_for_skeletons(skids = sk, annotations = syn, force = TRUE),
             error = function(e) NULL)
  }

  # Decide on annotations
  # Match
  ## match
  ms = em.lh.meta.orig[sk,"hemibrain_match"]
  ms = strsplit(ms,split=";|; ")
  ms = unique(unlist(ms))
  ams = paste0('hemibrain_match: ', ms)
  ## paper
  ps = em.lh.meta.orig[sk,"paper"]
  ps = strsplit(ps,split=";|; ")
  ps = unique(unlist(ps))
  ps = ps[!grepl("Jeanne|Mohamed|Fisek|Varela|Aso|Namiki|Zhang",ps)]
  ps = gsub("al\\.","al",ps)
  aps = paste0('Paper: ', ps)
  ## Citation
  cs = em.lh.meta.orig[sk,"all_citations"]
  cs = strsplit(cs,split=";|; ")
  cs = unique(unlist(cs))
  acs = paste0('Citation: ', cs)
  ## name
  ns = em.lh.meta.orig[sk,"cell"]
  ns = strsplit(ns,split=";|; ")
  ns = unlist(ns)
  ans = ns #paste0('new_name: ', ns)
  ## cell type
  cts = em.lh.meta.orig[sk,"cell_type"]
  cts = unlist(cts)
  acts = paste0('cell_type: ', cts)
  ## Tracing
  ss = em.lh.meta.orig[sk,"status"]
  ss = unlist(ss)
  ass = paste0('status: ', ss)
  ## Synonyms from Frechter et al.
  ### Frechter type synonyms
  ssyn = em.lh.meta.orig[sk,"frechter.cell.type"]
  if(!is.na(ssyn)){
    if(ssyn!="" & !grepl("WED|MB",ssyn)){
      change = (ssyn!=cts)&(ssyn!=gsub("LH","",cts))
      if(change){
        ssyn = unlist(ssyn)
        cit = unique(sort(intersect(cs,c("Frechter et al 2019", "Dolan et al 2019"))))
        if(!length(cit)){ cit = "Frechter et al 2019"}
        assyn = paste0('synonym: ', ssyn," (", paste(unique(cit),collapse="; "),")")
      }else{
        assyn = NULL
      }
    }else{
      assyn = NULL
    }
  }else{
    assyn = NULL
  }
  ### Other synonyms
  osyyn = em.lh.meta.orig[sk,"other_names"]
  osyyn = strsplit(osyyn,split="/|/ ")
  osyyn = unlist(osyyn)
  osyyn = osyyn[osyyn!="none"]
  if(length(osyyn)){
    osyyn = paste0('synonym: ', osyyn)
  }
  assyn = unique(c(assyn, osyyn))
  # Whimsical name
  new_cat = gsub(".*[0-9]{5}","",cat)
  new_cat = paste(ns, as.numeric(sk)+1, new_cat, sep = " ")
  acat = paste0('name: ', new_cat)
  acat = gsub("  "," ", acat)

  # Set annotations
  catmaid::catmaid_set_annotations_for_skeletons(skids = sk, annotations = c(ans, aps, acts, ass, acat, ams, assyn, acs))
  catmaid::catmaid_set_annotations_for_skeletons(skids = sk, annotations = "FAFB_published")

  # Collect
  new.names = unique(c(new.names, ans))
  papers = unique(c(papers, aps))
  statuses = unique(c(statuses, ass))
  cell.types = unique(c(cell.types, acts))
  cats = unique(c(cats, acat))
  matches = unique(c(matches, ams))
  synonyms = unique(c(synonyms, assyn))
  citations = c(citations, acs)

}

# Set meta annotations
catmaid::catmaid_set_meta_annotations(meta_annotations = "neuron name", annotations = new.names)
catmaid::catmaid_set_meta_annotations(meta_annotations = "paper", annotations = papers)
catmaid::catmaid_set_meta_annotations(meta_annotations = "tracing status", annotations = statuses)
catmaid::catmaid_set_meta_annotations(meta_annotations = "cell type", annotations = cell.types)
catmaid::catmaid_set_meta_annotations(meta_annotations = "whimsical name", annotations = cats)
catmaid::catmaid_set_meta_annotations(meta_annotations = "hemibrain match", annotations = matches)
catmaid::catmaid_set_meta_annotations(meta_annotations = "synonym", annotations = synonyms)
catmaid::catmaid_set_meta_annotations(meta_annotations = "citation", annotations = citations)

# # Synergise annotations
# old = catmaid_skids("annotation:Paper: Huovial et al 2018")
# catmaid::catmaid_set_annotations_for_skeletons(skids = old, annotations = "Paper: Huoviala et al 2018")
# catmaid::catmaid_remove_annotations_for_skeletons(skids = old, annotations = "Paper: Huovial et al 2018", force = TRUE)
# old = catmaid_skids("annotation:Paper: Dolan et al. 2019")
# catmaid::catmaid_set_annotations_for_skeletons(skids = old, annotations = "Paper: Dolan et al 2019")
# catmaid::catmaid_remove_annotations_for_skeletons(skids = old, annotations = "Paper: Dolan et al. 2019", force = TRUE)
# old = catmaid_skids("annotation:Paper: Otto et al. 2020")
# catmaid::catmaid_set_annotations_for_skeletons(skids = old, annotations = "Paper: Otto et al 2020")
# catmaid::catmaid_remove_annotations_for_skeletons(skids = old, annotations = "Paper: Otto et al. 2020", force = TRUE)
# ref = c("Paper: Fisek et al 2014",
#         "Paper: Varela et al 2019",
#         "Paper: Aso et al 2014")
# for(r in ref){
#   old = catmaid_skids(paste0("annotation:",r))
#   if(length(old)){
#     p = gsub("Paper","Citation",r)
#     catmaid::catmaid_set_annotations_for_skeletons(skids = old, annotations = p)
#     catmaid::catmaid_remove_annotations_for_skeletons(skids = old, annotations = r, force = TRUE)
#   }
# }

## Remove meta annotations
# catmaid_remove_meta_annotations(
#   annotations = cats,
#   meta_annotations = "whimsical names"
# )
# catmaid_remove_meta_annotations(
#   annotations = papers,
#   meta_annotations = "papers"
# )
# catmaid_remove_meta_annotations(
#   annotations = cell.types,
#   meta_annotations = "cell types"
# )

# Get meta data
meta = elmr::fafb_get_meta("annotation:FAFB_published")
meta = meta[,c("skid", "neuron_name", "whimsical_name", "cell_type", "synonym","tracing_status", "paper","citation")]
colnames(meta) = c("skid", "new_name", "catmaid_name", "type", "synonym", "tracing_status", "paper","citation")

# Was a neuron published before
meta$newly_identified = TRUE
meta$newly_identified[grepl("Jeanne|Aso|Fisek|Dolan|Frechter", meta$citation)] = FALSE

# Create google sheet
googlesheets4::write_sheet(data = meta,
                           ss = "1GABThkVFdtPTWEXD9A26eIZdD81GBoc3OHKPpRwZVbE",
                           sheet = "neurons")

# Re-name neurons
meta$current_name = catmaid_get_neuronnames(meta$skid)
for(i in 1:nrow(meta)){
  message(meta$current_name[i], " to ", meta$catmaid_name[i])
  catmaid_rename_neuron(skids = meta$skid[i],
                        names = meta$catmaid_name[i])
}



# hm = hemibrain_matches(priority="FAFB")
# lm = lm_matches()
# ids = c(6185360,
#         3393889,
#         2050698,
#         3136251,
#         11544024,
#         4176285,
#         3421839,
#         6900869,
#         5670783,
#         4274682,
#         2372530,
#         556874)
# f = fafb_get_meta(ids)
# f$catmaid_name = catmaid_get_neuronnames(f$skid)
# f$hemibrain.match = hm[as.character(f$skid),"match"]
# f$cell.type = hm[as.character(f$skid),"cell.type"]
# f$frechter.cell.type = most.lh[as.character(f$LM.match),"frechter.cell.type"]
# f$LM.match = lm[as.character(f$hemibrain.match),"match"]
# write.csv(f,"interim.csv")


