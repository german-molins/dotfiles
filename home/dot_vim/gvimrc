set guioptions-=m
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L

syntax on
colorscheme solarized

" Default font is bold, except for empty, text or markdown filetypes.
" Bug: Currently guifont does not have a local value, so opening a text or no ft
" file will cause a global change (all buffers and windows) of font.
set guifont=Monospace\ Bold\ 12
autocmd BufNewFile,BufRead *
    \    if !did_filetype() && empty(expand("<afile>:e")) 
	\    || &ft is# "text"
	\    || &ft is# "markdown"
    \ |      setlocal guifont=Monospace\ Regular\ 12
    \ |  endif
