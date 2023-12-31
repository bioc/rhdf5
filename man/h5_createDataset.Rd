% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/h5create.R
\name{h5_createDataset}
\alias{h5_createDataset}
\alias{h5createDataset}
\title{Create HDF5 dataset}
\usage{
h5createDataset(
  file,
  dataset,
  dims,
  maxdims = dims,
  storage.mode = "double",
  H5type = NULL,
  size = NULL,
  encoding = NULL,
  chunk = dims,
  fillValue,
  level = 6,
  filter = "gzip",
  shuffle = TRUE,
  native = FALSE
)
}
\arguments{
\item{file}{The filename (character) of the file in which the dataset will be
located. For advanced programmers it is possible to provide an object of
class \linkS4class{H5IdComponent} representing a H5 location identifier (file or
group). See \code{\link[=H5Fcreate]{H5Fcreate()}}, \code{\link[=H5Fopen]{H5Fopen()}}, \code{\link[=H5Gcreate]{H5Gcreate()}}, \code{\link[=H5Gopen]{H5Gopen()}} to
create an object of this kind.}

\item{dataset}{Name of the dataset to be created. The name can contain group
names, e.g. 'group/dataset', but the function will fail, if the group does
not yet exist.}

\item{dims}{The dimensions of the array as they will appear in the file.
Note, the dimensions will appear in inverted order when viewing the file
with a C-programm (e.g. HDFView), because the fastest changing dimension in
R is the first one, whereas the fastest changing dimension in C is the last
one.}

\item{maxdims}{The maximum extension of the array. Use \code{H5Sunlimited()}
to indicate an extensible dimension.}

\item{storage.mode}{The storage mode of the data to be written. Can be
obtained by \code{storage.mode(mydata)}.}

\item{H5type}{Advanced programmers can specify the datatype of the dataset
within the file. See \code{h5const("H5T")} for a list of available
datatypes. If \code{H5type} is specified the argument \code{storage.mode}
is ignored. It is recommended to use \code{storage.mode}}

\item{size}{For \code{storage.mode='character'} the maximum string length to use.
The default value of \code{NULL} will result in using variable length strings.
See the details for more information on this option.}

\item{encoding}{The encoding of the string data type. Valid options are
"ASCII" or "UTF-8".}

\item{chunk}{The chunk size used to store the dataset. It is an integer
vector of the same length as \code{dims}. This argument is usually set
together with a compression property (argument \code{level}).}

\item{fillValue}{Standard value for filling the dataset. The storage.mode of
value has to be convertible to the dataset type by HDF5.}

\item{level}{The compression level used. An integer value between 0 (no
compression) and 9 (highest and slowest compression).}

\item{filter}{Character defining which compression filter should be applied
to the chunks of the dataset.  See the Details section for more information
on the options that can be provided here.}

\item{shuffle}{Logical defining whether the byte-shuffle algorithm should be
applied to data prior to compression.}

\item{native}{An object of class \code{logical}. If TRUE, array-like objects
are treated as stored in HDF5 row-major rather than R column-major
orientation. Using \code{native = TRUE} increases HDF5 file portability
between programming languages. A file written with \code{native = TRUE}
should also be read with \code{native = TRUE}}
}
\value{
Returns (invisibly) \code{TRUE} if dataset was created successfully and \code{FALSE} otherwise.
}
\description{
R function to create an HDF5 dataset and defining its dimensionality and
compression behaviour.
}
\details{
Creates a new dataset in an existing HDF5 file. The function will fail if the
file doesn't exist or if there exists already another dataset with the same
name within the specified file.

The \code{size} argument is only used when \code{storage.mode = 'character'}.  When
storing strings HDF5 can use either a fixed or variable length datatype.
Setting \code{size} to a positive integer will use fixed length strings where
\code{size} defines the length.  \pkg{rhdf5} writes null padded strings by default
and so to avoid data loss the value provided here should be the length of the
longest string.  Setting \code{size = NULL} will use variable length strings. The
choice is probably dependent on the nature of the strings you're writing. The
principle difference is that a dataset of variable length strings will not be
compressed by HDF5 but each individual string only uses the space it
requires, whereas in a fixed length dataset each string is of length uses
\code{size}, but the whole dataset can be compressed. This explored more in the
examples below.

The \code{filter} argument can take several options matching to compression
filters distributed in either with the HDF5 library in \pkg{Rhdf5lib} or via
the \pkg{rhdf5filters} package.  The plugins available and the corresponding
values for selecting them are shown below:

\describe{ \item{zlib: Ubiquitous deflate compression algorithm used in GZIP
or ZIP files.  All three options below achieve the same result.}{ \itemize{
\item\code{"GZIP"}, \item\code{"ZLIB"}, \item\code{"DEFLATE"} } } \item{szip:
Compression algorithm maintained by the HDF5 group.}{ \itemize{
\item\code{"SZIP"} } } \item{bzip2}{ \itemize{ \item\code{"BZIP2"} } }
\item{BLOSC meta compressor: As a meta-compressor BLOSC wraps several
different compression algorithms.  Each of the options below will active a
different compression filter. }{ \itemize{ \item\code{"BLOSC_BLOSCLZ"}
\item\code{"BLOSC_LZ4"} \item\code{"BLOSC_LZ4HC"} \item\code{"BLOSC_SNAPPY"}
\item\code{"BLOSC_ZLIB"} \item\code{"BLOSC_ZSTD"} } } \item{lzf}{ \itemize{
\item\code{"LZF"} } } \item{Disable: It is possible to write chunks without
any compression applied.}{ \itemize{ \item\code{"NONE"} } } }
}
\examples{

h5File <- tempfile(pattern = "_ex_createDataset.h5")
h5createFile(h5File)

# create dataset with compression
h5createDataset(h5File, "A", c(5,8), storage.mode = "integer", chunk=c(5,1), level=6)

# create dataset without compression
h5createDataset(h5File, "B", c(5,8), storage.mode = "integer")
h5createDataset(h5File, "C", c(5,8), storage.mode = "double")

# create dataset with bzip2 compression
h5createDataset(h5File, "D", c(5,8), storage.mode = "integer",
    chunk=c(5,1), filter = "BZIP2", level=6)

# create a dataset of strings & define size based on longest string
ex_strings <- c('long', 'longer', 'longest')
h5createDataset(h5File, "E",
    storage.mode = "character", chunk = 3, level = 6,
    dims = length(ex_strings), size = max(nchar(ex_strings)))


# write data to dataset
h5write(matrix(1:40,nr=5,nc=8), file=h5File, name="A")
# write second column
h5write(matrix(1:5,nr=5,nc=1), file=h5File, name="B", index=list(NULL,2))
# write character vector
h5write(ex_strings, file = h5File, name = "E")

h5dump( h5File )

## Investigating fixed vs variable length string datasets

## create 1000 random strings with length between 50 and 100 characters
words <- ceiling(runif(n = 1000, min = 50, max = 100)) |>
vapply(FUN = \(x) {
 paste(sample(letters, size = x, replace = TRUE), collapse = "")
},
FUN.VALUE = character(1))

## create two HDF5 files
f1 <- tempfile()
f2 <- tempfile()
h5createFile(f1)
h5createFile(f2)

## create two string datasets
## the first is variable length strings, the second fixed at the length of our longest word
h5createDataset(f1, "strings", dims = length(words), storage.mode = "character", 
                size = NULL, chunk = 25)
h5createDataset(f2, "strings", dims = length(words), storage.mode = "character", 
                size = max(nchar(words)), chunk = 25)

## Write the data
h5write(words, f1, "strings")
h5write(words, f2, "strings")

## Check file sizes.
## In this example the fixed length string dataset is normally much smaller
file.size(f1)
file.size(f2)

}
\seealso{
\code{\link[=h5createFile]{h5createFile()}}, \code{\link[=h5createGroup]{h5createGroup()}}, \code{\link[=h5read]{h5read()}}, \code{\link[=h5write]{h5write()}}
}
\author{
Bernd Fischer, Mike L. Smith
}
