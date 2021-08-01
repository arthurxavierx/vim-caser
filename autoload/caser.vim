" This has been adapted from Tim Pope's amazing abolish.vim
" <https://github.com/tpope/vim-abolish>

" Case Handlers {{{
function! caser#CamelCase(word)
  let word = substitute(a:word, '[ .-]', '_', 'g')
  if word !~# '_' && word =~# '\l'
    return substitute(word, '^.', '\l&', '')
  else
    return substitute(word, '\C\(_\)\=\(.\)', '\=submatch(1)==""?tolower(submatch(2)) : toupper(submatch(2))', 'g')
  endif
endfunction

function! caser#MixedCase(word)
  return substitute(caser#CamelCase(a:word), '^.', '\u&', '')
endfunction

function! caser#SnakeCase(word)
  let word = substitute(a:word, '::', '/', 'g')
  let word = substitute(word, '\(\u\+\)\(\u\l\)', '\1_\2', 'g')
  let word = substitute(word, '\(\l\|\d\)\(\u\)', '\1_\2', 'g')
  let word = substitute(word, '[ .-]', '_', 'g')
  let word = tolower(word)
  return word
endfunction

function! caser#UpperCase(word)
  return toupper(caser#SnakeCase(a:word))
endfunction

function! caser#KebabCase(word)
  return substitute(caser#SnakeCase(a:word), '_', '-', 'g')
endfunction

function! caser#TitleKebabCase(word)
  return substitute(caser#TitleCase(a:word), ' ', '-', 'g')
endfunction

function! caser#SpaceCase(word)
  return substitute(caser#SnakeCase(a:word), '_', ' ', 'g')
endfunction

function! caser#TitleCase(word)
  let word = tolower(a:word)
  return substitute(caser#SpaceCase(word), '\(\<\w\)', '\=toupper(submatch(1))', 'g')
endfunction

function! caser#SentenceCase(word)
  let word = tolower(a:word)
  return substitute(caser#SpaceCase(word), '^\(\<\w\)', '\=toupper(submatch(1))', 'g')
endfunction

function! caser#DotCase(word)
  return substitute(caser#SnakeCase(a:word), '_', '.', 'g')
endfunction
"}}}

" Setup {{{

" Adapted from unimpaired.vim by Tim Pope.
function! caser#DoAction(fn, type)
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

function! caser#ActionOpfunc(type)
  return caser#DoAction(s:encode_fn, a:type)
endfunction

function! caser#ActionSetup(fn)
  let s:encode_fn = a:fn
  let &opfunc = matchstr(expand('<sfile>'), '\d\+_').'caser#ActionOpfunc'
endfunction

function! caser#MapAction(fn, keys)
  exe 'nnoremap <silent> <Plug>Caser'.a:fn.' :<C-U>call caser#ActionSetup("'.a:fn.'")<CR>g@'
  exe 'xnoremap <silent> <Plug>CaserV'.a:fn.' :<C-U>call caser#DoAction("'.a:fn.'",visualmode())<CR>'

  if !exists('g:caser_no_mappings') || !g:caser_no_mappings
    for key in a:keys
      exe 'nmap '.g:caser_prefix.key.' <Plug>Caser'.a:fn
      exe 'xmap '.g:caser_prefix.key.' <Plug>CaserV'.a:fn
    endfor
  endif
endfunction
" }}}
