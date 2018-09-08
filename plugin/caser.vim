if exists('g:loaded_caser')
  finish
endif
let g:loaded_caser = 1

" Defaults {{{
if !exists('g:caser_prefix')
  let g:caser_prefix = 'gs'
endif
" }}}

" Setup {{{
" Adapted from unimpaired.vim by Tim Pope.
function! s:DoAction(fn,type)
  " backup settings that we will change
  let sel_save = &selection
  let cb_save = &clipboard
  " make selection and clipboard work the way we need
  set selection=inclusive clipboard-=unnamed clipboard-=unnamedplus
  " backup the unnamed register, which we will be yanking into
  let reg_save = @@
  " yank the relevant text, and also set the visual selection (which will be reused if the text
  " needs to be replaced)
  if a:type =~ '^\d\+$'
    " if type is a number, then select that many lines
    silent exe 'normal! V'.a:type.'$y'
  elseif a:type =~ '^.$'
    " if type is 'v', 'V', or '<C-V>' (i.e. 0x16) then reselect the visual region
    silent exe "normal! `<" . a:type . "`>y"
  elseif a:type == 'line'
    " line-based text motion
    silent exe "normal! '[V']y"
  elseif a:type == 'block'
    " block-based text motion
    silent exe "normal! `[\<C-V>`]y"
  else
    " char-based text motion
    silent exe "normal! `[v`]y"
  endif
  " call the user-defined function, passing it the contents of the unnamed register
  let repl = {a:fn}(@@)
  " if the function returned a value, then replace the text
  if type(repl) == 1
    " put the replacement text into the unnamed register, and also set it to be a
    " characterwise, linewise, or blockwise selection, based upon the selection type of the
    " yank we did above
    call setreg('@', repl, getregtype('@'))
    " relect the visual region and paste
    normal! gvp
  endif
  " restore saved settings and register value
  let @@ = reg_save
  let &selection = sel_save
  let &clipboard = cb_save
endfunction

function! s:ActionOpfunc(type)
  return s:DoAction(s:encode_fn, a:type)
endfunction

function! s:ActionSetup(fn)
  let s:encode_fn = a:fn
  let &opfunc = matchstr(expand('<sfile>'), '<SNR>\d\+_').'ActionOpfunc'
endfunction

function! s:MapAction(key, fn)
  exe 'nnoremap <silent> '.g:caser_prefix.a:key.' :<C-U>call <SID>ActionSetup("caser#'.a:fn.'")<CR>g@'
  exe 'xnoremap <silent> '.g:caser_prefix.a:key.' :<C-U>call <SID>DoAction("caser#'.a:fn.'",visualmode())<CR>'
endfunction
" }}}

call s:MapAction('m',       'mixedcase')
call s:MapAction('c',       'camelcase')
call s:MapAction('s',       'snakecase')
call s:MapAction('_',       'snakecase')
call s:MapAction('u',       'uppercase')
call s:MapAction('U',       'uppercase')
call s:MapAction('t',       'titlecase')
call s:MapAction('<space>', 'spacecase')
call s:MapAction('-',       'kebabcase')
call s:MapAction('k',       'kebabcase')
call s:MapAction('.',       'dotcase')
