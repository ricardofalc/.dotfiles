filetype plugin indent on

set autoindent
set smarttab
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set shiftround

augroup PortableIndent
  autocmd!
  autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType yaml,json,html,css,javascript,typescript,markdown setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=0
  autocmd FileType make setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=0
augroup END
