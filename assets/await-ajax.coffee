###*
 * AJAX lib
###
do->
	"use strict"
	#=include ajax/_main.coffee

	# Export interface
	if module? then module.exports= Ajax
	else if window? then window.Ajax= Ajax
	else
		throw new Error "Unsupported environement"
	return
