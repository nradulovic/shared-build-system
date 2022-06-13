
include $(WS)/build/sbs/target_application.mk

.PHONY: test
test: $(PROJECT_ELF)
	$<
