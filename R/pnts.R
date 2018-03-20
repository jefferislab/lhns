#' Plot adult Lateral Horn primary neurite tracts
#'
#' @description Plots the primary neurite tracts from Frechter et al. 2017 in
#'   \code{\link[nat.flybrains]{FCWB}} space.
#' @param open whether to open a new RGL window for plotting
#' @param brain the brainspace in which to plot the primary neurite tracts. Defaults to FCWB
#'   (default=\code{TRUE})
#' @seealso \code{\link[nat.flybrains]{FCWB}}
#' @export
#' @importFrom rgl par3d plot3d text3d scaleMatrix
#' @importFrom nat.templatebrains xform_brain
plot_pnts <- function(open=TRUE, brain = nat.flybrains::FCWB){
  if(open){
    nat::nopen3d()
    par3d(userMatrix=scaleMatrix(1,-1,-1))
  }
  if(brain!=nat.flybrains::FCWB){
    pnts = xform_brain(lhns::primary.neurite.tracts,sample=nat.flybrains::FCWB,reference = brain)
  } else{
    pnts = lhns::primary.neurite.tracts
  }
  plot3d(pnts,soma=T,lwd=5, skipRedraw = TRUE)
  pxyz= amount = t(sapply(lhns::primary.neurite.tracts, function(x) nat::xyzmatrix(x)[nat::rootpoints(x),]))
  rownames(pxyz) = gsub(pattern = "LH|lh","",names(lhns::primary.neurite.tracts))
  shift <- matrix(c(-3, 3, 0), nrow(pxyz), 3, byrow = TRUE)
  text3d(pxyz + shift,texts =rownames(pxyz))
  rownames(amount) = sapply(lhns::primary.neurite.tracts[,"pnt"], function(x) length(lhns::most.lhns[lhns::most.lhns[,"pnt"]%in%x]))
  shift2 <- matrix(c(-3, 10, 0), nrow(amount), 3, byrow = TRUE)
  text3d(amount + shift2,texts =rownames(amount),col="red",cex=0.75)
  plot3d(nat.flybrains::FCWB)
}


