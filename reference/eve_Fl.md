# Process FLAIR Neuroimages and Register to EVE Brain Template

This function processes FLAIR (Fluid-Attenuated Inversion Recovery)
neuroimages for better lesion detection, especially in the
periventricular area by suppressing the CSF signal. It involves steps
such as reading the image, reorienting, bias correction using N4, brain
extraction, registration to the EVE template, and tissue segmentation.
It finally calculates the intracranial volume and outputs the data.

## Usage

``` r
eve_Fl(
  fpath,
  outpath,
  fsl_path,
  fsl_outputtype = "NIFTI_GZ",
  template_img_path = NULL
)
```

## Arguments

- fpath:

  Character string specifying the path to the FLAIR image file. The file
  should be in NIFTI file format (.nii.gz).

- outpath:

  Character string specifying the output directory where the processed
  data is saved.

- fsl_path:

  Character string specifying the path to the FSL software on the
  system.

- fsl_outputtype:

  Character string specifying the type of output file format for FSL;
  defaults to "NIFTI_GZ".

- template_img_path:

  Optional path to an EVE template image. If `NULL`, the function will
  try to use the optional package `EveTemplate`.

## Value

Returns a list containing three elements: `intensities`, `tissues`, and
`brain_volume_cm3`. Each element corresponds to the array of
intensities, the segmented tissue data, and the calculated brain
volumes, respectively. The function also saves these results as an
.Rdata file at the specified output path.

## Details

The function uses FSL tools for image processing steps such as
reorientation to standard space, bias correction, brain extraction, and
tissue segmentation. Segmentation into different tissue types (CSF, grey
matter, and white matter) is performed using FSL's FAST tool. Volumes
are calculated based on the segmented tissues.

## Examples

``` r
if (FALSE) { # \dontrun{
eve_Fl("path/to/your/flair/image.nii.gz",
       "path/to/output/",
       "/usr/local/fsl",
       "NIFTI_GZ")
} # }
```
