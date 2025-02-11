# Default version
VERSION_DEFAULT := 1.0.0-alpha.0

# File containing source code version
VERSION_FILE := VERSION

## Source code version
VERSION ?= $(shell cat $(VERSION_FILE) 2>/dev/null)

# Target to generate default version file
$(VERSION_FILE): FORCE
	$(Q)if [ ! -f $@ ]; then \
	  echo "$(VERSION_DEFAULT)" > $@; \
	fi

# Target to read or create a default VERSION file at the root of repository
# This version :
#   - has a meaning for the project (e.g., "v1.0.0")
#   - is used to generate a unique build-version
#
# Example:
# 	make version # > 1.0.0-alpha.0
.PHONY: version
version: $(VERSION_FILE) ## Display app version (ex: 1.0.0)
	@echo $(VERSION)
