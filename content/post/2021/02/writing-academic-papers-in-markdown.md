---
title: "How to write academic papers in Markdown"
date: '2021-02-14'
subtitle: "Tired of that silly LaTeX syntax? "
tags:
  - publishing
  - pandoc
  - Markdown
  - latex
categories:
  - software
---

In 2020, I explained [how to use pandoc](/post/2020/05/using-pandoc/) to publish a book. Essentially, I use the same workflow to write papers in academia. A couple of colleagues asked me how this was done, although they suspected it had something to do with [Pandoc](https://pandoc.org/). When I'm not writing in collaboration with someone, and thus using [Overleaf](https://overleaf.com/), I like to keep things simple, by resorting to my favorite way of writing things: Markdown. 

However geeky and cool LaTeX might be, it violates a lot of _Clean Code_ rules by ignoring separation of concerns. Even `html` has most of the layout separated - albeit not in a particularly good way - using `css`. Having to write `\textbf{wowza}` just to get something in bold gets tiresome fast, and creating your own rules, tags, or scripts ultimately do not resolve the issue, they just work around it. I'm not advocating for writing your dissertation in Word. It's simply very confusing to look at a document and try to read sections and streams of thought without the LaTeX syntax getting in the way. 

Enter Markdown: instead of 

```tex
Hello \textbf{bold} stuff! Oh wait, here's ``an image" - weird quotations
\begin{figure}[h!]
  \centering
  \includegraphics{something.png}
  \caption{My caption. \label{fig:delphi}}
\end{figure}
Yeah. That sucks. 
```

You write:

```md
Hello **bold** stuff! Oh wait, here's "an image" - regular quotes, whew.
!["My caption."](something.png)
Yeah. Much better.
```

Sure, there's still "syntax" to be learned the uninitiated. Still, it's a heck of a lot less, and it makes reading source files (`.md` instead of `.tex`) much, _much_ easier. Take a look at an Overleaf window of our latest paper draft:

![](../overleaf.jpg)

The left part - where you do the work - is simply hideous, and usually riddled with layout-specific syntax. Don't get me wrong, I love the collaborative plus-side of Overleaf, but it's still raw LaTeX. As a Java developer, I do not write `.class` files either: I write the `.java` ones and compile the latter. 

### The toolchain

As mentioned in the [pandoc article](/post/2020/05/using-pandoc/), this is the setup:

{{<mermaid>}}
graph LR;
    md[Plaintext, md =]
    tex[LaTeX, tex =]
    pdf[Postscript, pdf =]
    md --> tex
    tex --> pdf
{{< /mermaid >}}

Simple enough, and the [Pandoc User Guide](https://pandoc.org/MANUAL.html) helps you in understanding the specifics when converting from Markdown to Tex. The most challenging part of writing academic papers in Markdown is not the conversion process but the annoying details you have to get right when adhering to a layout/template of a conference or journal. I write most things in Sublime, and put simple commands in a `Makefile` in order for `⌘+B` (Build) to work. The build file itself is straightforward enough:

```make
all:
  pandoc -f markdown+smart delphi_report.pd.md --include-in-header=delphi_report_preamble.tex  --template=$(templatedir)/acm-pandoc-conf.tex --filter panflute --natbib --variable --biblio-style=$(csldir)/ACM-Reference-Format --bibliography=delphi.bib -t latex > delphi.tex
  xelatex delphi.tex
  bibtex delphi
```

### Templates

You'll need both a **Pandoc-specific** template and a **LaTeX-specific** template. The latter is usually up for grabs at your favorite conference/journal submission website. For instance, at ACM-sponsored conferences, your `.tex` file usually starts with:

```tex
\documentclass[sigconf]{acmart}
```

Meaning you'll need to have the file `acmart.cls` LaTeX class somewhere nearby. These files are automatically included in Overleaf after selecting the correct starting template. Right, nothing new here.

What is new, is the Pandoc template, called `acm-pandoc-conf.tex` in the above Makefile. This file adheres to Pandoc-specific syntax and allows you to fill in variables that are defined in the Frontmatter of Markdown files. The file will contain something like this:

```tex
\documentclass[sigconf,anonymous=$anonymous$]{acmart}

% use packages, acm-specific commands, etc

$if(title)$
  \title{$title$}
$endif$
$if(subtitle)$
  \subtitle{$subtitle$}
$endif$

\maketitle
\bibliographystyle{ACM-Reference-Format}

$body$


$if(bibliography)$
  \balance
  \bibliography{$bibliography$}
$endif$
\end{document}
\endinput
```

I published the full template as a [GitHub gist](https://gist.github.com/wgroeneveld/b6e2751c6da2a7bac73f668ddff5c3d0), in case anyone would like to reuse it. 

Now, every `$var` sign will be auto-replaced with the corresponding key in your `.md` file. For example:

```md
---
title: 'My Fancy Work'
date: '2019-07-16'
anonymous: "false"
author: 
    - name: Wouter Groeneveld
      institution: KU Leuven
      orcid: https://orcid.org/0000-0001-5099-7177
      city: Leuven
      country: Belgium
      email: wouter.groeneveld at university
    - name: Other Guy
output: pdf_document
abstract: "blah blah"
published: true
bibliography: "delphi"
tags: [Publishing]
panflute-filters: [scientific-twocolumn-tables]
panflute-path: '../../pandoc/filters'
---

# INTRODUCTION

Knowledge of software development is becoming more and more important, as shortcomings in the software engineering workforce require companies to come up with creative solutions such as coding boot-camps, to initiate candidates into the wonderful world of programming. However, to be successful as a developer, it no longer suffices to be technically proficient [@garousi2019closing]. There is still no agreement on what separates a great developer from a good one, even if both the academic and industrial world are starting to acknowledge the need for something more besides cognitive knowledge, however good this might be [@capretz2017soft]. 
Software is first and foremost created by people, for people, hinting on the need for so-called '_soft skills_', or, more generally, '_non-cognitive abilities_', defined as the subset of abilities not related to technical skills. 
```

This excerpt was taken from [my 2020 Delphi study](https://lirias.kuleuven.be/retrieve/549747/). Note the Section Header (`#`), easy way of citing (`[@key]`) and emphasizing terms (`_`). This gets compiled into the usual LaTex junk and you're off. You can make up as many variables as you'd like, and also loop through things like multiple authors - see the full gist for more details. 

### Post-processing

Did you notice the weird `panflute-filters` stuff? [Panflute](http://scorreia.com/software/panflute/), a Pandoc filter that makes Pandoc filters fun to write (according to the website), can be enabled with the `--filter panflute` flags after installing it as a Python 3 package. I use it to do the necessary post-processing on the generated Pandoc output - before it is made "final" as LaTex output. You can create custom hooks that lets you transform blocks, such as paragraphs, images, links, ... This comes in handy when your conference works with a double-column template. Pandoc is not so keen on those, and you sometimes want to convert a figure into a double-column one, or the other way around: `\begin{figure}` to `\begin{figure*}` or something similar. 

Of course, another way to do simple find and replace post-processing things is to just further transform the `.tex` output yourself using `sed` or whatever. This works, but is cumbersome, as sometimes you want to select specific blocks without resorting to artisan regular expressions that take hours to create. For something like **tables**, you'd write the following Markdown:

```md
blaaleft        blaright
----------   -----------
something              9
something             10

Table:  Demonstration of simple table syntax.
```

Pandoc by default generates something like this:

```tex
\begin{longtable}[]{@{}lr@{}}
\caption{Demonstration of simple table syntax.}\tabularnewline
\toprule
blaaleft & blaright\tabularnewline
\midrule
\endfirsthead
\toprule
blaaleft & blaright\tabularnewline
\midrule
\endhead
something & 9\tabularnewline
something & 10\tabularnewline
\bottomrule
\end{longtable}
```

With my filter, I managed to modify it to something like this:

```tex
\begin{table}[h!]
\centering
\caption{Demonstration of simple table syntax.\label{table:Demonstration_of_sim}}
\begin{tabular}{l r}
\hline
blaaleft & blaright\\ [0.5ex]
\hline
\hline
something & 9\tabularnewline
something & 10\tabularnewline
\hline\end{tabular}
\end{table}
```

Transforming the `longtable` into a `table` is simple enough, but this filter does more than that, as you can see. Passing in extra options as part of the `tabular` block is also possible. Inspect the full python file [in this GitHub gist](https://gist.github.com/wgroeneveld/9dbeb0d0b60c6cb5d8dfe9b938c5e94e) (yes it's a bit messy). A word of warning: Panflute's latest version is a bit experimental and might not be compatible with the latest Pandoc release. 

### Other nasty stuff

In essence, I try to remove as much markup-specific syntax as possible by letting the templates do their thing. Now and then, this is simply not possible, especially for complicated formulas or tables. If all else fails, it is still possible to combine both languages and embed LaTeX inside your Markdown file. Use this as your last resort. 

I also usually create a `preamble.tex` file that contains the necessary metadata for the conference, such as the ACM taxonomy, and a few extra TeX package includes. Furthermore, they're also handy when customizing standardized blocks, such as quotes in Markdown, prepended with `>`. The package `etoolbox` allows you to customize these using something like:

```tex
\AtBeginEnvironment{quote}{\begin{tcolorbox}[leftrule=2mm,bottomrule=0mm,toprule=0mm,rightrule=0mm,boxsep=0mm,grow to right by=-3mm, grow to left by=-3mm]\small}
\AtEndEnvironment{quote}{ \end{tcolorbox}}
```

Remember, the less clutter in your Markdown, the less strain for your eyes! I also know people who write most of their stuff in Markdown, convert it into TeX using Pandoc, and then copy over the compiled garbage into Overleaf to continue and chip away at it together with others. Of course, you can also simply check in your `.md` source files and use Git to collaborate, although without something like Overleaf, your CI server - and preferably also yourself - will have to install the required build toolchain.
