# mla-tex

Typeset your [MLA] papers in [XeTeX].

## Getting started

First, download `mla.cls` and copy or symlink it into the same
directory as your `.tex` document.

Start with the following template:

    \documentclass{mla}

    \begin{document}
    \makeheader

    Your content goes here.

    \end{document}

Compile as follows, or however you prefer to compile XeTeX:

    $ latexmk -pdfxe -interaction=nonstopmode <document>.tex

You will notice a number of placeholders in the PDF, for example there
is `\firstname{?}` where your first name should be. To set your first
name, put in the preamble:

    \firstname{Joe}  % adjust name to taste

Similarly for `\lastname`, `\professor`, `\class`, and `\title`. By
default, the current date is used; you can substitute another one by
specifying `\date`.

## Works cited

Obtain bibliographic information in BibTeX format (you can download
this from any reputable library database) and place it into a `.bib`
file. Specify in the preamble `\addbibresource{<file>.bib}` to make
those sources available. In the main text, you can cite them by their
shortnames as `\cite{<name>}` or `\cite[<pagenum>]{<name>}`. Any cited
sources will automatically be placed in a works cited if you include
the command `\makeworkscited` at the end.

## Options

You can cause text to be justified rather than left-aligned by
providing the `[justify]` documentclass option.

You can use [Tinos] for the main font rather than Times New Roman by
providing the `[tinos]` documentclass option.

You can prevent the Works Cited from being placed on a new page by
providing the `[workscitedsamepage]` documentclass option.

You can put page numbers in the lower-right corner rather than the
upper-right corner by providing the `[lowerrightpagenumbers]`
documentclass option.

You can prevent the page number heading from being shown on the first
page by providing the `[nofirstpagenumber]` option.

## Outline

An bulleted outline can be created with the outline environment. The bulleting style follows the format documented [here](https://libguides.liberty.edu/c.php?g=564129&p=4781213). The outline supports an indent level of three.

### Examples

#### Basic Usage
```
\begin{outline}
  \begin{enumerate}
    \item Hello world!
  \end{enumerate}
\end{outline}
```


#### Full Outline
```
\documentclass{mla}

% Header
\firstname{First}
\lastname{Last}
\professor{Dr. Example}
\class{EX 101}
\title{Using mla-tex to create an outline}

\begin{document}
\makeheader
Thesis: Lorem ipsum

  \begin{outline}
    \begin{enumerate}
      \item Item 1
      \item Item 2
        \begin{enumerate}
          \item Item 3
          \item Item 4
            \begin{enumerate}
              \item Item 5
              \item Item 6
            \end{enumerate}
        \end{enumerate}
    \end{enumerate}
  \end{outline}
\end{document}
```

## Advanced usage

To cause a field to be omitted in the printed document, with not even
a placeholder, simply specify it as e.g. `\title{}` rather than
`\title{<text>}`.

To substitute the value of e.g. your last name which you passed to
`\lastname`, use the expression `\get{lastname}`. This may be useful
if you want to use a custom header, as below, but still need to set
`\lastname` for the page number formatting. To get the current date in
MLA format, use `\today{}`.

You can replace the default header format with one more to your liking
by using the `header` and `centered` environments rather than the
`\makeheader` command. For example:

    \begin{header}
      ID Number
    \end{header}
    \begin{centered}
      The title
    \end{centered}

# Contributor guide

When adding a new feature, you should document it in the README. Any
user-visible change should also be noted in the changelog. I have some
information on how to write a changelog in [the contributor guide for
my projects](https://github.com/raxod502/contributor-guide).

[mla]: https://owl.english.purdue.edu/owl/section/2/11/
[tinos]: https://www.fontsquirrel.com/fonts/tinos
[xetex]: http://xetex.sourceforge.net/
