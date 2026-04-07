## Test environments

- Local macOS (Apple Silicon), R 4.4.1
- `R CMD check --no-manual MRIreduce_1.0.0.tar.gz`
- `R CMD check --as-cran --no-manual MRIreduce_1.0.0.tar.gz`

## R CMD check results

- `R CMD check --no-manual` returned `Status: OK`
- `R CMD check --as-cran --no-manual` returned only environment-related NOTEs in the current sandbox:
  - no internet access, so CRAN incoming checks and URL reachability could not be verified
  - current time verification was unavailable in this environment
  - temp-directory detritus note for `xcrun_db`

## Notes for CRAN

- Functions `eve_T1()` and `eve_Fl()` require the external neuroimaging software `FSL`, which is declared in `SystemRequirements`.
- Function `map2_eve()` requires an already configured Python environment for `reticulate` with the Python packages `nilearn`, `nibabel`, and `matplotlib`.
- The optional package `EveTemplate` is used only to resolve a default EVE template path. Users may instead supply `template_img_path` directly.
- Examples that require external software or local neuroimaging files are wrapped in `\\dontrun{}`.
- The package includes a minimal `testthat` suite for core pure-R functionality.
