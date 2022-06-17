
include $(WS)/build/sbs/target_application.mk

.PHONY: run
run: executable
	$(PROJECT_ELF)

