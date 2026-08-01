" Built-in file explorer.
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_winsize = -30

" Open/toggle a left-side file explorer.
nnoremap <leader>e :Lexplore<CR>
nnoremap <C-W>e :Lexplore<CR>

" Open explorer for the current file's directory.
nnoremap - :Explore %:p:h<CR>
