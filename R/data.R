#' A comprehensive lateral horn neuron dataset
#'
#' A dataset containing all of the FlyCircuit neurons that seem to have
#' dendrites in the lateral horn (LH), as well as traced dye-fills from Frechter
#' et al. 2017. The neurons are in the \code{nat} package's
#' \code{\link[nat]{neuron}} format.
#'
#' @source \url{http://www.flycircuit.tw/}
#' @seealso \code{\link{most.lhns.dps}}
#' @examples
#' \donttest{
#' library(nat)
#' head(most.lhns)
#' # summarise numbers of neurons per Primary Neurite tract
#' table(most.lhns[,'pnt'])
#' }
#' \dontrun{
#' good_lhns=subset(most.lhns, good.trace & !is.na(anatomy.group) &
#'                  anatomy.group!="notLHproper")
#' write.neurons(good_lhns, "/path/to/ouput/dir", subdir=file.path(pnt,anatomy.group),
#'               files=paste0(id, '.swc'))
#' }
"most.lhns"

#' A comprehensive lateral horn neuron dotprops dataset
#'
#' A \code{\link[nat]{dotprops}} dataset containing all of the FlyCircuit
#' lateral horn neurons that seem to have dendrite in the LH, as well as traced
#' dye-fills from Frechter et al. 2017
#'
#' @source \url{http://www.flycircuit.tw/}
#' @seealso \code{\link{most.lhns}}
"most.lhns.dps"


#' Lateral horn primary neurite tracts as a dotprops object
#'
#' The known primary neurite tracts that lateral horn neurons can take from
#' their somata, from Frechter et al. 2017.
#'
#' @seealso \code{\link{plot_pnts}}
#' @examples
#' \donttest{
#' library(nat)
#' plot_pnts()
#' plot3d(most.lhns, pnt=='av6', col='black', soma=T)
#'
#' ## a bit messy, so maybe try just with the spine (longest path of neuron)
#' # removes neurons
#' npop3d()
#' # nb UseStartPoint => longest path from soma
#' av6.spines=nlapply(subset(most.lhns, pnt=='av6'), spine, UseStartPoint=T)
#' plot3d(av6.spines, col='black')
#' }
"primary.neurite.tracts"


#' Projection neuron response data
#'
#' Ca2+ responses in the dendrites of Drosophila, uniglomerular GH146 positive
#' projection neurons from Badel et al. 2017.
#'
#' @source \url{http://dx.doi.org/10.1016/j.neuron.2016.05.022}
"Badel.PN.responses"

#' A categorised database of neurons providing input to the lateral horn
#'
#' @source \url{http://www.flycircuit.tw/}
#' @details See \url{http://virtualflybrain.org} for definitions of tract
#'   abbreviations.
#' @seealso \code{\link{most.lhns}}
#' @examples
#' \donttest{
#' library(nat)
#' head(lh.inputs)
#' # summarise numbers of neurons per modality/axon tract
#' with(lh.inputs, table(modality, tract))
#' table(most.lhns[,'pnt'])
#' }
"lh.inputs"

#' Dendritic overlap of LHN cell types with axon terminals of PN inputs to LH
#'
#' This matrix is organised by the identifier of the PN inputs (rows) and the
#' LHN cell type (columns).
#'
#' @seealso \code{\link{most.lhns}}, \code{\link{lh.inputs}}
"lhns.pn.overlap.matrix"

#' Light level tracign of PN axons
#'
#' Light level tracings of PN axons in FCWB space from Jefferis and Potter et al. 2007, Wong and Wang et al. 2002 and Yu et al. 2010.
#'
"light.pn.axons"

#' Gal4 line codes for LHNs
#'
#' Collated in Frechter et al. 2017.
#'
"lhn.lines"

#' Information on glomeruli and their cognate olfactory sensaroy neurons and receptors
#'
#' Information on glomeruli and their cognate olfactory sensaroy neurons and receptors from DoOR.
#' @details Information collated in: \url{https://www.ncbi.nlm.nih.gov/pubmed/27653699}
"olf.info"

#' Information on projection neurons
#'
#' Information on projection neurons, their glomeruli and their cognate olfactory sensaroy neurons and receptors.
#' @details Data largely from \url{https://www.ncbi.nlm.nih.gov/pubmed/27653699}
"pn.info"
