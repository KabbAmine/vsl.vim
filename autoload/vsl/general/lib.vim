" General functions.

" Creation     : 2015-01-24
" Modification : 2015-01-24
" Maintainer   : Kabbaj Amine <amine.kabb@gmail.com>
" License      : This file is placed in the public domain.

fun! vsl#general#lib#GetVisualSelection()
	" Return the visual selection.

	let l:selection=getline("'<")
	let l:cursorPos=getpos("'<'")
	let [line1,col1] = getpos("'<")[1:2]
	let [line2,col2] = getpos("'>")[1:2]
	call setpos('.', l:cursorPos)

	return l:selection[col1 - 1: col2 - 1]

endfun
fun! vsl#general#lib#ShowMessage(messageTypeNumber, messageContent)
	" Show a message according to his highlighting type.
	"	1- White (Normal).
	"	2- Red (Warning).
	"	3- Background in red (Error).
	"	4- Blue (Directory).

	if (a:messageTypeNumber == 1)
		let l:messageType = "Normal"
	elseif (a:messageTypeNumber == 2)
		let l:messageType = "WarningMsg"
	elseif (a:messageTypeNumber == 3)
		let l:messageType = "ErrorMsg"
	elseif (a:messageTypeNumber == 4)
		let l:messageType = "Directory"
	endif

	execute "echohl ".l:messageType
	echo a:messageContent
	echohl None

endfun
fun! vsl#general#lib#DefineVariable(variable, value)
	" Set value to a:variable if she doesn't exist.

	if !exists(a:variable)
		let {a:variable} = a:value
	endif
endfun
