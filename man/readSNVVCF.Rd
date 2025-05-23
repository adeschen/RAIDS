% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tools_internal.R
\encoding{UTF-8}
\name{readSNVVCF}
\alias{readSNVVCF}
\title{Read a VCF file with the genotypes use for the ancestry call}
\usage{
readSNVVCF(fileName, profileName = NULL, offset = 0L)
}
\arguments{
\item{fileName}{a \code{character} string representing the name, including
the path, of a VCF file containing the SNV read counts.
The VCF must contain those genotype fields: GT, AD, DP.}

\item{profileName}{a \code{character} with Name.ID for the genotype name.
Default: \code{NULL}.}

\item{offset}{a \code{integer} representing the offset to be added to the
position of the SNVs. The value of offset
is added to the position present in the file. Default: \code{0L}.}
}
\value{
a \code{data.frame} containing at least:
\describe{
\item{Chromosome}{ a \code{numeric} representing the name of
the chromosome}
\item{Position}{ a \code{numeric} representing the position on the
chromosome}
\item{Ref}{ a \code{character} string representing the reference nucleotide}
\item{Alt}{ a \code{character} string representing the alternative
nucleotide}
\item{File1R}{ a \code{numeric} representing the count for
the reference nucleotide}
\item{File1A}{ a \code{numeric} representing the count for the
alternative nucleotide}
\item{count}{ a \code{numeric} representing the total count}
}
}
\description{
The function reads VCF file and returns a data frame
containing the information about the read counts for the SNVs present in
the file.
}
\examples{


## Directory where demo SNP-pileup file
dataDir <- system.file("extdata/example/snpPileup", package="RAIDS")

## The SNP-pileup file
snpPileupFile <- file.path(dataDir, "ex1.vcf.gz")

info <- RAIDS:::readSNVVCF(fileName=snpPileupFile)
head(info)

}
\author{
Pascal Belleau, Astrid Deschênes and Alexander Krasnitz
}
\keyword{internal}
