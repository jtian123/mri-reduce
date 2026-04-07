# Partition Pipeline for Image Analysis

This R6 class is designed to streamline the processing pipeline for
image analysis, including steps from initial processing to combining
independent variables with reduced variables by tissue type by ROI.

## Methods

### Public methods

- [`PartitionPipeline$new()`](#method-PartitionPipeline-new)

- [`PartitionPipeline$iproc()`](#method-PartitionPipeline-iproc)

- [`PartitionPipeline$supparfun()`](#method-PartitionPipeline-supparfun)

- [`PartitionPipeline$map_suppar_roi()`](#method-PartitionPipeline-map_suppar_roi)

- [`PartitionPipeline$partition_intensities()`](#method-PartitionPipeline-partition_intensities)

- [`PartitionPipeline$tissue_segment()`](#method-PartitionPipeline-tissue_segment)

- [`PartitionPipeline$Cmb_tissue_type()`](#method-PartitionPipeline-Cmb_tissue_type)

- [`PartitionPipeline$process_indep_variables()`](#method-PartitionPipeline-process_indep_variables)

- [`PartitionPipeline$Cmb_indep_with_dep()`](#method-PartitionPipeline-Cmb_indep_with_dep)

- [`PartitionPipeline$clone()`](#method-PartitionPipeline-clone)

------------------------------------------------------------------------

### Method `new()`

#### Usage

    PartitionPipeline$new(
      tind = NULL,
      nfl = NULL,
      main_dir = NULL,
      tissue_type = NULL,
      outp_volume = TRUE,
      ICC_thresh_vec = NULL,
      suppar_thresh_vec = seq(0.7, 1, 0.01),
      B = 2000,
      roi = NULL,
      num_cores = NULL
    )

------------------------------------------------------------------------

### Method `iproc()`

#### Usage

    PartitionPipeline$iproc()

------------------------------------------------------------------------

### Method `supparfun()`

#### Usage

    PartitionPipeline$supparfun()

------------------------------------------------------------------------

### Method `map_suppar_roi()`

#### Usage

    PartitionPipeline$map_suppar_roi()

------------------------------------------------------------------------

### Method `partition_intensities()`

#### Usage

    PartitionPipeline$partition_intensities()

------------------------------------------------------------------------

### Method `tissue_segment()`

#### Usage

    PartitionPipeline$tissue_segment()

------------------------------------------------------------------------

### Method `Cmb_tissue_type()`

#### Usage

    PartitionPipeline$Cmb_tissue_type()

------------------------------------------------------------------------

### Method `process_indep_variables()`

#### Usage

    PartitionPipeline$process_indep_variables()

------------------------------------------------------------------------

### Method `Cmb_indep_with_dep()`

#### Usage

    PartitionPipeline$Cmb_indep_with_dep()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    PartitionPipeline$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
