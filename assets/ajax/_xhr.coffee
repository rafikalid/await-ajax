# Main method
_callXHR= (options)->
	# Prepare promise
	resolve= null
	reject= null
	promise= new Promise (res, rej)->
		resolve= res
		reject= rej
		return
	try
		# METHOD
		options.method ?= 'GET'
		# GET URL
		url= options.url
		throw 'Missing URL' unless url
		options.url= url= new URL url, _getBaseURL()
		# Prevent browser cache
		if options.cache is false
			urlParams = url.searchParams
			loop
				prm = '_' + Math.random().toString(32).substr(2)
				unless urlParams.has prm
					urlParams.append prm, 1
					break
		# REQUEST HEADERS
		headers= {}
		if options.headers
			for k,v of options.headers
				headers[_capitalizeSnakeCase k]= v
		options.headers= headers
		# PARSE RETURN VALUE
		if vl= options.responseType
			throw '"responseType" expected string' unless typeof vl is 'string'
			vl= vl.toLowerCase()
			options.responseType= vl= MIME_TYPES[vl] or vl
			if vl is 'application/json'
				promise= promise.then (resp)->
					throw resp.error unless resp.ok
					return resp.json()
		# prepare XHR
		xhr= options.xhr or new XMLHttpRequest()
		xhr.timeout= options.timeout if options.timeout?
		xhr.responseType= options.responseType if options.responseType?
		# upload / download listener
		xhr.upload.addEventListener 'progress', options.upload, false if options.upload?
		xhr.addEventListener 'progress', options.download, false if options.download?
		# create response object
		response = new RequestResponse xhr, url
		# headers received
		if options.headersReceived
			xhr.onreadystatechange= (event)->
				if xhr.readyState is 2
					options.headersReceived response
				return
		# CALLBACKS
		xhr.addEventListener 'load', (-> resolve response), false
		xhr.addEventListener 'error', (-> reject response), false
		xhr.addEventListener 'abort', (->
			response.aborted= true
			reject response
		), false
		### PREPARE DATA ###
		dataType= options.dataType or options.type or headers['Content-Type']
		dataType= MIME_TYPES[dataType] or dataType if dataType
		### SERIABLIZE DATA ###
		if data= options.data
			# string
			if typeof data is 'string'
				dataType ?= 'text/plain'
			else if data instanceof FormData or data instanceof HTMLFormElement
				# encode
				if dataType is MIME_TYPES.json
					data= _convertFormDataToJSON data
				else if dataType is MIME_TYPES.urlencoded
					data= _convertFormDataToUrlEncoded data
				else if dataType is MIME_TYPES.multipart
					dataType= undefined # TO enable adding multipart data boundries
					data= new FormData data unless data instanceof FormData
				else if dataType
					throw new Error 'Could not convert FormData to: ' + dataType
			# Object
			else if not dataType or dataType is MIME_TYPES.json
				data= JSON.stringify data
				dataType= MIME_TYPES.json
			else
				throw new Error "Illagal data for mimetype: " + dataType
		headers['Content-Type']= dataType if dataType
		# DEFINE REQUERED METHODS
		promise.abort= (abortMessage)->
			response.error= abortMessage or 'Aborted'
			xhr.abort()
			this # chain
		promise.id=		options.id
		# Store this call
		XHR_QUEUE.add promise
		promise.finally ->
			XHR_QUEUE.delete promise
			return
		# send request
		xhr.open options.method, url.href, true
		# add headers
		for k, v of headers
			xhr.setRequestHeader k, v
		# send data
		xhr.send data or null
	catch error
		reject error
	return promise
