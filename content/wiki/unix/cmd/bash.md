+++
title = "bash"
draft = false
tags = [
    "unix",
    "cmd",
    "bash"
]
date = "2013-03-12"
+++
# Bash Scripting 

#### Rerun last command 

```
!!
```

Joink.

#### bash opties uit een shell script halen 

Gepikt van http://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

```bash
#!/bin/bash
for i in $*
do
case $i in
    -p######*|--prefix*)
    PREFIX######`echo $i | sed 's/[-a-zA-Z0-9]*//'`

    ;;
    -s######*|--searchpath*)
    SEARCHPATH######`echo $i | sed 's/[-a-zA-Z0-9]*//'`
    ;;
    -l######*|--lib*)
    DIR######`echo $i | sed 's/[-a-zA-Z0-9]*//'`
    ;;
    --default)
    DEFAULT=YES
    ;;
    *)
            # unknown option
    ;;
esac
done
echo PREFIX = ${PREFIX}
echo SEARCH PATH = ${SEARCHPATH}
echo DIRS = ${DIR}
```

Makkelijker dan `getopts()`?

#### Pipen en multiple lines in shell scripts 

Dit is legale shell code:

```bash
#!/bin/sh
cat dinges.log |
  cut -d ' ' -f 3
  grep 'Exception' |
  uniq
```

De pipe aan het begin van een nieuwe lijn alleszins niet. Ook `>>` of `>` kan niet het begin zijn van een nieuwe lijn, dan wordt een spatie gepiped naar de outputstream.

#### array loops 

```bash
names=( Jennifer Tonya Anna Sadie )
for name in ${names[@]}
do
  echo $name
  # other stuff on $name
done
```

Ook mogelijk om bvb een counter bij te houden met `for (( i = 0 ; i < ${#names[@]} ; i++ ))`. Array waarde accessen met `${names[$i]}`.

Inline arrays "maken" en over lopen gaat met `for VAR in 'a' 'b' 'c' do ... done`.

##### argumenten samen rapen in een variabele 

```bash
DIR_EXCLUDES=(eclipsecompiled test bin target)
FILE_EXCLUDES=(messages errors)

SEARCH=""

for FILE_EXCLUDE in ${FILE_EXCLUDES[@]}
do
	SEARCH="${SEARCH} -not -name *${FILE_EXCLUDE}*"
done
for DIR_EXCLUDE in ${DIR_EXCLUDES[@]}
do
	SEARCH="${SEARCH} -not -path *${DIR_EXCLUDE}*"
done
```

:exclamation: dit werkt **niet** als er een dubbele quote bij komt kijken in de vorm van `<br/>"` - vreemd? uit te zoeken...

#### Controleren of een string in een variabele steekt 

Zie http://stackoverflow.com/questions/229551/string-contains-in-bash - makkelijkste manieren zijn

##### met grep 

```bash
if grep -q '|' <<<$line; then
  echo "jup"
fi
```

##### met regexp 

```bash
if [[ "$line" =~ "|" ]]; then
  echo "jup"
fi
```

#### Loopen over alle lijnen van bepaalde output voor verdere processing 

```bash
`cat somefile` | while read line
do
  echo "lijn $line"
done
```

Dit kan ook maar dan moet je de separator variabele voor `for` aanpassen:

```bash
IFS=$'<br/>n'
for line in `cat somefile`
do
  echo "lijn $line"
done
```

:exclamation: By default splitst for **op spaties**