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

ifndef SBS_INITIALIZE_INCLUDED
SBS_INITIALIZE_INCLUDED = 1

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
$(call check_defined, PROJECT_NAME, PROJECT_NAME is project name)

include $(WS)/build/sbs/definitions.mk

# Builder helper variables
OBJECTS          	 = $(patsubst %.c,$(WS)/$(DEF_GENERATED_DIR)/%.o,$(CC_SOURCES))
OBJECTS         	+= $(patsubst %.S,$(WS)/$(DEF_GENERATED_DIR)/%.o,$(AS_SOURCES))
DEPENDS          	 = $(patsubst %.o,%.d,$(OBJECTS))
PREPROCESSED     	 = $(patsubst %.o,%.i,$(OBJECTS))

# Create possible targets
PROJECT_NAME    	?= undefined
PROJECT_CONFIG  	?= template/configuration
PROJECT_ELF   		 = $(WS)/$(DEF_GENERATED_DIR)/$(PROJECT_NAME).elf
PROJECT_LIB     	 = $(WS)/$(DEF_GENERATED_DIR)/$(PROJECT_NAME).a
PROJECT_FLASH   	 = $(WS)/$(DEF_GENERATED_DIR)/$(PROJECT_NAME).hex
PROJECT_SIZE    	 = $(WS)/$(DEF_GENERATED_DIR)/$(PROJECT_NAME).siz
PROJECT_DOXYFILE_HTML 	= $(WS)/build/$(PROJECT_NAME).html.Doxyfile
PROJECT_DOXYFILE_PDF  	= $(WS)/build/$(PROJECT_NAME).pdf.Doxyfile

# This is the default target
.PHONY: all
all:

.PHONY: clean
clean: clean-size clean-flash

.PHONY: clean-objects
clean-objects: 
	$(VERBOSE)rm -f $(OBJECTS) $(DEPENDS)

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

distclean: clean
	$(PRINT) "Removing $(WS)/$(DEF_GENERATED_DIR) directory..."
	$(VERBOSE)rm -rf $(WS)/$(DEF_GENERATED_DIR)
	
.PHONY: documentation
documentation: html pdf 

.PHONY: clean-documentation
clean-documentation: clean-html clean-pdf
	$(VERBOSE)rm -rf $(DEF_DOX_O)
	$(PRINT) "Documentation cleaned up"

.PHONY: html
html: $(WS)/$(DEF_DOX_O_DIR)
	$(PRINT) "Generating HTML documentation..."
	$(VERBOSE)doxygen $(PROJECT_DOXYFILE_HTML) >/dev/null
	$(PRINT) "HTML generated in $(WS)/$(DEF_DOX_O_DIR)/$(DEF_DOX_HTML_O)"

.PHONY: clean-html
clean-html:
	$(PRINT) "Cleaning HTML documentation..."
	$(VERBOSE)rm -rf $(WS)/$(DEF_DOX_O_DIR)/$(DEF_DOX_HTML_O)

.PHONY: pdf
pdf: $(WS)/$(DEF_DOX_O_DIR)
	$(PRINT) "Generating PDF documentation..."
	$(VERBOSE)doxygen $(PROJECT_DOXYFILE_PDF) >/dev/null
	$(VERBOSE)$(MAKE) -C $(WS)/$(DEF_DOX_O_DIR)/$(DEF_DOX_LATEX_O)
	$(PRINT) "PDF generated in $(WS)/$(DEF_DOX_O_DIR)/$(DEF_DOX_LATEX_O)"

.PHONY: clean-pdf
clean-pdf:
	$(PRINT) "Cleaning PDF documentation..."
	$(VERBOSE)rm -rf $(WS)/$(DEF_DOX_O_DIR)/$(DEF_DOX_LATEX_O)

$(WS)/$(DEF_DOX_O_DIR):
	$(VERBOSE)$(MKDIR) -p $<
	
.PHONY: help
help:
	@echo "Neon Makefile help for project: '$(PROJECT_NAME)'"
	@echo
	@echo "== BUILD INFORMATION =="
	@echo "Targets:"
	@echo "  all                - Build lib and documentation."
	@echo "  clean              - Clean the generated directory contents."
	@echo "  library            - Build static library."
	@echo "  documentation      - Generate HTML and PDF documentation."
	@echo "  help               - Print this screen."
	@echo
	@echo "Generic arguments:"
	@echo "  V                  - Set verbosity level (default: $(V)):"
	@echo "                         0 - silent,"
	@echo "                         1 - verbose."
	@echo
	@echo "Port arguments:"
	@echo "  PLATFORM           - Build for specific platform."
	@echo "                       (default: $(PLATFORM))"
	@echo "  PROFILE            - Build for specific compilation profile."
	@echo "                       (default: $(PROFILE))"
	@echo "  ARCH               - Build for specific CPU architecture."
	@echo "                       (default: $(ARCH))"
	@echo "  CPU                - Build for specific CPU type."
	@echo "                       (default: $(CPU))"
	@echo "  OS                 - Build for specific OS family."
	@echo "                       (default: $(OS))"
	@echo
	@echo "Compiler variables:"
	@echo "  CC_FLAGS           - Compiler common flags."
	@echo "  CC_OPTIMIZATION_D  - Compiler optimization flags for"
	@echo "                       debug profile."
	@echo "  CC_OPTIMIZATION_R  - Compiler optimization flags for"
	@echo "                       release profile."
	@echo
	@echo "Linker variables:"
	@echo "  LD_FLAGS           - Linker common flags."
	@echo "  LD_LIBS          	- Linker additional libraries."
	@echo
	@echo "Usage example:"
	@echo "  make PLATFORM=$(PLATFORM) ARCH=$(ARCH) CC_FLAGS='-pedantic' V=1"
	@echo

.PHONY: cc_include_paths
cc_include_paths:
	$(foreach i,$(CC_INCLUDES),$(info $(WS)/$(i)))

.PHONY: cc_sources
cc_sources:
	$(foreach i,$(CC_SOURCES),$(info $(WS)/$(i)))
	$(foreach i,$(AS_SOURCES),$(info $(WS)/$(i)))

.PHONY: cc_flags
cc_flags:
	$(foreach i,$(CC_FLAGS),$(info $(i)))

.PHONY: cc_defines
cc_defines:
	$(foreach i,$(CC_DEFINES),$(info $(i)))

#
# Common library defines/includes/sources
#

# Add common library defines
RTK_GIT_VERSION := "$(shell git describe --abbrev=7 --always --dirty --tags 2>/dev/null || echo unknown)"

# Common defines for the library
CC_DEFINES += RTK_GIT_VERSION=\"$(RTK_GIT_VERSION)\"

endif
