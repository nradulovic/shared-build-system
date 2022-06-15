
include $(WS)/build/sbs/target_application.mk

.PHONY: test
test: $(PROJECT_ELF)
	$< > $(DEF_BUILD_DIR)/report_$(PROJECT_NAME)
	@echo Report in: $(DEF_BUILD_DIR)/report_$(PROJECT_NAME)
	@cat $(DEF_BUILD_DIR)/report_$(PROJECT_NAME)
