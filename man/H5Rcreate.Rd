% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/H5R.R
\name{H5Rcreate}
\alias{H5Rcreate}
\title{Create a reference}
\usage{
H5Rcreate(h5loc, name, ref_type = "H5R_OBJECT", h5space = NULL)
}
\arguments{
\item{h5loc}{An \code{H5IdComponent} object representing the location to be pointed to
by the created reference.}

\item{name}{Character string giving the name of the object to be referenced,
relative to the location given by \code{h5loc}.}

\item{ref_type}{The type of reference to create.  Accepts either \code{H5R_OBJECT}
or \code{H5R_DATASET_REGION}.}

\item{h5space}{An object of class \code{H5IdComponent} representing a dataspace
with a selection set.  This argument is only used if creating a
reference to a dataset region, and will be ignored otherwise.}
}
\value{
An \linkS4class{H5Ref} object storing the reference.
}
\description{
Creates a reference to an object or dataset selection inside an HDF5 file.
}
