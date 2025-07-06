" Character representing <Leader>
let mapleader = " "

nnoremap Y y$
nnoremap dD ddk

" Insert single char.
nnoremap <Leader>- i<Space><Esc>r
nnoremap <Leader>+ a<Space><Esc>r

" always magic search
nnoremap / /\v
vnoremap / /\v

nnoremap <silent> <Leader>l :ls<CR>
nnoremap <silent> <CR> :wa<CR>
nnoremap <BS> :xa<CR>

" Buffers
nnoremap <silent> <Leader>b :b#<CR>
nnoremap <F10> :b <C-Z>

" Put from primary selection and clipboard selection.
nnoremap <C-+> "+gp
nnoremap <C-*> "*gp

" Put formatted current date.
inoremap <silent> <M-d> <C-r>=strftime('%Y-%m-%d')<CR>
nnoremap <silent> <M-d> :put =strftime('%Y-%m-%d')<CR>

" -------------------------------------------------------------------
" Recursive mappings for C-like indented blocks using surround.vim and filetype
" autoindent

" Insert block right here.
imap <C-}> <C-s><C-s>}
imap <C-]> <C-s><C-s>]
imap <C-)> <C-s><C-s>)
" Insert block beginnig at the last non-blank char of line.
nmap <C-}> g_a<Space><Esc>Da<Space><C-}>
nmap <C-]> g_a<Space><Esc>Da<Space><C-]>
nmap <C-)> g_a<Space><Esc>Da<Space><C-)>
" Jump to next unmatched item of matchpair in this line; else exit insert mode
" and move cursor right.
inoremap <C-l> <Esc>l%%a

