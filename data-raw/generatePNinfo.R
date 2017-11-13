# Create data in pns from the flyconnectome googledrive
# require(googlesheets)
# googlesheets::gs_auth(verbose=TRUE)
# gs = googlesheets::gs_title("uPN Catalogue")
# gs = as.data.frame(googlesheets::gs_read(gs, ws = 1, range = NULL, literal = TRUE, verbose = TRUE, col_names = TRUE))
# pn.info = gs[,c("Glomerulus", "PN_name", "Sensillum", "Receptor(s)", "Odour(s)",
#            "Valence(simplified)", "expected_n_Grabe2016", "Lineage", "Tract",
#            "Lineage_source", "LH_source", "Lifetime_sparseness(Grabe)", "Lifetime_sparseness(DoOR)",
#            "Kurtosis(DoOR)")]
# devtools::use_data(pn.info,overwrite=TRUE)
