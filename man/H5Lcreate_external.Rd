% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/H5L.R
\name{H5Lcreate_external}
\alias{H5Lcreate_external}
\title{Create a link to an object in a different HDF5 file}
\usage{
H5Lcreate_external(target_file_name, target_obj_name, link_loc, link_name)
}
\arguments{
\item{target_file_name}{Name of the external HDF5 to link to}

\item{target_obj_name}{Path to the object in the file specified by
\code{target_file_name} to link to.}

\item{link_loc}{\linkS4class{H5IdComponent} object giving the location where the
new link should be created. Can represent an HDF5 file or group.}

\item{link_name}{Name (path) of the new link, relative to the location of
\code{link_loc}.}
}
\description{
\code{H5Lcreate_external()} creates a new external link. An external
link is a soft link to an object in a different HDF5 file from the location
of the link.
}
\examples{
## The example below creates a new HDF5 file in a temporary director, and then
## links to the group "/foo" found in the file "multiple_dtypes.h5" 
## distributed with the package.

h5File1 <- system.file("testfiles", "multiple_dtypes.h5", package="rhdf5")
h5File2 <- tempfile(pattern = "H5L_2_", fileext = ".h5")
h5createFile(h5File2)

## open the new file & create a link to the group "/foo" in the original file
fid <- H5Fopen(h5File2)
H5Lcreate_external(target_file_name = h5File1, target_obj_name = "/foo", 
  link_loc = fid, link_name = "/external_link")
H5Fclose(fid)

## check the new file has a group called "/external_link"
h5ls(h5File2)

}
