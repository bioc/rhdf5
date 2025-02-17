#include "H5T.h"

SEXP _h5getEnumNames( SEXP _dtype_id ) {

  hid_t dtype_id = STRSXP_2_HID( _dtype_id );
  if(H5Tget_class(dtype_id) != H5T_ENUM) {
    error("Not an H5T_ENUM datatype");
  }
  
  int nmembers = H5Tget_nmembers( dtype_id );
  SEXP Rval = PROTECT(allocVector(STRSXP, nmembers));
  for (int i=0; i<nmembers; i++) {
    char *st = H5Tget_member_name( dtype_id, i );
    SET_STRING_ELT(Rval, i, mkChar(st));
    H5free_memory(st);
  }
  
  UNPROTECT(1);
  return Rval;
}

SEXP _h5getEnumValues( SEXP _dtype_id ) {
  
  hid_t dtype_id = STRSXP_2_HID( _dtype_id );
  if(H5Tget_class(dtype_id) != H5T_ENUM) {
    error("Not an H5T_ENUM datatype");
  }
  if(H5Tget_size(dtype_id) > sizeof(int)) {
    error("Unable to handle 64-bit integers");
  }
  
  int nmembers = H5Tget_nmembers( dtype_id );
  SEXP Rval = PROTECT(allocVector(INTSXP, nmembers));
  void *buf = INTEGER(Rval);
  for (int i=0; i<nmembers; i++) {
    H5Tget_member_value(dtype_id, i, buf);
    buf = (int*)buf + 1;
  }
  
  UNPROTECT(1);
  return Rval;
}

SEXP _h5createComplexDataType( void ) {
  
  hid_t dtype_id = H5Tcreate(H5T_COMPOUND, 2 * H5Tget_size(H5T_IEEE_F64LE));
  
  H5Tinsert(dtype_id, "r", 0, H5T_IEEE_F64LE);
  H5Tinsert(dtype_id, "i", H5Tget_size(H5T_IEEE_F64LE), H5T_IEEE_F64LE);
  
  SEXP Rval;
  PROTECT(Rval = HID_2_STRSXP(dtype_id));
  UNPROTECT(1);
  return Rval;
}