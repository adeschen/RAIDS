### Unit tests for tools_internal.R functions

library(RAIDS)
library(withr)
library(gdsfmt)
library(Rsamtools)

#############################################################################
### Tests validateGDSClass() results
#############################################################################

context("validateGDSClass() results")


test_that("validateGDSClass() must return expected results when all input are valid", {

    data.dir <- test_path("fixtures")
    fileGDS <- file.path(data.dir, "1KG_Test.gds")

    gdsF <- openfn.gds(fileGDS)
    withr::defer((gdsfmt::closefn.gds(gdsF)), envir = parent.frame())

    result1 <- RAIDS:::validateGDSClass(gds=gdsF, name="gds")

    expect_identical(result1, 0L)
})


test_that("validateGDSClass() must return error when input is not valid", {

    expected <- "The \'tudo_01\' must be an object of class \'gds.class\'."

    expect_error(RAIDS:::validateGDSClass(gds="toto.gds", name="tudo_01"),
                    expected, fixed=TRUE)
})


#############################################################################
### Tests validateLogical() results
#############################################################################

context("validateLogical() results")


test_that("validateLogical() must return expected results when all input are valid", {

    result1 <- RAIDS:::validateLogical(logical=TRUE, name="parameter_01")

    expect_identical(result1, 0L)
})


test_that("validateLogical() must return error when input is not valid", {

    expected <- "The \'param_01\' parameter must be a logical (TRUE or FALSE)."

    expect_error(RAIDS:::validateLogical(logical="toto", name="param_01"),
                    expected, fixed=TRUE)
})


#############################################################################
### Tests validateSingleRatio() results
#############################################################################

context("validateSingleRatio() results")


test_that("validateSingleRatio() must return expected results when all input are valid", {

    result1 <- RAIDS:::validateSingleRatio(value=0.02, name="parameter_01")

    expect_identical(result1, 0L)
})


test_that("validateSingleRatio() must return error when input is not valid", {

    expected <- paste0("The \'param_01\' must be a single numeric positive ",
                        "value between 0 and 1.")

    expect_error(RAIDS:::validateSingleRatio(value="toto", name="param_01"),
                    expected, fixed=TRUE)
})


test_that("validateSingleRatio() must return error when input is negative value", {

    expected <- paste0("The \'param_02\' must be a single numeric positive ",
                        "value between 0 and 1.")

    expect_error(RAIDS:::validateSingleRatio(value=-0.01, name="param_02"),
                    expected, fixed=TRUE)
})


#############################################################################
### Tests validateCharacterString() results
#############################################################################

context("validateCharacterString() results")


test_that("validateCharacterString() must return expected results when all input are valid", {

    result1 <- RAIDS:::validateCharacterString(value="test", name="parameter_01")

    expect_identical(result1, 0L)
})


test_that("validateCharacterString() must return error when input is negative value", {

    expected <- "The \'param_03\' parameter must be a character string."

    expect_error(RAIDS:::validateCharacterString(value=-0.01, name="param_03"),
                    expected, fixed=TRUE)
})


test_that("validateCharacterString() must return error when input is vector of strings", {

    expected <- "The \'param_03\' parameter must be a character string."

    expect_error(RAIDS:::validateCharacterString(value=c("a", "b"), name="param_03"),
                    expected, fixed=TRUE)
})


#############################################################################
### Tests validatePositiveIntegerVector() results
#############################################################################

context("validatePositiveIntegerVector() results")


test_that("validatePositiveIntegerVector() must return expected results when all input are valid", {

    result1 <- RAIDS:::validatePositiveIntegerVector(value=c(1,2,3),
                                                        name="parameter_01")

    expect_identical(result1, 0L)
})


#############################################################################
### Tests extractNucleotide() results
#############################################################################

context("extractNucleotide() results")


test_that("extractNucleotide() must return expected results when all input are valid", {
    
    nuc <- c("A", "G", "C", "T")
    cnt <- c(100, 200, 4, 32)
    result1 <- RAIDS:::extractNucleotide(nucleotide=nuc, count=cnt, 
                                                curNucleo="C")
    
    expect_identical(result1, 4)
})


test_that("extractNucleotide() must return expected results when nucleotide not present in the input", {
    
    nuc <- c("A", "G",  "T")
    cnt <- c(100, 200, 32)
    result1 <- RAIDS:::extractNucleotide(nucleotide=nuc, count=cnt, 
                                         curNucleo="C")
    
    expect_identical(result1, 0)
})


#############################################################################
### Tests processPileupChrBin() results
#############################################################################

context("processPileupChrBin() results")


test_that("processPileupChrBin() must return NULL when chromosome absent", {
    
    varDf <- c("chr1"=c(1,2,3), "chr2"=c(1,3,5))
    result1 <- RAIDS:::processPileupChrBin(chr="chr3", resPileup=NULL, 
                            varDf=varDf, verbose=FALSE)
    
    expect_identical(result1, NULL)
})


#############################################################################
### Tests readSNVPileupFile() results
#############################################################################

context("readSNVPileupFile")


test_that("readSNVPileupFile() must return error when file does not content expected columns", {
    
    data.dir <- test_path("fixtures")
    fileTxt <- file.path(data.dir, "ex1.txt.gz")
    
    result1 <- RAIDS:::readSNVPileupFile(fileName=fileTxt, offset=0L)
    
    tmpF <- tempfile("ex1_notGood", fileext = c(".txt"))
    
    withr::defer(if(file.exists(tmpF)) unlink(tmpF), envir=parent.frame())
    
    write.table(result1[1:10, 1:3], file =  tmpF)
    
    error_message <- paste0("The SNP-pileup file must contain all those ",
        "columns: \'Chromosome\', \'Position\', \'Ref\', \'Alt\',",
        " \'File1R\', \'File1A\', \'File1E\', \'File1D\'.")
    
    expect_error(RAIDS:::readSNVPileupFile(fileName=tmpF, offset=0L), 
                    error_message)
})


#############################################################################
### Tests readSNVFileGeneric() results
#############################################################################

context("readSNVFileGeneric() results")


test_that("readSNVFileGeneric() must return error when file does not content expected columns", {
    
    data.dir <- test_path("fixtures")
    fileTxt <- file.path(data.dir, "ex1.txt.gz")
    
    result1 <- RAIDS:::readSNVPileupFile(fileName=fileTxt, offset=0L)
    
    tmpF2 <- tempfile("ex1_notGood", fileext = c(".txt"))
    
    withr::defer(if(file.exists(tmpF2)) unlink(tmpF2), envir=parent.frame())
    
    write.table(result1[1:10, 1:4], file =  tmpF2)
    
    error_message <- paste0("The generic SNP pileup file must contain all ", 
        "those columns: \'Chromosome\', \'Position\', \'Ref\', \'Alt\', ",
        "\'File1R\', \'File1A\', \'Count\'.")
    
    expect_error(RAIDS:::readSNVFileGeneric(fileName=tmpF2, offset=0L), 
                 error_message)
})


test_that("readSNVFileGeneric() must return expected value when all parameters are valid", {
    
    data.dir <- test_path("fixtures")
    fileTxt <- file.path(data.dir, "ex1.generic.txt.gz")
    
    result1 <- RAIDS:::readSNVFileGeneric(fileName=fileTxt, offset=0L)
    
    expect_equal(ncol(result1), 7)
    expect_equal(nrow(result1), 50)
    expect_equal(colnames(result1), c("Chromosome", "Position", "Ref", "Alt", 
                                        "File1R", "File1A", "count"))
    
})


#############################################################################
### Tests readSNVVCF() results
#############################################################################

context("readSNVVCF() results")


test_that("readSNVVCF() must return expected results", {
    
    data.dir <- test_path("fixtures")
    fileTxt <- file.path(data.dir, "ex1_small.vcf.gz")
    
    result1 <- RAIDS:::readSNVVCF(fileName=fileTxt, profileName=NULL, offset=0L)
    
    expect_equal(ncol(result1), 7)
    expect_equal(nrow(result1), 60)
    expect_equal(colnames(result1), c("Chromosome", "Position", "Ref", "Alt", 
                                      "File1R", "File1A", "count"))
})


#############################################################################
### Tests readSNVVCF() results
#############################################################################

context("readSNVBAM() results")


test_that("readSNVBAM() must return expected results", {
    
    fileTxt <- system.file("extdata", "no_which_buffered_pileup.bam", 
                            package="Rsamtools", mustWork=TRUE)
    
    result1 <- RAIDS:::readSNVBAM(fileTxt, varSelected=data.frame(chr=c(1,1), 
                        start=c(3,5), REF=c("A", "A"), ALT=c("C", "C")))
    
    expect_equal(ncol(result1), 11)
    expect_equal(nrow(result1), 2)
    expect_equal(colnames(result1), c("Chromosome", "Position", "Ref", "Alt", 
                        "File1R", "File1A", "count", "A", "C", "G", "T"))
})



#############################################################################
### Tests processBlockChr() results
#############################################################################

context("processBlockChr() results")


test_that("processBlockChr() must return expected results", {
    
    fileGDS <- test_path("fixtures", "1KG_Test.gds")
    
    fileLdBlock <- test_path("fixtures", "ThisFileDoesntExist.txt")
    
    error_message <- paste0("The \'fileBlock\' must be a character string ", 
        "representing the file .det from plink block result. ", 
        "The file must exist.")

    expect_error(RAIDS:::processBlockChr(fileReferenceGDS=fileGDS, 
        fileBlock=fileLdBlock), error_message)
})


test_that("processBlockChr() must return expected results", {
    
    fileGDS <- test_path("fixtures", "1KG_Test.gds")
    
    blockChr <- data.frame(CHR=c(rep(1, 4)), BP1=c(51897, 54707, 55544, 61986),
        BP2=c(51927, 54715, 59039, 66506), KB=c(0.031, 0.009, 3.496, 4.521),
        NSNPS=c(2, 2, 2, 3), SNPS=c("s3|s4", "s6|s7", "s14|s15", 
                            "s17|s18|s31"), stringsAsFactors=FALSE)
    
    
    tmpF3 <- tempfile("block.DEMO", fileext = c(".det"))
    
    withr::defer(if(file.exists(tmpF3)) unlink(tmpF3), envir=parent.frame())
    
    write.table(x=blockChr, file=tmpF3, sep=" ")
    
    results <- RAIDS:::processBlockChr(fileReferenceGDS=fileGDS, 
        fileBlock=tmpF3)
    
    expect_equal(length(results), 2)
    expect_equal(results$chr, c(1))
    expect_equal(results$block.snp, c(-1, -2, 1, 1, -3, 2, 2))
})
