# RESPONSE
class RequestResponse
	constructor: (@xhr, url)->
		@originalURL= url
		return
	# Get response header
	header: (name)-> @xhr.getResponseHeader name
	###* parse HTML and get MetaRedirectURL ###
	getMetaRedirectURL: ->
		if @type?.indexOf 'html' isnt -1
			if response = @xhr.responseText
				metaRegex = /<meta.+?>/gi
				while tag = metaRegex.exec response
					if /\bhttp-equiv\s*=\s*"?refresh\b/i.test tag[0]
						return tag[0].match(/url=([^\s"']+)"?/i)?[1]
		return null
	### parse JSON ###
	json: -> if data= this.xhr.responseText then JSON.parse data else null

	### GETTERS ###
	```
	get status(){return this.xhr.status}
	get statusText(){return this.xhr.statusText}
	get readyState(){return this.xhr.readyState}
	get url(){return this.xhr.responseURL || this.originalURL}
	get ok(){
		var status= this.xhr.status;
		return status >= 200 && status < 300
	}
	get type(){
		var dataType = this.xhr.getResponseHeader('content-type');
		if(dataType)
			dataType= dataType.substr(0, dataType.indexOf(';')).toLowerCase();
		return dataType
	}
	get headers(){return this.xhr.getAllResponseHeaders()}
	get text(){return this.xhr.responseText}
	get response(){return this.xhr.response}
	```
