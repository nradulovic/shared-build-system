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

# Some defaults if they are not already given.
PLATFORM ?= gcc
PROFILE ?= debug
OS ?= linux
CPU ?= x86
ARCH ?= x86

$(info VARIANT: $(PLATFORM)-$(PROFILE)-$(OS)-$(CPU)-$(ARCH))

# NOTE: Load specified CPU
include $(WS)/build/va_build/cpu_$(CPU).mk
-include $(WS)/build/va_build/$(PLATFORM)_cpu_$(CPU).mk

# NOTE: Load specified ARCH
include $(WS)/build/va_build/arch_$(ARCH).mk
-include $(WS)/build/va_build/$(PLATFORM)_arch_$(ARCH).mk

# NOTE: Load specified OS
include $(WS)/build/va_build/os_$(OS).mk
-include $(WS)/build/va_build/$(PLATFORM)_os_$(OS).mk

# NOTE: Load specified PROFILE
include $(WS)/build/va_build/profile_$(PROFILE).mk
-include $(WS)/build/va_build/$(PLATFORM)_profile_$(PROFILE).mk

# NOTE: Load specified PLATFORM
include $(WS)/build/va_build/platform_$(PLATFORM).mk

# From ADD_NPORT_FEATURE set substract DEL_NPORT_FEATURE set
NPORT_FEATURE_LIST = $(filter-out $(sort $(DEL_NPORT_FEATURE)), $(sort $(ADD_NPORT_FEATURE)))

# Include only filtered include files
NPORT_FEATURES = $(NPORT_FEATURE_LIST:%=$(WS)/build/va_build/$(PLATFORM)_feature_%.mk)


include $(NPORT_FEATURES)
