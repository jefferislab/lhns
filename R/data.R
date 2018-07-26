#' A comprehensive lateral horn neuron dataset
#'
#' A dataset containing all of the FlyCircuit neurons that seem to have
#' dendrites in the lateral horn (LH), as well as traced dye-fills from Frechter
#' et al. 2018. The neurons are in the \code{nat} package's
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
#' dye-fills from Frechter et al. 2018
#'
#' @source \url{http://www.flycircuit.tw/}
#' @seealso \code{\link{most.lhns}}
"most.lhns.dps"


#' Lateral horn primary neurite tracts as a dotprops object
#'
#' The known primary neurite tracts that lateral horn neurons can take from
#' their somata, from Frechter et al. 2018.
#'
#' @seealso \code{\link{plot_pnts}}, \code{\link{lh_tract_data}}
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

#' Information about number/type of LHNs for each tract
#'
#' @details This was based on work by Arian Jamasb, Ruari Roberts, Alex Bates,
#'   and Greg Jefferis as a contribution to Frechter et al. 2018.
#'
#'   The sampling strategy counted profiles in all the main LH associated tracts
#'   and then used random sampling and tracing to the first branchpoint to
#'   estimate the number of LHNs in each tract.
#'
#'   From LHN_Tract_Table_Tex.R @ b49e87462c938222313e4f6835572bbdb2fb5727
#' @seealso \code{\link{primary.neurite.tracts}}
"lh_tract_data"

#' Projection neuron response data
#'
#' Ca2+ responses in the dendrites of Drosophila, uniglomerular GH146 positive
#' projection neurons from Badel et al. 2017.
#'
#' @source \url{http://dx.doi.org/10.1016/j.neuron.2016.05.022}
"badel.PN.responses"

#' A categorised database of neurons providing input to the lateral horn
#'
#' @source \url{http://www.flycircuit.tw/}
#' @details See \url{http://virtualflybrain.org} for definitions of tract
#'   abbreviations.
#' @seealso \code{\link{most.lhns}}
#' @examples
#' \donttest{
#' library(nat)
#' head(most.lhins)
#' # summarise numbers of neurons per modality/axon tract
#' with(most.lhins, table(modality, tract))
#' table(most.lhns[,'pnt'])
#' }
"most.lhins"

#' A categorised database of Vector clouds for neurons providing input to the lateral horn
#'
#' @source \url{http://www.flycircuit.tw/}
#' @details See \url{http://virtualflybrain.org} for definitions of tract
#'   abbreviations.
#' @seealso \code{\link{most.lhns}}
#' @examples
#' \donttest{
#' library(nat)
#' head(most.lhins)
#' # summarise numbers of neurons per modality/axon tract
#' with(most.lhins, table(modality, tract))
#' table(most.lhns[,'pnt'])
#' }
"most.lhins.dps"

#' Dendritic overlap of LHN cell types with axon terminals of PN inputs to LH
#'
#' This matrix is organised by the identifier of the PN inputs (rows) and the
#' LHN cell type (columns).
#'
#' @seealso \code{\link{most.lhns}}, \code{\link{most.lhins}}
"lhns.pn.overlap.matrix"

#' Light level tracing of PN axons
#'
#' Light level tracings of PN axons in FCWB space from Jefferis and Potter et al. 2007, Wong and Wang et al. 2002 and Yu et al. 2010.
"pn.axons.light"

#' Vector cloud fopr light level tracing of PN axons
#'
#' Light level tracings of PN axons in FCWB space from Jefferis and Potter et al. 2007, Wong and Wang et al. 2002 and Yu et al. 2010.
"pn.axons.light.dps"

#' Split-Gal4 line codes for LHNs
#'
#' Collated by Dolan et al. 2018.
#'
"lh_line_info"

#' Summary of cell types with clean split-GAL4 lines from Dolan et al. 2018
#'
#' Collated by Dolan et al. 2018.
#'
"cell_type_summary"

#' Information on glomeruli and their cognate olfactory sensaroy neurons and receptors
#'
#' Information on glomeruli and their cognate olfactory sensaroy neurons and receptors from DoOR.
#' @details Information collated in: \url{https://www.ncbi.nlm.nih.gov/pubmed/27653699}
"olf.info"

#' Information on projection neurons
#'
#' Information on projection neurons, their glomeruli and their cognate olfactory sensaroy neurons and receptors.
#' @details Data largely from Grabe et al. 2016 \url{https://www.ncbi.nlm.nih.gov/pubmed/27653699}
"pn.info"

#' Vector clouds of LH output neurons from split GAL4 lines
#'
#' Vector cloud objects from segmented image data. Meta-data contains experimentally verified information on neurostransmitter expression. Data from Mike Dolan.
#' @details Dolan et al. 2018, upcoming.
"lh.splits.dps"


#' Single skeletons of LHNs from MCFO
#'
#' Single skeletons of LH neurons from split GAL4 line multi-colour-flip-out dat. Meta-data contains experimentally verified information on neurostransmitter expression. Data from Mike Dolan.
#' @details Dolan et al. 2018, upcoming.
"lh.mcfo"


#' Vector clouds for single LHNs from MCFO
#'
#' Single skeletons of LH neurons from split GAL4 line multi-colour-flip-out dat. Meta-data contains experimentally verified information on neurostransmitter expression. Data from Mike Dolan.
#' @details Dolan et al. 2018, upcoming.
"lh.mcfo.dps"


#' Vector clouds of LH output neurons from split GAL4 lines
#'
#' Vector cloud objects from segmented image data. Meta-data contains experimentally verified information on neurostransmitter expression. Data from Mike Dolan.
#' @details Dolan et al. 2018, upcoming.
"lhon.splits.dps"


#' Vector clouds of LH local neurons from split GAL4 lines
#'
#' Vector cloud objects from segmented image data. Meta-data contains experimentally verified information on neurostransmitter expression. Data from Mike Dolan.
#' @details Dolan et al. 2018, upcoming.
"lhln.splits.dps"


#' Vector clouds of LH input neurons from split GAL4 lines
#'
#' Vector cloud objects from segmented image data. Meta-data contains experimentally verified information on neurostransmitter expression. Data from Mike Dolan.
#' @details Dolan et al. 2018, upcoming.
"lhin.splits.dps"


#' Vector clouds of peri-LH  neurons from split GAL4 lines
#'
#' Vector cloud objects from segmented image data. Meta-data contains experimentally verified information on neurostransmitter expression. Data from Mike Dolan.
#' @details Dolan et al. 2018, upcoming.
"lhin.splits.dps"


#' Mushroom body output neuron Vector clouds representing
#'
#' Vector cloud objects from segmented image data. In FCWB space. Data from Yoshi Aso.
#' @details Aso et al. 2014 \url{https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4273437/}
"mbons.light.dps"

#' EM skeletons for LHNs
#'
#' EM skeletons for LHNs identified in the Dolan split lines. Tracing in progress.
#' @details Dolan et al. 2018, upcoming.
"emlhns"

#' Vector clouds of EM skeletons for LHNs
#'
#' Vector clouds for EM LHNs identified in the Dolan split lines. Tracing in progress.
#' @details Dolan et al. 2018, upcoming.
"emlhns.dps"


#' Lateral horn neuron morphologies from Jeanne and Fisek et al. 2018
#'
#' Skeletonized 3-D Morphologies of all Digitized LHNs related to Figure 4 in Jeanne and Fisek et al. 2018.
#' Meta-data contains the LHN's voltage responses to GH146 glomerular photostimulation. Transformed into FCWB space.
#'
#' @source \url{https://doi.org/10.1016/j.neuron.2018.05.011}
#' @seealso \code{\link{jfw.lhns.dps}}
"jfw.lhns"


#' Vector clouds for lateral horn neuron morphologies from Jeanne and Fisek et al. 2018
#'
#' Skeletonized 3-D Morphologies of all Digitized LHNs related to Figure 4 in Jeanne and Fisek et al. 2018.
#' Meta-data contains the LHN's voltage responses to GH146 glomerular photostimulation. Transformed into FCWB space.
#'
#' @source \url{https://doi.org/10.1016/j.neuron.2018.05.011}
#' @seealso \code{\link{jfw.lhns}}
"jfw.lhns.dps"
