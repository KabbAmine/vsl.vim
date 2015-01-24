" Color conversion functions.

" Creation     : 2015-01-24
" Modification : 2015-01-24
" Maintainer   : Kabbaj Amine <amine.kabb@gmail.com>
" License      : This file is placed in the public domain.

fun! vsl#color#convert#Rgb2Hex(rgbCol)
    " Convert from rgb to hex:
    " 255, 0, 255 => #FF00FF

    let l:rgbCol = substitute(a:rgbCol, " ", "", "g")       " Remove spaces.
    let l:rgbColL = split(l:rgbCol, ",")

    let l:color = ""
    for l:element in copy(l:rgbColL)
		let l:hexElem = printf('%02X', l:element)
        let l:color = l:color.l:hexElem
    endfor

    return "#".l:color

endfun
fun! vsl#color#convert#Rgb2RgbPerc(rgbCol)
    " Convert from rgb to rgb (%):
    " 255, 0, 255 => 100%, 0%, 100%

    let l:rgbCol = substitute(a:rgbCol, " ", "", "g")
    let l:rgbColL = split(l:rgbCol, ",")

    let l:color = ""
    for l:element in copy(l:rgbColL)
        let l:rgbElem= (l:element * 100) / 255
        if len(l:color) == 0
            let l:color = l:rgbElem."%"
        else
            let l:color = l:color.", ".l:rgbElem."%"
        endif
    endfor

    return l:color

endfun
fun! vsl#color#convert#RgbPerc2Hex(rgbPercCol)
    " Convert from rgb (%) to hex:
    " 100%, 0%, 100% => #FF00FF

    let l:rgbCol = vsl#color#convert#RgbPerc2Rgb(a:rgbPercCol)
    let l:color = vsl#color#convert#Rgb2Hex(l:rgbCol)

    return l:color

endfun
fun! vsl#color#convert#RgbPerc2Rgb(rgbPercCol)
    " Convert from rgb (%) to rgb:
    " 100%, 0%, 0% => 255, 0, 0

    let l:rgbPercCol = substitute(a:rgbPercCol, " ", "", "g")
    let l:rgbPercCol = substitute(l:rgbPercCol, "%", "", "g")   " Remove %.
    let l:rgbPercColL = split(l:rgbPercCol, ",")

    let l:color = ""
    for l:element in copy(l:rgbPercColL)
        let l:elementF = str2float(l:element)
        let l:rgbElem = round(l:elementF * 2.55)
        let l:rgbElem = float2nr(l:rgbElem)
        if len(l:color) == 0
            let l:color = l:rgbElem
        else
            let l:color = l:color.", ".l:rgbElem
        endif
    endfor

    return l:color

endfun
fun! vsl#color#convert#Hex2Lit(hexCol)
    " Convert from hex to literal name.
    " #FF0000 => red

    let l:colIndex = index(values(vsl#color#html#names), toupper(a:hexCol))

    if l:colIndex != -1
        let s:color =get(keys(vsl#color#html#names), l:colIndex)
    else
        let s:color = a:hexCol
    endif

    return s:color

endfun
fun! vsl#color#convert#Hex2Rgb(hexCol)
    " Convert from hex to rgb:
    " #FF00FF => 255, 0, 255

    let l:hexColL = matchlist(a:hexCol, '#\([0-9A-F]\{1,2}\)\([0-9A-F]\{1,2}\)\([0-9A-F]\{1,2}\)')
    " Remove 1st and empty values.
    call remove(l:hexColL, 0)
    call remove(l:hexColL, 3, -1)

    let l:color = ""
    for l:element in l:hexColL
        let l:rgbElem = str2nr(l:element, 16)
        let l:rgbElem = string(l:rgbElem)
        if !empty(l:color)
            let l:color = l:color.", ".l:rgbElem
        else
            let l:color = l:rgbElem
        endif
    endfor

    return l:color
endfun
fun! vsl#color#convert#Hex2RgbPerc(hexCol)
    " Convert from hex to rgb (%):
    " #FF00FF => 100%, 0, 100%

    let l:rgbCol = vsl#color#convert#Hex2Rgb(a:hexCol)
    let l:color = vsl#color#convert#Rgb2RgbPerc(l:rgbCol)

    return l:color

endfun
fun! vsl#color#convert#Rgb2Hsl(rgbCol)
	" Convert from rgb to hsl:
	" 255, 0, 255 => 300, 100%, 50%
	" Algorithm from http://www.easyrgb.com/index.php?X=MATH&H=18#text18

    let l:rgbCol = substitute(a:rgbCol, " ", "", "g")       " Remove spaces.
    let l:rgbColL = split(l:rgbCol, ",")

	let l:r = l:rgbColL[0] / 255.0
	let l:g = l:rgbColL[1] / 255.0
	let l:b = l:rgbColL[2] / 255.0

	let l:min = vsl#type#list#GetMinVal([l:r,l:g,l:b])
	let l:max = vsl#type#list#GetMaxVal([l:r,l:g,l:b])
	let l:delta = l:max - l:min

	let l:l = (l:max + l:min) / 2.0

	if (l:delta == 0)
		" Achromatic.
		let l:h = 0
		let l:s = 0
	else
		if (l:l < 0.5)
			let l:s = l:delta / (l:max + l:min)
		else
			let l:s = l:delta / (2 - l:max - l:min)
		endif

		let l:deltaR = ( ( ( l:max - l:r ) / 6.0 ) + ( l:delta / 2.0 ) ) / l:delta
		let l:deltaG = ( ( ( l:max - l:g ) / 6.0 ) + ( l:delta / 2.0 ) ) / l:delta
		let l:deltaB = ( ( ( l:max - l:b ) / 6.0 ) + ( l:delta / 2.0 ) ) / l:delta

		if (l:r == l:max)
			let l:h = l:deltaB - l:deltaG
		elseif (l:g == l:max)
			let l:h = (1/3.0) + l:deltaR - l:deltaB
		elseif (l:b == l:max)
			let l:h = (2/3.0) + l:deltaG - l:deltaR
		endif

		if (l:h < 0)
			let l:h = l:h + 1
		endif
		if (l:h > 1)
			let l:h = l:h - 1
		endif
	endif

	let l:h = float2nr(abs(round(l:h * 360)))
	let l:s = float2nr(abs(round(l:s * 100)))
	let l:l = float2nr(abs(round(l:l * 100)))

	let l:color = l:h.", ".l:s."%, ".l:l."%"

	return l:color

endfun
fun! vsl#color#convert#Hsl2Rgb(hslCol)
	" Convert from hsl to rgb:
	" 300, 100%, 50% => 255, 0, 255
	" Algorithm from http://www.easyrgb.com/index.php?X=MATH&H=18#text18

	let l:hslColL = matchlist(a:hslCol, '\([ ]*[0-9]\{1,3}[ ]*\),\([ ]*[0-9]\{1,3}%[ ]*\),\([ ]*[0-9]\{1,3}%[ ]*\)')
	call remove(l:hslColL, 0)
	call remove(l:hslColL, 3, -1)

	let l:h = str2float(l:hslColL[0]) / 360
	let l:s = str2float(l:hslColL[1]) / 100
	let l:l = str2float(l:hslColL[2]) / 100

	if (l:s == 0)
		let l:r = l:l * 255.0
		let l:g = l:l * 255.0
		let l:b = l:l * 255.0
	else
		if (l:l < 0.5)
			let l:varTp2 = l:l * (1 + l:s)
		else
			let l:varTp2 = (l:l + l:s) - (l:s * l:l)
		endif

		let l:varTp1 = 2 * l:l - l:varTp2

		let l:r = float2nr(round(255 * vsl#color#convert#Hue2Rgb(l:varTp1, l:varTp2, (l:h + (1/3.0)))))
		let l:g = float2nr(round(255 * vsl#color#convert#Hue2Rgb(l:varTp1, l:varTp2, l:h)))
		let l:b = float2nr(round(255 * vsl#color#convert#Hue2Rgb(l:varTp1, l:varTp2, (l:h - (1/3.0)))))

	endif
	let l:color = string(l:r).", ".string(l:g).", ".string(l:b)

	return l:color

endfun
fun! vsl#color#convert#Hue2Rgb(v1, v2, vH)

	let l:v1 = a:v1
	let l:v2 = a:v2
	let l:vH = a:vH

	if (l:vH < 0)
		let l:vH = l:vH + 1
	endif
	if (l:vH > 1)
		let l:vH = l:vH - 1
	endif
	if ((6.0 * l:vH) < 1)
		return (l:v1 + (l:v2 - l:v1) * 6.0 * l:vH)
	endif
	if ((2.0 * l:vH) < 1)
		return (l:v2)
	endif
	if ((3.0 * l:vH) < 2)
		return (l:v1 + (l:v2 - l:v1) * ((2 / 3.0) - l:vH) * 6.0)
	endif

	return l:v1

endfun
fun! vsl#color#convert#Hsl2Hex(hslCol)
	" Convert from hsl to hex:
	" 300, 100%, 50% => #FF00FF

	let l:rgbCol = vsl#color#convert#Hsl2Rgb(a:hslCol)
	let l:color = vsl#color#convert#Rgb2Hex(l:rgbCol)

	return l:color

endfun
fun! vsl#color#convert#Hex2Hsl(hexCol)
	" Convert from hex to hsl:
	" #FF00FF => 300, 100%, 50%

	let l:rgbCol = vsl#color#convert#Hex2Rgb(a:hexCol)
	let l:color = vsl#color#convert#Rgb2Hsl(l:rgbCol)

	return l:color

endfun
