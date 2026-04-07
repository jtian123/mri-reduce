#' Plot Mask on EVE Template using Python and Nilearn
#'
#' This function plots a mask image on the EVE template using Python's Nilearn library and optionally saves the plot as an image.
#' It ensures the required Python libraries are installed, and it handles the appropriate Conda environment setup.
#'
#' @param mask_img_path A string representing the file path to the mask NIfTI file.
#' @param cmap The colormap to use. Either a string (name of a matplotlib colormap) or a matplotlib colormap object. Default is 'bwr_r'.
#' @param alpha Transparency level for the overlay. Default is 1.
#' @param save_path A string representing the file path where the plot image should be saved (e.g., "output.png"). If NULL, the plot will be shown interactively instead of saved. Default is NULL.
#' @param template_img_path Optional path to an EVE template image. If `NULL`,
#' the function will try to use the optional package `EveTemplate`.
#' @param ... Additional arguments to customize the anatomical plot. These arguments are passed
#'        directly to the Python function `nilearn.plotting.plot_anat`. You can specify parameters
#'        such as `title`, `display_mode`, `cut_coords`, `dim`, etc.
#'        For more details on available options, refer to the official documentation at:
#'        https://nilearn.github.io/stable/modules/generated/nilearn.plotting.plot_anat.html
#' @details
#' The function uses the Python environment configured for `reticulate`.
#' It checks that the required Python libraries `nilearn`, `nibabel`, and
#' `matplotlib` are already available, then calls the Python helper
#' `plot_mask_on_eve`. The background template can be provided directly, or
#' resolved through the optional package `EveTemplate`. If `save_path` is
#' provided, the plot is saved as an image at the specified location.
#'
#' @return None
#' @importFrom reticulate source_python
#' @examples
#' \dontrun{
#' map2_eve(
#'   mask_img_path = "/path/to/mask_nifti_GM_Volume.nii.gz",
#'   save_path = "/path/to/save_output.png",
#'   template_img_path = "/path/to/eve_template.nii.gz",
#'   cmap = "bwr_r",
#'   alpha = 0.8,
#'   title = "Mask on EVE Template"
#' )
#' }
#'
#' @export
map2_eve <- function(mask_img_path, cmap = 'bwr_r', alpha = 1, save_path = NULL, template_img_path = NULL, ...) {
  ensure_python_environment <- function() {
    if (!reticulate::py_available(initialize = FALSE)) {
      stop(
        "No Python environment is configured for reticulate. ",
        "Configure Python first, then install nilearn, nibabel, and matplotlib."
      )
    }

    reticulate::py_config()
  }

  ensure_python_dependencies <- function() {
    required_modules <- c("nilearn", "nibabel", "matplotlib")
    missing_modules <- required_modules[!vapply(required_modules, reticulate::py_module_available, logical(1))]
    if (length(missing_modules) > 0) {
      stop(
        "Missing required Python packages: ",
        paste(missing_modules, collapse = ", "),
        ". Install them in the Python environment configured for reticulate."
      )
    }
  }

  ensure_python_environment()
  ensure_python_dependencies()

  template_img_path <- resolve_eve_template_path(template_img_path)

  python_env <- new.env(parent = emptyenv())
  reticulate::source_python(system.file("python/plot_mask_on_eve.py", package = "MRIreduce"), envir = python_env)
  if (!exists("plot_mask_on_eve", envir = python_env, inherits = FALSE)) {
    stop("The Python helper `plot_mask_on_eve` could not be loaded.")
  }

  # Call the Python function with the template image path
  python_env$plot_mask_on_eve(mask_img_path = mask_img_path, template_img_path = template_img_path, cmap = cmap, alpha = alpha,save_path = save_path, ...)
}

##test
#map2_eve(mask_img_path = "/Users/jinyaotian/Downloads/mask_nifti_GM_Volume_pm25_test1_avg_red.nii.gz",save_path = '/Users/jinyaotian/Desktop/test.png',title = "Mask on EVE Template" )
