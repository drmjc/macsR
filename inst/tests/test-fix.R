context("fix.macs.output testing")

test_that("test files exist", {
	expect_true( is.dir(system.file("examples", "MACS-2sample-50hits", package="macsR")) )
	expect_true( is.dir(system.file("examples", "MACS-2sample-50hits-fixed", package="macsR")) )
	expect_true( file.exists(system.file("examples", "MACS-2sample-50hits", "FoxA1.vs.input.MCF7_peaks.xls", package="macsR")) )
	expect_true( is.tsv.file(system.file("examples", "MACS-2sample-50hits", "FoxA1.vs.input.MCF7_peaks.xls", package="macsR")) ) 
	expect_true( file.exists(system.file("examples", "MACS-2sample-50hits-fixed", "FoxA1.vs.input.MCF7_peaks.xls", package="macsR")) )
	expect_true( is.excel.file(system.file("examples", "MACS-2sample-50hits-fixed", "FoxA1.vs.input.MCF7_peaks.xls", package="macsR")) ) 
})

test_that("fix.macs.output testing", {
	input <- system.file("examples", "MACS-2sample-50hits", package="macsR")
	testdir <- tempfile("fix.macs")
	dir.create(testdir)
	# cat("testdir:", testdir, "\n")
	file.copy(dir(input, full.names=TRUE), testdir)
	
	expect_that(
		peaks <- fix.macs.output(testdir),
		is_a("data.frame")
	)
	
	expect_that( length(dir(testdir)), equals(12) )
	expect_that( length(dir(testdir, pattern=".*peaks-FDR.*bed")), equals(4) )
	
	expect_true( file.exists(file.path(testdir, "FoxA1.vs.input.MCF7_peaks_original.xls")) )
	expect_true( is.tsv.file(file.path(testdir, "FoxA1.vs.input.MCF7_peaks_original.xls")) )

	expect_true( file.exists(file.path(testdir, "FoxA1.vs.input.MCF7_peaks.xls")) )
	expect_true( is.excel.file(file.path(testdir, "FoxA1.vs.input.MCF7_peaks.xls")) )
	
	expect_true( file.exists(file.path(testdir, "FoxA1.vs.input.MCF7_negative_peaks.xls")) )
	expect_true( is.excel.file(file.path(testdir, "FoxA1.vs.input.MCF7_negative_peaks.xls")) )
	
	# @TODO: write some tests comparing the actual output with the expected output in 'examples/MACS-2sample-50hits-fixed'
	unlink(testdir)
})