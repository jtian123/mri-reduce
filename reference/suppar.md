# Super Partitioning of Variables Based on Correlation

This function identifies and groups highly correlated variables into
modules from a given dataset using a series of correlation computations
stored across temporary files. It utilizes a hierarchical chunk
processing method to handle large datasets.

## Usage

``` r
suppar(
  tmp,
  thresh = NULL,
  n.chunkf = 10000,
  B = 2000,
  compute.corr = TRUE,
  dist.thresh = NULL,
  dir.tmp
)
```

## Arguments

- tmp:

  A data frame or matrix of data to be analyzed.

- thresh:

  Numeric vector; thresholds for defining the correlation strength
  necessary to consider two variables as connected or dependent. The
  function creates modules of variables that have correlations above
  these thresholds.

- n.chunkf:

  Integer; the number of features to process per chunk in the
  correlation analysis.

- B:

  Integer; the maximum size of a module. If a module reaches this size,
  it will not be merged with other modules even if its members are
  correlated with members of another module.

- compute.corr:

  Logical; should the correlation be computed (TRUE) or pre-computed
  correlations be used (FALSE).

- dist.thresh:

  Optional; a distance threshold to apply before computing correlations,
  allowing for spatial constraints on correlation computation.

- dir.tmp:

  Directory path where temporary correlation files are stored.

## Value

A list containing two elements: - A list of character vectors, where
each vector contains the names of variables that form a module. - A
character vector of independent variables not included in any module.

## Details

`suppar` function starts by setting up the environment and preparing the
data. If `compute.corr` is TRUE, it computes the correlation and stores
the results in temporary files in `dir.tmp`. It then loads these files
one by one, aggregates correlated variables into groups using the
`partagg` function, and finally, it cleans up the temporary files.

The `corfun1` and `corfun2` are helper functions called within `suppar`
to manage the computation of correlations in chunks and saving those in
a manageable manner, which helps in processing large datasets without
overwhelming memory resources.

`partagg`, an Rcpp function, efficiently processes and aggregates
variables into modules based on the correlation data read from the
temporary files. It ensures that the size of any module does not exceed
the `B` parameter.

## Examples

``` r
tmp <- matrix(rnorm(200), ncol = 20)
dir_tmp <- file.path(tempdir(), "suppar-example")
suppar(tmp = tmp, thresh = c(0.3, 0.1), n.chunkf = 20, B = 10,
       compute.corr = TRUE, dir.tmp = dir_tmp)
#> [1] "created: /tmp/RtmpoxygYd/suppar-example"
#> [1] "Finishing chunk 1 start.ind: 1 end.ind: 20 n.edges: 35"
#> [[1]]
#> NULL
#> 
#> [[2]]
#>  [1] "V1"  "V2"  "V3"  "V4"  "V5"  "V6"  "V7"  "V8"  "V9"  "V10" "V11" "V12"
#> [13] "V13" "V14" "V15" "V16" "V17" "V18" "V19" "V20"
#> 
```
