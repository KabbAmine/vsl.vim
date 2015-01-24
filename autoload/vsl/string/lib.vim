" String functions.

" Creation     : 2015-01-24
" Modification : 2015-01-24
" Maintainer   : Kabbaj Amine <amine.kabb@gmail.com>
" License      : This file is placed in the public domain.

fun! vsl#string#lib#Set1LetterUpperCase(string)
	" Make the 1st letter of a string in uppercase.

	if !empty(a:string)
		let l:stringUpper = toupper(strpart(a:string, 0, 1)).tolower(strpart(a:string, 1))
		return l:stringUpper
	endif

endfun
