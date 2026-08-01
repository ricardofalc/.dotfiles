set wildmenu
set wildmode=list:longest,full
set path+=**
set suffixesadd=.js,.ts,.tsx,.jsx,.py,.sh,.yaml,.yml,.json,.md
set wildignore+=*/.git/*,*/node_modules/*,*/dist/*,*/build/*,*.o,*.pyc

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif
