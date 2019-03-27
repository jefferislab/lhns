[![Travis-CI Build Status](https://travis-ci.org/jefferislab/lhns.svg?branch=master)](https://travis-ci.org/jefferislab/lhns)
# lhns
R Package containing neuron skeleton data relevant to the lateral horn of the vinegar fly, Drosophila melanogaster. For use with [nat](https://github.com/jefferis/rcatmaid). In development.


## Installation

In R
```r
# install
if (!require("devtools")) install.packages("devtools")
devtools::install_github("jefferislab/lhns")
```

The package is being updated regularly. Running:

```r
devtools::update_packages('jefferislab/lhns')
```
will update from github *if necessary*.

## What's in the package currently?
```r

# use
library(lhns)
plot3d(most.lhns)
?most.lhns
plot_pnts()
```

## Remaking data

To remake the data from scratch, you will need to clone the github repository. You can do this in the terminal like so:

```
# choose an appropriate location
cd /path/to/some/folder/
git clone https://github.com/jefferislab/lhns.git
```

I then recommend opening the rstudio project and doing:

```r
source("data-raw/make.R")
```

To use this, you will then need to reinstall the `lhns` package from your local checkout 

```r
# adjust to path of your git checkout
devtools::install("/path/to/some/folder/lhns")
```
### LHN cell types
If you need to alter an LHN cell type classification, you need to edit
[processLHNs.R](data-raw/processLHNs.R) and then follow the steps above i.e. 
`source("data-raw/make.R")`. 
### Commiting changes

You can commit any changes in git using the integrated support for git in Rstudio. You will have to ask for write access to push to the github repo.

## Acknowledgements
* Images from [FlyCircuit](http://flycircuit.tw) were obtained from the NCHC (National Center for High-performance Computing) and NTHU (National Tsing Hua University), Hsinchu, Taiwan.
* Dye-fills of LH neurons were obtained by Shahar Frechter.
* **Add acknowledgements for additional data**

Data initially compiled and annotated for analysis in:


> *Functional and Anatomical Specificity in a Higher Olfactory Centre*.
> Shahar Frechter, Alexander S. Bates, Sina Tootoonian, Michael-John Dolan, James D. Manton, Arian Jamasb, Johannes Kohl, Davi Bock, Gregory S.X.E. Jefferis.
> 5 June 2018; bioRxiv 336982; doi: https://doi.org/10.1101/336982


by Alexander Bates and Shahar Frechter. 
