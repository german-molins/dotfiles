let g:bullets_enabled_file_types = [
    \ 'markdown',
    \ 'text',
    \ 'gitcommit'
    \]

let g:bullets_enable_in_empty_buffers = 0
let g:bullets_set_mappings = 1
let g:bullets_mapping_leader = ''

let g:bullets_delete_last_bullet_if_empty = 1
let g:bullets_line_spacing = 1

let g:bullets_pad_right = 0

" Ordered list containing the heirarchical bullet levels, starting from the
" outer most level.
" " chk = checkbox (- [ ])
let g:bullets_outline_levels = ['ROM', 'ABC', 'num', 'abc', 'rom', 'std-', 'std*', 'std+'] " default
let g:bullets_renumber_on_change = 1
let g:bullets_nested_checkboxes = 1
