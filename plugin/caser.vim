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
function! s:DoAction(fn, type)
  " backup settings that we will change
  let sel_save = &selection
  let cb_save = &clipboard

  " make selection and clipboard work the way we need
  set selection=inclusive clipboard-=unnamed clipboard-=unnamedplus

  " backup the unnamed register, which we will be yanking into
  let reg_save = @@
  let sel = ""

  " yank the relevant text, and also set the visual selection (which will be reused if the text
  " needs to be replaced)
  if a:type =~ '^\d\+$'
    " if type is a number, then select that many lines
    let sel = 'V'.a:type.'$y'
  elseif a:type =~ '^.$'
    " if type is 'v', 'V', or '<C-V>' (i.e. 0x16) then reselect the visual region
    let sel = "`<" . a:type . "`>y"
  elseif a:type == 'line'
    " line-based text motion
    let sel = "'[V']y"
  elseif a:type == 'block'
    " block-based text motion
    let sel = "`[\<C-V>`]y"
  else
    " char-based text motion
    let sel = "`[v`]y"
  endif

  silent exe 'normal! ' . sel

  " call the user-defined function, passing it the contents of the unnamed register
  let repl = {"caser#".a:fn}(@@)

  " if the function returned a value, then replace the text
  if type(repl) == 1
    " put the replacement text into the unnamed register, and also set it to be a
    " characterwise, linewise, or blockwise selection, based upon the selection type of the
    " yank we did above
    call setreg('@', repl, getregtype('@'))

    " reselect the visual region and paste
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

function! s:MapAction(fn, keys)
  exe 'nnoremap <silent> <Plug>Caser'.a:fn.' :<C-U>call <SID>ActionSetup("'.a:fn.'")<CR>g@'
  exe 'xnoremap <silent> <Plug>CaserV'.a:fn.' :<C-U>call <SID>DoAction("'.a:fn.'",visualmode())<CR>'

  if !exists('g:caser_no_mappings') || !g:caser_no_mappings
    for key in a:keys
      exe 'nmap '.g:caser_prefix.key.' <Plug>Caser'.a:fn
      exe 'xmap '.g:caser_prefix.key.' <Plug>CaserV'.a:fn
    endfor
  endif
endfunction

" }}}

call s:MapAction('MixedCase', ['m', 'p'])
call s:MapAction('CamelCase', ['c'])
call s:MapAction('SnakeCase', ['_'])
call s:MapAction('UpperCase', ['u', 'U'])
call s:MapAction('TitleCase', ['t'])
call s:MapAction('SentenceCase', ['s'])
call s:MapAction('SpaceCase', ['<space>'])
call s:MapAction('KebabCase', ['k', '-'])
call s:MapAction('TitleKebabCase', ['K'])
call s:MapAction('DotCase', ['.'])
