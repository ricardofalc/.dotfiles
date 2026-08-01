" Small built-in help menu for this portable Vim config.
function! PortableHelpMenuFilter(id, key) abort
  if a:key ==# 'q' || a:key ==# "\<Esc>" || a:key ==# "\<CR>" || a:key ==# ' '
    call popup_close(a:id)
    return 1
  endif

  return 0
endfunction

function! PortableHelpMenu() abort
  let l:lines = [
        \ 'Portable Vim help',
        \ '',
        \ 'Explorer',
        \ '  \e              open/toggle explorer',
        \ '  i               cycle explorer view',
        \ '',
        \ 'Windows',
        \ '  Ctrl-h/j/k/l    move between splits',
        \ '  Ctrl-w > / <    resize split',
        \ '  Ctrl-w =        equalize splits',
        \ '',
        \ 'Project search',
        \ '  :grep word .    search below current folder',
        \ '  :copen          show search results',
        \ '  :cnext/:cprev   next/previous result',
        \ '',
        \ 'Indenting',
        \ '  =               auto-indent selected lines',
        \ '  gg=G            auto-indent the whole file',
        \ '',
        \ 'Close this help with q, Esc, Enter, or Space.',
        \ ]

  if exists('*popup_create')
    call popup_create(l:lines, {
          \ 'title': ' Vim ',
          \ 'pos': 'center',
          \ 'minwidth': 58,
          \ 'padding': [0, 1, 0, 1],
          \ 'border': [],
          \ 'filter': 'PortableHelpMenuFilter',
          \ })
  else
    botright 24new
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
    setlocal nonumber norelativenumber signcolumn=no
    call setline(1, l:lines)
    normal! gg
    nnoremap <buffer> <silent> q :bd!<CR>
    nnoremap <buffer> <silent> <Esc> :bd!<CR>
  endif
endfunction

nnoremap <silent> <leader>h :call PortableHelpMenu()<CR>
nnoremap <silent> <leader>? :call PortableHelpMenu()<CR>
