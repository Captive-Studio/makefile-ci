
HEROKU := heroku
HEROKU_CACHE_PATH := $(PROJECT_CACHE_PATH)/heroku

## Heroku api key used to login with cli
HEROKU_API_KEY ?=
## Heroku default app prefix (default: $(CI_PROJECT_NAME))
HEROKU_APP_PREFIX ?= $(CI_PROJECT_NAME)
## Heroku default app suffix (default: -$(CI_ENVIRONMENT_NAME))
HEROKU_APP_SUFFIX ?= -$(CI_ENVIRONMENT_NAME)
## Heroku app name (default: $(HEROKU_APP_PREFIX)$(HEROKU_APP_SUFFIX))
HEROKU_APP ?= $(HEROKU_APP_PREFIX)$(HEROKU_APP_SUFFIX)

# Heroku git url
ifneq ($(HEROKU_API_KEY),)
	HEROKU_GIT_URL := https://heroku:$(HEROKU_API_KEY)@git.heroku.com
else
	HEROKU_GIT_URL := https://git.heroku.com
endif

# Register variables to be displayed before deployment
DEPLOY_VARIABLES += HEROKU_APP

.PHONY: heroku-login
heroku-login:
ifneq ($(HEROKU_API_KEY),)
	@$(call log,info,"[Heroku] Login using \$$HEROKU_API_KEY...",1)
else
	$(Q):
endif

.PHONY: heroku-deploy
heroku-deploy: heroku-login
	@$(call log,info,"[Heroku] Deploy $(HEROKU_APP)...",1)
	$(Q)$(GIT) push --no-verify --force $(HEROKU_GIT_URL)/$(HEROKU_APP).git HEAD:main
