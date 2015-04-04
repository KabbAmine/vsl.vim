" Functions & utilities for colorschems in Vim.

" Creation     : 2015-01-24
" Modification : 2015-04-04
" Maintainer   : Kabbaj Amine <amine.kabb@gmail.com>
" License      : This file is placed in the public domain.

fun! vsl#colorscheme#lib#Hi(groupName, bgColor, fgColor, option) " {{{1
	" Set higlighting colors of specified group name

	let l:bgColor = type(a:bgColor) == type('NONE') ? ['NONE', 'NONE'] : a:bgColor
	let l:fgColor = type(a:fgColor) == type('NONE') ? ['NONE', 'NONE'] : a:fgColor

	let l:command = 'hi ' . a:groupName
	let l:params = ['gui']
	for i in (range(0, len(l:params)-1))
		let l:command .= ' '.l:params[i].'bg='.l:bgColor[i].' '.l:params[i].'fg='.l:fgColor[i]
		let l:command .= ' '.l:params[i].'='.a:option
	endfor

	exe l:command
endfun
" }}}

" vim:ft=vim:fdm=marker:fmr={{{,}}}:
