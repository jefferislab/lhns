context("test-utilities.R")

test_that("process_lhn_name", {
  baseline = data.frame(
    pnt = c("AV2", NA),
    anatomy.group = c("AV2d", NA),
    cell.type = c("AV2d1", NA),
    stringsAsFactors = FALSE
  )
  expect_equal(process_lhn_name(c("AV2d1", NA)), baseline)
})
