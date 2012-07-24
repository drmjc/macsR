context("Annotation testing")

test_that("test files exist", {
	expect_true( is.dir(system.file("examples", "MACS-2sample-50hits", package="macsR")) )
	expect_true( file.exists(system.file("examples", "MACS-2sample-50hits", "FoxA1.vs.input.MCF7_peaks.xls", package="macsR")) )
	expect_true( is.tsv.file(system.file("examples", "MACS-2sample-50hits", "FoxA1.vs.input.MCF7_peaks.xls", package="macsR")) ) 
})

test_that("annotation on a 'fixed' MACS dir works", {
	input <- system.file("examples", "MACS-2sample-50hits-fixed", package="macsR")
	expect_that(
		is.dir(input), 
		is_true()
	)
	testdir <- tempfile("annotate.macs")
	dir.create(testdir)
	# message("testing annotation in", dir)
	
	file.copy(dir(input, full.names=TRUE), testdir)
	expect_that(
		peaks.annot <- annotate.macs.output(testdir),
		shows_message("Writing xls to")
	)
	expect_that(length(dir(testdir)), equals(13))
	expect_true(file.exists(file.path(testdir,"FoxA1.vs.input.MCF7_peaks_annot.xls")))
	expect_true(is.excel.file(file.path(testdir,"FoxA1.vs.input.MCF7_peaks_annot.xls")))
	
	unlink(testdir)
})
