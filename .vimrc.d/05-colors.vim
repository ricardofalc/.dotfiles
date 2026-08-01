" Portable 256-color terminal palette.
" Works best when $TERM supports 256 colors, for example xterm-256color.
set background=dark

if !has('gui_running') && &t_Co < 256 && $TERM =~# '256color'
  set t_Co=256
endif

if &t_Co >= 256 || $TERM =~# '256color' || has('gui_running')
  highlight Normal       cterm=NONE ctermfg=252 ctermbg=NONE gui=NONE guifg=#d8dee9 guibg=NONE
  highlight Comment      cterm=NONE ctermfg=244 ctermbg=NONE gui=NONE guifg=#7d8590 guibg=NONE
  highlight Constant     cterm=NONE ctermfg=174 ctermbg=NONE gui=NONE guifg=#d08770 guibg=NONE
  highlight String       cterm=NONE ctermfg=150 ctermbg=NONE gui=NONE guifg=#a3be8c guibg=NONE
  highlight Identifier   cterm=NONE ctermfg=252 ctermbg=NONE gui=NONE guifg=#d8dee9 guibg=NONE
  highlight Function     cterm=NONE ctermfg=109 ctermbg=NONE gui=NONE guifg=#81a1c1 guibg=NONE
  highlight Statement    cterm=NONE ctermfg=110 ctermbg=NONE gui=NONE guifg=#88c0d0 guibg=NONE
  highlight PreProc      cterm=NONE ctermfg=180 ctermbg=NONE gui=NONE guifg=#ebcb8b guibg=NONE
  highlight Type         cterm=NONE ctermfg=146 ctermbg=NONE gui=NONE guifg=#b48ead guibg=NONE
  highlight Special      cterm=NONE ctermfg=173 ctermbg=NONE gui=NONE guifg=#d08770 guibg=NONE
  highlight Underlined   cterm=underline ctermfg=110 ctermbg=NONE gui=underline guifg=#88c0d0 guibg=NONE
  highlight Error        cterm=NONE ctermfg=231 ctermbg=124 gui=NONE guifg=#eceff4 guibg=#bf616a
  highlight Todo         cterm=bold ctermfg=16 ctermbg=180 gui=bold guifg=#2e3440 guibg=#ebcb8b

  highlight CursorLine   cterm=NONE ctermbg=236 gui=NONE guibg=#3b4252
  highlight CursorColumn cterm=NONE ctermbg=236 gui=NONE guibg=#3b4252
  highlight LineNr       cterm=NONE ctermfg=240 ctermbg=NONE gui=NONE guifg=#4c566a guibg=NONE
  highlight CursorLineNr cterm=NONE ctermfg=110 ctermbg=236 gui=NONE guifg=#88c0d0 guibg=#3b4252
  highlight Visual       cterm=NONE ctermfg=NONE ctermbg=60 gui=NONE guifg=NONE guibg=#4c566a
  highlight Search       cterm=NONE ctermfg=16 ctermbg=180 gui=NONE guifg=#2e3440 guibg=#ebcb8b
  highlight IncSearch    cterm=NONE ctermfg=16 ctermbg=110 gui=NONE guifg=#2e3440 guibg=#88c0d0
  highlight MatchParen   cterm=NONE ctermfg=16 ctermbg=110 gui=NONE guifg=#2e3440 guibg=#88c0d0
  highlight Pmenu        cterm=NONE ctermfg=252 ctermbg=236 gui=NONE guifg=#d8dee9 guibg=#3b4252
  highlight PmenuSel     cterm=NONE ctermfg=16 ctermbg=110 gui=NONE guifg=#2e3440 guibg=#88c0d0
endif
