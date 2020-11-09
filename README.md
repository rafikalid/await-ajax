# await-ajax
Ajax library based on promises

# Basic use:

## Get data from the server
```javascript
// Load data from URL
response= await Ajax.get('https://example.com');

// Use more options, @see bellow for details
response= await Ajax.get(options);

isOk= response.ok;		// if the response status is between 200 and 299
data= response.response; // Get Binary response
data= response.text;	// Get text response
data= response.json();	// Parse response as JSON
```

## Load JSON from the server
```javascript
// First solution
response= await Ajax.get(options);
data= response.json();

// Second solution
data= await Ajax.getJSON(options);
```

## Post data to server
```javascript
// Send data, data type will be generated auto
response= await Ajax.post({
	url:	'path/to/controller'	// any valid URI  (String or of type URL)
	data:	{data} // Text, Object, formData, HTMLFormElement
});

// Send data as json
response= await Ajax.postJSON({
	url:	'path/to/controller'	// any valid URI  (String or of type URL)
	data: {data}	// Text, Object, formData, HTMLFormElement
})
```

# Ajax options
```javascript
options= {
	id:			'someId'	// This id enables to abort this request using Ajax.abort('id')
	method:		'GET'		// method: GET or POST
	url:		'URI'		// Any valid URI, relative URI, URL Object
	timeout:	Infinity	// request timeout in ms

	headers:	{}			// Request HTTP headers
	cache:		true		// Help to prevent browser cache when "false"

	data:	{data}		// When method is POST. Could be: Text, Object, FormData, HTMLFormElement
	dataType: 'auto'	// fix the Request content type, the library will serialize data when: json, multipart, urlencoded or text

	xhr:	new XMLHttpRequest()	// Set a custom XMLHttpRequest object

	// Add listener for data upload: event= {lengthComputable, loaded, total}
	upload: function(event){ /* logic */ }

	// Add listener for data download: event= {lengthComputable, loaded, total}
	download: function(event){ /* logic */ }
	upload: function(event){ /* logic */ }

	// Add listener when headers received (before data starts downloading)
	headersReceived: function(response){ /* logic */ }
};
```

# Response object
```javascript
response= {
	xhr:	XMLHttpRequest	// used XMLHttpRequest object
	error: ''	// Error message when ERROR

	status: 	200	// response status
	statusText:	''	// Status text
	readyState: 4	// ready state, from 0 to 4

	url: URL()		// current URL
	originalURL: URL	// requested URL (before any http redirect)

	ok:		Boolean	// if response status is between 200 and 299
	type:	''	// Response Content-Type
	headers: {}	// Response headers

	text:	'' // Response Text
	response: Blob // Response binary
};

// Get response header
response.header('headerName')

// Parse response as JSON
data= response.json()

// Parse reponse HTML and Get meta redirect URL
response.getMetaRedirectURL()
```
