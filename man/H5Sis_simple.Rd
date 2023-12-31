% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/H5S.R
\name{H5Sis_simple}
\alias{H5Sis_simple}
\title{Determine whether a dataspace is a simple dataspace}
\usage{
H5Sis_simple(h5space)
}
\arguments{
\item{h5space}{\linkS4class{H5IdComponent} object representing a dataspace.}
}
\description{
In HDF5 a dataspace is considered "simple" if it represents a regular
N-dimensional array of points.
Currently (HDF 1.10.7) all dataspaces are simple.  Support for complex
dataspaces is planned for future HDF versions.
}
