#include "H5G.h"

void addVector_int( int pos, SEXP Rval, SEXP groupnames, const char *groupname, int N, int* cc, const char *names[] ) {
  
  SEXP Rconstants;
  PROTECT(Rconstants=allocVector(INTSXP, N));
  for (int i=0; i<N; i++) {
      INTEGER(Rconstants)[i] = cc[i];
  }

  SEXP Rnames = PROTECT(allocVector(STRSXP, N));
  for (int i=0; i<N; i++) {
    SET_STRING_ELT(Rnames, i, mkChar(names[i]));
  }
  SET_NAMES(Rconstants, Rnames);
  UNPROTECT(1); // Rnames

  UNPROTECT(1); // Rconstants

  SET_VECTOR_ELT(Rval,pos,Rconstants);
  SET_STRING_ELT(groupnames, pos, mkChar(groupname));
}

void addVector_hid( int pos, SEXP Rval, SEXP groupnames, const char *groupname, int N, hid_t* cc, const char *names[] ) {
    
    SEXP Rconstants;
    PROTECT(Rconstants=allocVector(STRSXP,N));
    for (int i=0; i<N; i++) {
        SET_STRING_ELT(Rconstants, i, HID_2_CHARSXP(cc[i]));
    }
    
    SEXP Rnames = PROTECT(allocVector(STRSXP, N));
    for (int i=0; i<N; i++) {
        SET_STRING_ELT(Rnames, i, mkChar(names[i]));
    }
    SET_NAMES(Rconstants, Rnames);
    UNPROTECT(1); // Rnames
    
    UNPROTECT(1); // Rconstants
    
    SET_VECTOR_ELT(Rval,pos,Rconstants);
    SET_STRING_ELT(groupnames, pos, mkChar(groupname));
}


SEXP _H5constants( void ) {
  SEXP Rval;
  PROTECT(Rval = allocVector(VECSXP, 21));
  SEXP groupnames = PROTECT(allocVector(STRSXP, 21));
  int i=0;

  int const_H5F_ACC[2]       = {  H5F_ACC_TRUNC,   H5F_ACC_EXCL };
  const char *name_H5F_ACC[] = { "H5F_ACC_TRUNC", "H5F_ACC_EXCL"};
  addVector_int(i++, Rval, groupnames, "H5F_ACC", 2, const_H5F_ACC, name_H5F_ACC);

  int const_H5F_ACC_RD[2]       = {  H5F_ACC_RDWR,   H5F_ACC_RDONLY };
  const char *name_H5F_ACC_RD[] = { "H5F_ACC_RDWR", "H5F_ACC_RDONLY"};
  addVector_int(i++, Rval, groupnames, "H5F_ACC_RD", 2, const_H5F_ACC_RD, name_H5F_ACC_RD);

  int const_H5F_SCOPE[2]       = {  H5F_SCOPE_GLOBAL,   H5F_SCOPE_LOCAL };
  const char *name_H5F_SCOPE[] = { "H5F_SCOPE_GLOBAL", "H5F_SCOPE_LOCAL"};
  addVector_int(i++, Rval, groupnames, "H5F_SCOPE", 2, const_H5F_SCOPE, name_H5F_SCOPE);

  int const_H5F_LIBVER[4]       = {  H5F_LIBVER_EARLIEST,   H5F_LIBVER_LATEST,   H5F_LIBVER_V18 ,  H5F_LIBVER_V110  };
  const char *name_H5F_LIBVER[] = { "H5F_LIBVER_EARLIEST", "H5F_LIBVER_LATEST", "H5F_LIBVER_V18", "H5F_LIBVER_V110" };
  addVector_int(i++, Rval, groupnames, "H5F_LIBVER", 4, const_H5F_LIBVER, name_H5F_LIBVER);

  int const_H5_INDEX[2]       = {  H5_INDEX_NAME,   H5_INDEX_CRT_ORDER };
  const char *name_H5_INDEX[] = { "H5_INDEX_NAME", "H5_INDEX_CRT_ORDER"};
  addVector_int(i++, Rval, groupnames, "H5_INDEX", 2, const_H5_INDEX, name_H5_INDEX);

  int const_H5_ITER[3]       = {  H5_ITER_INC,   H5_ITER_DEC,   H5_ITER_NATIVE };
  const char *name_H5_ITER[] = { "H5_ITER_INC", "H5_ITER_DEC", "H5_ITER_NATIVE"};
  addVector_int(i++, Rval, groupnames, "H5_ITER", 3, const_H5_ITER, name_H5_ITER);

  int const_H5L_TYPE[4]       = {  H5L_TYPE_HARD,   H5L_TYPE_SOFT,   H5L_TYPE_EXTERNAL,   H5L_TYPE_ERROR };
  const char *name_H5L_TYPE[] = { "H5L_TYPE_HARD", "H5L_TYPE_SOFT", "H5L_TYPE_EXTERNAL", "H5L_TYPE_ERROR"};
  addVector_int(i++, Rval, groupnames, "H5L_TYPE", 4, const_H5L_TYPE, name_H5L_TYPE);

  int const_H5O_TYPE[4]       = {  -1,             H5O_TYPE_GROUP,   H5O_TYPE_DATASET,   H5O_TYPE_NAMED_DATATYPE };
  const char *name_H5O_TYPE[] = { "H5O_TYPE_ALL", "H5O_TYPE_GROUP", "H5O_TYPE_DATASET", "H5O_TYPE_NAMED_DATATYPE"};
  addVector_int(i++, Rval, groupnames, "H5O_TYPE", 4, const_H5O_TYPE, name_H5O_TYPE);
  
  int const_H5O_SHMESG_FLAG[7]       = {  H5O_SHMESG_NONE_FLAG,   H5O_SHMESG_SDSPACE_FLAG,   H5O_SHMESG_DTYPE_FLAG,   H5O_SHMESG_FILL_FLAG,   H5O_SHMESG_PLINE_FLAG,   H5O_SHMESG_ATTR_FLAG,   H5O_SHMESG_ALL_FLAG };
  const char *name_H5O_SHMESG_FLAG[] = { "H5O_SHMESG_NONE_FLAG", "H5O_SHMESG_SDSPACE_FLAG", "H5O_SHMESG_DTYPE_FLAG", "H5O_SHMESG_FILL_FLAG", "H5O_SHMESG_PLINE_FLAG", "H5O_SHMESG_ATTR_FLAG", "H5O_SHMESG_ALL_FLAG"};
  addVector_int(i++, Rval, groupnames, "H5O_SHMESG_FLAG", 7, const_H5O_SHMESG_FLAG, name_H5O_SHMESG_FLAG);

  int const_H5S[3]       = {  H5S_SCALAR,   H5S_SIMPLE,   H5S_NULL };
  const char *name_H5S[] = { "H5S_SCALAR", "H5S_SIMPLE", "H5S_NULL"};
  addVector_int(i++, Rval, groupnames, "H5S", 3, const_H5S, name_H5S);
  
  hid_t const_H5S_UNLIMITED[1]       = {  H5S_UNLIMITED };
  const char *name_H5S_UNLIMITED[] = { "H5S_UNLIMITED" };
  addVector_hid(i++, Rval, groupnames, "H5S_UNLIMITED", 1, const_H5S_UNLIMITED, name_H5S_UNLIMITED);

  int const_H5S_SELECT[6]       = {  H5S_SELECT_SET,   H5S_SELECT_OR,   H5S_SELECT_AND,   H5S_SELECT_XOR,   H5S_SELECT_NOTB,   H5S_SELECT_NOTA };
  const char *name_H5S_SELECT[] = { "H5S_SELECT_SET", "H5S_SELECT_OR", "H5S_SELECT_AND", "H5S_SELECT_XOR", "H5S_SELECT_NOTB", "H5S_SELECT_NOTA"};
  addVector_int(i++, Rval, groupnames, "H5S_SELECT", 6, const_H5S_SELECT, name_H5S_SELECT);

  hid_t const_H5T[]       = {  H5T_IEEE_F32BE,   H5T_IEEE_F32LE,   H5T_IEEE_F64BE,   H5T_IEEE_F64LE,
			       H5T_STD_I8BE,    H5T_STD_I8LE,    H5T_STD_I16BE,   H5T_STD_I16LE,   
			       H5T_STD_I32BE,   H5T_STD_I32LE,   H5T_STD_I64BE,   H5T_STD_I64LE,   
			       H5T_STD_U8BE,    H5T_STD_U8LE,    H5T_STD_U16BE,   H5T_STD_U16LE,   
			       H5T_STD_U32BE,   H5T_STD_U32LE,   H5T_STD_U64BE,   H5T_STD_U64LE,   
			       H5T_STD_B8BE,    H5T_STD_B8LE,    H5T_STD_B16BE,   H5T_STD_B16LE,   
			       H5T_STD_B32BE,   H5T_STD_B32LE,   H5T_STD_B64BE,   H5T_STD_B64LE,   
			       H5T_NATIVE_CHAR, H5T_NATIVE_SCHAR, H5T_NATIVE_UCHAR,
			       H5T_NATIVE_SHORT, H5T_NATIVE_USHORT,
			       H5T_NATIVE_INT, H5T_NATIVE_UINT,
			       H5T_NATIVE_LONG, H5T_NATIVE_ULONG, H5T_NATIVE_LLONG, H5T_NATIVE_ULLONG,
			       H5T_NATIVE_FLOAT, H5T_NATIVE_DOUBLE, H5T_NATIVE_LDOUBLE,
			       H5T_NATIVE_B8, H5T_NATIVE_B16, H5T_NATIVE_B32, H5T_NATIVE_B64,
			       H5T_NATIVE_OPAQUE, H5T_NATIVE_HADDR, H5T_NATIVE_HSIZE, H5T_NATIVE_HSSIZE,
			       H5T_NATIVE_HERR, H5T_NATIVE_HBOOL,
			       H5T_NATIVE_INT8, H5T_NATIVE_UINT8, H5T_NATIVE_INT_LEAST8, H5T_NATIVE_UINT_LEAST8, H5T_NATIVE_INT_FAST8, H5T_NATIVE_UINT_FAST8,
			       H5T_NATIVE_INT16, H5T_NATIVE_UINT16, H5T_NATIVE_INT_LEAST16, H5T_NATIVE_UINT_LEAST16, H5T_NATIVE_INT_FAST16, H5T_NATIVE_UINT_FAST16,
			       H5T_NATIVE_INT32, H5T_NATIVE_UINT32, H5T_NATIVE_INT_LEAST32, H5T_NATIVE_UINT_LEAST32, H5T_NATIVE_INT_FAST32, H5T_NATIVE_UINT_FAST32,
			       H5T_NATIVE_INT64, H5T_NATIVE_UINT64, H5T_NATIVE_INT_LEAST64, H5T_NATIVE_UINT_LEAST64, H5T_NATIVE_INT_FAST64, H5T_NATIVE_UINT_FAST64,
			       H5T_NATIVE_DOUBLE,
			       H5T_C_S1, H5T_FORTRAN_S1,
			       H5T_STD_REF_OBJ, H5T_STD_REF_DSETREG };
  const char *name_H5T[] = { "H5T_IEEE_F32BE", "H5T_IEEE_F32LE", "H5T_IEEE_F64BE", "H5T_IEEE_F64LE", 
                             "H5T_STD_I8BE",  "H5T_STD_I8LE",  "H5T_STD_I16BE", "H5T_STD_I16LE", 
                             "H5T_STD_I32BE", "H5T_STD_I32LE", "H5T_STD_I64BE", "H5T_STD_I64LE", 
                             "H5T_STD_U8BE",  "H5T_STD_U8LE",  "H5T_STD_U16BE", "H5T_STD_U16LE", 
                             "H5T_STD_U32BE", "H5T_STD_U32LE", "H5T_STD_U64BE", "H5T_STD_U64LE", 
                             "H5T_STD_B8BE",  "H5T_STD_B8LE",  "H5T_STD_B16BE", "H5T_STD_B16LE", 
                             "H5T_STD_B32BE", "H5T_STD_B32LE", "H5T_STD_B64BE", "H5T_STD_B64LE", 
			     "H5T_NATIVE_CHAR", "H5T_NATIVE_SCHAR", "H5T_NATIVE_UCHAR",
			     "H5T_NATIVE_SHORT", "H5T_NATIVE_USHORT",
			     "H5T_NATIVE_INT", "H5T_NATIVE_UINT",
			     "H5T_NATIVE_LONG", "H5T_NATIVE_ULONG", "H5T_NATIVE_LLONG", "H5T_NATIVE_ULLONG",
			     "H5T_NATIVE_FLOAT", "H5T_NATIVE_DOUBLE", "H5T_NATIVE_LDOUBLE",
			     "H5T_NATIVE_B8", "H5T_NATIVE_B16", "H5T_NATIVE_B32", "H5T_NATIVE_B64",
			     "H5T_NATIVE_OPAQUE", "H5T_NATIVE_HADDR", "H5T_NATIVE_HSIZE", "H5T_NATIVE_HSSIZE",
			     "H5T_NATIVE_HERR", "H5T_NATIVE_HBOOL",
			     "H5T_NATIVE_INT8", "H5T_NATIVE_UINT8", "H5T_NATIVE_INT_LEAST8", "H5T_NATIVE_UINT_LEAST8", "H5T_NATIVE_INT_FAST8", "H5T_NATIVE_UINT_FAST8",
			     "H5T_NATIVE_INT16", "H5T_NATIVE_UINT16", "H5T_NATIVE_INT_LEAST16", "H5T_NATIVE_UINT_LEAST16", "H5T_NATIVE_INT_FAST16", "H5T_NATIVE_UINT_FAST16",
			     "H5T_NATIVE_INT32", "H5T_NATIVE_UINT32", "H5T_NATIVE_INT_LEAST32", "H5T_NATIVE_UINT_LEAST32", "H5T_NATIVE_INT_FAST32", "H5T_NATIVE_UINT_FAST32",
			     "H5T_NATIVE_INT64", "H5T_NATIVE_UINT64", "H5T_NATIVE_INT_LEAST64", "H5T_NATIVE_UINT_LEAST64", "H5T_NATIVE_INT_FAST64", "H5T_NATIVE_UINT_FAST64",
			     "H5T_NATIVE_DOUBLE",
			     "H5T_C_S1", "H5T_FORTRAN_S1",
			     "H5T_STD_REF_OBJ", "H5T_STD_REF_DSETREG" };
  addVector_hid(i++, Rval, groupnames, "H5T", 81, const_H5T, name_H5T);

  int const_H5T_CLASS[11]      = {  H5T_INTEGER,   H5T_FLOAT,   H5T_TIME,   H5T_STRING,   H5T_BITFIELD,   H5T_OPAQUE,   H5T_COMPOUND,   H5T_REFERENCE,   H5T_ENUM,   H5T_VLEN,   H5T_ARRAY };
  const char *name_H5T_CLASS[] = { "H5T_INTEGER", "H5T_FLOAT", "H5T_TIME", "H5T_STRING", "H5T_BITFIELD", "H5T_OPAQUE", "H5T_COMPOUND", "H5T_REFERENCE", "H5T_ENUM", "H5T_VLEN", "H5T_ARRAY"};
  addVector_int(i++, Rval, groupnames, "H5T_CLASS", 11, const_H5T_CLASS, name_H5T_CLASS);

  int const_H5T_CSET[2]      = { H5T_CSET_ASCII, H5T_CSET_UTF8 };
  const char *name_H5T_CSET[] = { "H5T_CSET_ASCII", "H5T_CSET_UTF8" };
  addVector_int(i++, Rval, groupnames, "H5T_CSET", 2, const_H5T_CSET, name_H5T_CSET);

  int const_H5I_TYPE[15]       = { H5I_FILE, H5I_GROUP, H5I_DATATYPE, H5I_DATASPACE, H5I_DATASET, H5I_ATTR, 
				   H5I_BADID, H5I_UNINIT,
				   H5I_REFERENCE, H5I_VFL, H5I_GENPROP_CLS, H5I_GENPROP_LST, 
				   H5I_ERROR_CLASS, H5I_ERROR_MSG, H5I_ERROR_STACK };
  const char *name_H5I_TYPE[]  = { "H5I_FILE", "H5I_GROUP", "H5I_DATATYPE", "H5I_DATASPACE", "H5I_DATASET", "H5I_ATTR",
				   "H5I_BADID", "H5I_UNINIT",
				   "H5I_REFERENCE", "H5I_VFL", "H5I_GENPROP_CLS", "H5I_GENPROP_LST", 
				   "H5I_ERROR_CLASS", "H5I_ERROR_MSG", "H5I_ERROR_STACK" };
  addVector_int(i++, Rval, groupnames, "H5I_TYPE", 15, const_H5I_TYPE, name_H5I_TYPE);

  hid_t const_H5P[16]      = {  H5P_OBJECT_CREATE, H5P_FILE_CREATE, H5P_FILE_ACCESS, H5P_DATASET_CREATE, H5P_DATASET_ACCESS, H5P_DATASET_XFER,
			      H5P_FILE_MOUNT, H5P_GROUP_CREATE, H5P_GROUP_ACCESS, H5P_DATATYPE_CREATE, H5P_DATATYPE_ACCESS, H5P_STRING_CREATE,
			      H5P_ATTRIBUTE_CREATE, H5P_OBJECT_COPY, H5P_LINK_CREATE, H5P_LINK_ACCESS };
  const char *name_H5P[] = {  "H5P_OBJECT_CREATE", "H5P_FILE_CREATE", "H5P_FILE_ACCESS", "H5P_DATASET_CREATE", "H5P_DATASET_ACCESS", "H5P_DATASET_XFER",
			      "H5P_FILE_MOUNT", "H5P_GROUP_CREATE", "H5P_GROUP_ACCESS", "H5P_DATATYPE_CREATE", "H5P_DATATYPE_ACCESS", "H5P_STRING_CREATE",
			      "H5P_ATTRIBUTE_CREATE", "H5P_OBJECT_COPY", "H5P_LINK_CREATE", "H5P_LINK_ACCESS" };
  addVector_hid(i++, Rval, groupnames, "H5P", 16, const_H5P, name_H5P);

  int const_H5D[3]      = { H5D_COMPACT, H5D_CONTIGUOUS, H5D_CHUNKED };
  const char *name_H5D[] = { "H5D_COMPACT", "H5D_CONTIGUOUS", "H5D_CHUNKED" };
  addVector_int(i++, Rval, groupnames, "H5D", 3, const_H5D, name_H5D);

  int const_H5D_FILL_TIME[3]      = { H5D_FILL_TIME_IFSET, H5D_FILL_TIME_ALLOC, H5D_FILL_TIME_NEVER };
  const char *name_H5D_FILL_TIME[] = { "H5D_FILL_TIME_IFSET", "H5D_FILL_TIME_ALLOC", "H5D_FILL_TIME_NEVER" };
  addVector_int(i++, Rval, groupnames, "H5D_FILL_TIME", 3, const_H5D_FILL_TIME, name_H5D_FILL_TIME);

  int const_H5D_ALLOC_TIME[4]      = { H5D_ALLOC_TIME_DEFAULT, H5D_ALLOC_TIME_EARLY, H5D_ALLOC_TIME_INCR, H5D_ALLOC_TIME_LATE };
  const char *name_H5D_ALLOC_TIME[] = { "H5D_ALLOC_TIME_DEFAULT", "H5D_ALLOC_TIME_EARLY", "H5D_ALLOC_TIME_INCR", "H5D_ALLOC_TIME_LATE" };
  addVector_int(i++, Rval, groupnames, "H5D_ALLOC_TIME", 4, const_H5D_ALLOC_TIME, name_H5D_ALLOC_TIME);
  
  int const_H5R_TYPE[2] = { H5R_OBJECT, H5R_DATASET_REGION };
  const char *name_H5R_TYPE[] = { "H5R_OBJECT", "H5R_DATASET_REGION" };
  addVector_int(i++, Rval, groupnames, "H5R_TYPE", 2, const_H5R_TYPE, name_H5R_TYPE);

  /*################################*/
  /* return constants */
  /*################################*/

  SET_NAMES(Rval, groupnames);
  UNPROTECT(1);  // groupnames
  UNPROTECT(1);  // Rval
  return(Rval);
}

SEXP
_getDatatypeName(SEXP _type);
SEXP
_getDatatypeClass(SEXP _type);
