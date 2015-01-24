" List functions.

" Creation     : 2015-01-24
" Modification : 2015-01-24
" Maintainer   : Kabbaj Amine <amine.kabb@gmail.com>
" License      : This file is placed in the public domain.

fun! vsl#type#list#GetMinVal(list)
	" Return the minimum value of a list.

	let l:min = a:list[0]
	if l:min > a:list[1]
		let l:min = a:list[1]
	endif
	if l:min > a:list[2]
		let l:min = a:list[2]
	endif

	return l:min

endfun
fun! vsl#type#list#GetMaxVal(list)
	" Return the maximum value of a list.

	let l:max = a:list[0]
	if l:max < a:list[1]
		let l:max = a:list[1]
	endif
	if l:max < a:list[2]
		let l:max = a:list[2]
	endif

	return l:max

endfun
fun! vsl#type#list#RemoveDuplicates(list)
	" Remove duplicates
	" http://stackoverflow.com/questions/6630860/remove-duplicates-from-a-list-in-vim
	
	let l:cleanList = filter(copy(a:list), 'index(a:list, v:val, v:key+1)==-1')
	return l:cleanList
endfun
