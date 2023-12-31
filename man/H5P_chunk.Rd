% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/H5P.R
\name{H5P_chunk}
\alias{H5P_chunk}
\alias{H5Pset_chunk}
\alias{H5Pget_chunk}
\title{Get and set the size of the chunks used to store a chunked layout dataset}
\usage{
H5Pset_chunk(h5plist, dim)

H5Pget_chunk(h5plist)
}
\arguments{
\item{h5plist}{An object of class \linkS4class{H5IdComponent} representing a dataset creation property list.}

\item{dim}{The chunk size used to store the dataset. This argument should be an integer vector of the same length as
the number of dimensions of the dataset the dataset creation property list will be applied to.}
}
\description{
Get and set the size of the chunks used to store a chunked layout dataset
}
\details{
Note that a necessary side effect of running this function is that the
layout of the dataset will be changes to \code{H5D_CHUNKED} if it is not already set to this.
}
\seealso{
\code{\link[=H5Pset_layout]{H5Pset_layout()}}
}
