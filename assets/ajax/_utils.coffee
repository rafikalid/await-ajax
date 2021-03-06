# MIME TYPES
MIME_TYPES=
	json		: 'application/json'
	xml			: 'application/xml'
	urlencoded	: 'application/x-www-form-urlencoded'
	text		: 'text/plain'
	multipart	: 'multipart/form-data'

# Capitalize
_capitalizeSnakeCase= (str, delimeter='-')->
	if str
		str= str.replace /^[\s-_]+|[\s-_]+$/g, ''
			.replace /[\s-_]+(\w)/g, (_, w)-> delimeter + w.toUpperCase()
		str= str.charAt(0).toUpperCase() + str.substr 1
	return str

###*
 * Convert formData to JSON
###
_convertFormDataToObject= (formData)->
	formData= new FormData formData unless formData instanceof FormData
	result= {}
	formData.forEach (v,k)->
		if typeof v is 'string'
			# if sub path
			k= k.split '.'
			len= k.length - 1
			i=0
			res= result
			while i < len
				res= res[k[i++]]?= _create null
			# set value
			k= k[len]
			if res[k]
				res[k]= [res[k]] unless Array.isArray res[k]
				res[k].push v
			else
				res[k]= v
		return
	return result
_convertFormDataToJSON= (formData)->
	return JSON.stringify _convertFormDataToObject(formData)

###*
 * Convert formData to URL encoded
###
_convertFormDataToUrlEncoded= (formData)->
	formData= new FormData formData unless formData instanceof FormData
	params = new URLSearchParams()
	formData.forEach (v,k)->
		params.append k, v if typeof v is 'string'
		return
	return params.toString()
