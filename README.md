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

## Advanced usage

To cause a field to be omitted in the printed document, with not even
a placeholder, simply specify it as e.g. `\title{}` rather than
`\title{<text>}`.

You can replace the default header format with one more to your liking
by using the `header` and `centered` environments rather than the
`\makeheader` command. For example:

    \begin{header}
      ID Number
    \end{header}
    \begin{centered}
      The title
    \end{centered}

[mla]: https://owl.english.purdue.edu/owl/section/2/11/
[tinos]: https://www.fontsquirrel.com/fonts/tinos
[xetex]: http://xetex.sourceforge.net/
