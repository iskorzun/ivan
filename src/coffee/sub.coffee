do ->
	'use strict'

	window.OnBind = (el, ev, callback) ->
		if el.addEventListener
			el.addEventListener ev, callback, false
		else if el.attachEvent
			el.attachEvent 'on' + ev, callback
		return

	includeLinkCss = (href)->
		stylesheet = document.createElement('link')
		stylesheet.href = href
		stylesheet.rel = 'stylesheet'
		stylesheet.type = 'text/css'
		document.getElementsByTagName('head')[0].appendChild stylesheet
		return
	window.includeCss = (arrLink)->
		if Array.isArray(arrLink)
			includeLinkCss(linkCss) for linkCss in arrLink
			return
		else
			includeLinkCss(arrLink)
			return

