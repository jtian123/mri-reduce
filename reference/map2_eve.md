# Plot Mask on EVE Template using Python and Nilearn

This function plots a mask image on the EVE template using Python's
Nilearn library and optionally saves the plot as an image. It ensures
the required Python libraries are installed, and it handles the
appropriate Conda environment setup.

## Usage

``` r
map2_eve(
  mask_img_path,
  cmap = "bwr_r",
  alpha = 1,
  save_path = NULL,
  template_img_path = NULL,
  ...
)
```

## Arguments

- mask_img_path:

  A string representing the file path to the mask NIfTI file.

- cmap:

  The colormap to use. Either a string (name of a matplotlib colormap)
  or a matplotlib colormap object. Default is 'bwr_r'.

- alpha:

  Transparency level for the overlay. Default is 1.

- save_path:

  A string representing the file path where the plot image should be
  saved (e.g., "output.png"). If NULL, the plot will be shown
  interactively instead of saved. Default is NULL.

- template_img_path:

  Optional path to an EVE template image. If `NULL`, the function will
  try to use the optional package `EveTemplate`.

- ...:

  Additional arguments to customize the anatomical plot. These arguments
  are passed directly to the Python function
  `nilearn.plotting.plot_anat`. You can specify parameters such as
  `title`, `display_mode`, `cut_coords`, `dim`, etc. For more details on
  available options, refer to the official documentation at:
  https://nilearn.github.io/stable/modules/generated/nilearn.plotting.plot_anat.html

## Value

None

## Details

The function uses the Python environment configured for `reticulate`. It
checks that the required Python libraries `nilearn`, `nibabel`, and
`matplotlib` are already available, then calls the Python helper
`plot_mask_on_eve`. The background template can be provided directly, or
resolved through the optional package `EveTemplate`. If `save_path` is
provided, the plot is saved as an image at the specified location.

## Examples

``` r
if (FALSE) { # \dontrun{
map2_eve(
  mask_img_path = "/path/to/mask_nifti_GM_Volume.nii.gz",
  save_path = "/path/to/save_output.png",
  template_img_path = "/path/to/eve_template.nii.gz",
  cmap = "bwr_r",
  alpha = 0.8,
  title = "Mask on EVE Template"
)
} # }
```
