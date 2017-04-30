# If the first argument is "run"...
ifeq (show,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

prog:
	@echo =1=[command]==

.PHONY: show
show: prog
	md2man-roff $(RUN_ARGS)| man -l -
