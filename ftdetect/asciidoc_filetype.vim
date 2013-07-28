" Vim filetype detection file
" Language:     AsciiDoc
" Author:       Stuart Rackham <srackham@gmail.com>
" Last Change:  AsciiDoc 8.2.0
" URL:          http://www.methods.co.nz/asciidoc/
" Licence:      GPL (http://www.gnu.org)
" Remarks:      Vim 6 or greater

au BufNewFile,BufRead *.asc,*.asciidoc setfiletype asciidoc

if exists("g:asciidoc_txt_force")
  au BufNewFile,BufRead *.txt setfiletype asciidoc
else
  if exists("g:asciidoc_txt_guess")
    au BufNewFile,BufRead *.txt call s:FTasciidoc()
  endif
endif

if exists("g:asciidoc_common_force")
  au BufNewFile,BufRead README,TODO,CHANGELOG,NOTES  setfiletype asciidoc
else
  if exists("g:asciidoc_common_guess")
    au BufRead README,TODO,CHANGELOG,NOTES call s:FTasciidoc()
  endif
endif

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
  if line !~ '.\{3,}'
    return
  endif
  let len = len(line)
  let line = getline(n)
  if line !~ '[-=]\{3,}'
    return
  endif
  if len < len(line) - 3 || len > len(line) + 3
    return
  endif
  setfiletype asciidoc
endfunction

" vim: et sw=2 ts=2 sts=2:
