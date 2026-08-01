" Shared Vim config.

for vimrc_file in split(glob('~/.vimrc.d/*.vim'), "\n")
  execute 'source' fnameescape(vimrc_file)
endfor
unlet! vimrc_file

" Machine-specific Vim config. Put work-only settings and mappings here.
if filereadable(expand('~/.vimrc.local'))
  execute 'source' fnameescape(expand('~/.vimrc.local'))
endif
