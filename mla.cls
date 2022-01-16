%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Preamble

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mla}[2019/10/01 MLA v1.2-dev]

%% article uses 10pt by default.
\LoadClass[12pt]{article}
\RequirePackage{iftex}

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

%% Option [workscitedsamepage]: do not place the Works Cited on a new
%% page.
\newif\if@workscitedclearpage\@workscitedclearpagetrue
\DeclareOption{workscitedsamepage}{
  \@workscitedclearpagefalse
}

%% Option [lowerrightpagenumbers]: put page numbers in the lower right
%% rather than the upper right.
\newif\if@lowerrightpagenumbers\@lowerrightpagenumbersfalse
\DeclareOption{lowerrightpagenumbers}{
  \@lowerrightpagenumberstrue
}

%% Option [nofirstpagenumber]: don't display a page number in the
%% upper right corner.
\newif\if@nofirstpagenumber\@nofirstpagenumberfalse
\DeclareOption{nofirstpagenumber}{
  \@nofirstpagenumbertrue
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

% https://tex.stackexchange.com/q/528358
\setlength\headheight{15pt}

%% Put the author's last name and the page number in the
%% upper-right-hand corner.
\if@lowerrightpagenumbers
\rfoot{\ifno{lastname}{\thepage}{\get{lastname}~\thepage}}
\else
\rhead{\ifno{lastname}{\thepage}{\get{lastname}~\thepage}}
\fi

\if@nofirstpagenumber
\fancypagestyle{blank}{
  \fancyhf{}
}
\thispagestyle{blank}
\fi

%% Remove the horizontal rule that is usually displayed just below the
%% page header.
\renewcommand*{\headrulewidth}{0pt}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Font

%% Set the appropriate font (Tinos or Times New Roman).
% Load New TX if not using OpenType-compatible engine
\iftutex
  \usepackage{fontspec}
  \if@tinos
  \setmainfont{Tinos}
  \else
  \setmainfont{Times New Roman}
  \fi
\else
  \RequirePackage[T1]{fontenc}
  \RequirePackage{newtxtext}
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

%% MLA also says that every paragraph should be indented, including
%% the first paragraph of a section.
\usepackage{indentfirst}

%% Make a new version of the {center} environment that doesn't add
%% extra spacing.
\newenvironment
{centered}
{\parskip=0pt\par\par\nopagebreak\centering}
{\par\noindent\ignorespacesafterend}

%% Everyone loves double-spacing.
\usepackage{setspace}
\setstretch{2}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Header

%% Mutable field management. The declaration \newfield{foo} will
%% generate a command \foo{...} that can be used to set the value of
%% field foo. You can then insert the value with \get{foo}, and unset
%% it back to the default, which is the literal text \foo{?}, using
%% \unset{foo}. There is also \ifno{foo}{A}{B}, which expands to A if
%% foo is unset, and expands to B otherwise. If command \foo{...} is
%% already defined, you can allow redefining it with \renewfield{foo}.
\newcommand*{\newfield}[1]{%
  \unset{#1}%
  \expandafter\newcommand\csname #1\endcsname[1]{%
    \expandafter\def\csname value#1\endcsname{##1}}%
}
\newcommand*{\renewfield}[1]{%
  \unset{#1}%
  \expandafter\renewcommand\csname #1\endcsname[1]{%
    \expandafter\def\csname value#1\endcsname{##1}}%
}
\newcommand*{\get}[1]{\csname value#1\endcsname}
\newcommand{\ifno}[3]{%
  \expandafter\ifdefempty\csname value#1\endcsname{#2}{#3}%
}
\newcommand*{\unset}[1]{%
  \expandafter\def\csname value#1\endcsname{\textbackslash #1\{?\}}%
}

%% Fields used in header.
\newfield{firstname}
\newfield{lastname}
\newfield{professor}
\newfield{class}
\renewfield{date}
\renewfield{title}

%% Default values.
\date{\today}

%% Make an MLA date format in order to handle the above default date
%% value.
\usepackage[calc]{datetime2}
\DTMnewdatestyle{mladate}{%
  \renewcommand{\DTMdisplaydate}[4]{##3 \DTMmonthname{##2} ##1}
  \renewcommand{\DTMDisplaydate}{\DTMdisplaydate}}
\DTMsetdatestyle{mladate}

%% Define a general command for inserting MLA-style headers.
\newenvironment{header}{
  \begingroup%
  \rmfamily%
  \fontsize{12}{2}%
  \setlength{\parindent}{0pt}
}{%
  \endgroup%
}

%% And a convenience function for the most common case.
\newcommand*{\makeheader}{%
  \begin{header}
    \ifno{firstname}{
      \ifno{lastname}{}{
        \get{lastname} \par
      }
    }{
      \ifno{lastname}{
        \get{firstname} \par
      }{
        \get{firstname}~\get{lastname} \par
      }
    }
    \ifno{professor}{}{
      \get{professor} \par
    }
    \ifno{class}{}{
      \get{class} \par
    }
    \ifno{date}{}{
      \get{date} \par
    }
  \end{header}%
  \begin{centered}
    \get{title}
  \end{centered}%
}

\newcommand*{\makeworkscited}{%
  \if@workscitedclearpage%
  \pagebreak%
  \fi%
  \printbibliography}

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

%% Use American-style quotation marks.
\usepackage[american]{babel}

%% Hyperlink bibliography entries.
\usepackage[hidelinks]{hyperref}

%% Package doing all of our bibliography stuff.
\usepackage[style=mla,mladraft=true,annotation=true]{biblatex}

%% Bibliography commands
\DeclareFieldFormat{ibidpostnote}{#1}%
\renewbibmacro*{cite:idem}{%
  \ifsingletitle%
  {\iffieldundef{postnote}%
    {\usebibmacro{cite:name}}%
    {\unspace\global\boolfalse{cbx@named}}}%
  {\addspace\global\boolfalse{cbx@named}}}
\renewbibmacro*{cite:mla:title:internal}{% 0.7.1 new internal macro
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
\renewbibmacro*{cite:mla:title}{% 0.7.1 tidied up
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

\newenvironment{outline}
{
    \renewcommand{\labelenumi}{\Roman{enumi}.}
    \renewcommand{\labelenumii}{\Alph{enumii}.}
    \renewcommand{\labelenumiii}{\arabic{enumiii}.}
}{}
