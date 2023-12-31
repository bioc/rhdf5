h5lsConvertToDataframe <- function(L, all=FALSE, native) {
  if (is.data.frame(L)) {
    L$ltype <- h5const2String("H5L_TYPE", L$ltype)
    L$otype <- h5const2String("H5I_TYPE", L$otype)
    if (!all) {
      L <- L[,c("group", "name", "otype", "dclass","dim")]
    }
  } else {
    for (i in seq_len(length(L))) {
      L[i] <- list(h5lsConvertToDataframe(L[[i]],all=all, native = native))
    }
  }
  L
}

#' List the content of an HDF5 file.
#' 
#' @param file The filename (character) of the file in which the dataset will
#' be located. You can also provide an object of class [H5IdComponent-class] 
#' representing a H5 location identifier (file or group). See [H5Fcreate()], 
#' [H5Fopen()], [H5Gcreate()], [H5Gopen()] to create an object of this kind.
#' @param recursive If `TRUE`, the content of the whole group hierarchy is
#' listed. If `FALSE`, Only the content of the main group is shown. If a positive
#' integer is provided this indicates the maximum level of the hierarchy that
#' is shown.
#' @param all If `TRUE`, a longer list of information on each entry is provided.
#' @param datasetinfo If `FALSE`, datatype and dimensionality information is not
#' provided. This can speed up the content listing for large files.
#' @param index_type See `h5const("H5_INDEX")` for possible arguments.
#' @param order See `h5const("H5_ITER")` for possible arguments.
#' @param s3 Logical value indicating whether the file argument should be
#' treated as a URL to an Amazon S3 bucket, rather than a local file path.
#' @param s3credentials A list of length three, providing the credentials for
#' accessing files in a private Amazon S3 bucket.
#' @param native An object of class `logical`. If TRUE, array-like objects
#' are treated as stored in HDF5 row-major rather than R column-major
#' orientation. Using `native = TRUE` increases HDF5 file portability
#' between programming languages. A file written with `native = TRUE`
#' should also be read with `native = TRUE`
#' 
#' @return \code{h5ls} returns a `data.frame` with the file content.
#' 
#' @author Bernd Fischer, Mike L. Smith
#' @seealso [h5dump()]
#' @references \url{https://portal.hdfgroup.org/display/HDF5}
#' @keywords programming interface IO file
#' @examples
#' 
#' h5File <- tempfile(pattern = "ex_dump.h5")
#' h5createFile(h5File)
#' 
#' # create groups
#' h5createGroup(h5File,"foo")
#' h5createGroup(h5File,"foo/foobaa")
#' 
#' # write a matrix
#' B = array(seq(0.1,2.0,by=0.1),dim=c(5,2,2))
#' attr(B, "scale") <- "liter"
#' h5write(B, h5File,"foo/B")
#' 
#' # list content of hdf5 file
#' h5ls(h5File,all=TRUE)
#' 
#' # list content of an hdf5 file in a public S3 bucket
#' \donttest{
#' h5ls(file = "https://rhdf5-public.s3.eu-central-1.amazonaws.com/h5ex_t_array.h5", s3 = TRUE)
#' }
#' 
#' @export
h5ls <- function( file, recursive = TRUE, all=FALSE, datasetinfo=TRUE, 
                  index_type = h5default("H5_INDEX"), order = h5default("H5_ITER"), 
                  s3 = FALSE, s3credentials = NULL, native = FALSE) {
  
    if(isTRUE(s3)) {
      fapl <- H5Pcreate("H5P_FILE_ACCESS")
      on.exit(H5Pclose(fapl))
      H5Pset_fapl_ros3(fapl, s3credentials)
      loc <- h5checktypeOrOpenLocS3(file, readonly = TRUE, fapl = fapl, native = native)
    } else {
      loc <- h5checktypeOrOpenLoc(file, readonly = TRUE, fapl = NULL, native = native)
    }
    on.exit(h5closeitLoc(loc), add = TRUE)
    
    if (length(datasetinfo)!=1 || !is.logical(datasetinfo)) stop("'datasetinfo' must be a logical of length 1")
    index_type <- h5checkConstants( "H5_INDEX", index_type )
    order <- h5checkConstants( "H5_ITER", order )
    if (is.logical(recursive)) {
        if (recursive) {
            depth = -1L
        } else {
            depth = 1L
        }
    } else if ( is.numeric(recursive) | is.integer(recursive) ) {
        depth = as.integer(recursive)
        if( length(recursive) > 1 ) {
            warning("'recursive' must be of length 1.  Only using first value.")
        } else if (recursive == 0) {
            stop("value 0 for 'recursive' is undefined, either a positive integer or negative (maximum recursion)")
        } 
    } else {
        stop("'recursive' must be number or a logical")
    }
    di <- ifelse(datasetinfo, 1L, 0L)
    L <- .Call("_h5ls", loc$H5Identifier@ID, depth, di, index_type, order, loc$H5Identifier@native, PACKAGE='rhdf5')
    h5lsConvertToDataframe(L, all=all, native = loc$H5Identifier@native)
}


