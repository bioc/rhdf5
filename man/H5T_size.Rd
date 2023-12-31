% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/H5T.R
\name{H5T_size}
\alias{H5T_size}
\alias{H5Tset_size}
\alias{H5Tget_size}
\title{Retrieve or set the type of padding used by string datatype}
\usage{
H5Tset_size(dtype_id = h5default(type = "H5T"), size)

H5Tget_size(dtype_id)
}
\arguments{
\item{dtype_id}{ID of HDF5 datatype to query or modify.}

\item{size}{The new datatype size in bytes.}
}
\description{
Retrieve or set the type of padding used by string datatype
}
