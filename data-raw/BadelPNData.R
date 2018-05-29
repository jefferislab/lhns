# Prepare Badel et al. PN data
resp = readxl::read_excel("/GD/LMBD/Papers/2015lhns/fig/Alex/data/BadelPNData.xls")
resp.df = as.data.frame(resp)
badel.PN.responses = as.matrix(resp.df[,-1])
rownames(badel.PN.responses) = resp.df$X__1
devtools::use_data(badel.PN.responses,overwrite=TRUE)
