%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Preamble

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mla}

%% article uses 10pt by default.
\LoadClass[12pt]{article}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Options

%% Option [justify]: use justified text instead of left-aligned.
\newif\if@justify\@justifyfalse
\DeclareOption{justify}{
  \@justifytrue
}

%% Option [tinos]: use Tinos instead of Times New Roman.
\newif\if@tinos\@tinosfalse
\DeclareOption{tinos}{
  \@tinostrue
}

\ProcessOptions\relax

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Page layout

%% MLA requires 8.5x11 (letterpaper) and 1in margins on all sides.
\usepackage[letterpaper]{geometry}
\geometry{
  top=1.0in,
  bottom=1.0in,
  left=1.0in,
  right=1.0in
}

%% Package fancyhdr allows customizing the headers and footers.
%% Setting the pagestyle is required for the customized
%% headers/footers to be used. \fancyhf{} removes the default contents
%% of the headers and footers, leaving them blank.
\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}

%% Put the author's last name and the page number in the
%% upper-right-hand corner.
\rhead{\@lastname~\thepage}

%% Remove the horizontal rule that is usually displayed just below the
%% page header.
\renewcommand{\headrulewidth}{0pt}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Font

%% Set the appropriate font (Tinos or Times New Roman).
\usepackage{fontspec}
\if@tinos
\setmainfont{Tinos}
\else
\setmainfont{Times New Roman}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Text formatting

%% Smarter quotes.
\usepackage{csquotes}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Spacing

%% Unless justification is requested, use package ragged2e to inhibit
%% it. Note that vanilla \raggedright screws up paragraph indents.
\if@justify\else
\usepackage{ragged2e}
\setlength\RaggedRightParindent\parindent
\RaggedRight
\fi

%% MLA requires exactly 0.5in paragraph indents.
\setlength{\parindent}{0.5in}

%% Make a new version of the {center} environment that doesn't add
%% extra spacing.
\newenvironment
{tightcenter}
{\parskip=0pt\par\nopagebreak\centering}
{\par\noindent\ignorespacesafterend}

%% Everyone loves double-spacing.
\usepackage{setspace}
\linespread{2}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Header

\def\@firstname{}
\newcommand{\firstname}[1]{
  \def\@firstname{#1}
}

\def\@lastname{}
\newcommand{\lastname}[1]{
  \def\@lastname{#1}
}

\newcommand{\professor}[1]{
  \def\@professor{#1}
}

\newcommand{\class}[1]{
  \def\@class{#1}
}

%% Make an MLA date format just in case we need to generate and
%% typeset the current date (if \date{...} is not provided by the
%% user).
\usepackage{datetime}
\newdateformat{datef}{\THEDAY~\monthname[\THEMONTH] \THEYEAR}

\newcommand*{\makeheader}{\begingroup
  \rmfamily
  \fontsize{12}{2}
  \noindent \@firstname~\@lastname \\
  \noindent \@professor            \\
  \noindent \@class                \\
  \noindent \datef\@date
  \maketitle
  \endgroup}

\renewcommand{\maketitle}{\begingroup
  \begin{tightcenter}
    \@title
  \end{tightcenter}
  \endgroup}

\newcommand*{\makeworkscited}{\begingroup
  \pagebreak
  \begin{tightcenter}
    Works Cited
  \end{tightcenter}
  \printbibliography[heading=apa]
  \endgroup}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Sectioning commands

\renewcommand   \thesection{\@arabic\c@section.}
\renewcommand\thesubsection{\thesection\@arabic\c@subsection}
\renewcommand      \section{\@startsection
  {section}
  {1}
  {\z@}%
  {\z@}%
  {\lineskip}%
  {\normalfont}}
\renewcommand   \subsection{\@startsection
  {subsection}
  {2}
  {\z@}%
  {\z@}%
  {\lineskip}%
  {\normalfont}}
\renewcommand\subsubsection{\@startsection
  {subsubsection}
  {3}
  {\z@}%
  {\z@}%
  {\lineskip}%
  {\normalfont}}
\renewcommand    \paragraph{\@startsection
  {paragraph}
  {4}
  {\z@}%
  {\z@}%
  {\lineskip}%
  {\normalfont}}
\renewcommand \subparagraph{\@startsection
  {subparagraph}
  {5}
  {\parindent}%
  {\z@}%
  {\lineskip}%
  {\normalfont}}

%% Formatting section headings
\def\section{\@startsection{section}{1}{\z@}{-5.25ex plus -1ex minus
-.2ex}{1.5ex plus .2ex}{\center}}
\def\thesection{\arabic{section}.}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Works cited

\usepackage[style=mla,mladraft=true,annotation=true]{biblatex}

\newcommand{\sources}[1]{
  \def\@sources{#1}
  \bibliography{#1}
}

%% Bibliography commands
\DeclareFieldFormat{ibidpostnote}{#1}%
\newbibmacro*{cite:idem}{%
  \ifsingletitle%
  {\iffieldundef{postnote}%
    {\usebibmacro{cite:name}}%
    {\unspace\global\boolfalse{cbx@named}}}%
  {\addspace\global\boolfalse{cbx@named}}}
\newbibmacro*{cite:mla:title:internal}{% 0.7.1 new internal macro
  \ifbool{cbx@named}%
  {\unspace\addcomma\addspace}%
  {}%
  \iffieldundef{title}%
  {\iffieldequalstr{entrytype}{review}%
    {\printtext[bibhyperref]{\printtext{\bibstring{reviewof}%
          \addspace\printfield{booktitle}}}}%
    {\ifthenelse{\iffieldequalstr{entrytype}{suppbook}% 0.7.1
        \OR\iffieldequalstr{entrytype}{suppcollection}}%
      {\printtext[bibhyperref]{%
          \printfield[mla:capital]{entrysubtype}}}%
      {}}}%
  {\printtext[bibhyperref]{%
      \printfield[citetitle:\strfield{entrytype}]{labeltitle}}}}%
\newbibmacro*{cite:mla:title}{% 0.7.1 tidied up
  \unspace%
  \ifnameundef{labelname}%
  {\unspace%
    \printtext[bibhyperref]{%
      \printfield[citetitle:\strfield{entrytype}]{labeltitle}}%
    \iffieldundef{postnote}%
    {}%
    {\addspace}}%
  {\ifsingletitle%
    {}%
    {\usebibmacro{cite:mla:title:internal}\addspace}}%
  \ifthenelse{\iffieldequalstr{entrytype}{review}%
    \and\ifnameundef{author}%
    \and\iffieldundef{title}}%
  {\printtext[bibhyperref]%
    {\unspace\printtext{\bibcpstring{reviewof}%
        \addspace\printfield{booktitle}}}}%
  {}}%
\DeclareCiteCommand{\cite}[\mkbibparens]
{\usebibmacro{prenote}}%
{\usebibmacro{citeindex}%
  \usebibmacro{cite:mla}}{}
{\usebibmacro{postnote}}
\defbibheading{apa}[\refname]{}

%% Annotations for the bibliography
\renewbibmacro{finentry}{% Renew the annotation macro
  \finentry
  \iffieldundef{annotation}%
  {}%
  {\ifbool{bbx@annotation}%
    % Make the annotation look like a quotation and remove the
    % indent
    {\begin{quotation}\noindent%
        \printfield{annotation}%
      \end{quotation}}%
    {}}%
}
