#ifndef _H5T_H
#define _H5T_H

#include <R.h>
#include <Rdefines.h>
#include <R_ext/Rdynload.h>
#include <R_ext/Error.h>
#include "myhdf5.h"
#include "H5constants.h"

SEXP _H5Tcreate( SEXP _type, SEXP _size );
SEXP _H5Tget_class( SEXP _dtype_id );
SEXP _H5Tcopy( SEXP _dtype_id );
SEXP _H5Tset_size( SEXP _dtype_id, SEXP _size );
SEXP _H5Tget_size( SEXP _dtype_id );
SEXP _H5Tset_strpad( SEXP _dtype_id, SEXP _strpad );
SEXP _H5Tget_strpad( SEXP _dtype_id );
SEXP _H5Tset_cset( SEXP _dtype_id, SEXP _cset );
SEXP _H5Tget_cset( SEXP _dtype_id );
SEXP _H5Tis_variable_str( SEXP _dtype_id );
SEXP _H5Tset_precision( SEXP _dtype_id, SEXP _precision );
SEXP _H5Tget_precision( SEXP _dtype_id );
SEXP _H5Tset_offset( SEXP _dtype_id, SEXP _offset );
SEXP _H5Tget_offset( SEXP _dtype_id );
SEXP _H5Tenum_create( SEXP _base_id );
SEXP _H5Tenum_insert( SEXP _type, SEXP _name, SEXP _value );
SEXP _H5Tget_nmembers( SEXP _dtype_id );

// found in H5T_extras.c
SEXP _h5getEnumNames( SEXP _dtype_id );
SEXP _h5getEnumValues( SEXP _dtype_id );
SEXP _h5createComplexDataType( void );
#endif
