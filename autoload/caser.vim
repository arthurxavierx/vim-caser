" This has been adapted from Tim Pope's amazing abolish.vim
" <https://github.com/tpope/vim-abolish>
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

function! caser#SpaceCase(word)
  return substitute(caser#SnakeCase(a:word), '_', ' ', 'g')
endfunction

function! caser#TitleCase(word)
  return substitute(caser#SpaceCase(a:word), '\(\<\w\)', '\=toupper(submatch(1))', 'g')
endfunction

function! caser#SentenceCase(word)
  return substitute(caser#SpaceCase(a:word), '^\(\<\w\)', '\=toupper(submatch(1))', 'g')
endfunction

function! caser#DotCase(word)
  return substitute(caser#SnakeCase(a:word), '_', '.', 'g')
endfunction
