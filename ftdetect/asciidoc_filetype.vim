" Vim filetype detection file
" Language:     AsciiDoc
" Author:       Original Stuart Rackham <srackham@gmail.com>; forked from hjwp/vim-asciidoc
" Last Change:  AsciiDoc 8.2.0
" URL:          traycerb/asciidoc
" Licence:      GPL (http://www.gnu.org)
" Remarks:      Vim 6 or greater

autocmd BufNewFile,BufRead *.adoc,*.ad,*.asc set filetype=asciidoc
autocmd BufNewFile,BufRead *.txt
    \ if exists("g:asciidoc_txt_force") |
    \   set filetype=asciidoc |
    \ elseif exists("g:asciidoc_txt_guess") |
    \   call s:FTasciidoc() |
    \ endif
au BufNewFile,BufRead README,TODO,NOTES,CHANGELOG
    \ if exists("g:asciidoc_common_force") |
    \   set filetype=asciidoc |
    \ elseif exists("g:asciidoc_common_guess") |
    \   call s:FTasciidoc() |
    \ endif

" This function checks for a valid AsciiDoc document title after first
" skipping any leading comments, looking for a valid asciidoc title.
function! s:FTasciidoc()
  let in_comment_block = 0
  let n = 1
  "Loop moves past opening comment blocks and blank lines
  while n < 50
    let line = getline(n)
    let n = n + 1
    "Move to next line if in a comment block, until end of comment block
    "Line beginning and ending with four or more forward slashes '/'
    if line =~ '^/\{4,}$'
      if ! in_comment_block
        let in_comment_block = 1
      else
        let in_comment_block = 0
      endif
      continue
    endif
    if in_comment_block
      continue
    endif
    "Continue searching if line starts with // or is a blank/whitespace line
    if line !~ '\(^//\)\|\(^\s*$\)'
      break
    endif
  endwhile


  "check if valid asciidoc title
  if line =~ '^=\s\+\S.*$'
    "single line title style
    set filetype = asciidoc
  else
    let lineNext = getline (n)
    let lenLine = len(line)
    let lenLineNext = len(lineNext)
    let lenDifference = lenLine - lenLineNext
    if ((line =~ '^[^. +/[].*[^.:]$') && (lineNext =~ '^==\+$') &&  (lenDifference > -2 && lenDifference < 2 ))
        "double line title style
        "Delimiter length must be +/-1 compared to title length
        set filetype = asciidoc
    endif
  endif

"    Valid asciidoc title must be >= 3 chars
"    if line !~ '.\{3,}'
    "    return
"    endif

"    " 'len' is length of currently stored line (n-1)
"    let len = len(line)
"    " 'line' now contains string line (n)
"    let line = getline(n)

"    "Valid asciidoc title delimiter must match at least 3 '-' or '='
"    if line !~ '[-=]\{3,}'
    "    return
"    endif

     "length of line (n) and (n-1) must be between +/- 3 characters of each
     "other
"    if len < len(line) - 3 || len > len(line) + 3
    "    return
"    endif
"    setfiletype asciidoc
endfunction
