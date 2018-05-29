if(!exists('most.lhns', envir = .GlobalEnv, inherits = FALSE))
  stop("Please run processLHNs.R or make.R to generate most.lhns")

message("Making most.lhns.dps. This could take a minute!")
doMC::registerDoMC()
most.lhns.dps=dotprops(most.lhns, k=5, resample=1)


names_in_common=intersect(names(most.lhns.dps), rownames(df))
most.lhns.dps = most.lhns.dps[names_in_common]
most.lhns.dps[,]=df[names_in_common,]

devtools::use_data(most.lhns.dps, overwrite=TRUE, compress = F)
