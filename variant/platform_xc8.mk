#
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

# Platform description
BUILD_PLATFORM_DESC = "Microchip XC8"

CC_INCLUDES += nk/va_include/platform_xc8
# CC_SOURCES += lib/va_source/nport_platform_xc8.c

# Rule to compile C sources to object files.
$(DEF_BUILD_DIR)/%.o: $(WS)/%.c
	$(PRINT) " [CC]: $@"
	$(VERBOSE)echo "Building with Microchip XC8 is not supported."

# Rule to compile C sources to preprocessed files.
$(DEF_BUILD_DIR)/%.i: $(WS)/%.c
	$(PRINT) " [CC]: $@"
	$(VERBOSE)echo "Building with Microchip XC8 is not supported."

# Rule to compile Assembly sources to preprocessed files.
$(DEF_BUILD_DIR)/%.i: $(WS)/%.S
	$(PRINT) " [AS]: $@"
	$(VERBOSE)echo "Building with Microchip XC8 is not supported."

# Rule to compile Assembly sources to object files.
$(DEF_BUILD_DIR)/%.o: $(WS)/%.S
	$(PRINT) " [AS]: $@"
	$(VERBOSE)echo "Building with Microchip XC8 is not supported."

# Rule to link object files to library.
%.a:
	$(PRINT) " [AR]: $@"
	$(VERBOSE)echo "Building with Microchip XC8 is not supported."

# Rule to link object files to ELF executable.
%.elf: $(LD_LIBS) $(AR_LIBS)
	$(PRINT) " [LD]: $@"
	$(VERBOSE)echo "Building with Microchip XC8 is not supported."

# Rule to generate HEX file from ELF executable.
%.hex:
	$(PRINT) " [OBJCOPY]: $@"
	$(VERBOSE)echo "Building with Microchip XC8 is not supported."

# Rule to generate size report from ELF executable.
%.siz:
	$(PRINT) " [SIZE]: $@"
	$(VERBOSE)echo "Building with Microchip XC8 is not supported."

