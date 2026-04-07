test_that("load_required_data returns packaged objects without touching .GlobalEnv", {
  expect_false(exists("lab_df", envir = .GlobalEnv, inherits = FALSE))

  label_info <- MRIreduce:::load_required_data("eve_label_info_dataframe.RData", "MRIreduce")
  expect_named(label_info, "lab_df")
  expect_s3_class(label_info[["lab_df"]], "data.frame")
  expect_false(exists("lab_df", envir = .GlobalEnv, inherits = FALSE))
})

test_that("suppar returns dependent groups and independent features", {
  set.seed(1)
  tmp <- matrix(rnorm(80), ncol = 8)
  colnames(tmp) <- paste0("V", seq_len(ncol(tmp)))

  dir_tmp <- file.path(tempdir(), "suppar-test")
  result <- MRIreduce::suppar(tmp = tmp, thresh = c(0.1, 0.05), n.chunkf = 8, B = 4,
                              compute.corr = TRUE, dir.tmp = dir_tmp)

  expect_length(result, 2)
  expect_true(is.list(result[[1]]) || is.null(result[[1]]))
  expect_type(result[[2]], "character")
})

test_that("map_feature2_loc resolves unreduced feature names from saved ROI data", {
  tmp_main <- file.path(tempdir(), "mrireduce-map-feature")
  dir.create(file.path(tmp_main, "intensities"), recursive = TRUE, showWarnings = FALSE)

  roi <- "inferior_frontal_gyrus_left"
  tind <- 5
  df <- data.frame(
    V1 = c(1, 2, 3, 10, 20),
    V2 = c(4, 5, 6, 30, 40)
  )
  rownames(df) <- c("x", "y", "z", "img1", "img2")
  saveRDS(df, file.path(tmp_main, "intensities", paste0("intensities_", roi, "_", tind, ".rds")))

  loc_df <- MRIreduce::map_feature2_loc(
    feature_name = paste0(roi, "_V2"),
    threshold = 0.8,
    main_dir = tmp_main
  )

  expect_equal(dim(loc_df), c(3L, 1L))
  expect_equal(as.numeric(loc_df[[1]]), c(4, 5, 6))
})
