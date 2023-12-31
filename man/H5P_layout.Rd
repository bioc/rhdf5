% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/H5P.R
\name{H5P_layout}
\alias{H5P_layout}
\alias{H5Pset_layout}
\alias{H5Pget_layout}
\title{Get and set the type of storage used to store the raw data for a dataset}
\usage{
H5Pset_layout(h5plist, layout = h5default("H5D"))

H5Pget_layout(h5plist)
}
\arguments{
\item{h5plist}{An object of class \linkS4class{H5IdComponent} representing a dataset creation property list.}

\item{layout}{A character giving the name of a dataset layout type.}
}
\description{
Possible options for the \code{layout} argument are:
\itemize{
\item \code{H5D_COMPACT}
\item \code{H5D_CONTIGUOUS}
\item \code{H5D_CHUNKED}
\item \code{H5D_VIRTUAL}
}
}
\details{
The names of the layout types can also be obtained via \code{h5const("H5D")}.
}
