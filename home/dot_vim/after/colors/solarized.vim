"==============================================================================
" Duplicate from source for reference.
"==============================================================================

" General
	let s:vmode       = "gui"

" Dark mode
	let s:base03      = "#002b36"
	let s:base01      = "#586e75"
	let s:base00      = "#657b83"
	let s:base0       = "#839496"
	let s:base1       = "#93a1a1"
	let s:base3       = "#fdf6e3"

" Light mode
if &background == "light"
    let s:temp03      = s:base03
    let s:temp01      = s:base01
    let s:temp00      = s:base00
    let s:base03      = s:base3
    let s:base01      = s:base1
    let s:base0       = s:temp00
    let s:base3       = s:temp03
endif

exe "let s:bg_base03    = ' ".s:vmode."bg=".s:base03 ."'"

exe "let s:fg_base03    = ' ".s:vmode."fg=".s:base03 ."'"
exe "let s:fg_base01    = ' ".s:vmode."fg=".s:base01 ."'"
exe "let s:fg_base0     = ' ".s:vmode."fg=".s:base0  ."'"
exe "let s:fg_base3     = ' ".s:vmode."fg=".s:base3  ."'"

"==============================================================================

" Toggle background from 'dark' to 'light'.
call togglebg#map("<F3>")

let s:fg_normal = s:fg_base3
if &background ==# 'dark'
elseif &background ==# 'light'
	" my lighter alternative
	" let s:fg_normal = s:fg_base0
endif
" Line number same as background.
" Except Comment, all other highlight groups are set same as Normal. 
exe "hi! LineNr".s:bg_base03
exe "hi! Normal".s:fg_normal
if exists("syntax_on")
	exe "hi! Comment"   .s:fg_base01
	exe "hi! Constant"  .s:fg_normal
	exe "hi! Identifier".s:fg_normal
	exe "hi! Statement" .s:fg_normal
	exe "hi! Preproc"   .s:fg_normal
	exe "hi! Type"      .s:fg_normal
	exe "hi! Special"   .s:fg_normal
endif
