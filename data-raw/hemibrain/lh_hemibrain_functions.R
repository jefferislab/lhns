## Load a save function
write_lhns <- function(df,
                       bodyids = NULL,
                       selected_file = "1OSlDtnR3B1LiB5cwI5x5Ql6LkZd8JOS5bBr-HTi0pOw",
                       column = NULL,
                       sheet = "lhns",
                       id.field = "bodyid"){
  # Read the Google Sheet
  gs = hemibrainr:::gsheet_manipulation(FUN = googlesheets4::read_sheet,
                           ss = selected_file,
                           sheet = sheet,
                           guess_max = 3000,
                           return = TRUE)
  gs[[id.field]] = correct_id(gs[[id.field]])
  rownames(gs) = gs[[id.field]]
  # Check column
  if(is.null(column)){
    column = colnames(gs)
  }
  column = intersect(column,colnames(df))
  column = intersect(column,colnames(gs))
  if(!length(column)){
    stop("Given columns not in Google Sheet")
  }
  # Check df
  if(!is.null(bodyids)){
    df = subset(df, df[[id.field]] %in% bodyids)
    message("Updating ", nrow(df), " entries")
  }
  # Add new rows if necessary
  if(sum(!df[[id.field]]%in%gs[[id.field]])){
    write_lhns_missing(df, selected_file = selected_file, sheet = sheet, id.field = id.field)
    df = subset(df, df[[id.field]]%in%gs[[id.field]])
  }
  # Work out rows to update
  rows = match(df[[id.field]],gs[[id.field]])+1
  rownames(df) = rows
  for(r in rows){
    for(c in column){
      letter = LETTERS[match(c,colnames(gs))]
      range = paste0(letter,r)
      hemibrainr:::gsheet_manipulation(FUN = googlesheets4::range_write,
                                       ss = selected_file,
                                       range = range,
                                       data = as.data.frame(df[as.character(r),c]),
                                       sheet = sheet,
                                       col_names = FALSE)
    }
  }
}

# hidden
write_lhns_missing <- function(df,
                               sheet = "lhns",
                               id.field = "bodyid",
                               selected_file = "1OSlDtnR3B1LiB5cwI5x5Ql6LkZd8JOS5bBr-HTi0pOw"){
  # Read the Google Sheet
  gs = hemibrainr:::gsheet_manipulation(FUN = googlesheets4::read_sheet,
                                        ss = selected_file,
                                        sheet = sheet,
                                        guess_max = 3000,
                                        return = TRUE)
  gs[[id.field]] = correct_id(gs[[id.field]])
  rownames(gs) = gs[[id.field]]
  df = subset(df, ! df[[id.field]] %in% gs[[id.field]])
  # Check column
  column = colnames(gs)
  column = intersect(column,colnames(df))
  column = intersect(column,colnames(gs))
  # input missing information
  if(!is.null(df$bodyid)){
    meta = neuprint_get_meta(df$bodyid)
    for(c in setdiff(colnames(gs),colnames(df))){
      if(c%in%colnames(meta)){
        df[[c]] = meta[[c]][match(df$bodyid,meta$bodyid)]
      }else{
        df[[c]] = ""
      }
    }
  }
  df = df[!duplicated(df[[id.field]]),]
  df = df[,colnames(gs)]
  df[df=="none"] = ""
  # Write to google sheet
  hemibrainr:::gsheet_manipulation(FUN = googlesheets4::sheet_append,
                                   ss = selected_file,
                                   data = as.data.frame(df),
                                   sheet = sheet)
}

# hidden
correct_id <-function(v){
  gsub(" ","",v)
}

# hidden
hemibrain_multi3d <- function(..., someneuronlist = hemibrain_neurons()){
  m = as.list(match.call())
  count = length(m)-1
  cols = rainbow(count)
  for(i in 1:count){
    j = i+1
    n = as.character(get(as.character(m[[j]])))
    n = n[n%in%names(someneuronlist)]
    col = grDevices::colorRampPalette(colors = c(cols[i],"grey10"))
    col = col(length(n)+2)[1:length(n)]
    rgl::plot3d(someneuronlist[n], lwd = 2, col = col, soma = TRUE)
  }
}

# hidden
process_types <- function(df, hemibrain_lhns){
  # Sort out missing information
  df$bodyid = rownames(df)
  missing = subset(df, is.na(df$type))
  meta = neuprint_get_meta(as.character(missing$bodyid))[,c("bodyid","type","cellBodyFiber")]
  meta$cbf = gsub("\\^.*","",meta$cellBodyFiber)
  df$cbf[match(meta$bodyid,df$bodyid)] = meta$cbf
  df$type[match(meta$bodyid,df$bodyid)] = meta$type
  # Add in any missing hemilineage information
  missing.hl = subset(df, is.na(df$ItoLee_Hemilineage))$bodyid
  with.hl = subset(df, !is.na(df$ItoLee_Hemilineage))
  for(bi in missing.hl){
    ct = subset(df, bodyid == bi)$cell.type
    if(ct %in% with.hl$cell.type){
      same = subset(with.hl,cell.type==ct)[1,]
      df[match(bi,df$bodyid),c("ItoLee_Hemilineage","Hartenstein_Hemilineage")] = same[,c("ItoLee_Hemilineage","Hartenstein_Hemilineage")]
    }else{
      ag = gsub("([a-z]).*","\\1",ct)
      ags = gsub("([a-z]).*","\\1",with.hl$cell.type)
      if(ag %in% ags){
        same = subset(with.hl,grepl(ag,cell.type))[1,]
        df[match(bi,df$bodyid),c("ItoLee_Hemilineage","Hartenstein_Hemilineage")] = same[,c("ItoLee_Hemilineage","Hartenstein_Hemilineage")]
      }
    }
  }
  # Make matches
  df$FAFB.match = hemibrain_lhns$FAFB.match[match(df$bodyid,hemibrain_lhns$bodyid)]
  df$FAFB.match[is.na(df$FAFB.match)] = "none"
  df$FAFB.match.quality = hemibrain_lhns$FAFB.match.quality[match(df$bodyid,hemibrain_lhns$bodyid)]
  df$LM.match = hemibrain_lhns$LM.match[match(df$bodyid,hemibrain_lhns$bodyid)]
  df$LM.match[is.na(df$LM.match)] = "none"
  df$LM.match.quality = hemibrain_lhns$LM.match.quality[match(df$bodyid,hemibrain_lhns$bodyid)]
  # Update match qualities
  df$LM.match.quality = standardise_quality(df$LM.match.quality)
  df$FAFB.match.quality = standardise_quality(df$FAFB.match.quality)
  df$FAFB.match.quality[df$FAFB.match=="none"] = "none"
  df$LM.match.quality[df$LM.match=="none"] = "none"
  # Have these type been published before?
  pcts = unique(c(most.lhns[,"cell.type"],most.lhins[,"cell.type"], fafb_lhns[,"cell_type"]))
  df$published = FALSE
  df$published[df$cell.type %in% pcts] = TRUE
  ## Correct cell types
  for(ct in unique(df$cell.type)){
    d = subset(df, df$cell.type==ct)
    ito.types = unique(d$type)
    if(length(ito.types)>1){
      f = factor(d$type, levels = sort(unique(d$type), decreasing = TRUE))
      cell.types = paste0(d$cell.type,letters[f])
      df$cell.type[match(d$bodyid,df$bodyid)] = cell.types
    }
  }
  df$type.change = FALSE
  df$cell.type[grepl("OTHER|other",df$cell.type)] = df$type[grepl("OTHER|other",df$cell.type)]
  ## Has there been a type change?
  for(ct in unique(df$cell.type)){
    d = subset(df, df$cell.type==ct)
    ito.types = unique(d$type)
    if(length(ito.types)>1){
      df$type.change[match(d$bodyid,df$bodyid)] = TRUE
    }else{
      e = subset(df, df$type%in%ito.types)
      if(nrow(e)!=nrow(d)){
        df$type.change[match(d$bodyid,df$bodyid)] = TRUE
      }
    }
  }
  # Add cell type prefix
  prefix =!grepl("WED|aSP|MB-C1|LHMB1|PPL2ab-PN1|DNp44",df$cell.type)
  df$cell.type[prefix] = paste0("LH",df$cell.type[prefix])
  df$cell.type = gsub("NA","",df$cell.type)
  # Add primary neurite system
  df$pnt = sub("^\\D*\\d+\\K.*", "", df$cell.type, perl=TRUE)
  # Other issues
  df$cbf.change[is.na(df$cbf.change)] = FALSE
  # Connectivity type different from cell types
  df$connectivity.type = df$cell.type
  df$cell.type = gsub("[a-z]$","",df$cell.type)
  # Return
  df = df[!is.na(df$bodyid),]
  rownames(df) = df$bodyid
  df
}

# hidden
standardise_quality <- function(x){
  x[x=="e"] = "good"
  x[x=="o"] = "medium"
  x[x=="p"] = "poor"
  x[x=="n"] = "none"
  x
}

# hidden
state_results <- function(df){
  message(paste(unique(df$pnt),collapse=", "))
  message("Number of neurons that have changed type: ", sum(df$type.change), "/", nrow(df))
  message("Number of neurons that have changed CBF: ", sum(df$cbf.change!="FALSE"), "/", nrow(df))
  message("Number of neurons that have been published: ", sum(df$published), "/", nrow(df))
  message("Number of neurons that have been FAFB matched: ", sum(df$FAFB.match.quality!="none"), "/", nrow(df))
  message("Number of neurons that have been LM matched: ", sum(df$LM.match.quality!="none"), "/", nrow(df))
}

# hidden
take_pictures <- function(df){
  if(!is.null(df$pnt)){
    pnts = unique(df$pnt)
  }
  for(p in pnts){
    message(p)
    pnt = p
    dfp = subset(df,df$pnt == p)
    # Get hemibrain neurons
    bodyids = extract_ids(as.character(unique(dfp$bodyid)))
    db = tryCatch(hemibrain_neurons()[bodyids], error = function(e) NULL)
    if(is.null(db)){
      db = hemibrain_read_neurons(bodyids, OmitFailures = TRUE)
    }
    db = hemibrainr:::scale_neurons.neuronlist(db, scaling = (8/1000))
    # Get light level neurons
    ids = extract_ids(unique(dfp$LM.match))
    most.lhns.f = hemibrain_lm_lhns(brainspace = c("JRCFIB2018F"),cable = c("lhns"))
    most.lhins.f = hemibrain_lm_lhns(brainspace = c("JRCFIB2018F"),cable = c("lhins"))
    lms = nat::union(most.lhns.f,most.lhins.f)
    lms = lms[names(lms)%in%ids]
    # Get FAFB neurons
    skids = extract_ids(unique(dfp$FAFB.match))
    if(length(skids)){
      fafb = catmaid::read.neurons.catmaid(skids)
      fafb = tryCatch( suppressWarnings(nat.templatebrains::xform_brain(fafb, sample = "FAFB14", reference = "JRCFIB2018F")),
                       error = function(e) NULL)
    }else{
      fafb = NULL
    }
    # Create folders
    folders = sprintf("data-raw/hemibrain/pnts/images/%s/",pnt)
    fafb.match.folder = paste0(folders,"FAFB/")
    lm.match.folder =  paste0(folders,"LM/")
    split.match.folder =  paste0(folders,"split/")
    dir.create(fafb.match.folder, recursive = TRUE)
    dir.create(lm.match.folder, recursive = TRUE)
    dir.create(split.match.folder, recursive = TRUE)
    # Set colours
    reds = grDevices::colorRampPalette(colors = c(hemibrain_bright_colors["cerise"],"grey10"))
    blues = grDevices::colorRampPalette(colors = c(hemibrain_bright_colors["marine"],"grey10"))
    greens = grDevices::colorRampPalette(colors = c(hemibrain_bright_colors["green"],"grey10"))
    # Take images
    nat::nopen3d(userMatrix = structure(c(0.827756524085999, 0.134821459650993,
                                          -0.544648587703705, 0, 0.557223737239838, -0.311243295669556,
                                          0.769824028015137, 0, -0.0657294392585754, -0.940718233585358,
                                          -0.332759499549866, 0, 0, 0, 0, 1), .Dim = c(4L, 4L)), zoom = 0.710681617259979,
                 windowRect = c(0L, 45L, 1178L, 875L))
    for(ct in extract_ids(dfp$cell.type)){
      rgl::clear3d()
      # IDs
      d = subset(dfp, cell.type==ct)
      bis = extract_ids(d$bodyid)
      sks = extract_ids(d$FAFB.match)
      is = extract_ids(d$LM.match)
      # Plot brain
      rgl::plot3d(hemibrain_microns.surf, col="grey10", alpha = 0.1)
      # Plot hemibrain neurons
      neurons = db[names(db)%in%bis]
      if(!length(neurons)){
        neurons = tryCatch(neuprint_read_neurons(bis), error = function(e) NULL)
      }
      if(!length(neurons)){
        next
      }
      col1 = reds(length(neurons)+2)[1:length(neurons)]
      rgl::plot3d(neurons,lwd=2,col=col1, soma = 5)
      # Plot LM
      if(length(is)){
        neurons2 = lms[names(lms)%in%is]
        if(!length(neurons2)){
          next
        }
        col2 = greens(length(neurons2)+2)[1:length(neurons2)]
        rgl::plot3d(neurons2,lwd=2,col=col2, soma = 5)
        rgl.snapshot(file=paste0(lm.match.folder,"LM_matches_",ct,".png"))
        nat::npop3d()
      }
      # Plot FAFB
      if(length(sks)){
        neurons3 = fafb[names(fafb)%in%sks]
        if(!length(neurons3)){
          next
        }
        col3 = blues(length(neurons3)+2)[1:length(neurons3)]
        rgl::plot3d(neurons3,lwd=2,col=col3, soma = 5)
        rgl.snapshot(file=paste0(fafb.match.folder,"FAFB_matches_",ct,".png"))
        nat::npop3d()
      }
      # Plot split
      rgl::clear3d()
      rgl::plot3d(hemibrain_microns.surf, col="grey10", alpha = 0.1)
      hemibrainr::plot3d_split(neurons, radius = 1, soma = 5)
      rgl.snapshot(file=paste0(split.match.folder,"split_",ct,".png"))
      rgl::clear3d()
    }
    # Plot CBFs and linages
    hls = extract_ids(dfp$ItoLee_Hemilineage)
    cols = rainbow(length(hls))
    rgl::clear3d()
    rgl::plot3d(hemibrain_microns.surf, col="grey10", alpha = 0.1)
    for(i in 1:length(hls)){
      n = extract_ids(dfp$bodyid[dfp$ItoLee_Hemilineage == hls[i]])
      col = grDevices::colorRampPalette(colors = c(cols[i],"grey10"))
      neurons = db[names(db)%in%n]
      if(!length(neurons)){
        next
      }
      col = col(length(neurons)+2)[1:length(neurons)]
      rgl::plot3d(neurons, lwd = 2, col = col, soma = TRUE)
    }
    rgl.snapshot(file=paste0(folders,"hemilineages_",paste(hls,collapse="_"),".png"))
    for(i in 1:length(hls)){
      rgl::clear3d()
      rgl::plot3d(hemibrain_microns.surf, col="grey10", alpha = 0.1)
      hldf = subset(dfp,dfp$ItoLee_Hemilineage==hls[i])
      cbfs = extract_ids(hldf$cbf)
      rcols = rainbow(length(hls))
      for(j in 1:length(cbfs)){
        n = extract_ids(hldf$bodyid[hldf$cbf == cbfs[j]])
        col = grDevices::colorRampPalette(colors = c(rcols[j],"grey10"))
        neurons = db[names(db)%in%n]
        if(!length(neurons)){
          next
        }
        col = col(length(neurons)+2)[1:length(neurons)]
        rgl::plot3d(neurons, lwd = 2, col = col, soma = TRUE)
      }
      rgl.snapshot(file=paste0(folders,"cbfs_",paste(hls[i],"_",cbfs,collapse="_"),".png"))
    }
  }
}

# hidden
extract_ids <- function(x){
  x = x[!is.na(x)]
  x = x[x!="none"]
  unique(as.character(x))
}

# hidden
is.lhn <- function(x, logical = TRUE){
  csv = read.csv("data-raw/csv/hemibrain_lh_list.csv")
  csv$bodyid = correct_id(csv$bodyid)
  islh = csv$lh[match(x,csv$bodyid)]
  ifelse(islh=="FALSE",FALSE,TRUE)
}

# hidden
hemibrain_ct3d <- function(df, someneuronlist = hemibrain_neurons()){
  m = unique(df[,"cell.type"])
  m = sort(m)
  count = length(m)
  cols = rainbow(count)
  for(i in 1:count){
    n = as.character(subset(df, df$cell.type == m[i])$bodyid)
    n = n[n%in%names(someneuronlist)]
    col = grDevices::colorRampPalette(colors = c(cols[i],"grey10"))
    col = col(length(n)+2)[1:length(n)]
    rgl::plot3d(someneuronlist[n], lwd = 2, col = col, soma = TRUE)
  }
}






