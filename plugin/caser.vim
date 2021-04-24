if exists('g:loaded_caser')
  finish
endif
let g:loaded_caser = 1

" Defaults {{{
if !exists('g:caser_prefix')
  let g:caser_prefix = 'gs'
endif

call caser#MapAction('MixedCase', ['m', 'p'])
call caser#MapAction('CamelCase', ['c'])
call caser#MapAction('SnakeCase', ['_'])
call caser#MapAction('UpperCase', ['u', 'U'])
call caser#MapAction('TitleCase', ['t'])
call caser#MapAction('SentenceCase', ['s'])
call caser#MapAction('SpaceCase', ['<space>'])
call caser#MapAction('KebabCase', ['k', '-'])
call caser#MapAction('TitleKebabCase', ['K'])
call caser#MapAction('DotCase', ['.'])
" }}}
