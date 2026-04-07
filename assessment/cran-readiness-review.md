# MRIreduce Code Quality And CRAN Readiness Review

Date: 2026-04-06

## Update After Initial Remediation

After the first implementation pass, the package status improved materially:

- `R CMD check --no-manual MRIreduce_1.0.0.tar.gz` now completes with **1 NOTE**
- The remaining NOTE is package size:
  - installed size about **14.2 MB**
  - `extdata` about **13.2 MB**

The earlier hard `R CMD check` failure on missing `DESCRIPTION` dependencies is fixed.
The confirmed runtime bugs around `map_feature2_loc()`, `eve_Fl()` path handling,
`PartitionPipeline` cluster cleanup, and several namespace issues are also fixed.

Current practical assessment: **substantially closer, but still not fully CRAN-ready**.

The main remaining submission risks are:

- bundled data footprint
- CRAN policy review for external tooling expectations (`FSL`, Python, and non-CRAN-style installation assumptions)
- lack of automated tests/CI package checks

## Update After CRAN-Focused Cleanup

After a second pass focused on package size and regression coverage:

- `R CMD check --no-manual MRIreduce_1.0.0.tar.gz` now returns **Status: OK**
- `R CMD check --as-cran --no-manual MRIreduce_1.0.0.tar.gz` returns only **environment-related NOTEs** on this machine

What changed:

- removed the two large bundled example/template files from `inst/extdata`
- changed `map2_eve()` to obtain the anatomical template from `EveTemplate` instead of shipping a large NIfTI file
- simplified the vignette so it no longer depends on the removed large sample object
- added a minimal `testthat` suite for core pure-R behavior
- cleaned remaining CRAN-style metadata/documentation issues

Current practical assessment: **moderately close to CRAN submission**, with the main caveat being that final confidence still depends on running `--as-cran` on a machine with normal internet access and doing one more pass on external-tool expectations.

If I had to rescore it now for your boss, I would move it from about **3/10** to about **7.5/10** for a first CRAN submission.

The remaining local `--as-cran` NOTEs appear to be environmental rather than package defects:

- no internet access, so CRAN incoming checks and URL reachability cannot be verified here
- local time verification unavailable in this environment
- temp-directory detritus note for `xcrun_db`

## Bottom line

Current assessment: **not close to CRAN-ready yet**.

If I had to summarize this for management: I would rate the package at roughly **3/10 for a first CRAN submission** in its current state. The main reason is not style or minor polish. It already fails a local `R CMD check`, and there are several confirmed runtime bugs in the pipeline code and documentation/check issues that CRAN would flag quickly.

That said, this does **not** look unsalvageable. The package has a real structure, a built vignette, compiled code, and a coherent workflow. The gap is mainly in package engineering, dependency hygiene, and runtime robustness.

## What I checked

- Package metadata: `DESCRIPTION`, `NAMESPACE`, build/check behavior
- Exported R functions and major internal pipeline code
- Generated `.Rd` files and vignette
- Included data footprint and repository/package structure
- Basic local diagnostics:
  - `R CMD build .`
  - `R CMD check --no-manual MRIreduce_1.0.0.tar.gz`

## Confirmed CRAN blockers

### 1. `R CMD check` already fails on package dependencies

Local check result:

```text
Namespace dependencies missing from DESCRIPTION Imports/Depends entries:
  'EveTemplate', 'extrantsr', 'fslr', 'oro.nifti', 'R6'
```

Evidence:

- `DESCRIPTION:12-27`
- `NAMESPACE:10-25`
- `MRIreduce.Rcheck/00check.log`

Why this matters:

- This is a hard submission blocker. CRAN will reject the package before getting to deeper review.

### 2. Additional unimported functions are used and will likely fail after the first dependency issue is fixed

Confirmed unqualified calls:

- `inner_join` in `R/funcs.R:303`
- `bind_cols` in `R/funcs.R:460-461`
- `partition` and `mapping_key` in `R/funcs.R:192-194`
- `str_extract` in `R/funcs.R:517,528`

Why this matters:

- These functions are not imported in `NAMESPACE`.
- Some may only work accidentally if the user has attached other packages manually.
- After the current DESCRIPTION error is fixed, these are likely to surface as runtime failures or check notes/errors.

### 3. Examples for FSL-dependent functions are not actually protected from execution

Evidence:

- `man/eve_T1.Rd:51-56`
- `man/eve_Fl.Rd:35-43`

Problem:

- The examples use literal comments like `## Not run:` instead of `\dontrun{}` or a CRAN-safe conditional.
- In generated Rd files, that means the `eve_T1(...)` and `eve_Fl(...)` calls are still executable examples.

Why this matters:

- These functions require local files and FSL.
- CRAN checks examples. In current form, these are likely to fail.

### 4. `map2_eve()` installs Python/Conda dependencies at runtime

Evidence:

- `R/map2_eve.R:35-105`

Problem:

- The function attempts to install Miniconda and Python packages (`nilearn`, `nibabel`, `matplotlib`) automatically.

Why this matters:

- CRAN strongly disfavors packages that install software or reach out to the network during examples/checks/runtime in this way.
- Even outside CRAN, this is a heavy side effect for a plotting helper.

### 5. Package size is large for CRAN

Observed sizes:

- Built source tarball: about **14.0 MB**
- `inst/extdata`: about **13.85 MB**

Largest bundled files:

- `inst/extdata/eve_t1.nii.gz`
- `inst/extdata/1514935-20050520_T1.nii.gz.Rdata`

Why this matters:

- CRAN prefers smaller source packages and often questions large bundled datasets.
- This is not always fatal, but it is a real submission risk and may require trimming or strong justification.

## Confirmed runtime bugs and correctness issues

### 1. `map_feature2_loc()` refers to the wrong package name

Evidence:

- `R/map_feature2_loc.R:57`

Problem:

- It loads data from package `"whims"` instead of `"MRIreduce"`.

Impact:

- This is a direct runtime bug.
- On this machine, `whims` is not installed, and the lookup fails immediately.

### 2. `Cmb_tissue_type()` expects a `fname` column that `tissue_segment()` removes before saving

Evidence:

- Writer removes `fname`: `R/funcs.R:308-315`
- Reader expects `fname`: `R/funcs.R:385-389`

Problem:

- `tissue_segment()` saves volume files without the `fname` column.
- `Cmb_tissue_type()` then tries to restore row names from `df$fname`.

Impact:

- This looks like a deterministic pipeline break, not a corner case.

### 3. `process_indep_variables()` can silently misalign voxel unit scaling

Evidence:

- `R/funcs.R:446-452`

Problem:

- `unit_ = volumes$unit_voxel` is applied by position, not by matching image name.

Impact:

- If row order differs, output volumes will be wrong without throwing an error.

### 4. `eve_Fl()` constructs output paths unsafely

Evidence:

- `R/eve_Fl.R:124`

Problem:

- `outfile <- paste0(outpath, fnm, ".Rdata")`

Impact:

- If `outpath` does not end with `/`, the output path is malformed.
- `eve_T1()` uses `file.path()` correctly; `eve_Fl()` does not.

### 5. Cluster cleanup in `PartitionPipeline$partition_intensities()` is registered too late

Evidence:

- `R/PartitionPipeline.R:65-74`

Problem:

- `on.exit(stopCluster(cl))` is set **after** `parLapply()`.

Impact:

- If `parLapply()` errors, the cluster may be left running.

### 6. Data-loading helper writes into `.GlobalEnv`

Evidence:

- `R/funcs.R:10-16`

Problem:

- `load_required_data(..., envir = .GlobalEnv)`

Impact:

- Package functions create global side effects.
- This makes debugging harder and is poor package behavior.

### 7. `concat_reduced_var()` appears unfinished/broken

Evidence:

- `R/funcs.R:511-536`

Problems:

- Uses `files`, which is undefined
- Uses `str_extract()` without importing `stringr`
- No tests or documentation indicate this is working

Impact:

- Even if currently unused, dead broken code lowers package quality and can become a future maintenance trap.

## Quality and submission risks that are not immediate check failures but still important

### 1. No tests are present

Observed:

- No `tests/`
- No `tests/testthat/`

Impact:

- For a pipeline this complex, lack of automated tests is a major risk.
- It also weakens confidence when fixing CRAN issues because regressions are hard to detect.

### 2. CI only builds pkgdown, not package checks

Evidence:

- Only workflow found: `.github/workflows/pkgdown.yaml`

Impact:

- There is no visible GitHub Action enforcing `R CMD check`.
- That likely explains why some package-engineering issues have persisted for a year.

### 3. `DESCRIPTION` mixes runtime dependencies with development tooling

Evidence:

- `DESCRIPTION:12-27`

Examples:

- `devtools`
- `roxygen2`
- `remotes`

Impact:

- These generally do not belong in runtime `Imports`.
- This is a maintainability smell and may complicate dependency resolution.

### 4. Personal/local paths appear in public API defaults and docs

Evidence:

- Default FSL path: `R/eve_T1.R:44`
- Generated Rd usage: `man/eve_T1.Rd:6-12`
- Vignette examples use `/Users/jinyaotian/...`: `vignettes/MRIreduce.Rmd:104-119`

Impact:

- This is not acceptable for a general-purpose CRAN package interface.
- It also makes the package look insufficiently generalized.

### 5. Documentation has some correctness issues

Examples:

- Description refers to `"NeuroPartitioner"` instead of `MRIreduce`: `DESCRIPTION:10`
- `suppar` example is malformed and produces a warning:
  - `man/suppar.Rd:66-69`
- Vignette note says `mask_img_path` should point to `loc_df`, but `map2_eve()` expects a mask NIfTI path:
  - `R/map2_eve.R:6`
  - `vignettes/MRIreduce.Rmd:202`

## Overall CRAN-readiness judgment

### My answer to the main question

**How close is this package to CRAN submission?**

Not very close in its current form.

I would not recommend attempting CRAN submission yet. The package needs at least one solid package-engineering pass before it becomes a realistic candidate, and then a second pass to validate behavior with tests/checks on clean systems.

If the goal is "could we submit soon with focused effort?", my answer is:

- **Possible, but not immediately**
- **Requires multiple blocking fixes first**
- **Needs explicit strategy for FSL/Python/external dependency handling**

## Recommended plan before implementing anything

### Phase 1. Make the package pass basic package checks

Goal:

- Clean `R CMD check` on a clean machine before thinking about CRAN submission.

Tasks:

- Fix `DESCRIPTION` vs `NAMESPACE` dependency declarations
- Import or namespace-qualify all called functions
- Remove development-only tools from runtime imports
- Replace unsafe executable examples with CRAN-safe `\dontrun{}` or conditional examples
- Remove personal default paths from exported APIs

### Phase 2. Fix confirmed pipeline/runtime bugs

Tasks:

- Fix the `whims` package reference in `map_feature2_loc()`
- Fix the `fname` inconsistency between `tissue_segment()` and `Cmb_tissue_type()`
- Align volume scaling by image identifier, not row order
- Fix unsafe path construction in `eve_Fl()`
- Move cluster cleanup to safe error-handling scope
- Remove `.GlobalEnv` side effects from data loading
- Either repair or remove unfinished dead code like `concat_reduced_var()`

### Phase 3. Decide the CRAN strategy for external tooling

This is the most important design question.

Need decisions on:

- How FSL-dependent functions behave on systems without FSL
- Whether `map2_eve()` should remain in this package, be refactored to avoid auto-installation, or be moved behind a softer optional interface
- Whether bundled neuroimaging example files should be reduced, moved, or downloaded outside CRAN

### Phase 4. Add confidence infrastructure

Tasks:

- Add unit tests for core data transformations
- Add at least one lightweight end-to-end smoke test with tiny bundled fixtures
- Add GitHub Actions for `R CMD check`
- Run `R CMD check --as-cran` on at least macOS and Linux

## Suggested priority order

1. Fix package metadata/imports/check failures
2. Fix deterministic pipeline bugs
3. Refactor external dependency behavior for CRAN safety
4. Add tests and check CI
5. Reassess whether data footprint is acceptable for CRAN

## Short management summary

The package looks like a serious research tool, but it is currently packaged more like a lab/internal package than a CRAN-ready public package. The main blockers are package-engineering issues, not the core idea. I would treat CRAN submission as a **short project**, not a near-term button press.
