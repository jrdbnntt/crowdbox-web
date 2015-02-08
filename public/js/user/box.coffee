###
For the box info

###



# Submit song query
$('form[name="songQuery"]').submit (event) ->
	event.preventDefault();
	console.log 'Submitted query'
	body = 
		query: $('input[name="songQuery"]').val()
		edisonId: $('#edisonId').val()
	
	if !body.query.trim()
		alert('Query Required')
		return
	
	$.ajax
		type: 'post'
		url: '/user/box_addSong'
		data: body
		success: (res)->
			alert res.message
		error: (err)->
			alert 'Error submitting query, try again.'
	return
