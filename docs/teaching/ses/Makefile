.PHONY : clean all
.DEFAULT_GOAL := all

EXCLUDE=-x \*.idea\* -x \*out\*

zip:
	zip -r decorator.zip decorator/ $(EXCLUDE)
	zip -r facade.zip facade/ $(EXCLUDE)
	zip -r singleton.zip singleton/ $(EXCLUDE)

clean:
	rm -rf *.zip

all: zip
