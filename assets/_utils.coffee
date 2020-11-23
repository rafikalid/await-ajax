###*
 * Common core from "core-ui"
###
_assign= Object.assign


# BaseURL
_ajaxBaseURL= null
_getBaseURL= ->
	unless _ajaxBaseURL
		try
			_ajaxBaseURL= document.getElementsByTagName('base')[0].href
		catch error
			_ajaxBaseURL= document.location.href
	return _ajaxBaseURL
