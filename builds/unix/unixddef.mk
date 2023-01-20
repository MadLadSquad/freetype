#
# FreeType 2 configuration rules templates for
# development under Unix with no configure script (gcc only)
#


<<<<<<< HEAD
# Copyright (C) 1996-2024 by
=======
# Copyright (C) 1996-2023 by
>>>>>>> 63a30c8fa (Fixed accidentally removed folder that causes compile errors)
# David Turner, Robert Wilhelm, and Werner Lemberg.
#
# This file is part of the FreeType project, and may only be used, modified,
# and distributed under the terms of the FreeType project license,
# LICENSE.TXT.  By continuing to use, modify, or distribute this file you
# indicate that you have read the license and understand and accept it
# fully.


TOP_DIR := $(shell cd $(TOP_DIR); pwd)
OBJ_DIR := $(shell cd $(OBJ_DIR); pwd)

PLATFORM := unix

DELETE := rm -f
CAT    := cat
SEP    := /

# This is used for `make refdoc' and `make refdoc-venv'
#
BIN := bin


# library file name
#
LIBRARY := lib$(PROJECT)


# The directory where all library files are placed.
#
# By default, this is the same as $(OBJ_DIR); however, this can be changed
# to suit particular needs.
#
LIB_DIR := $(OBJ_DIR)


NO_OUTPUT := 2> /dev/null

# EOF
