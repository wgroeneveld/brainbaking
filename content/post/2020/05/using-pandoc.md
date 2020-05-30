---
title: "Using Pandoc to publish a book"
date: '2020-05-01'
subtitle: "Successfully combining writing and LaTeX skills"
aliases:
  - /post/using-pandoc/
tags:
  - publishing
  - book
  - pandoc
  - markdown
  - latex
published: true
---

So, [I wrote a book](https://redzuurdesem.be/het-boek/) about bread baking. 

And it did not happen overnight. I started working on the idea in 2017, but was using Google Docs at that time, which frustrated more than it was a joy to work with. GDocs and Word-like processors harass me too much with menu bars, toolbars, collaboration tools, backup capabilities, and so forth - while all I want to do is simply write. In 2018, I rebooted my writing attempt and resorted to my favorite text-editor: Sublime Text. 

To focus on the writing itself, and not the layout and whatnot, I decided to write in Markdown. In a non-fiction book, such as the one I was planning to write, it is important not to overburden readers with flashy layouting - so Markdown's minimalistic approach helped a lot here: underscores to _emphasize_ things is mostly enough. 

![subl](/img/book/makingof-schrijven.png)

### The toolchain

My aim was to publish a physical version of a book, similar to my favorite opinionated books about cooking and baking such as David Pollan's and Michael Booth's work. My publisher expects a `.pdf` file, so naturally compiling from simple text (`.md`) to `.pdf` is in order - and something Pandoc is really good at. I wanted to minimize the amount of LaTex I had to write myself, but for layouting purposes, a big preamble file would probably be unavoidable. 

The setup:

{{<mermaid>}}
graph LR;
    md[Plaintext, md =]
    tex[LaTeX, tex =]
    pdf[Postscript, pdf =]
    md --> tex
    tex --> pdf
{{< /mermaid >}}

For LaTeX compilation, `xetex` instead of `pdflatex` was employed, as my experience taught me the first one is more flexible when it comes to typesetting and such. My Makefile jumpstart command looks like this:

```make
  pandoc -f markdown \
    -V documentclass=memoir -V lang=nl-BE -M lang:nl \
    --include-in-header=preamble.tex \
    --include-before-body=coversheet.tex \
    --include-after-body=afterbody.tex \
    --pdf-engine=xelatex \
    --filter pandoc-citeproc \
    --filter filters/fancybreak.py \
    --top-level-division=part \
    --metadata-file=metadata.yml \
    --highlight-style=haddock \
    -t latex+smart > book.tex \
    chap1.pd.md chap2.pd.md chap3.pd.md ... \
  xelatex book.tex
```

As you can see from the above command, `memoir` was used, and the 500+ pages manual was thoroughly read to learn about obscure layouting commands that eventually allowed me to position everything exactly as I wanted it to be. However, it took a week of trail and error before reaching that point of satisfaction... 

Memoir is an extremely flexible and complete package: it comes with chapter styles, header and footer styles, special stuff for your table/figure/... lists, and so forth. Most packages you'd use in conjunction with the `article` document class become obsolete - as long as you adhere to memoir's rules! 

### The 'cover sheet' pages

The first three pages of the book are the cover pages, and they are set:

1. Title only (plain)
2. Empty page
3. Title, author, and publisher (fancier)

An optional fourth page, which I included, contains the copyright, edition information, and so forth. Everything is part of `\frontmatter`, and written in LaTex itself. I got inspired by some examples provided by the memoir fellows:

![subl](/img/book/book-coversheet.png)

The style is called 'Gentle Madness'. I had no intention of pouring hours into making my own original version of something that was already good enough: it's part of the cover pages... You know, the things you flip through, in search for the actual content?

### Chapter style and font

As said before, memoir comes with 'batteries included' - and that is definitely the case for chapter styles. I opted for a minimalistic chapter number and a title - that's it:

![subl](/img/book/book-chapter.png)

The tex needed to do that:

```tex
\makeatletter
\providecommand{\subtitle}[1]{
  \apptocmd{\@title}{\par {\large #1 \par}}{}{}
}
\makeatother

\chapterstyle{dash}\renewcommand*{\chaptitlefont}{\normalfont\itshape\LARGE}
\setlength{\beforechapskip}{2\onelineskip}
\setsecheadstyle{\normalfont\Large\raggedright}
```

The quote below the chapter title is a Markdown quote, using simply '>' to start the sentence. It did bug me that I had to write a bit of latex to align it properly, though. I'm sure this could be fixed with another Python filter, but by then most of my chapter files were already created. The above screenshot is the result of the following piece of Markdown:

```md
## Het begint allemaal met een kabouter

\label{kabouter}

> '_Eat (good) food. Mostly plants. Not too much._' - \mbox{Michael} Pollan, In Defense of Food

### Dagelijks brood met een druk op de knop

\begin{flushright}
Augustus 2010
\end{flushright}

'Het kaboutertje is weer bezig' glimlachte mijn vrouw, toen ze opkeek van haar boek. Dat leek haar wel een gepaste manier om het plotse achtergrondlawaai te identificeren. Deze mini-mens wordt verkocht inclusief huisje: een 
```

I tried to separate content from latex as much as possible, but failed when it came to labeling, quote alignment, and some mbox instances. Now that I look back, these can be left out with extra `\hyphenation{}` rules in the preamble.

### Footnotes, footers, and citing work

Inspired by other books, I really wanted to go for extensive use of footnotes throughout the book - and not have a silly numbering style that will mess with my idea of superscript numbering to cite other work. That said, footnote symbols usually **do not** reset each page, but each chapter, resulting in a lot of compile errors because I reached the end of the line fairly quickly. 

Enter the `perpage` package, where footnote numbering can be tampered with, without clashing with the memoir class:

```tex
\usepackage{perpage}
\MakePerPage{footnote}
\renewcommand*{\thefootnote}{\fnsymbol{footnote}}
```

The end result looks like this:

![footnotes](/img/book/book-footnotes.png)

For the header and footer, I wanted to maximize the available space on a page. That means only one of both, so no header. It is important to distinguish footer text from chapter text, so I opted to reduce the harshness of the text by using gray and another font type. It can be configured as a separate chapter style, that should distinctively **not** be applied to 'part x' pages:

```tex
\makepagestyle{desem}
\createmark{chapter}{left}{nonumber}{}{}  % remove 'chapter x:' from \leftmark
\makeevenfoot{desem}{\textsf{\textcolor{lightgray}{\footnotesize \textbf{\thepage} \: | \: RED ZUURDESEM}}}{}{} 
\makeoddfoot{desem}{}{}{\textsf{\textcolor{lightgray}{\footnotesize \leftmark \: | \: \textbf{\thepage}}}}
\copypagestyle{plain}{desem}
\copypagestyle{part}{empty}
\AtBeginDocument{\addtocontents{toc}{\protect\thispagestyle{empty}}} 
```

For citing work, the rough draft employed a dusty academic way (the default way) of doing that: author and year between brackets: 'in research blabla bla (Surname, 2019).' It gave me a headache: it does _not_ read fluently at all. the '\[10\]' thing at the end of a sentence was not that great either. It is non-fiction, but it should not be a boring piece of academic work! In the end, I opted for superscript with a reduced font size:

![cite](/img/book/book-cite.png)

I found that citation style in [zotero.org/styles](https://www.zotero.org/styles and https://citationstyles.org/authors/), it's called `the-open-university-numeric-superscript.csl` and added as a parameter in the metadata YML file for pandoc to parse. As you can see from the pandoc command, the `pandoc-citeproc` filter was used - it worked well enough and meant not manually fiddling with bibliography tools.


### Figures and lists

The problem with using LaTeX and the memoir style is that most of the default settings feel a bit too rigid - too academic. I tried shaving off that word 'academic' as much as possible. For lists, this meant reducing it's complexity to simply a pointer to the page instead of numbering them individually:

![figure](/img/book/book-figures.png)

After a lot of stackoverflow hints, I managed to nail it down to:

```tex
\makeatletter
\renewcommand{\cftfigurepresnum}{\begin{lrbox}{\@tempboxa}}
\renewcommand{\cftfigureaftersnum}{\end{lrbox}}
\renewcommand{\cfttablepresnum}{\begin{lrbox}{\@tempboxa}}
\renewcommand{\cfttableaftersnum}{\end{lrbox}}
\makeatother
\setlength{\cftfigurenumwidth}{0pt}
\setlength{\cfttablenumwidth}{0pt}
```

Of course, for figures themselves, more work was needed: I was not particularly keen on having something like 'Figure x.y: caption'. Let's get rid of that figure caption (thanks to [http://www.peteryu.ca/tutorials/publishing/latex_captions](http://www.peteryu.ca/tutorials/publishing/latex_captions)):

```tex
\usepackage[skip=4pt,font=small]{caption}
\captionsetup[figure]{labelformat=empty, labelsep=colon, labelfont=bf, textfont={it}}
\captionsetup[table]{labelformat=empty, labelsep=colon, labelfont=bf, textfont={it}}
\renewcommand{\thefigure}{\thechapter.\Alph{figure}} 
\renewcommand{\thetable}{\thechapter.\Alph{figure}}
```

For 'default' inline figures, that works. However, some figures I wanted spread out onto the page extending beyond the typical type block width. A custom LaTeX command, that takes into account different odd and even page widths, called `\centerimg` did the trick:

```tex
\usepackage{wrapfig}    % inline l/r
\usepackage{calc}   % for adjustimg cmd calculations
\usepackage{changepage} % full-page 
\newcommand{\adjustimg}{% Horizontal adjustment of image
  \checkoddpage%
  \ifoddpage\hspace*{\dimexpr\evensidemargin-\oddsidemargin}\else\hspace*{-\dimexpr\evensidemargin-\oddsidemargin}\fi%
}
\newcommand{\centerimg}[2][width=\textwidth]{% Center an image
  \makebox[\textwidth]{\adjustimg\includegraphics[#1]{#2}}%
}
```

The end result:

![img](/img/book/book-image.png)

Sadly, to make use of the new LaTeX command, I had to interleave it with the rest of the text in my Markdown chapter file. The above screenshot is the result of this:

```md
deeld als voorbereiding op de bulkrijs. Een professionele bakker kan zich de langdurige bezetting van een machine meestal niet veroorloven. 

\begin{figure}
    \mbox{} \par
    \noindent\centerimg[width=\paperwidth]{img/bw/deeg.jpg}
    \caption[Gerezen brooddeeg op een linnen doek.]{Stilte! Hier slaapt - euh, rijst - brood.}
\end{figure}

Het is een mythe dat bakken exacte hoeveelheden vereist, ook al is patisserie hier uiteraard gevoeliger aan dan brood. 
```

I never found a way around this - even for inline figures - as the default image include for Markdown does not give me the opportunity to provide two captions: one for the image, and one shorter version for the text in the table of figures. 

### Page Layout

This is where most of the swearing happened. My book format is `135x215mm` - and getting that right was a bit of a pain, especially since my publisher required a few millimeters of spacing as the printing and cutting process of pages needs that. I ended up increasing the stock size to take this extra spacing into account (3 and 6mm, respectively):

```tex
\setstocksize{221mm}{138mm}
\settrimmedsize{215mm}{135mm}{*}
\settrims{0mm}{0mm}
\settypeblocksize{180mm}{100mm}{*}

\setlrmargins{*}{17mm}{*}
\setulmargins{*}{20mm}{*}

\setheadfoot{\baselineskip}{2\baselineskip}
\setheaderspaces{0.5in}{*}{*}

\checkandfixthelayout
```

The trimmed size is set to zero, as it's included in the stock size. I wanted `18mm` of text height: the header is gone so we could increase this a little bit, compared to other books of similar size. For the margins, the spine gets the most, and it's auto-calculated (`{*}`). 

### Other encountered problems

#### Hyphenation rules for Dutch

In the Dutch language, when a word is split because of hyphenation rules in LaTeX (that is handled by setting the Pandoc language, by the way), the diaeresis is removed from words such as 'industriële'. This [stackoverflow link](https://tex.stackexchange.com/questions/106737/how-to-remove-diaeresis-after-hyphen) provided the solution, but I had to use the complicated one for Xetex to work nicely. Some words, I 'hyphened' manually in the preamble, by adding `\hyphenation{korst-rand}`.

#### Spacing between paragraphs

Spaces between big sections of text, which are still part of the same chapter, can be achieved with `* * *` in Markdown using a simple Python filter. However, when that spacing hits the end of the page, readers have no idea whether or not a section was finished. You can use `\fancybreak{}` for that, but then the whole text would be filled with fancy symbols that take away the reading experience. It only should be displayed at the top or bottom of the page, if spacing is not possible. 

I found the solution to the problem on another blog and can't remember which one, but this piece of tex fixes it:

```tex
\newcommand{\starbreak}{%
    \fancybreak{* * *}%
}
\DeclareRobustCommand{\cs}[1]{\texttt{\char`\\#1}}
\newlength{\tpheight}\setlength{\tpheight}{0.9\textheight}
\newlength{\txtheight}\setlength{\txtheight}{0.9\tpheight}
\newlength{\tpwidth}\setlength{\tpwidth}{0.9\textwidth}
\newlength{\txtwidth}\setlength{\txtwidth}{0.9\tpwidth}
\newlength{\drop}
```

The end result, at the bottom of the page:

![starbreak](/img/book/book-starbreak.png)

### The verdict

Would I employ this toolchain again when writing the next book? Without a doubt. I am very happy with the end result and managed to guide Pandoc and memoir to render it just the way I want, something that would be difficult to achieve in Word without resorting to a shotgun (to either shoot at the Word devs, or at myself). It was a very good learning experience, which included the necessary swearing. 

At least I won't have to start from scratch next time!

