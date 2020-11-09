###
 * interface for with "core-ui"
###
get:		(options)-> _callAjax options, {method: 'GET', url: null}
getJSON:	(options)-> _callAjax options, {method: 'GET', url: null, responseType: 'json'}

# getOnce:	(options)-> _callAjax options, {method: 'GET', url: null, once: yes}
# getJSONOnce:(options)-> _callAjax options, {method: 'GET', url: null, once: yes, responseType: 'json'}

post:		(options)-> _callAjax options, {method: 'POST', url: null}
postJSON:	(options)-> _callAjax options, {method: 'POST', url: null, dataType: 'json'}

# Main method
ajax:		Ajax

# UTILS
formToObject:		_convertFormDataToObject
formToJSON:			_convertFormDataToJSON
formToUrlEncoded:	_convertFormDataToUrlEncoded

MIME_TYPES:			MIME_TYPES
