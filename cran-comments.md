## Resubmission

This is a resubmission. The package has been updated in response to the CRAN review comments.

Changes made:

- In `DESCRIPTION`, removed single quotes around non-package terms and added a DOI-formatted reference for the partition framework: Millstein et al. (2020) `<doi:10.1093/bioinformatics/btz661>`.
- Replaced `\\dontrun{}` with `\\donttest{}` in the affected examples and guarded those examples so they remain informative without running during checks when local imaging files or external software are unavailable.
- Replaced unconditional `print()` / `cat()` progress output with suppressible `message()` calls in the files identified in the review (`R/PartitionPipeline.R`, `R/eve_Fl.R`, `R/eve_T1.R`, `R/funcs.R`, `R/suppar_source.R`).

## Test environments

- Local macOS (Apple Silicon), R 4.4.1
- GitHub Actions: ubuntu-latest (release)
- GitHub Actions: macos-latest (release)
- GitHub Actions: windows-latest (release)

## R CMD check results

- `R CMD check --as-cran --no-manual MRIreduce_1.0.0.tar.gz`: examples, `--run-donttest`, tests, and vignettes all completed successfully.
- In the current sandbox, the remaining NOTEs are environment-related only:
  - no internet access, so CRAN incoming checks and URL reachability could not be verified
  - current time verification was unavailable in this environment
  - temp-directory detritus note for `xcrun_db`
- GitHub Actions `R-CMD-check` is passing on Ubuntu, macOS, and Windows.

## Notes for CRAN

- The core pure-R package functionality checks cleanly without external neuroimaging software.
- Functions `eve_T1()` and `eve_Fl()` require the external neuroimaging software `FSL`, which is declared in `SystemRequirements`.
- Function `map2_eve()` requires a configured Python environment for `reticulate` with `nilearn`, `nibabel`, and `matplotlib`.
- The optional package `EveTemplate` is used only to resolve a default EVE template path. Users may instead supply `template_img_path` directly.
- Vignette code chunks that require external software or local imaging files are marked `eval = FALSE`.
- The package includes a minimal `testthat` suite for core pure-R functionality.
