% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/process1KG.R
\encoding{UTF-8}
\name{identifyRelativeRef}
\alias{identifyRelativeRef}
\title{Identify genetically unrelated patients in GDS Reference file}
\usage{
identifyRelativeRef(
  fileReferenceGDS,
  maf = 0.05,
  thresh = 2^(-11/2),
  fileIBD,
  filePart
)
}
\arguments{
\item{fileReferenceGDS}{a \code{character} string representing the file
name of the Reference GDS file. The file must exist.}

\item{maf}{a single \code{numeric} representing the threshold for the minor
allele frequency. Only the SNPs with ">= maf" will be used.
Default: \code{0.05}.}

\item{thresh}{a single \code{numeric} representing the threshold value used
to decide if a pair of individuals is ancestrally divergent.
Default: \code{2^(-11/2)}.}

\item{fileIBD}{a \code{character} string representing the path and file
name of the RDS file that will be created. The RDS file will contain the
kinship coefficient between the patients.
The extension of the file must be '.rds'.}

\item{filePart}{a \code{character} string representing the path and file
name of the RDS file that will be created. The RDS file will contain the
information about the Reference patients that are unrelated. The file will
contains two lists: the \code{list} of related samples, called \code{rels}
and the list of unrelated samples, called \code{unrels}.
The extension of the file must be '.rds'.}
}
\value{
\code{NULL} invisibly.
}
\description{
The function identify patients that are genetically related in
the Reference file. It generates a first RDS file with the list of unrelated
patient. It also generates a second RDS file with the kinship coefficient
between the patients.
}
\examples{


## Path to the demo pedigree file is located in this package
dataDir <- system.file("extdata", package="RAIDS")

## Open existing demo Reference GDS file
fileGDS <- file.path(dataDir, "PopulationReferenceDemo.gds")


## Temporary output files
## The first RDS file will contain the list of unrelated patients
## The second RDS file will contain the kinship information between patients
patientTmpFile <-  "unrelatedPatients_TEMP.rds"
ibdTmpFile <- "ibd_TEMP.rds"

## Different code depending of the withr package availability
if (requireNamespace("withr", quietly=TRUE)) {

    ## Temporary output files
    ## The first RDS file will contain the list of unrelated patients
    ## The second RDS file will contain the kinship information
    ## between patients
    patientTmpFileLocal <- withr::local_file(patientTmpFile)
    ibdTmpFileLocal <- withr::local_file(ibdTmpFile)

    ## Identify unrelated patients in demo Reference GDS file
    identifyRelativeRef(fileReferenceGDS=fileGDS, maf=0.05, thresh=2^(-11/2),
        fileIBD=ibdTmpFileLocal, filePart=patientTmpFileLocal)

    ## Remove temporary files
    withr::deferred_run()

} else {

    ## Identify unrelated patients in demo Reference GDS file
    identifyRelativeRef(fileReferenceGDS=fileGDS, maf=0.05, thresh=2^(-11/2),
        fileIBD=ibdTmpFile, filePart=patientTmpFile)

    ## Remove temporary files
    unlink(patientTmpFile, force=TRUE)
    unlink(ibdTmpFile, force=TRUE)
}

}
\author{
Pascal Belleau, Astrid Deschênes and Alexander Krasnitz
}
