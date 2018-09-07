" This has been adapted from Tim Pope's amazing abolish.vim
" <https://github.com/tpope/vim-abolish>
function! caser#camelcase(word)
  let word = substitute(a:word, '[ .-]', '_', 'g')
  if word !~# '_' && word =~# '\l'
    return substitute(word, '^.', '\l&', '')
  else
    return substitute(word, '\C\(_\)\=\(.\)', '\=submatch(1)==""?tolower(submatch(2)) : toupper(submatch(2))', 'g')
  endif
endfunction

function! caser#mixedcase(word)
  return substitute(caser#camelcase(a:word), '^.', '\u&', '')
endfunction

function! caser#snakecase(word)
  let word = substitute(a:word, '::', '/', 'g')
  let word = substitute(word, '\(\u\+\)\(\u\l\)', '\1_\2', 'g')
  let word = substitute(word, '\(\l\|\d\)\(\u\)', '\1_\2', 'g')
  let word = substitute(word, '[ .-]', '_', 'g')
  let word = tolower(word)
  return word
endfunction

function! caser#uppercase(word)
  return toupper(caser#snakecase(a:word))
endfunction

function! caser#kebabcase(word)
  return substitute(caser#snakecase(a:word), '_', '-', 'g')
endfunction

function! caser#spacecase(word)
  return substitute(caser#snakecase(a:word), '_', ' ', 'g')
endfunction

function! caser#titlecase(word)
  return substitute(caser#spacecase(a:word), '\(\<\w\)', '\=toupper(submatch(1))', 'g')
endfunction

function! caser#dotcase(word)
  return substitute(caser#snakecase(a:word), '_', '.', 'g')
endfunction
