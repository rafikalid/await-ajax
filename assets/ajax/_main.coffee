###* AJAX MAIN ###
XHR_QUEUE= new Set() # store active requests

#=include _utils.coffee
#=include _response.coffee
#=include _xhr.coffee
# wrapper
__callAjax= (options, options2)->
	if (typeof options is 'string') or (options instanceof URL)
		options2.url= options
	else if typeof options is 'object' and options?
		_assign options2, options
	else
		throw new Error "Illegal arguments"
	return _callXHR options2

# Module interface
Ajax=
	get:		(options)-> _callAjax options, {method: 'GET', url: null}
	getJSON:	(options)-> _callAjax options, {method: 'GET', url: null, responseType: 'json'}

	# getOnce:	(options)-> _callAjax options, {method: 'GET', url: null, once: yes}
	# getJSONOnce:(options)-> _callAjax options, {method: 'GET', url: null, once: yes, responseType: 'json'}

	post:		(options)-> _callAjax options, {method: 'POST', url: null}
	postJSON:	(options)-> _callAjax options, {method: 'POST', url: null, dataType: 'json'}

	call:		(options)->
		throw new Error "Illegal arguments" unless arguments.length is 1 and typeof options is 'object' and options?
		return _callXHR options

	# Queue for all xhr requests
	all:		XHR_QUEUE

	# Abort all requests
	abortAll: (abortMessage)->
		XHR_QUEUE.forEach (req)->
			req.abort abortMessage
			return
		this # chain

	# Abort request with Id
	abort: (requestId, abortMessage)->
		XHR_QUEUE.forEach (req)->
			req.abort abortMessage if req.id is requestId
			return
		this # chain

	# UTILS
	formToJSON:			_convertFormDataToJSON
	formToUrlEncoded:	_convertFormDataToUrlEncoded
