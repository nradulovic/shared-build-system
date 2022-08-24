
include $(WS)/build/../external/sbs/target_application.mk

.PHONY: run
run: executable
	$(PROJECT_ELF)

