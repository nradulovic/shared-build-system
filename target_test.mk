
include $(WS)/build/sbs/target_application.mk

.PHONY: test
test: $(PROJECT_ELF)
	$< > $(WS)/$(DEF_GENERATED_DIR)/report_$(PROJECT_NAME)
	@echo Report in: $(WS)/$(DEF_GENERATED_DIR)/report_$(PROJECT_NAME)
