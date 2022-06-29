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

$(info VARIANT [platform-profile-os-cpu-arch]: $(PLATFORM)-$(PROFILE)-$(OS)-$(CPU)-$(ARCH))

# NOTE: Load specified CPU
include $(WS)/build/sbs/variant/cpu_$(CPU).mk
-include $(WS)/build/sbs/variant/$(PLATFORM)_cpu_$(CPU).mk

# NOTE: Load specified ARCH
include $(WS)/build/sbs/variant/arch_$(ARCH).mk
-include $(WS)/build/sbs/variant/$(PLATFORM)_arch_$(ARCH).mk

# NOTE: Load specified OS
include $(WS)/build/sbs/variant/os_$(OS).mk
-include $(WS)/build/sbs/variant/$(PLATFORM)_os_$(OS).mk

# NOTE: Load specified PROFILE
include $(WS)/build/sbs/variant/profile_$(PROFILE).mk
-include $(WS)/build/sbs/variant/$(PLATFORM)_profile_$(PROFILE).mk

# NOTE: Load specified PLATFORM
include $(WS)/build/sbs/variant/platform_$(PLATFORM).mk

# From ADD_NPORT_FEATURE set substract DEL_NPORT_FEATURE set
VARIANT__FEATURE_LIST = $(filter-out $(sort $(VARIANT_DEL_FEATURES)), $(sort $(VARIANT_FEATURES)))

$(info FEATURES: $(VARIANT__FEATURE_LIST))

# Include only filtered include files
VARIANT__FEATURE_INCLUDES = $(VARIANT__FEATURE_LIST:%=$(WS)/build/sbs/variant/$(PLATFORM)_feature_%.mk)

include $(VARIANT__FEATURE_INCLUDES)
