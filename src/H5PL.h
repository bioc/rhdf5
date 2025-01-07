#ifndef _H5PL_H
#define _H5PL_H

#include <R.h>
#include <Rdefines.h>
#include <R_ext/Rdynload.h>
#include <R_ext/Error.h>
#include "myhdf5.h"
#include "HandleList.h"

SEXP _H5PLprepend( SEXP _search_path );
SEXP _H5PLsize( void );
SEXP _H5PLget( SEXP index );

#endif
