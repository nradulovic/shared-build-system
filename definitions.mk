
ifndef SBS_DEFINITIONS_INCLUDED
SBS_DEFINITIONS_INCLUDED = 1

# Project directory structure
DEF_EXTERNAL_DIR 		= external
DEF_GENERATED_DIR 		= generated
DEF_DOCUMENTATION_DIR 	= documentation
DEF_PACK_DIR    		= packed

# Documentation defaults
DEF_DOX_O_DIR    = $(WS)/generated/documentation
DEF_DOX_HTML_O   = html
DEF_DOX_LATEX_O  = latex

# Common build variables
DEF_BUILD_DIR   	= $(WS)/generated

# Handle the verbosity argument
# If the argument is not given assume that verbosity is off.
V ?= 0
ifeq ("$(V)","1")
VERBOSE         := # Empty space
PRINT           := @true # Empty space
else ifeq ("$(V)","0")
VERBOSE         := @ # Empty space
PRINT           := @echo # Empty space
MAKEFLAGS       += -s
else
$(error Specify either `V=0` or `V=1`)
endif

endif