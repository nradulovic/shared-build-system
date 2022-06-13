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

# Enable 
# mfloat-abi=hard: Uses floating-point instructions and the floating-point ABI
# fpv4: VFP version
# sp: single precision
# d16: 16 64-bit FPU registers
CC_FLAGS += --mfloat-abi=hard -mfpu=fpv4-sp-d16
LD_LIBS += m

