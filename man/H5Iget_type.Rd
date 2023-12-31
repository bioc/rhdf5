% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/H5I.R
\name{H5Iget_type}
\alias{H5Iget_type}
\title{Find the type of an object}
\usage{
H5Iget_type(h5identifier)
}
\arguments{
\item{h5identifier}{Object of class \linkS4class{H5IdComponent}.}
}
\value{
Returns a character vector of length 1 containing the HDF5 type
for the supplied identifier.
}
\description{
Possible types returned by the function are:
\itemize{
\item \code{H5I_FILE}
\item \code{H5I_GROUP}
\item \code{H5I_DATATYPE}
\item \code{H5I_DATASPACE}
\item \code{H5I_DATASET}
\item \code{H5I_ATTR}
}
}
\examples{
h5file <- system.file("testfiles", "h5ex_t_array.h5", package="rhdf5")
fid <- H5Fopen(h5file)
gid <- H5Gopen(fid, "/")

## identify the HDF5 types for these identifiers
H5Iget_type(fid)
H5Iget_type(gid)

## tidy up
H5Gclose(gid)
H5Fclose(fid)

}
