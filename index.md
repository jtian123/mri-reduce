# MRIreduce

## Introduction

MRIreduce is an advanced R package designed to convert NIfTI format
T1/FL neuroimages into structured, high-dimensional 2D data frames,
focusing on region of interest (ROI) based processing. This package
incorporates a key algorithm called ‘partition’, which offers a fast,
flexible framework for agglomerative partitioning based on the
Direct-Measure-Reduce approach. This method ensures that each reduced
variable maintains a user-specified minimum level of information while
being interpretable, as each maps uniquely to one variable in the
reduced dataset. The ‘partition’ algorithm, detailed in Millstein et
al. (2020), allows for customization in variable selection, measurement
of information loss, and data reduction methods. MRIreduce is
indispensable for researchers requiring efficient, accurate preparation
of neuroimaging data for detailed statistical analysis and machine
learning applications, enhancing the interpretability and utility of
neuroimaging studies.

## Installation Instructions

This document provides detailed steps to install the necessary
dependencies for the package. Please follow the instructions carefully
to ensure all dependencies are correctly installed.

### Step 1: Install devtools

The `devtools` package is essential for installing packages directly
from GitHub. If you do not have `devtools` installed, run the following
code:

``` r
if (!requireNamespace("devtools", quietly = TRUE))
    install.packages("devtools")
```

### Step 2: Install fslr

The fslr package is an interface to the FSL (FMRIB Software Library)
tools. Install it from CRAN:

``` r
install.packages("fslr")
```

### Step 3: Optionally install EveTemplate

If you want the package to resolve the EVE template automatically,
install the optional `EveTemplate` package. Otherwise, you can supply a
template path directly to
[`eve_T1()`](https://uscbiostats.github.io/MRIreduce/reference/eve_T1.md),
[`eve_Fl()`](https://uscbiostats.github.io/MRIreduce/reference/eve_Fl.md),
and
[`map2_eve()`](https://uscbiostats.github.io/MRIreduce/reference/map2_eve.md).

First, ensure that remotes is installed:

``` r
if (!requireNamespace("remotes", quietly = TRUE))
    install.packages("remotes")
```

Then install EveTemplate:

``` r
remotes::install_github("neuroconductor/EveTemplate")
```

### Step 4: Install FSL

FSL is not an R package but a standalone software suite for MRI and fMRI
analysis. Follow the instructions on \[their website\]
(<https://fsl.fmrib.ox.ac.uk/fsl/docs/#/install/index>) to download and
install it.
