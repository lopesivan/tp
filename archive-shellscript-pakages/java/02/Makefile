hamls    = $(wildcard *.haml)
EXT      = .xml

.SUFFIXES:              # Delete the default suffixes
.SUFFIXES: .haml $(EXT) # Define our suffix list

# -------------------------------------------------------------------------- #
# -------------------------------------------------------------------------- #
# -------------------------------------------------------------------------- #
HAML     = haml
HAMLFLAGS= --double-quote-attributes

# -------------------------------------------------------------------------- #
# shell macro
# -------------------------------------------------------------------------- #

targets_haml=\
	for d in $(hamls); \
	do \
		for e in .xml; do \
			echo $${d%.*}$$e; \
		done; \
	done

##############################################################################

%.xml : %.haml
	$(HAML) $(HAMLFLAGS) $< $@

# -------------------------------------------------------------------------- #
# -------------------------------------------------------------------------- #
# -------------------------------------------------------------------------- #

prebuilding = $(shell $(targets_haml))

all: $(prebuilding) jar

jar:
	@ant $@

indent:
	@ant $@

#	compile Java source
compile:
	@ant $@

#	show user the -projecthelp option
help:
	@ant -projecthelp

#	run JUnit test against the text TestRunner
run-test-text:
	@ant $@

run:
	@ant $@

run-test:
	@ant $@
#
# ============================================================================
#

clean :
	-ant clean
	-rm -rf $(addprefix *, $(EXT))
	@(find src/ -type f -name \*.orig -exec rm {} \; )

# END OF FILE

