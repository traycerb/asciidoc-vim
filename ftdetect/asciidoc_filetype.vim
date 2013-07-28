" Vim filetype detection file
" Language:     AsciiDoc
" Author:       Stuart Rackham <srackham@gmail.com>
" Last Change:  AsciiDoc 8.2.0
" URL:          http://www.methods.co.nz/asciidoc/
" Licence:      GPL (http://www.gnu.org)
" Remarks:      Vim 6 or greater

au BufNewFile,BufRead *.asc,*.asciidoc set filetype=asciidoc
au BufNewFile,BufRead *.txt
    \ if exists("g:asciidoc_txt_force") |
    \   set filetype=asciidoc |
    \ elseif exists("g:asciidoc_txt_guess") |
    \   call s:FTasciidoc() |
    \ endif

" This function checks for a valid AsciiDoc document title after first
" skipping any leading comments.
function! s:FTasciidoc()
  let in_comment_block = 0
  let n = 1
  while n < 50
    let line = getline(n)
    let n = n + 1
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
    if line !~ '\(^//\)\|\(^\s*$\)'
      break
    endif
  endwhile
  if line !~ '^=\{1,5}\s\+\S.*$'
    return
  endif
  set filetype=asciidoc
endfunction

" vim: et sw=2 ts=2 sts=2:
