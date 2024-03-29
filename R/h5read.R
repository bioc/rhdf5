.h5postProcessDataset <- function(obj, h5dataset) {
  ## warn about NA conversion for integers if 'rhdf5.NA-OK' is missing
  if( storage.mode(obj) == "integer" || is(obj, "integer64") ) {
    if(any(is.na(obj))) {
      if( !H5Aexists(h5obj = h5dataset, name = "rhdf5-NA.OK") ) {
        if(storage.mode(obj) == "integer") {
          na_val <- "-2^31"
        } else if (is(obj, "integer64")) {
          na_val <- "-2^63"
        } else { ## we should never end up here
          na_val <- "DEFAULT"
        }
        message("The value ", na_val, " was detected in the dataset.\n",
                "This has been converted to NA within R.")
      }
    }
  } else if( storage.mode(obj) == "character" ) { 
    ## coerce the string "NA" to NA if required
    if(H5Aexists(h5dataset, name = "as.na")) {
      na_char_idx <- (obj == "NA")
      if(any(na_char_idx)) {
        obj[na_char_idx] <- NA_character_
      }
    }
    ## determine if this is ASCII or UTF-8 encoding
    h5type <- H5Dget_type(h5dataset)
    if(H5Tget_cset(h5type) == 1L) { 
      Encoding(obj) <- "UTF-8" 
    }
  }
  
  return(obj)
}

h5readDataset <- function (h5dataset, index = NULL, start = NULL, stride = NULL, 
                           block = NULL, count = NULL, compoundAsDataFrame = TRUE, drop = FALSE, ...) {
    
    h5spaceFile <- H5Dget_space(h5dataset)
    on.exit(H5Sclose(h5spaceFile))
    h5spaceMem = NULL
    if (!is.null(index)) {
        s <- H5Sget_simple_extent_dims(h5spaceFile)$size
        if (length(index) != length(s)) {
            stop("length of index has to be equal to dimensional extension of HDF5 dataset.")
        }
        
        index_null <- sapply(index, is.null)
        
        for (i in seq_along(index)) {
            if ( is.name(index[[i]]) | is.call(index[[i]]) ) {
                index[[i]] <- eval(index[[i]])  
            }
        }
        size <- .H5Sselect_dim( h5spaceFile, index)
        #size <- .H5Sselect_index( h5spaceFile, index, index_null)
        h5spaceMem <- H5Screate_simple(size, native = h5dataset@native)
        on.exit(H5Sclose(h5spaceMem), add = TRUE)
    }
    else {
        if (any(c(!is.null(start), !is.null(stride), 
                  !is.null(count), !is.null(block)))) {
            size = 0
            try({
                size = H5Sselect_hyperslab(h5spaceFile, 
                                           start = start, stride = stride, count = count, 
                                           block = block)
            })
            h5spaceMem = H5Screate_simple(size, native = h5dataset@native)
            on.exit(H5Sclose(h5spaceMem), add = TRUE)
        }
    }
    obj <- NULL
    tryCatch({
        obj <- H5Dread(h5dataset = h5dataset, h5spaceFile = h5spaceFile, 
                       h5spaceMem = h5spaceMem,
                       compoundAsDataFrame = compoundAsDataFrame, drop = drop, ...)
    },
    error = function(e) { 
        err <- h5checkFilters(h5dataset)
        ## if we fail here it doesn't make it to the usual H5Dclose call
        on.exit(H5Dclose(h5dataset))
        if(nchar(err) > 0)
            stop(err, call. = FALSE)
        else 
            stop(e)
    }
    )
    
    ## Here we reorder data to match the order requested in index.
    ## The calls to H5Sselect_index will have returned data linearly
    ## from the file, not the potentially random order requested.
    if (!is.null(index)) {
        I = list()
        for (i in seq_along(index)) {
            if(!index_null[i]) { ## skip if the index was generated inside this function
                tmp <- unique(index[[i]])
                if(is.unsorted(tmp)) { 
                    tmp <- sort.int(tmp) 
                } 
                I[[i]] = match(index[[i]], tmp)
            } else {
                I[[i]] <- seq_len(s[i])
            }
        }
        obj.dim <- lapply(dim(obj), FUN = seq_len)
        ## only need to compare the dimensions not set automatically
        if(!identical(I[!index_null], obj.dim[!index_null])) {
            obj <- do.call("[", c(list(obj), I, drop = FALSE))
        } 
    }
    
    return(obj)
}

#' Reads and write object in HDF5 files
#' 
#' Reads objects in HDF5 files. This function can be used to read
#' either full arrays/vectors or subarrays (hyperslabs) from an
#' existing dataset.
#' 
#' Read an R object from an HDF5 file. If none of the arguments
#' \code{start, stride, block, count} are specified, the dataset has the same
#' dimension in the HDF5 file and in memory. If the dataset already exists in
#' the HDF5 file, one can read subarrays, so called hyperslabs from
#' the HDF5 file. The arguments \code{start, stride, block, count} define the
#' subset of the dataset in the HDF5 file that is to be read/written. See these
#' introductions to hyperslabs:
#' \url{https://support.hdfgroup.org/HDF5/Tutor/selectsimple.html},
#' \url{https://support.hdfgroup.org/HDF5/Tutor/select.html} and
#' \url{http://ftp.hdfgroup.org/HDF5/Tutor/phypecont.html}. Please note that in
#' R the first dimension is the fastest changing dimension.
#' 
#' When viewing the HDF5 datasets with any C-program (e.g. HDFView), the order
#' of dimensions is inverted. In the R interface counting starts with 1,
#' whereas in the C-programs (e.g. HDFView) counting starts with 0.
#' 
#' Special cases.  There are a few instances where rhdf5 will make assumptions 
#' about the dataset you are reading and treat it slightly differently.  1)
#' complex numbers.  If your datasets is a compound datatype, has only two 
#' columns, and these are named 'r' and 'i' rhdf5 will assume the data is 
#' intended to be complex numbers and will read this into R's complex type.  If
#' that is not the case, you will need to extract the two values separately
#' using the \code{Re()} and \code{Im()} accessors manually.
#' 
#' @param file The file name (character) of the file in which the dataset is
#' be located. It is possible to provide an object of
#' class [H5IdComponent-class] representing a H5 location identifier
#' (file or group). See \code{\link{H5Fcreate}}, \code{\link{H5Fopen}},
#' \code{\link{H5Gcreate}}, \code{\link{H5Gopen}} to create an object of this
#' kind.
#' @param name The name of the dataset in the HDF5 file.
#' @param index List of indices for subsetting. The length of the list has to
#' agree with the dimensional extension of the HDF5 array. Each list element is
#' an integer vector of indices. A list element equal to NULL chooses all
#' indices in this dimension. Counting is R-style 1-based.
#' @param start The start coordinate of a hyperslab (similar to subsetting in
#' R). Counting is R-style 1-based. This argument is ignored, if index is not
#' NULL.
#' @param stride The stride of the hypercube. Read the introduction
#' \url{http://ftp.hdfgroup.org/HDF5/Tutor/phypecont.html} before using this
#' argument. R behaves like Fortran in this example. This argument is ignored,
#' if index is not NULL.
#' @param block The block size of the hyperslab. Read the introduction
#' \url{http://ftp.hdfgroup.org/HDF5/Tutor/phypecont.html} before using this
#' argument. R behaves like Fortran in this example. This argument is ignored,
#' if index is not NULL.
#' @param count The number of blocks to be read. This argument is ignored,
#' if index is not NULL.
#' @param native An object of class \code{logical}. If TRUE, array-like objects
#' are treated as stored in HDF5 row-major rather than R column-major
#' orientation. Using \code{native = TRUE} increases HDF5 file portability
#' between programming languages. A file written with \code{native = TRUE}
#' should also be read with \code{native = TRUE}
#' @param compoundAsDataFrame If true, a compound datatype will be coerced to a
#' data.frame. This is not possible, if the dataset is multi-dimensional.
#' Otherwise the compound datatype will be returned as a list. Nested compound
#' data types will be returned as a nested list.
#' @param callGeneric If TRUE a generic function h5read.classname will be
#' called if it exists depending on the dataset's class attribute within the
#' HDF5 file. This function can be used to convert the standard output of
#' h5read depending on the class attribute. Note that h5read is not a S3
#' generic function. Dispatching is done based on the HDF5 attribute after the
#' standard h5read function.
#' @param read.attributes (logical) If `TRUE`, the HDF5 attributes are read and
#' attached to the respective R object.
#' @param drop (logical) If TRUE, the HDF5 object is read as a vector with `NULL`
#' dim attributes.
#' @param s3 Logical value indicating whether the file argument should be
#' treated as a URL to an Amazon S3 bucket, rather than a local file path.
#' @param s3credentials A list of length three, providing the credentials for
#' accessing files in a private Amazon S3 bucket.
#' @param \dots Further arguments passed to \code{\link{H5Dread}}.
#' 
#' @return \code{h5read} returns an array with the data read.
#' 
#' @author Bernd Fischer, Mike Smith
#' @seealso \code{\link{h5ls}}
#' @examples
#' 
#' h5File <- tempfile(pattern = "ex_hdf5file.h5")
#' h5createFile(h5File)
#' 
#' # write a matrix
#' B = array(seq(0.1,2.0,by=0.1),dim=c(5,2,2))
#' h5write(B, h5File, "B")
#' 
#' # read a matrix
#' E = h5read(h5File,"B")
#' 
#' # write and read submatrix
#' h5createDataset(h5File, "S", c(5,8), storage.mode = "integer", chunk=c(5,1), level=7)
#' h5write(matrix(1:5,nr=5,nc=1), file=h5File, name="S", index=list(NULL,1))
#' h5read(h5File, "S")
#' h5read(h5File, "S", index=list(NULL,2:3))
#' 
#' # Read a subset of an hdf5 file in a public S3 bucket
#' \donttest{
#' h5read('https://rhdf5-public.s3.eu-central-1.amazonaws.com/rhdf5ex_t_float_3d.h5', 
#'       s3 = TRUE, name = "a1", index = list(NULL, 3, NULL))
#' }
#' 
#' @name h5_read
#' @export h5read
h5read <- function(file, name, index=NULL, start=NULL, stride=NULL, block=NULL,
                   count = NULL, compoundAsDataFrame = TRUE, callGeneric = TRUE,
                   read.attributes=FALSE, drop = FALSE, ..., native = FALSE,
                   s3 = FALSE, s3credentials = NULL) {
    
    if(isTRUE(s3)) {
        fapl <- H5Pcreate("H5P_FILE_ACCESS")
        on.exit(H5Pclose(fapl))
        H5Pset_fapl_ros3(fapl, s3credentials)
        loc <- h5checktypeOrOpenLocS3(file, readonly = TRUE, fapl = fapl, native = native)
    } else {
        loc <- h5checktypeOrOpenLoc(file, readonly = TRUE, fapl = NULL, native = native)
    }
    on.exit(h5closeitLoc(loc), add = TRUE)
    
    if (!H5Lexists(loc$H5Identifier, name)) {
        stop("Object '", name, "' does not exist in this HDF5 file.")
    } else {
        oid = H5Oopen(loc$H5Identifier, name)
        on.exit(H5Oclose(oid), add = TRUE)
        type = H5Iget_type(oid)
        num_attrs = H5Oget_num_attrs(oid)
        if (is.na(num_attrs)) { num_attrs = 0 }
        if (type == "H5I_GROUP") {
            gid <- H5Gopen(loc$H5Identifier, name)
            obj <- if(.isAnndataNullable(gid)) {
              .h5readNullable(gid)
            } else {
              h5dump(gid, start=start, stride=stride, block=block, 
                         count=count, compoundAsDataFrame = compoundAsDataFrame, callGeneric = callGeneric, ...)
            }
            H5Gclose(gid)
        } else if (type == "H5I_DATASET") {
            h5dataset <- H5Dopen(loc$H5Identifier, name)
            on.exit(H5Dclose(h5dataset), add = TRUE)
            obj <- h5readDataset(h5dataset, index = index, start = start, stride = stride, 
                                 block = block, count = count, compoundAsDataFrame = compoundAsDataFrame, drop = drop, ...)
            obj <- .h5postProcessDataset(obj = obj, h5dataset = h5dataset)
            cl <- attr(obj,"class")
            if (!is.null(cl) & callGeneric) {
                if (exists(paste("h5read",cl,sep="."),mode="function")) {
                    obj <- do.call(paste("h5read",cl,sep="."), args=list(obj = obj))
                }
            }
        } else {
            message("Reading of object type not supported.")
            obj <- NULL
        } ## GROUP
        if (read.attributes & (num_attrs > 0) & !is.null(obj)) {
            for (i in seq_len(num_attrs)) {
                A = H5Aopen_by_idx(loc$H5Identifier, n = i-1, objname = name)
                attrname <- H5Aget_name(A)
                if (attrname != "dim") {
                    attr(obj, attrname) = H5Aread(A, ...)
                }
                ## Don't put this in on.exit() 
                ## A is overwritten in the loop and we lose track of it
                H5Aclose(A)
            }
        }
    }  # !H5Lexists
    
    obj
}

.isAnndataNullable <- function(gid) {
  
  ## test attribute existence
  if(!H5Aexists(gid, "encoding-type") || !H5Aexists(gid, "encoding-version")) {
    return(FALSE)
  }
  
  ## TODO: test attribute values
  
  ## test datasets exist
  group_data <- h5ls(gid, recursive = FALSE)
  if(!all(c("values", "mask") %in% group_data$name)) {
    return(FALSE)
  }
  
  return(TRUE)
  
}

## expects to be called inside h5read
.h5readNullable <- function(gid) {
  
  ## the way H5Dread treats ENUM is weird and inconsistent with H5Aread
  ## we do some casting as.logical here, but it'd be better elsewhere
  values <- h5read(gid, "values")
  mask <- h5read(gid, "mask")
  values[which(as.logical(mask))] <- NA
  
  aid <- H5Aopen(gid, name = "encoding-type")
  on.exit(H5Aclose(aid))
  enc_type <- H5Aread(aid)
  
  if(enc_type == "nullable-boolean") {
    values <- as.logical(values)
  }
  
  return(values)
}
