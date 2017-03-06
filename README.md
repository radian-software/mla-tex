# mla-tex

Typeset your [MLA] papers in [XeTeX].

## How to use

Here is a template:

    \documentclass{mla}

    \firstname{Joe}
    \lastname{Smith}
    \professor{Pedantic Professor}
    \class{MLA Writing 101}
    \date{} % omit to use current date

    \title{About Essay-Writing}

    \begin{document}
    \makeheader

    The main text of your essay goes here.

    \end{document}

## Options

Use [Tinos] instead of Times New Roman:

    \documentclass[tinos]{mla}

Justify your essay instead of leaving it left-aligned:

    \documentclass[justify]{mla}

## Tips

You will need to tell XeTeX where to find `mla.cls`. One way to do
this is to put this repository next to your `.tex` file and then

    $ export TEXINPUTS=.:./mla-tex:

If you use [AUCTeX], you can put this at the end of your `.tex` file
to tell Emacs to use XeTeX when you compile:

    % Local Variables:
    % TeX-engine: xetex
    % End:

[auctex]: https://www.gnu.org/software/auctex/
[mla]: https://owl.english.purdue.edu/owl/section/2/11/
[tinos]: https://www.fontsquirrel.com/fonts/tinos
[xetex]: http://xetex.sourceforge.net/
