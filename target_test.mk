
include $(WS)/build/build/target_application.mk

.PHONY: test
test: $(PROJECT_ELF)
	$<
