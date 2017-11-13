[![Travis-CI Build Status](https://travis-ci.org/jefferislab/lhns.svg?branch=master)](https://travis-ci.org/jefferislab/lhns)
# lhns
R Package containing neuron skeleton data relevant to the lateral horn of the vinegar fly, Drosophila melanogaster. For use with [nat](https://github.com/jefferis/rcatmaid). In development.

## What's in the package currently?
```r
# install
if (!require("devtools")) install.packages("devtools")
devtools::install_github("jefferislab/lhns")
library(lhns)
plot3d(most.lhns)
?most.lhns
plot_pnts()
```

## Remaking data

To remake the data from scratch, I recommend opening the rstudio project and then:

```r
source("data-raw/make.R")
```

Note: Windows users need [Rtools](http://www.murdoch-sutherland.com/Rtools/) and
[devtools](http://CRAN.R-project.org/package=devtools) to install this way.

## Acknowledgements

Data from FlyCircuit and dye-fills of LH neurons by Shahar Frechter. Data compiled and annotated for analysis in Frechter et al. (2017) by Alexander Bates and Shahar Frechter. 

