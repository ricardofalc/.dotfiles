" Wayland clipboard provider for terminal Vim.
" Lets "+y / "+p use the laptop clipboard through wl-copy and wl-paste.
if has('clipboard_provider') && executable('wl-copy') && executable('wl-paste')
  function! s:WaylandClipboardAvailable() abort
    return executable('wl-copy') && executable('wl-paste')
  endfunction

  function! s:WaylandClipboardCopy(reg, type, str) abort
    let l:args = 'wl-copy'

    if a:reg ==# '*'
      let l:args .= ' -p'
    endif

    call system(l:args, a:str)
  endfunction

  function! s:WaylandClipboardPaste(reg) abort
    let l:args = 'wl-paste --type text/plain;charset=utf-8'

    if a:reg ==# '*'
      let l:args .= ' -p'
    endif

    return ['', systemlist(l:args)]
  endfunction

  let v:clipproviders['wl_clipboard'] = {
        \ 'available': function('s:WaylandClipboardAvailable'),
        \ 'copy': {
        \   '+': function('s:WaylandClipboardCopy'),
        \   '*': function('s:WaylandClipboardCopy'),
        \ },
        \ 'paste': {
        \   '+': function('s:WaylandClipboardPaste'),
        \   '*': function('s:WaylandClipboardPaste'),
        \ },
        \ }
  set clipmethod^=wl_clipboard

  " Copy every yank to the laptop clipboard, but leave deletes/change operations alone.
  augroup WaylandYankClipboard
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' && v:event.regname !=# '+' | call setreg('+', v:event.regcontents, v:event.regtype) | endif
  augroup END
endif
