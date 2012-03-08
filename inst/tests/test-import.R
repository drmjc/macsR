context("File I/O testing")

test_that("test files exist", {
	expect_that(
		file.exists(system.file("examples", "macs_peaks-tsv.xls", package="macsR")), 
		is_true()
	)
	expect_that(
		file.exists(system.file("examples", "macs_negative_peaks-tsv.xls", package="macsR")), 
		is_true()
	)
	expect_that(
		file.exists(system.file("examples", "macs_peaks-xls.xls", package="macsR")), 
		is_true()
	)
	expect_that(
		file.exists(system.file("examples", "macs_negative_peaks-xls.xls", package="macsR")), 
		is_true()
	)
})

test_that("test files are correct format", {
	expect_true(
		is.tsv.file(system.file("examples", "macs_peaks-tsv.xls", package="macsR"))
	)
	expect_true(
		is.tsv.file(system.file("examples", "macs_negative_peaks-tsv.xls", package="macsR"))
	)
	expect_true(
		is.excel.file(system.file("examples", "macs_peaks-xls.xls", package="macsR"))
	)
	expect_true(
		is.excel.file(system.file("examples", "macs_negative_peaks-xls.xls", package="macsR"))
	)
})

test_that("tsv _peaks files can be imported", {
	f <- system.file("examples", "macs_peaks-tsv.xls", package="macsR")
	p <- import.macs.peaks.file(f)
	expect_that(p, is_a("data.frame"))
	expect_that(nrow(p), equals(21))
})

test_that("tsv _negative_peaks files can be imported", {
	f <- system.file("examples", "macs_negative_peaks-tsv.xls", package="macsR")
	p <- import.macs.peaks.file(f)
	expect_that(p, is_a("data.frame"))
	expect_that(nrow(p), equals(23))
})


test_that("xls _peaks peaks files can be imported", {
	f <- system.file("examples", "macs_peaks-xls.xls", package="macsR")
	p <- import.macs.peaks.file(f)
	expect_that(p, is_a("data.frame"))
	expect_that(nrow(p), equals(20))
})

test_that("xls _negative_peaks peaks files can be imported", {
	f <- system.file("examples", "macs_negative_peaks-xls.xls", package="macsR")
	p <- import.macs.peaks.file(f)
	expect_that(p, is_a("data.frame"))
	expect_that(nrow(p), equals(20))
})
