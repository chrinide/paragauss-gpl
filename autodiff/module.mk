#
#
# ParaGauss, a program package for high-performance computations
# of molecular systems
# Copyright (C) 2014
# T. Belling, T. Grauschopf, S. Krüger, F. Nörtemann, M. Staufer,
# M. Mayer, V. A. Nasluzov, U. Birkenheuer, A. Hu, A. V. Matveev,
# A. V. Shor, M. S. K. Fuchs-Rohr, K. M. Neyman, D. I. Ganyushin,
# T. Kerdcharoen, A. Woiterski, A. B. Gordienko, S. Majumder,
# M. H. i Rotllant, R. Ramakrishnan, G. Dixit, A. Nikodem, T. Soini,
# M. Roderus, N. Rösch
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 as published
# by the Free Software Foundation [1].
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# [1] http://www.gnu.org/licenses/gpl-2.0.html
#
# Please see the accompanying LICENSE file for further information.
#
############################################################
# Make has no scopes, not to pollute the namespace
# use $(AD)/..., or AD- prefix for targets and $(AD-...)
# prefix for variables. A notable exception so far is the
# top-level traget
#
#       $(libad.a)
#

#
# We expect the before "include"ing this file the
# variable $(AD) is set to a suitable prefix.
#
# CURDIR is set on every make or $(MAKE) -C dir:
#
AD ?= $(CURDIR)

#
# List of AD implementations to build:
#
AD-objs = \
	$(AD)/ad0x1.o \
	$(AD)/ad1x1.o \
	$(AD)/ad2x1.o \
	$(AD)/ad1x2.o \
	$(AD)/ad2x2.o \
	$(AD)/ad1x3.o \
	$(AD)/ad2x3.o \
	$(AD)/ad1x5.o \
	$(AD)/ad1x7.o \

#
# They will be ARchived here:
#
libad.a = $(AD)/libad.a

#
# Target specific MAKE variables:
#
$(AD)/ad0x%.f90: ORD = 0
$(AD)/ad1x%.f90: ORD = 1
$(AD)/ad2x%.f90: ORD = 2

$(AD)/ad%x1.f90: NVAR = 1
$(AD)/ad%x2.f90: NVAR = 2
$(AD)/ad%x3.f90: NVAR = 3
$(AD)/ad%x4.f90: NVAR = 4
$(AD)/ad%x5.f90: NVAR = 5
$(AD)/ad%x6.f90: NVAR = 6
$(AD)/ad%x7.f90: NVAR = 7


#
# They all depend on master file, relying on target specific
# variables $(ORD) and $(NVAR) for auto-generating sources.
#
# The preprocessor directive -DAUTODIFF=$(MODULE-NAME) is supposed
# to set the name of the f90 module in the sources to $(MODULE-NAME).
#
$(AD-objs:.o=.f90): $(AD)/autodiff2.f90
	$(FPP) $(FPPOPTIONS) -DORD=$(ORD) -DNVAR=$(NVAR) -DAUTODIFF=$(basename $(@F)) $< $@

$(libad.a): $(AD-objs)
	$(AR) ruv $@  $(^)
	$(RANLIB) $@

#
# This removes autogenerated files and the lib itself:
#
AD-clean:
	rm -f $(AD-objs:.o=.f90)
	rm -f $(libad.a)

.PHONY: AD-clean

#
# Below we modify "global" variables and prerequisites of
# top-level targets ...
#

#
# This (global) variable (f90objs) is used in Make.rules to build and
# include dependencies:
#
f90objs += $(AD-objs)

#
# This is also a top-level (global) target, extend the list
# of dependencies:
#
clean: AD-clean
