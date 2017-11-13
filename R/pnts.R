#' Plot adult Lateral Horn primary neurite tracts
#'
#' @description Plots the primary neurite tracts from Frechter et al. 2017 in FCWB space.
#'
#' @export
#' @rdname plot.pnts
plot_pnts <- function(){
  nat::nopen3d()
  rgl::plot3d(nat.flybrains::FCWB)
  rgl::plot3d(lhns::primary.neurite.tracts,soma=T,lwd=5)
  pxyz= amount = t(sapply(lhns::primary.neurite.tracts, function(x) nat::xyzmatrix(x)[nat::rootpoints(x),]))
  rownames(pxyz) = gsub(pattern = "LH|lh","",names(lhns::primary.neurite.tracts))
  shift <- matrix(c(-3, 3, 0), nrow(pxyz), 3, byrow = TRUE)
  rgl::text3d(pxyz + shift,texts =rownames(pxyz))
  rownames(amount) = sapply(lhns::primary.neurite.tracts[,"pnt"], function(x) length(lhns::most.lhns[lhns::most.lhns[,"pnt"]%in%x]))
  shift2 <- matrix(c(-3, 10, 0), nrow(amount), 3, byrow = TRUE)
  rgl::text3d(amount + shift2,texts =rownames(amount),col="red",cex=0.75)
}
