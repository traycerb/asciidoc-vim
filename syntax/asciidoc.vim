" Vim syntax file
" Language: Asciidoc text document
" Maintainer: Dag Wieers <dag@wieers.com> (merged wih Stuart Rackham's
"             upstream asciidoc.vim script).
" URL: http://www.methods.co.nz/asciidoc/
" License: GPL (http://www.gnu.org)
" Remarks: Vim 6 or greater
" Limitations: See 'Appendix E: Vim Syntax Highlighter' in the AsciiDoc 'User
"               Guide'.
" Last Change: $Date: 2007/07/18 16:11:12 $
" $Revision$

if exists("b:current_syntax")
  finish
endif

syn clear
syn sync fromstart
syn sync linebreaks=1

" Run :help syn-priority to review syntax matching priority.
syn keyword asciidocToDo TODO FIXME CHECK TEST XXX ZZZ DEPRECATED contained
syn match asciidocBackslash /\\/

"ID marker for revision info in header.  $Id: text $
syn region asciidocIdMarker start=/^\$Id:\s/ end=/\s\$$/

"\\ \@<! -> can't lead with '\'
"<\d\{1,2}> '<' Number (1 or 2) '>'
"Only within literal block '....'
syn match asciidocCallout /\\\@<!<\d\{1,2}>/

syn match asciidocListBlockDelimiter /^--$/
syn match asciidocLineBreak /[ \t]+$/
syn match asciidocRuler /^'\{3,}$/
syn match asciidocPagebreak /^<\{3,}$/
syn match asciidocEntityRef /\\\@<!&[#a-zA-Z]\S\{-};/
" FIXME: The tricky part is not triggering on indented list items that are also
" preceeded by blank line, handles only bulleted items (see 'Limitations' above
" for workarounds).
"syn region asciidocLiteralParagraph start="^\n[ \t]\+\(\([^-*. \t] \)\|\(\S\S\)\)" end="\(^+\?\s*$\)\@="
syn region asciidocLiteralParagraph start=/^\s\+\S\+/ end=/\(^+\?\s*$\)\@=/
syn match asciidocURL /\\\@<!\<\(http\|https\|ftp\|file\|irc\):\/\/[^| \t]*\(\w\|\/\)/
syn match asciidocEmail /[\\.:]\@<!\(\<\|<\)\w\(\w\|[.-]\)*@\(\w\|[.-]\)*\w>\?[0-9A-Za-z_]\@!/
syn match asciidocAttributeRef /\\\@<!{\w\(\w\|-\)*\([=!@#$%?:].*\)\?}/


" As a damage control measure quoted patterns always terminate at a blank
" line (see 'Limitations' above).
syn match asciidocQuotedSubscript /\\\@<!\~\(\~\+$\)\@!\S\_.\{-}\(\~\|\n\s*\n\)/

"\\ \@<! -> zero width assertion NO literal '\'
"\^ \S \_.\{-}  -> literal '^', (any non Whitespace), any char + EOL (zero or
"more, non greedy)
"End with:
"\(
"    \^  or -> literal '^' or 2 newlines with optional whitespace inbetween
"        or \n\s*\n
"\)
"\(\^\+$\)\@!  -> zero width which matches if there are NOT only '^' signs
"until the end of the line.
syn match asciidocQuotedSuperscript /\\\@<!\^\(\^\+$\)\@!\S\_.\{-}\(\^\|\n\s*\n\)/

"zero width assertion match if following is present:
" ^ or
"   or | \t ( or
"             or . , = - ]
"+ -> literal plus
"zero width none of the following: [, <space>, ), \n, \t, ]
"zero or more (non-greedy) of the following
" . or
"   or \n but not followed by \s* \n
"\S -> non-whitespace
"+ -> literal plus
"zero width assertion match if following is present:
"| \t) or one of
"      or one of ],.?!;:=- or
"                          or $
"\)

"\(
"    ^\|[| \t([.,=\-\]]
"\) \@<=
"+
"\(
"    [ )\n\t]
"\) \@!
"\(
"    . \| \n
"    \(
"       \s* \n
"    \) \@!
"\) \{-}
"\S
"\(
"    +
"    \(
"        [| \t)[\],.?!;:=\-]\|$
"    \)
"    \@=
"\)
"
"For Quoted Monospaced demarcated by '+'
syn match asciidocQuotedMonospaced /\(^\|[| \t([.,=\-\]]\)\@<=+\(+\+$\)\@!\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(+\([| \t)[\],.?!;:=\-]\|$\)\@=\)/
"For Quoted Monospaced demarcated by '`'
syn match asciidocQuotedMonospaced /\(^\|[| \t([.,=\-\]]\)\@<=`\(`\+$\)\@!\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(`\([| \t)[\],.?!;:=\-]\|$\)\@=\)/

"[\\+] \@<! > can't start with a literal blackslash and '+'
"++ \S -> '+'x2 and a non-whitespace character
"\_. \{-} -> Any single character or end-of-line, zero or more, non-greedy
"\( ++ \| \n \s* \n \) end with either '+' x2 or a newline and zero or more white
"space, and another newline)
"
"\(+\+$\)\@!  -> zero width which matches if there are NOT only '+' signs
"until the end of the line.
"
"syn match asciidocQuotedUnconstrainedMonospaced
"/[\\+]\@<!++\S\_.\{-}\(++\|\n\s*\n\)/

syn match asciidocQuotedUnconstrainedMonospaced /[\\+]\@<!++\(+\+$\)\@!\S\_.\{-}\(++\|\n\s*\n\)/

syn match asciidocQuotedEmphasized /\(^\|[| \t([.,=\-\]]\)\@<=_\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(_\([| \t)[\],.?!;:=\-]\|$\)\@=\)/
syn match asciidocQuotedEmphasized /\(^\|[| \t([.,=\-\]]\)\@<='\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\('\([| \t)[\],.?!;:=\-]\|$\)\@=\)/
syn match asciidocQuotedUnconstrainedEmphasized /\\\@<!__\S\_.\{-}\(__\|\n\s*\n\)/

syn match asciidocQuotedBold /\(^\|[| \t([.,=\-\]]\)\@<=\*\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(\*\([| \t)[\],.?!;:=\-]\|$\)\@=\)/
syn match asciidocQuotedUnconstrainedBold /\\\@<!\*\*\S\_.\{-}\(\*\*\|\n\s*\n\)/

" Don't allow ` in single quoted (a kludge to stop confusion with `monospaced`).
syn match asciidocQuotedSingleQuoted /\(^\|[| \t([.,=\-]\)\@<=`\([ )\n\t]\)\@!\([^`]\|\n\(\s*\n\)\@!\)\{-}[^` \t]\('\([| \t)[\],.?!;:=\-]\|$\)\@=\)/

syn match asciidocQuotedDoubleQuoted /\(^\|[| \t([.,=\-]\)\@<=``\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(''\([| \t)[\],.?!;:=\-]\|$\)\@=\)/

syn match asciidocDoubleDollarPassthrough /\\\@<!\(^\|[^0-9a-zA-Z$]\)\@<=\$\$..\{-}\(\$\$\([^0-9a-zA-Z$]\|$\)\@=\|^$\)/
syn match asciidocTriplePlusPassthrough /\\\@<!\(^\|[^0-9a-zA-Z$]\)\@<=+++..\{-}\(+++\([^0-9a-zA-Z$]\|$\)\@=\|^$\)/

syn region asciidocTable_OLD start=/^\([`.']\d*[-~_]*\)\+[-~_]\+\d*$/ end=/^$/
syn match asciidocBlockTitle /^\.[^. \t].*[^-~_]$/ contains=asciidocQuoted.*,asciidocAttributeRef
syn match asciidocTitleUnderline /[-=~^+]\{2,}$/ transparent contained contains=NONE
syn match asciidocOneLineTitle /^=\{1,5}\s\+\S.*$/ contains=asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash
syn match asciidocTwoLineTitle /^[^. +/].*[^.]\n[-=~^+]\{2,}$/ contains=asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash,asciidocTitleUnderline

syn match asciidocAttributeList /^\[[^[ \t].*\]$/
syn match asciidocQuoteBlockDelimiter /^_\{4,}$/
syn match asciidocExampleBlockDelimiter /^=\{4,}$/
syn match asciidocSidebarDelimiter /^*\{4,}$/

syn match asciidocAdmonitionNote /^\(NOTE\|TIP\):\(\s\+.*\)\@=/
syn match asciidocAdmonitionNote /^\[\(NOTE\|TIP\)\]\s*$/
syn match asciidocAdmonitionWarn /^\(CAUTION\|IMPORTANT\|WARNING\):\(\s\+.*\)\@=/
syn match asciidocAdmonitionWarn /^\[\(CAUTION\|IMPORTANT\|WARNING\)\]\s*$/

" See http://vimdoc.sourceforge.net/htmldoc/usr_44.html for excluding region
" contents from highlighting.
syn match asciidocTablePrefix /\(\S\@<!\(\([0-9.]\+\)\([*+]\)\)\?\([<\^>.]\{,3}\)\?\([a-z]\)\?\)\?|/ containedin=asciidocTableBlock contained
syn region asciidocTableBlock matchgroup=asciidocTableDelimiter start=/^|=\{3,}$/ end=/^|=\{3,}$/ keepend contains=ALL
syn match asciidocTablePrefix /\(\S\@<!\(\([0-9.]\+\)\([*+]\)\)\?\([<\^>.]\{,3}\)\?\([a-z]\)\?\)\?!/ containedin=asciidocTableBlock contained
syn region asciidocTableBlock2 matchgroup=asciidocTableDelimiter2 start=/^!=\{3,}$/ end=/^!=\{3,}$/ keepend contains=ALL

syn match asciidocListContinuation /^+$/
syn region asciidocLiteralBlock start=/^\.\{4,}$/ end=/^\.\{4,}$/ contains=asciidocCallout keepend
syn region asciidocListingBlock start=/^-\{4,}$/ end=/^-\{4,}$/ contains=asciidocCallout keepend
syn region asciidocCommentBlock start="^/\{4,}$" end="^/\{4,}$" contains=asciidocToDo
syn region asciidocPassthroughBlock start="^+\{4,}$" end="^+\{4,}$"

" Allowing leading \w characters in the filter delimiter is to accomodate
" the pre version 8.2.7 syntax and may be removed in future releases.
syn region asciidocFilterBlock start=/^\w*\~\{4,}$/ end=/^\w*\~\{4,}$/

"\\ \@<! -> no preceding '\'
"<< -> two '<'
""\{-} -> zero or more ' " '  (double quote)
"\w \(\w \| -\)* -> any word char, followed by either zero or more words chars or a hyphen
""\? -> zero or one ' " ' (double quote) as many as possible
",\? -> zero or one ' , ' (comma) as many as possible
syn region asciidocMacroAttributes matchgroup=asciidocRefMacro start=/\\\@<!<<"\{-}\w\(\w\|-\)*"\?,\?/ end=/\(>>\)\|^$/ contains=asciidocQuoted.* keepend

syn region asciidocMacroAttributes matchgroup=asciidocAnchorMacro start=/\\\@<!\[\{2}\(\w\|-\)\+,\?/ end=/\]\{2}/ keepend
syn region asciidocMacroAttributes matchgroup=asciidocAnchorMacro start=/\\\@<!\[\{3}\(\w\|-\)\+/ end=/\]\{3}/ keepend

"[ \\ 0-9a-zA-Z ] \@<!  // zero width negative assertion of these
"chars can exist, which can't occur before subsequent \w
"\w \( \w \| - \)*  -> any word char, followed by either zero or more words
"chars or a hyphen
": \S \{-} \[/  -> colon, non-whitespace character (as few as possible),
"opening square bracket
"skip=/\\\]/  -> skip  \]
"end=/\]\|^$/  -> end at ] or empty line
syn region asciidocMacroAttributes matchgroup=asciidocMacro start=/[\\0-9a-zA-Z]\@<!\w\(\w\|-\)*:\S\{-}\[/ skip=/\\\]/ end=/\]\|^$/ contains=asciidocQuoted.* keepend

" \\@<!\\  region \\
syn region asciidocMacroAttributes matchgroup=asciidocIndexTerm start=/\\\@<!(\{2,3}/ end=/)\{2,3}/ contains=asciidocQuoted.* keepend
syn region asciidocMacroAttributes matchgroup=asciidocAttributeMacro start=/\({\(\w\|-\)\+}\)\@<=\[/ skip=/\\\]/ end=/\]/ keepend


"^// -> two forward slashes at beginning of line
"\( -> start of grouping
"[ -> define start of a class/range of chars, from which any *one* can match
"^/ ->  match any char *except* (negated by '^') a forward slash
"] -> end of char class
".* -> any char, zero or more
"\| -> seperates an alternation match (not sure what the alternate is here)
"\) -> end of grouping
"$ -> until end of line
syn match asciidocCommentLine "^//\([^/].*\|\)$" contains=asciidocToDo
syn region asciidocAttributeEntry start=/^:\a/ end=/:\(\s\|$\)/ oneline

" Lists.
syn match asciidocListBullet /^\s*\zs\(-\|\*\{1,5}\)\ze\s/
syn match asciidocListNumber /^\s*\zs\(\(\d\+\.\)\|\.\{1,5}\|\(\a\.\)\|\([ivxIVX]\+)\)\)\ze\s\+/
syn region asciidocListLabel start=/^\s*/ end=/\(:\{2,4}\|;;\)$/ oneline contains=asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash keepend
" DEPRECATED: Horizontal label.
syn region asciidocHLabel start=/^\s*/ end=/\(::\|;;\)\(\s\+\|\\$\)/ oneline contains=asciidocQuoted.*,asciidocMacroAttributes keepend
" Starts with any of the above.
syn region asciidocList start=/^\s*\(-\|\*\{1,5}\)\s/ start=/^\s*\(\(\d\+\.\)\|\.\{1,5}\|\(\a\.\)\|\([ivxIVX]\+)\)\)\s\+/ start=/.\+\(:\{2,4}\|;;\)$/ end=/\(^[=*]\{4,}$\)\@=/ end=/\(^+\?\s*$\)\@=/ contains=asciidocList.\+,asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash,asciidocCommentLine,asciidocAttributeList

"====================== OLD STUFF ============================

"Sections
syn region asciidocSect0 start=/^=\s\+\S/ end=/$/ oneline contains=asciidocQuoted.*,asciidocAttributeRef
syn region asciidocSect1 start=/^==\s\+\S/ end=/$/ oneline contains=asciidocQuoted.*,asciidocAttributeRef
syn region asciidocSect2 start=/^===\s\+\S/ end=/$/ oneline contains=asciidocQuoted.*,asciidocAttributeRef
syn region asciidocSect3 start=/^====\s\+\S/ end=/$/ oneline contains=asciidocQuoted.*,asciidocAttributeRef
syn region asciidocSect4 start=/^=====\s\+\S/ end=/$/ oneline contains=asciidocQuoted.*,asciidocAttributeRef

"FIXME: It is impossible to distinguish underlined titles from block delimiters
"       because we cannot calculate length in VIM syntax
syn match asciidocSect0Old /^[^. +/[].*[^.:]\n==\+$/ contains=asciidocQuoted.*,asciidocAttributeRef
syn match asciidocSect1Old /^[^. +/[].*[^.:]\n--\+$/ contains=asciidocQuoted.*,asciidocAttributeRef
syn match asciidocSect2Old /^[^. +/[].*[^.:]\n\~\~\+$/ contains=asciidocQuoted.*,asciidocAttributeRef


"^ -> start of  line
"[^. +/[] -> NOT any one of (all literal): ^ . space / [
".* -> any char, zero or more, greedy
"[^.:] -> NOT any one of (all literal): . :
"\n -> newline
"Section above represents the Section Title
"^^\+$ -> caret '^' at beginning of line until end of line
syn match asciidocSect3Old /^[^. +/[].*[^.:]\n^^\+$/ contains=asciidocQuoted.*,asciidocAttributeRef
syn match asciidocSect4Old /^[^. +/[].*[^.:]\n++\+$/ contains=asciidocQuoted.*,asciidocAttributeRef

"Others
syn match asciidocReplacements "[\s^]\(\(C\)\|\(TM\)\|\(R\)\|--\|\.\.\.\)[\s$]"

"literal $, wordchar (1+), (':' whitespace, anychar (1+), whitespace )(zero or 1), at end of
"line
"$ TEXT: MoreText $
syn match asciidocRevisionInfo "\$\w\+\(:\s.\+\s\)\?\$"

syn match asciidocBiblio "^\s*+\s\+"
syn match asciidocSource "^\s\s*\$\s\+.\+$"
"syn match asciidocSpecialChar "{amp}\w+;"
syn region asciidocQuestion start="\S" end="??\s*$" oneline
syn region asciidocGlossary start="\S" end=":-\s*$" oneline
"syn match asciidocFootnote "footnote:\[.*\]"
"syn match asciidocLink "link:.*\[.*\]"
"syn match asciidocURI "\(callto\|file\|ftp\|gopher\|http\|https\|mailto\|news\|xref\):.*\[\]"
"syn match asciidocURITitle "\(callto\|file\|ftp\|gopher\|http\|https\|mailto\|news\|xref\):.*\[.*\]"
"syn match asciidocInclude "include::.*\[.*\]"
"syn match asciidocInclude "include1::.*\[.*\]"
"syn match asciidocInclude "image:.*\[.*\]"
"syn match asciidocInclude "image::.*\[.*\]"
"syn match asciidocInclude "footnote:\[.*\]"
"syn match asciidocInclude "indexterm:\[.*\]"
"syn match asciidocInclude "ifdef::.*\[\]"
"syn match asciidocInclude "ifndef::.*\[\]"
"syn match asciidocInclude "endif::.*\[\]"
"syn match asciidocInclude "eval::\[\]"
"syn match asciidocInclude "sys::\[\]"
"syn match asciidocInclude "sys2::\[\]"


"Boolean
"Character
"Comment
"Conditional
"Constant
"Cursor
"Debug
"Define
"Delimiter
"DiffAdd
"DiffChange
"DiffDelete
"DiffText
"Directory
"ErrorMsg
"Exception
"Float
"FoldColumn
"Folded
"Function
"Identifier
"IncSearch
"Keyword
"Label
"Macro
"ModeMsg
"MoreMsg
"Number
"Operator
"PreCondit
"PreProc
"Question
"Repeat
"Search
"SpecialChar
"SpecialComment
"Special
"SpecialKey
"Statement
"StatusLine
"StatusLineNC
"StorageClass
"String
"Structure
"Tag
"Title
"Todo
"Typedef
"Type
"Underlined
"VertSplit
"VisualNOS
"WarningMsg
"WildMenu

"Styles
highlight default link asciidocAdmonitionNote Character
highlight default link asciidocAdmonitionWarn Character
highlight default link asciidocBackslash Comment
highlight default link asciidocBiblio Constant
highlight default link asciidocDoubleDollarPassthrough CursorLineNr
highlight default link asciidocFootnote Define
highlight default link asciidocGlossary Delimiter
highlight default link asciidocHLabel DiffAdd
highlight default link asciidocInclude DiffChange
highlight default link asciidocQuestion DiffDelete
highlight default link asciidocQuotedBold Define
highlight default link asciidocQuotedDoubleQuoted Directory
highlight default link asciidocQuotedEmphasized Define
highlight default link asciidocQuotedMonospaced ErrorMsg
highlight default link asciidocQuotedUnconstrainedBold Float
highlight default link asciidocQuotedUnconstrainedEmphasized Define
highlight default link asciidocQuotedUnconstrainedMonospaced NonText
highlight default link asciidocQuotedSingleQuoted Function
highlight default link asciidocQuotedSubscript Tag
highlight default link asciidocQuotedSuperscript Tag
highlight default link asciidocReference Keyword
highlight default link asciidocReplacements Label
highlight default link asciidocRevisionInfo Macro
highlight default link asciidocSource ModeMsg
highlight default link asciidocToDo Error
highlight default link asciidocTriplePlusPassthrough Number

"Attributes
highlight default link asciidocAttributeEntry Operator
highlight default link asciidocAttributeList PreCondit
highlight default link asciidocAttributeMacro Macro
"highlight default link asciidocAttributeRef
highlight default link asciidocAttributeRef PreProc

"Lists
highlight default link asciidocListBlockDelimiter Question
highlight default link asciidocListBullet NonText
highlight default link asciidocListContinuation Search
highlight default link asciidocListLabel SpecialChar
highlight default link asciidocListNumber SpecialComment

"Sections
highlight default link asciidocSect0 MoreMsg
highlight default link asciidocSect1 MoreMsg
highlight default link asciidocSect2 MoreMsg
highlight default link asciidocSect3 MoreMsg
highlight default link asciidocSect4 MoreMsg
highlight default link asciidocSect0Old MoreMsg
highlight default link asciidocSect1Old MoreMsg
highlight default link asciidocSect2Old MoreMsg
highlight default link asciidocSect3Old MoreMsg
highlight default link asciidocSect4Old MoreMsg

"Links
highlight default link asciidocEmail Tag
highlight default link asciidocLink Title
highlight default link asciidocOneLineTitle Todo
highlight default link asciidocTwoLineTitle Typedef
highlight default link asciidocURL Type

"Blocks
highlight default link asciidocBlockTitle Function
highlight default link asciidocExampleBlockDelimiter VertSplit
highlight default link asciidocFilterBlock VisualNOS
highlight default link asciidocListingBlock Number
highlight default link asciidocLiteralBlock WildMenu
highlight default link asciidocLiteralParagraph Normal
highlight default link asciidocQuoteBlockDelimiter Character
highlight default link asciidocSidebarDelimiter Conditional

"Tables
highlight default link asciidocTableBlock2 NONE
highlight default link asciidocTableBlock NONE
highlight default link asciidocTableDelimiter2 Boolean
highlight default link asciidocTableDelimiter Character
highlight default link asciidocTable_OLD Comment
highlight default link asciidocTablePrefix2 Conditional
highlight default link asciidocTablePrefix Constant

"Comments
highlight default link asciidocCommentBlock Comment
highlight default link asciidocCommentLine Comment

"Macros
highlight default link asciidocAnchorMacro SpellCap
highlight default link asciidocIndexTerm SpellRare
highlight default link asciidocMacro SpellBad
highlight default link asciidocMacroAttributes SpellLocal
highlight default link asciidocRefMacro ColorColumn

"Other
highlight default link asciidocCallout Label
highlight default link asciidocEntityRef Special
highlight default link asciidocIdMarker Special
highlight default link asciidocLineBreak Special
highlight default link asciidocPagebreak Type
highlight default link asciidocPassthroughBlock Visual
highlight default link asciidocRuler SpecialKey

let b:current_syntax = "asciidoc"

"Show tab and trailing characters
"set listchars=tab:»·,trail:·
"set list

"
"set textwidth=78 formatoptions=tcqn autoindent
set formatoptions=tcqn

if version >= 700
    "Prevent simple numbers at the start of lines to be confused with list items:
    set formatlistpat=^\\s*\\d\\+\\.\\s\\+
endif

set comments=s1:/*,ex:*/,://,b:#,:%,fb:-,fb:*,fb:.,fb:+,fb:>

"Typing "" inserts a pair of quotes (``'') and places the cursor between
"them. Works in both insert and command mode (switching to insert mode):
imap "" ``''<ESC>hi
map "" i""

nnoremap Q gq}

"eof
