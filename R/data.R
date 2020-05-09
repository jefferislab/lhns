#' A comprehensive lateral horn neuron dataset
#'
#' A dataset containing all of the FlyCircuit neurons that seem to have
#' dendrites in the lateral horn (LH), as well as traced dye-fills from Frechter
#' et al. 2019. The neurons are in the \code{nat} package's
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
#' @references Frechter, Shahar, Alexander Shakeel Bates, Sina Tootoonian, Michael-John Dolan, James D. Manton, Arian Rokkum Jamasb, Johannes Kohl, Davi Bock, and Gregory Sxe Jefferis. 2019.
#' “Functional and Anatomical Specificity in a Higher Olfactory Centre.” eLife 8 (May).
#' \href{https://doi.org/10.7554/eLife.44590}{doi:10.7554/eLife.44590}
"most.lhns"

#' A comprehensive lateral horn neuron dotprops dataset
#'
#' A \code{\link[nat]{dotprops}} dataset containing all of the FlyCircuit
#' lateral horn neurons that seem to have dendrite in the LH, as well as traced
#' dye-fills from Frechter et al. 2018
#'
#' @source \url{http://www.flycircuit.tw/}
#' @references Frechter, Shahar, Alexander Shakeel Bates, Sina Tootoonian, Michael-John Dolan, James D. Manton, Arian Rokkum Jamasb, Johannes Kohl, Davi Bock, and Gregory Sxe Jefferis. 2019.
#' “Functional and Anatomical Specificity in a Higher Olfactory Centre.” eLife 8 (May).
#' \href{https://doi.org/10.7554/eLife.44590}{doi:10.7554/eLife.44590}
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
#' plot3d(most.lhns, pnt=='av6', col='black', soma=TRUE)
#'
#' ## a bit messy, so maybe try just with the spine (longest path of neuron)
#' # removes neurons
#' npop3d()
#' # nb UseStartPoint => longest path from soma
#' av6.spines=nlapply(subset(most.lhns, pnt=='av6'), spine, UseStartPoint=TRUE)
#' plot3d(av6.spines, col='black')
#' }
#'
#' @source \url{http://www.flycircuit.tw/}
#' @references Frechter, Shahar, Alexander Shakeel Bates, Sina Tootoonian, Michael-John Dolan, James D. Manton, Arian Rokkum Jamasb, Johannes Kohl, Davi Bock, and Gregory Sxe Jefferis. 2019.
#' “Functional and Anatomical Specificity in a Higher Olfactory Centre.” eLife 8 (May).
#' \href{https://doi.org/10.7554/eLife.44590}{doi:10.7554/eLife.44590}
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
#'   From LHN_Tract_Table_Tex.R @
#'   \code{b49e87462c938222313e4f6835572bbdb2fb5727}
#' @seealso \code{\link{primary.neurite.tracts}}
"lh_tract_data"

#' Projection neuron response data
#'
#' Ca2+ responses in the dendrites of Drosophila, uniglomerular GH146 positive
#' projection neurons from Badel et al. 2017.
#'
#' @references Badel, Laurent, Kazumi Ohta, Yoshiko Tsuchimoto, and Hokto Kazama. 2016. “Decoding of Context-Dependent Olfactory Behavior in Drosophila.” Neuron 91 (1): 155–67.
#' \href{https://doi.org/10.1016/j.neuron.2016.05.022}{doi:10.1016/j.neuron.2016.05.022}
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
#'
#' @source \url{http://www.flycircuit.tw/}
#' @references Frechter, Shahar, Alexander Shakeel Bates, Sina Tootoonian, Michael-John Dolan, James D. Manton, Arian Rokkum Jamasb, Johannes Kohl, Davi Bock, and Gregory Sxe Jefferis. 2019.
#' “Functional and Anatomical Specificity in a Higher Olfactory Centre.” eLife 8 (May).
#' \href{https://doi.org/10.7554/eLife.44590}{doi:10.7554/eLife.44590}
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
#'
#' @source \url{http://www.flycircuit.tw/}
#' @references Frechter, Shahar, Alexander Shakeel Bates, Sina Tootoonian, Michael-John Dolan, James D. Manton, Arian Rokkum Jamasb, Johannes Kohl, Davi Bock, and Gregory Sxe Jefferis. 2019.
#' “Functional and Anatomical Specificity in a Higher Olfactory Centre.” eLife 8 (May).
#' \href{https://doi.org/10.7554/eLife.44590}{doi:10.7554/eLife.44590}
"most.lhins.dps"

#' Dendritic overlap of LHN cell types with axon terminals of PN inputs to LH
#'
#' This matrix is organised by the identifier of the PN inputs (rows) and the
#' LHN cell type (columns).
#'
#' @seealso \code{\link{most.lhns}}, \code{\link{most.lhins}}
#'
#' @references Frechter, Shahar, Alexander Shakeel Bates, Sina Tootoonian, Michael-John Dolan, James D. Manton, Arian Rokkum Jamasb, Johannes Kohl, Davi Bock, and Gregory Sxe Jefferis. 2019.
#' “Functional and Anatomical Specificity in a Higher Olfactory Centre.” eLife 8 (May).
#' \href{https://doi.org/10.7554/eLife.44590}{doi:10.7554/eLife.44590}
"lhns.pn.overlap.matrix"

#' Light level tracing of PN axons
#'
#' Light level tracings of PN axons in FCWB space from Jefferis and Potter et al. 2007, Wong and Wang et al. 2002 and Yu et al. 2010.
"pn.axons.light"

#' Vector cloud for light level tracing of PN axons
#'
#' Light level tracings of PN axons in FCWB space from Jefferis and Potter et al. 2007, Wong and Wang et al. 2002 and Yu et al. 2010.
"pn.axons.light.dps"

#' Split-Gal4 line codes for LHNs
#'
#' Collated by Dolan et al. 2019.
#'
#' @references Dolan, Michael-John, Shahar Frechter, Alexander Shakeel Bates, Chuntao Dan, Paavo Huoviala, Ruairí Jv Roberts, Philipp Schlegel, et al. 2019.
#' “Neurogenetic Dissection of the Drosophila Lateral Horn Reveals Major Outputs, Diverse Behavioural Functions, and Interactions with the Mushroom Body.” eLife 8 (May).
#' \href{https://doi.org/10.7554/eLife.43079}{doi:10.7554/eLife.43079}
#' @source \url{https://doi.org/10.7554/eLife.43079}
"lh_line_info"

#' Summary of cell types with clean split-GAL4 lines from Dolan et al. 2018
#'
#' Collated by Dolan et al. 2019.
#'
#' @references Dolan, Michael-John, Shahar Frechter, Alexander Shakeel Bates, Chuntao Dan, Paavo Huoviala, Ruairí Jv Roberts, Philipp Schlegel, et al. 2019.
#' “Neurogenetic Dissection of the Drosophila Lateral Horn Reveals Major Outputs, Diverse Behavioural Functions, and Interactions with the Mushroom Body.” eLife 8 (May).
#' \href{https://doi.org/10.7554/eLife.43079}{doi:10.7554/eLife.43079}
#' @source \url{https://doi.org/10.7554/eLife.43079}
"cell_type_summary"

#' Pre-calculated NBLAST scores between all neurons in this package
#'
#' Saves time re-calculating an NBLAST between all LH associated neuron morphologies
#'
#' @references Frechter, Shahar, Alexander Shakeel Bates, Sina Tootoonian, Michael-John Dolan, James D. Manton, Arian Rokkum Jamasb, Johannes Kohl, Davi Bock, and Gregory Sxe Jefferis. 2019.
#' “Functional and Anatomical Specificity in a Higher Olfactory Centre.” eLife 8 (May).
#' \href{https://doi.org/10.7554/eLife.44590}{doi:10.7554/eLife.44590}
"lh_nblast"

#' Odour responses for different LHN cell types
#'
#' LHNs can be found in most.lhns. From Frechter et al. 2019.
#'
#' @references Frechter, Shahar, Alexander Shakeel Bates, Sina Tootoonian, Michael-John Dolan, James D. Manton, Arian Rokkum Jamasb, Johannes Kohl, Davi Bock, and Gregory Sxe Jefferis. 2019.
#' “Functional and Anatomical Specificity in a Higher Olfactory Centre.” eLife 8 (May).
#' \href{https://doi.org/10.7554/eLife.44590}{doi:10.7554/eLife.44590}
"lhn_odour_responses"

#' Information on glomeruli and their cognate olfactory sensory neurons and receptors
#'
#' Information on glomeruli and their cognate olfactory sensory neurons and receptors from DoOR.
#' @details Information collated in: \url{https://www.ncbi.nlm.nih.gov/pubmed/27653699}
"olf.info"

#' Information on projection neurons
#'
#' Information on projection neurons, their glomeruli and their cognate olfactory sensory neurons and receptors.
#' @details Data largely from Grabe et al. 2016 \url{https://www.ncbi.nlm.nih.gov/pubmed/27653699}
"pn.info"

#' Vector clouds of LH output neurons from split GAL4 lines
#'
#' Vector cloud objects from segmented image data. Meta-data contains experimentally verified information on neurotransmitter expression. Data from Mike Dolan.
#'
#' @references Dolan, Michael-John, Shahar Frechter, Alexander Shakeel Bates, Chuntao Dan, Paavo Huoviala, Ruairí Jv Roberts, Philipp Schlegel, et al. 2019.
#' “Neurogenetic Dissection of the Drosophila Lateral Horn Reveals Major Outputs, Diverse Behavioural Functions, and Interactions with the Mushroom Body.” eLife 8 (May).
#' \href{https://doi.org/10.7554/eLife.43079}{doi:10.7554/eLife.43079}
#' @source \url{https://doi.org/10.7554/eLife.43079}
"lh.splits.dps"

#' Single skeletons of LHNs from MCFO
#'
#' Single skeletons of LH neurons from split GAL4 line multi-colour-flip-out data. Meta-data contains experimentally verified information on neurotransmitter expression. Data from Mike Dolan.
#'
#' @references Dolan, Michael-John, Shahar Frechter, Alexander Shakeel Bates, Chuntao Dan, Paavo Huoviala, Ruairí Jv Roberts, Philipp Schlegel, et al. 2019.
#' “Neurogenetic Dissection of the Drosophila Lateral Horn Reveals Major Outputs, Diverse Behavioural Functions, and Interactions with the Mushroom Body.” eLife 8 (May).
#' \href{https://doi.org/10.7554/eLife.43079}{doi:10.7554/eLife.43079}
#' @source \url{https://doi.org/10.7554/eLife.43079}
"lh.mcfo"

#' Vector clouds for single LHNs from MCFO
#'
#' Single skeletons of LH neurons from split GAL4 line multi-colour-flip-out data. Meta-data contains experimentally verified information on neurotransmitter expression. Data from Mike Dolan.
#'
#' @references Dolan, Michael-John, Shahar Frechter, Alexander Shakeel Bates, Chuntao Dan, Paavo Huoviala, Ruairí Jv Roberts, Philipp Schlegel, et al. 2019.
#' “Neurogenetic Dissection of the Drosophila Lateral Horn Reveals Major Outputs, Diverse Behavioural Functions, and Interactions with the Mushroom Body.” eLife 8 (May).
#' \href{https://doi.org/10.7554/eLife.43079}{doi:10.7554/eLife.43079}
#' @source \url{https://doi.org/10.7554/eLife.43079}
"lh.mcfo.dps"

#' Vector clouds of LH output neurons from split GAL4 lines
#'
#' Vector cloud objects from segmented image data. Meta-data contains experimentally verified information on neurotransmitter expression. Data from Mike Dolan.
#'
#' @references Dolan, Michael-John, Shahar Frechter, Alexander Shakeel Bates, Chuntao Dan, Paavo Huoviala, Ruairí Jv Roberts, Philipp Schlegel, et al. 2019.
#' “Neurogenetic Dissection of the Drosophila Lateral Horn Reveals Major Outputs, Diverse Behavioural Functions, and Interactions with the Mushroom Body.” eLife 8 (May).
#' \href{https://doi.org/10.7554/eLife.43079}{doi:10.7554/eLife.43079}
#' @source \url{https://doi.org/10.7554/eLife.43079}
"lhon.splits.dps"


#' Vector clouds of LH local neurons from split GAL4 lines
#'
#' Vector cloud objects from segmented image data. Meta-data contains experimentally verified information on neurotransmitter expression. Data from Mike Dolan.
#'
#' @references Dolan, Michael-John, Shahar Frechter, Alexander Shakeel Bates, Chuntao Dan, Paavo Huoviala, Ruairí Jv Roberts, Philipp Schlegel, et al. 2019.
#' “Neurogenetic Dissection of the Drosophila Lateral Horn Reveals Major Outputs, Diverse Behavioural Functions, and Interactions with the Mushroom Body.” eLife 8 (May).
#' \href{https://doi.org/10.7554/eLife.43079}{doi:10.7554/eLife.43079}
#' @source \url{https://doi.org/10.7554/eLife.43079}
"lhln.splits.dps"

#' Vector clouds of LH input neurons from split GAL4 lines
#'
#' Vector cloud objects from segmented image data. Meta-data contains experimentally verified information on neurotransmitter expression. Data from Mike Dolan.
#'
#' @references Dolan, Michael-John, Shahar Frechter, Alexander Shakeel Bates, Chuntao Dan, Paavo Huoviala, Ruairí Jv Roberts, Philipp Schlegel, et al. 2019.
#' “Neurogenetic Dissection of the Drosophila Lateral Horn Reveals Major Outputs, Diverse Behavioural Functions, and Interactions with the Mushroom Body.” eLife 8 (May).
#' \href{https://doi.org/10.7554/eLife.43079}{doi:10.7554/eLife.43079}
#' @source \url{https://doi.org/10.7554/eLife.43079}
"lhin.splits.dps"

#' Vector clouds of peri-LH  neurons from split GAL4 lines
#'
#' Vector cloud objects from segmented image data. Meta-data contains experimentally verified information on neurotransmitter expression. Data from Mike Dolan.
#'
#' @references Dolan, Michael-John, Shahar Frechter, Alexander Shakeel Bates, Chuntao Dan, Paavo Huoviala, Ruairí Jv Roberts, Philipp Schlegel, et al. 2019.
#' “Neurogenetic Dissection of the Drosophila Lateral Horn Reveals Major Outputs, Diverse Behavioural Functions, and Interactions with the Mushroom Body.” eLife 8 (May).
#' \href{https://doi.org/10.7554/eLife.43079}{doi:10.7554/eLife.43079}
#' @source \url{https://doi.org/10.7554/eLife.43079}
"lhin.splits.dps"

#' Mushroom body output neuron Vector clouds representing
#'
#' Vector cloud objects from segmented image data. In FCWB space. Data from Yoshi Aso.
#'
#' @references Aso, Yoshinori, Daisuke Hattori, Yang Yu, Rebecca M. Johnston, Nirmala A. Iyer, Teri-T B. Ngo, Heather Dionne, et al. 2014.
#' “The Neuronal Architecture of the Mushroom Body Provides a Logic for Associative Learning.” eLife 3 (December): e04577.
#' \href{https://doi.org/10.7554/eLife.04577}{doi:10.7554/eLife.04577}
#' @source \url{https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4273437/}
"mbons.light.dps"

#' EM neuron skeletons for published lateral horn related reconstructions and all olfactory projection neurons.
#'
#' EM skeletons complete with synapses, a \code{neuronlist} objects for LH-associated neurons including projection neurons that input the lateral horn. These neurons have been reconstructed in both the FAFB ssTEM brain space
#' manually/semi-manually. They have also been cross-matched with their equivalent neurons from the FlyEM hemibrain project. These objects have been warped into the
#' \code{nat.flybrains::nat.flybrains::FCWB} template brain space, as has much of the data in this package. Note that the reconstruction of olfactory PN dendrites has not been done to synaptic-completion.
#'
#' @details These neurons have also been split into their putative primary neurite, primary dendrite, dendrite, axon and soma compartments. See the function \code{hemibrainr::flow_centrality}
#' for details.
#'
#' @references Bates, A. S., P. Schlegel, R. J. V. Roberts, N. Drummond, I. F.
#'   M. Tamimi, R. Turnbull, X. Zhao, et al. 2020. “Complete Connectomic
#'   Reconstruction of Olfactory Projection Neurons in the Fly Brain.” bioRxiv.
#'   \href{https://doi.org/10.1101/2020.01.19.911453}{doi:10.1101/2020.01.19.911453}.
#'
#' @references Marin, Elizabeth C., Ruairí J. V. Roberts, Laurin Büld, Maria Theiss, Markus W. Pleijzier, Tatevik Sarkissian, Willem J. Laursen, et al. 2020.
#' “Connectomics Analysis Reveals First, Second, and Third Order Thermosensory and Hygrosensory Neurons in the Adult Drosophila Brain.”
#' bioRxiv.\href{https://doi.org/10.1101/2020.01.20.912709}{doi:10.1101/2020.01.20.912709}
#'
#' @references Dolan, Michael-John, Shahar Frechter, Alexander Shakeel Bates, Chuntao Dan, Paavo Huoviala, Ruairí Jv Roberts, Philipp Schlegel, et al. 2019.
#' “Neurogenetic Dissection of the Drosophila Lateral Horn Reveals Major Outputs, Diverse Behavioural Functions, and Interactions with the Mushroom Body.” eLife 8 (May).
#' \href{https://doi.org/10.7554/eLife.43079}{doi:10.7554/eLife.43079}
#'
#' @references Dolan, Michael-John, Ghislain Belliart-Guérin, Alexander Shakeel Bates, Shahar Frechter, Aurélie Lampin-Saint-Amaux, Yoshinori Aso, Ruairí J. V. Roberts, et al. 2018.
#' “Communication from Learned to Innate Olfactory Processing Centers Is Required for Memory Retrieval in Drosophila.”
#' Neuron 100 (3): 651–68.e8.\href{https://doi.org/10.1016/j.neuron.2018.08.037}{doi:10.1016/j.neuron.2018.08.037}
#'
#' @references Huoviala, Paavo, Michael-John Dolan, Fiona M. Love, Shahar Frechter, Ruairí J. V. Roberts, Zane Mitrevica, Philipp Schlegel, et al. 2018.
#' “Neural Circuit Basis of Aversive Odour Processing in Drosophila from Sensory Input to Descending Output.”
#' bioRxiv. \href{https://doi.org/10.1101/394403}{doi:10.1101/394403}
#'
#' @references Shan Xu, C., Michal Januszewski, Zhiyuan Lu, Shin-Ya Takemura, Kenneth J. Hayworth, Gary Huang, Kazunori Shinomiya, et al. 2020.
#' “A Connectome of the Adult Drosophila Central Brain.”
#' bioRxiv. \href{https://doi.org/10.1101/2020.01.21.911859}{doi:10.1101/2020.01.21.911859}
#'
#' Li, Peter H., Larry F. Lindsey, Michał Januszewski, Zhihao Zheng, Alexander Shakeel Bates, István Taisz, Mike Tyka, et al. 2019.
#' “Automated Reconstruction of a Serial-Section EM Drosophila Brain with Flood-Filling Networks and Local Realignment.”
#' bioRxiv. \href{https://doi.org/10.1101/605634}{doi:10.1101/605634}
#'
#' @source \url{https://doi.org/10.1101/2020.01.19.911453}
#' @name lh.em
#' @rdname lh.em
"lh.fafb"
#' @name lh.em
#' @rdname lh.em
"lh.hemibrain"
#' @rdname lh.em
"pn.fafb"

#' Lateral horn neuron morphologies from Jeanne and Fisek et al. 2018
#'
#' Skeletonized 3-D Morphologies of all Digitized LHNs related to Figure 4 in Jeanne and Fisek et al. 2018.
#' Meta-data contains the LHN's voltage responses to GH146 glomerular photostimulation. Transformed into FCWB space.
#'
#' @references Jeanne, James M., Mehmet Fişek, and Rachel I. Wilson. 2018.
#' “The Organization of Projections from Olfactory Glomeruli onto Higher-Order Neurons.”
#' Neuron 98 (6): 1198–1213.e6. \href{https://doi.org/10.1016/j.neuron.2018.05.011}{doi:10.1016/j.neuron.2018.05.011}
#'
#' @source \url{https://doi.org/10.1016/j.neuron.2018.05.011}
#' @seealso \code{\link{jfw.lhns.dps}}
"jfw.lhns"

#' Vector clouds for lateral horn neuron morphologies from Jeanne and Fisek et al. 2018
#'
#' Skeletonized 3-D Morphologies of all Digitized LHNs related to Figure 4 in Jeanne and Fisek et al. 2018.
#' Meta-data contains the LHN's voltage responses to GH146 glomerular photostimulation. Transformed into FCWB space.
#'
#' @references Jeanne, James M., Mehmet Fişek, and Rachel I. Wilson. 2018.
#' “The Organization of Projections from Olfactory Glomeruli onto Higher-Order Neurons.”
#' Neuron 98 (6): 1198–1213.e6. \href{https://doi.org/10.1016/j.neuron.2018.05.011}{doi:10.1016/j.neuron.2018.05.011}
#'
#' @source \url{https://doi.org/10.1016/j.neuron.2018.05.011}
#' @seealso \code{\link{jfw.lhns}}
"jfw.lhns.dps"

#' Body IDs for lateral horn neurons in the hemibrain volume.
#'
#' Body Ids for lateral horn neurons, pulled from neuPrint from the hemibrain volume. Only neurons marked by the project as 'Traced' have been considered.
#' Lateral horn neurons defined as third-order olfactory neurons with >= 1% of their postsynapses or >= 10 postsynapses supplied by canonical
#' olfactory uniglomerular PNs.
#'
#' @references Shan Xu, C., Michal Januszewski, Zhiyuan Lu, Shin-Ya Takemura, Kenneth J. Hayworth, Gary Huang, Kazunori Shinomiya, et al. 2020.
#' “A Connectome of the Adult Drosophila Central Brain.”
#' bioRxiv. \href{https://doi.org/10.1101/2020.01.21.911859}{doi:10.1101/2020.01.21.911859}
#'
#' @source \url{https://doi.org/10.1101/2020.01.21.911859}
#' @name hemibrain
#' @rdname hemibrain
"hemibrain.lhn.bodyids"

