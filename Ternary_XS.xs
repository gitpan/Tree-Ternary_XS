#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef PL_na 
#define PL_na na 
#endif

#ifndef PL_dowarn
#define PL_dowarn dowarn
#endif

#ifndef warn_uninit
#define warn_uninit "Uninitialised variable"
#endif

#include "ternary.h"

MODULE = Tree::Ternary_XS		PACKAGE = Tree::Ternary_XS		PREFIX= Ternary_

SV *
Ternary_new(package)
        char * package

	PROTOTYPE: $

        CODE:
	Tobj t;
	SV *tp;
	t = t_new();
	tp = newSVpv((char *)&t, sizeof(Tobj));
        RETVAL = newRV(tp);
	SvREFCNT_dec(tp);
        sv_bless(RETVAL, gv_stashpv(package, 0));
	SvREADONLY_on(tp);

        OUTPUT:
	        RETVAL

void
Ternary_DESTROY(t)
	SV * t

	PROTOTYPE: $

	CODE:
	Tobj *this;
	this = (Tobj *)SvPV(SvRV(t), PL_na);
	t_DESTROY(this);



SV *
Ternary_insert(t, w)
	SV * t
	SV * w

	PROTOTYPE: $$

	CODE:
	Tobj *this;
	STRLEN wlen;
	char *wp;

	if (!SvOK(w)) {
		if (PL_dowarn) warn(warn_uninit);
		XSRETURN_UNDEF;
	}
	this = (Tobj *)SvPV(SvRV(t), PL_na);
	wp = SvPV(w, wlen);

	t_insert(this, wp);
 

int
Ternary_search(t, s)
	SV * t
	SV * s

	PROTOTYPE: $$$

	CODE:
	Tobj *this;
	STRLEN slen;
	char *sp;

	if (!SvPOK(s)) { /* this used to be svOK(s) ? */
		if (PL_dowarn) warn(warn_uninit);
		XSRETURN_NO;
	}

	this = (Tobj *)SvPV(SvRV(t), PL_na);
	sp = SvPV(s, slen);

	RETVAL = t_search(this, sp);

	OUTPUT:
		RETVAL


int
Ternary_nodes(t)
	SV * t

	PROTOTYPE: $$

	CODE:
	Tobj *this;

	this = (Tobj *)SvPV(SvRV(t), PL_na);

	RETVAL = t_nodes(this);

	OUTPUT:
		RETVAL




int
Ternary_terminals(t)
	SV * t

	PROTOTYPE: $$

	CODE:
	Tobj *this;

	this = (Tobj *)SvPV(SvRV(t), PL_na);

	RETVAL = t_terminals(this);

	OUTPUT:
		RETVAL



void
Ternary_pmsearch(t, w, v)
	SV * t
	SV * w
	SV * v

	PROTOTYPE: $$$

	PREINIT:
		Tobj *this;
		STRLEN vlen;
		STRLEN wlen;
		char *vp;
		char *wp;
		char **searchchar;
		int searchn;
		int i;

	PPCODE:
	if (!SvPOK(v)) {
		if (PL_dowarn) warn(warn_uninit);
		XSRETURN_NO;
	}

	if (!SvPOK(w)) {
		if (PL_dowarn) warn(warn_uninit);
		XSRETURN_NO;
	}

	this = (Tobj *)SvPV(SvRV(t), PL_na);
	vp = SvPV(v, vlen);
	wp = SvPV(w, wlen);

	t_pmsearch(this, wp, vp);

	searchchar = this->searchchar;
	searchn = this->searchn;

	if (GIMME == G_SCALAR) {
		XPUSHs(sv_2mortal(newSViv(searchn)));
	} else {
		for (i = 0; i < searchn; i++) {
			XPUSHs(sv_2mortal(newSVpv(searchchar[i], 0)));
		}
	}




void
Ternary_traverse(t)
	SV * t

	PROTOTYPE: $

	PREINIT:
		Tobj *this;
		char **searchchar;
		int searchn;
		int i;

	PPCODE:

	this = (Tobj *)SvPV(SvRV(t), PL_na);

	t_traverse(this);

	searchchar = this->searchchar;
	searchn = this->searchn;

	for (i = 0; i < searchn; i++) {
		XPUSHs(sv_2mortal(newSVpv(searchchar[i], 0)));
	}


void
Ternary_nearsearch(t, n, w)
	SV * t
	SV * n
	SV * w

	PROTOTYPE: $$$

	PREINIT:
		Tobj *this;
		STRLEN wlen;
		char *wp;
		int realn;
		char **searchchar;
		int searchn;
		int i;

	PPCODE:
	if (!SvIOK(n)) {
		if (PL_dowarn) warn(warn_uninit);
		XSRETURN_NO;
	}

	if (!SvPOK(w)) {
		if (PL_dowarn) warn(warn_uninit);
		XSRETURN_NO;
	}

	this = (Tobj *)SvPV(SvRV(t), PL_na);
	wp = SvPV(w, wlen);
	realn = SvIV(n);

	t_nearsearch(this, wp, realn);

	searchchar = this->searchchar;
	searchn = this->searchn;

	if (GIMME == G_SCALAR) {
		XPUSHs(sv_2mortal(newSViv(searchn)));
	} else {
		for (i = 0; i < searchn; i++) {
			XPUSHs(sv_2mortal(newSVpv(searchchar[i], 0)));
		}
	}







