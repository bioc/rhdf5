% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/H5R.R
\name{H5R}
\alias{H5R}
\title{H5R - References to objects and regions}
\description{
The \code{H5R} functions can be used for creating or working with
references to specific objects and data regions in an HDF5 file.
}
\examples{
library(rhdf5)

## first we'll create a file with a group named "foo" and a
## 1-dimensional dataset named "baa" inside that group.
file_name <- tempfile(fileext = ".h5")
h5createFile(file_name)
h5createGroup(file = file_name, group = "/foo")
h5write(1:100, file=file_name, name="/foo/baa")


fid <- H5Fopen(file_name)
ref_to_group <- H5Rcreate(fid, name = "/foo")
ref_to_dataset <- H5Rcreate(fid, name = "/foo/baa")
two_refs <- c(ref_to_group, ref_to_dataset)
two_refs

## the size of this dataspace is the number of object references
## we want to store
sid <- H5Screate_simple(2)
tid <- H5Tcopy(dtype_id = "H5T_STD_REF_OBJ")
did <- H5Dcreate(fid, name = "object_refs", dtype_id = tid, h5space = sid)
H5Dwrite(did, two_refs)
H5Dclose(did)
H5Sclose(sid)
H5Fclose(fid)

}
\author{
Mike Smith
}
