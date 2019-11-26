.PHONY : clean all
.DEFAULT_GOAL := all

EXCLUDE=-x \*.idea\* -x \*out\* -x \*build\* -x \*.gradle\*

zip:
	zip -r decorator.zip decorator/ $(EXCLUDE)
	zip -r facade.zip facade/ $(EXCLUDE)
	zip -r singleton.zip singleton/ $(EXCLUDE)
	zip -r di.zip di/ $(EXCLUDE)
	zip -r factory.zip factory/ $(EXCLUDE)

clean:
	rm -rf *.zip

all: zip
