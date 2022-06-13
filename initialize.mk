# Neon
# Copyright (C) 2018   REAL-TIME CONSULTING
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
# more details.
#
# You should have received a copy of the GNU Lesser General Public License along with
# this program. If not, see <http://www.gnu.org/licenses/>.
#

ifndef LIB_BUILD_COMMON_MK
LIB_BUILD_COMMON_MK = 1

# == Functions ==
# Check that given variables are set and all have non-empty values,
# die with an error otherwise.
#
# Params:
#   1. Variable name(s) to test.
#   2. (optional) Error message to print.
check_defined = \
    $(strip $(foreach 1,$1, \
            $(call __check_defined,$1,$(strip $(value 2)))))
    __check_defined = \
        $(if $(value $1),, \
              $(error Undefined $1$(if $2, ($2))))

# Try to include a file given in the first argument. The function will return
# the status which must be checked.
#
# Params:
#   1. Include file name
safe_include = \
    $(if $(shell if [ -e $1 ]; then echo 1; fi),$(eval include $1), \
        $(shell echo $1))

$(call check_defined, WS, WS is relative path to Neon build directory)
$(call check_defined, PROJECT_DIR, PROJECT_DIR is project root source directory)
$(call check_defined, PROJECT_NAME, PROJECT_NAME is project name)

# Project directory structure
DEF_EXTERNAL_DIR = external

# Documentation defaults
DEF_DOX_O        = documentation/generated
DEF_DOX_HTML_O   = html
DEF_DOX_LATEX_O  = latex
DEF_DOX_PROJECT  = documentation/$(MOD_NAME)_doxyfile
DEF_DOX_BASE     = $(WS)/documentation/base_doxyfile
DEF_DOXYFILE	 = $(DEF_DOX_O)/doxyfile

# Builder helper variables
OBJECTS          = $(patsubst %.c,$(DEF_BUILD_DIR)/%.o,$(CC_SOURCES))
OBJECTS         += $(patsubst %.S,$(DEF_BUILD_DIR)/%.o,$(AS_SOURCES))
DEPENDS          = $(patsubst %.o,%.d,$(OBJECTS))
PREPROCESSED     = $(patsubst %.o,%.i,$(OBJECTS))

# Common build variables
DEF_BUILD_DIR   = generated
DEF_PACK_DIR    = packed

# Create possible targets
PROJECT_NAME   ?= undefined
PROJECT_CONFIG ?= configuration/template
PROJECT_ELF     = $(DEF_BUILD_DIR)/$(PROJECT_NAME).elf
PROJECT_LIB     = $(DEF_BUILD_DIR)/$(PROJECT_NAME).a
PROJECT_FLASH   = $(DEF_BUILD_DIR)/$(PROJECT_NAME).hex
PROJECT_SIZE    = $(DEF_BUILD_DIR)/$(PROJECT_NAME).siz

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

# This is the default target
.PHONY: all
all:

.PHONY: clean
clean:

.PHONY: clean-objects
clean-objects: 
	$(VERBOSE)rm -f $(OBJECTS) $(DEPENDS)

.PHONY: documentation
documentation: html pdf 

.PHONY: documentation-clean
documentation-clean: html-clean pdf-clean
	$(VERBOSE)rm -rf $(DEF_DOX_O)
	$(PRINT) "Documentation cleaned up"

.PHONY: html
html: $(DEF_DOXYFILE)
	@echo "GENERATE_HTML = YES" >> $(DEF_DOXYFILE)
	$(PRINT) "Generating HTML documentation..."
	$(VERBOSE)doxygen $< >/dev/null
	@echo
	$(PRINT) "HTML generated in $(DEF_DOX_O)/$(DEF_DOX_HTML_O)"

.PHONY: clean-lib
clean-lib: clean-objects
	$(PRINT) "Cleaning library..."
	$(VERBOSE)rm -rf $(PROJECT_LIB)

.PHONY: clean-elf
clean-elf: clean-lib
	$(PRINT) "Cleaning executable..."
	$(VERBOSE)rm -rf $(PROJECT_ELF)

.PHONY: clean-size
clean-size: clean-elf
	$(PRINT) "Cleaning size report..."
	$(VERBOSE)rm -rf $(PROJECT_SIZE)

.PHONY: clean-flash
clean-flash: clean-elf
	$(PRINT) "Cleaning flash binary file..."
	$(VERBOSE)rm -rf $(PROJECT_FLASH)

.PHONY: html-clean
html-clean:
	$(PRINT) "Cleaning HTML documentation..."
	$(VERBOSE)rm -rf $(DEF_DOX_O)/$(DEF_DOX_HTML_O)

.PHONY: pdf
pdf: $(DEF_DOXYFILE)
	@echo "GENERATE_LATEX = YES" >> $(DEF_DOXYFILE)	
	$(PRINT) "Generating PDF documentation..."
	$(VERBOSE)doxygen $< >/dev/null
	$(VERBOSE)$(MAKE) -C $(DEF_DOX_O)/$(DEF_DOX_LATEX_O)
	@echo
	$(PRINT) "PDF generated in $(DEF_DOX_O)/$(DEF_DOX_LATEX_O)"

.PHONY: pdf-clean
pdf-clean:
	$(PRINT) "Cleaning PDF documentation..."
	$(VERBOSE)rm -rf $(DEF_DOX_O)/$(DEF_DOX_LATEX_O)

.PHONY: $(DEF_DOXYFILE)
$(DEF_DOXYFILE): $(DEF_DOX_PROJECT) $(DEF_DOX_BASE)
	$(PRINT) "Generating Doxyfile..."
	@mkdir -p $(dir $@)
	@cat $(DEF_DOX_BASE) > $@
	@cat $(DEF_DOX_PROJECT) >> $@
	@echo "PROJECT_NUMBER = '$(GIT_VERSION)'" >> $@
	@echo "OUTPUT_DIRECTORY = $(DEF_DOX_O)" >> $@
	@echo "HTML_OUTPUT = $(DEF_DOX_HTML_O)" >> $@
	@echo "LATEX_OUTPUT = $(DEF_DOX_LATEX_O)" >> $@

.PHONY: help
help:
	@echo "Neon Makefile help for module '$(MOD_NAME)'"
	@echo
	@echo "This module depends on the following modules: $(MOD_DEPS)"
	@echo
	@echo "== BUILD INFORMATION =="
	@echo "Targets:"
	@echo "  all                - Build lib and documentation."
	@echo "  clean              - Clean the build directory."
	@echo "  lib                - Build static PicoBlocks library."
	@echo "  documentation      - Generate HTML and PDF documentation."
	@echo "  help               - Print this screen."
	@echo
	@echo "Generic arguments:"
	@echo "  V                  - Set verbosity level (default: $(DEF_V)):"
	@echo "                         0 - silent,"
	@echo "                         1 - verbose."
	@echo "  PROFILE            - Make code in (default: $(PROFILE)):"
	@echo "                         release,"
	@echo "                         debug mode."
	@echo
	@echo "Port arguments:"
	@echo "  PLATFORM           - Build for specific platform."
	@echo "                       (default: $(PLATFORM))"
	@echo "  ARCH               - Build for specific CPU architecture."
	@echo "                       (default: $(ARCH))"
	@echo
	@echo "Compiler variables:"
	@echo "  CFLAGS             - Compiler common flags."
	@echo "  COPTIMIZATION_D    - Compiler optimization flags for"
	@echo "                       debug profile."
	@echo "  COPTIMIZATION_R    - Compiler optimization flags for"
	@echo "                       release profile."
	@echo
	@echo "Linker variables:"
	@echo "  LDFLAGS            - Linker common flags."
	@echo "  LDLIBS             - Linker additional libraries."
	@echo
	@echo "Usage example:"
	@echo "  make PLATFORM=$(PLATFORM) ARCH=$(ARCH) CC_FLAGS='-pedantic' V=1"
	@echo

.PHONY: cc_include_paths
cc_include_paths:
ifdef NEON_ROOT
	$(foreach i,$(CC_INCLUDES),$(info $(NEON_ROOT)/$(i)))
else
	$(foreach i,$(CC_INCLUDES),$(info $(WS)/$(i)))
endif

.PHONY: cc_sources
cc_sources:
ifdef NEON_ROOT
	$(foreach i,$(CC_SOURCES),$(info $(NEON_ROOT)/$(i)))
	$(foreach i,$(AS_SOURCES),$(info $(NEON_ROOT)/$(i)))
else
	$(foreach i,$(CC_SOURCES),$(info $(WS)/$(i)))
	$(foreach i,$(AS_SOURCES),$(info $(WS)/$(i)))
endif

.PHONY: cc_flags
cc_flags:
	$(foreach i,$(CC_FLAGS),$(info $(i)))

.PHONY: cc_defines
cc_defines:
	$(foreach i,$(CC_DEFINES),$(info $(i)))

.PHONY: package
package: config
	$(VERBOSE)for p in $(CC_INCLUDES); \
    do \
        dirs=$$(dirname $$(find $${p} -name *.h)); \
        mkdir -pv $(DEF_PACK_DIR)/$${dirs}; \
        cp -vr $(WS)/$${dirs} $(DEF_PACK_DIR)/$${p};\
    done
	$(VERBOSE)for file in $(CC_SOURCES); do \
        mkdir -pv $$(dirname $(DEF_PACK_DIR)/$${file}); \
        cp -v $(WS)/$${file} $(DEF_PACK_DIR)/$${file};\
    done
	$(VERBOSE)echo "Compiler flags  : " $(CC_FLAGS) > $(DEF_PACK_DIR)/settings.txt
	$(VERBOSE)echo "Compiler defines: " $(CC_DEFINES) >> $(DEF_PACK_DIR)/settings.txt
	$(VERBOSE)echo "Linker flags    : " $(LD_FLAGS) >> $(DEF_PACK_DIR)/settings.txt
	
#
# Common library defines/includes/sources
#

# Add common library defines
RTK_GIT_VERSION := "$(shell git describe --abbrev=7 --always --dirty --tags 2>/dev/null || echo unknown)"

# Common defines for the library
CC_DEFINES += RTK_GIT_VERSION=\"$(RTK_GIT_VERSION)\"

endif
