.PHONY: all
all: setup dependencies lint ## Run all targets

#-------------
# SETUP
#-------------
.PHONY: setup setup.default setup.local setup.ci $(call core-hooks,.setup)
setup: setup.workflow-run ## Install global dependencies and setup the project
setup.default: $(call core-hooks,.setup)
setup.local: setup.default
setup.ci: setup.default
.setup.before::
	@:
.setup::
	@:
.setup.after::
	@:

#-------------
# INSTALL
#-------------
.PHONY: install install.default install.local install.ci $(call core-hooks,.install)
install: install.workflow-run ## Install project dependencies (force installation)
install.default: $(call core-hooks,.install)
install.local: install.default
install.ci: install.default
.install.before::
	@:
.install::
	@:
.install.after::
	@:

#-------------
# DEPENDENCIES
#-------------
.PHONY: dependencies dependencies.default dependencies.local dependencies.ci $(call core-hooks,.dependencies)
dependencies: dependencies.workflow-run ## Ensure project dependencies are present (install only if needed)
dependencies.default: $(call core-hooks,.dependencies)
dependencies.local: dependencies.default
dependencies.ci: dependencies.default
.dependencies.before::
	@:
.dependencies::
	@:
.dependencies.after::
	@:

#-------------
# BUILD
#-------------
.PHONY: build build.default build.local build.ci $(call core-hooks,.build)
build: build.workflow-run ## Build sources
build.default: $(call core-hooks,.build)
build.local: build.default
build.ci: build.default
.build.before::
	@:
.build::
	@:
.build.after::
	@:

#-------------
# CLEAN
#-------------
.PHONY: clean clean.default clean.local clean.ci $(call core-hooks,.clean)
clean: clean.workflow-run ## Clean build files
clean.default: $(call core-hooks,.clean)
clean.local: clean.default
clean.ci: clean.default
.clean.before::
	@:
.clean::
	@:
.clean.after::
	@:

#-------------
# LINT
#-------------
.PHONY: lint lint.default lint.local lint.ci $(call core-hooks,.lint)
lint: dependencies lint.workflow-run ## Lint all source files
lint.default: $(call core-hooks,.lint)
lint.local: lint.default
lint.ci: lint.default
.lint.before::
	@:
.lint::
	@:
.lint.after::
	@:

#-------------
# FORMAT
#-------------
.PHONY: format format.default format.local format.ci $(call core-hooks,.format)
format: dependencies format.workflow-run ## Format all source files
format.default: $(call core-hooks,.format)
format.local: format.default
format.ci: format.default
.format.before::
	@:
.format::
	@:
.format.after::
	@:

#-------------
# TEST
#-------------
.PHONY: test test.default test.local test.ci $(call core-hooks,.test)
test: dependencies test.workflow-run ## Run unit tests
test.default: $(call core-hooks,.test)
test.local: test.default
test.ci: test.default
.test.before::
	@:
.test::
	@:
.test.after::
	@:

#-------------
# TEST SYSTEM (E2E)
#-------------
.PHONY: test-e2e test-e2e.default test-e2e.local test-e2e.ci $(call core-hooks,.test-e2e)
test-e2e: dependencies test-e2e.workflow-run ## Run system tests (e2e)
test-e2e.default: $(call core-hooks,.test-e2e)
test-e2e.local: test-e2e.default
test-e2e.ci: test-e2e.default
.test-e2e.before::
	@:
.test-e2e::
	@:
.test-e2e.after::
	@:

#-------------
# DEVELOP
#-------------
.PHONY: develop develop.default develop.local develop.ci $(call core-hooks,.develop)
develop: dependencies develop.workflow-run ## Setups a local development environment
develop.local: $(call core-hooks,.develop)
develop.ci:
	@$(call log,warn,"[Develop] Job disabled in CI mode",0)
.develop.before::
	@:
.develop::
	@:
.develop.after::
	@:

#-------------
# SCAN
#-------------
#
# To add a new target to scan
#
# my-target-scan:
# 	@echo 'Scan!'
#
# MAKEFILE_SCAN_TARGETS += my-target-scan
#
.PHONY: scan scan.default scan.local scan.ci $(call core-hooks,.scan)
scan: scan.workflow-run ## Scan code for potential issues
scan.default: $(call core-hooks,.scan)
scan.ci: scan.default
scan.local: scan.default
.scan.before::
	@:
.scan:
	$(Q)FAILS=0; \
	for target in $(MAKEFILE_SCAN_TARGETS); do \
		$(MAKE) $$target || FAILS=1; \
	done; \
	if [ $$FAILS -eq 0 ]; then \
		$(call log,info,"🎉 Everything is OK",1); \
	else \
		$(call log,fatal,"❌ Some problems need to be fixed",1); \
		exit 1; \
	fi
.scan.after::
	@:

# A list of variable names that will be displayed before deployment
DEPLOY_VARIABLES := \
	CI_ENVIRONMENT_URL

#-------------
# DEPLOY
#-------------
.PHONY: deploy deploy.default deploy.local deploy.ci $(call core-hooks,.deploy)
deploy: deploy.workflow-run ## Deploy the application to the given environment
deploy.default: $(call core-hooks,.deploy)
deploy.local: .deploy-check
	$(Q)$(call log,warn,WARNING! This will deploy local files,1)
	$(Q)read -r -p "Continue? [y/N]" REPLY;echo; \
	if [[ "$$REPLY" =~ ^[Yy]$$ ]]; then \
		$(MAKE) deploy.default; \
	fi
deploy.ci: .deploy-check
	$(Q)$(MAKE) deploy.default;

.deploy-check:
# Display important deploy variables
	@$(foreach V,$(sort $(CI_VARIABLES) $(DEPLOY_VARIABLES)), \
		$(if $(filter CI_ENVIRONMENT_NAME,$(V)),\
			$(if $(filter local,$($V)),\
				$(call log,error,$V=$($V) (forbidden value, use CI_ENVIRONMENT_NAME=<environment> make deploy),1),\
				$(call log,info,$V=$($V),1)\
			),\
			$(call log,info,$V=$($V),1)\
		); \
	)
# Stop program if error
ifeq ($(CI_ENVIRONMENT_NAME),local)
	@$(call log,fatal,Deployment stopped,1);
	$(Q)exit 1;
endif

.deploy.before::
	@:
.deploy::
	@:
.deploy.after::
	@:

#-------------
# RESCUE
#-------------
.PHONY: rescue rescue.default rescue.local rescue.ci $(call core-hooks,.rescue)
rescue: rescue.workflow-run ## Clean everything in case of problem
rescue.default: $(call core-hooks,.rescue)
rescue.local: rescue.default
rescue.ci:
	@$(call log,warn,"[Rescue] Job disabled in CI mode",0)

.rescue.before::
	@:
.rescue::
	@:
.rescue.after::
	@:

# Reinstall after rescue
.rescue.before::
	@$(call log,info,"[Git] Clean all local changes...",1)
	$(Q)$(call log,warn,WARNING! This will remove all non commited git changes.,1)
	$(Q)read -r -p "Continue? [y/N]" REPLY;echo; \
	if [[ "$$REPLY" =~ ^[Yy]$$ ]]; then \
		$(GIT) clean -fdx; \
	fi
.rescue.after:: dependencies

# This generic job allow to easily switch implementation between local and CI mode
#
# Example :
# job: job.workflow-run
# 	-> Will run job.ci when $(CI) is set
#   -> Will run job.local when $(CI) is not set
#
ifneq ($(call filter-false,$(CI)),)
%.workflow-run:
	@$(call log,info,"[Make] $* \(mode=CI\)")
	@${MAKE} $*.ci
else
%.workflow-run:
	@$(call log,info,"[Make] $* \(mode=Local\)")
	@${MAKE} $*.local
endif
