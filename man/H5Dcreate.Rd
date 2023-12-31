% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/H5D.R
\name{H5Dcreate}
\alias{H5Dcreate}
\title{Create a new HDF5 dataset}
\usage{
H5Dcreate(
  h5loc,
  name,
  dtype_id,
  h5space,
  lcpl = NULL,
  dcpl = NULL,
  dapl = NULL
)
}
\arguments{
\item{h5loc}{An object of class \linkS4class{H5IdComponent} representing a H5
location identifier (file or group). See \code{\link[=H5Fcreate]{H5Fcreate()}}, \code{\link[=H5Fopen]{H5Fopen()}},
\code{\link[=H5Gcreate]{H5Gcreate()}}, \code{\link[=H5Gopen]{H5Gopen()}} to create an object of this kind.}

\item{name}{Name of the dataset.}

\item{dtype_id}{A character name of a datatype. See \code{h5const("H5T")}
for possible datatypes. Can also be an integer representing an HDF5 datatype.}

\item{h5space}{An object of class \linkS4class{H5IdComponent} representing a H5 dataspace.
See \code{\link[=H5Dget_space]{H5Dget_space()}}, \code{\link[=H5Screate_simple]{H5Screate_simple()}}, \code{\link[=H5Screate]{H5Screate()}} to create an object
of this kind}

\item{lcpl, dcpl, dapl}{An objects of class \linkS4class{H5IdComponent} representing
HDF5 property lists.  Specially these should respectively be: a link creation
property list, a dataset creation property list, a dataset access property list}
}
\value{
An object of class \code{H5IdComponent} representing the opened dataset.
}
\description{
Create a new HDF5 dataset
}
