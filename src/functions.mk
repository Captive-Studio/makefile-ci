# Display a password with **** + last 4 characters
#
# @example
#  echo $(call mask-password,$(PASSWORD))
#
define mask-password
$(shell [ -z '$(1)' ] && (echo '') || (echo "****$(shell echo $(1) | tail -c 4)"))
endef

# Escape a shell string passed as a single quoted string
#
# @example
#  embeddable-text = $(call escape-shell,$(SOME_TEXT))
#
escape-shell = $(subst $(newline),\$(newline),$(subst ','\'',$(1)))