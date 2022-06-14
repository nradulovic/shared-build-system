
include $(WS)/build/sbs/target_application.mk

.PHONY: test
test: $(PROJECT_ELF)
	$< > $(WS)/build/generated/report_$(PROJECT_NAME)
	@echo Report in: $(WS)/build/generated/report_$(PROJECT_NAME)
	@cat $(WS)/build/generated/report_$(PROJECT_NAME)
