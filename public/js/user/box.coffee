###
For the box info

###



# Submit song query
$('form[name="songQuery"]').submit (event) ->
	console.log 'Submitted query'
	data = 
		query: $('input[name="songQuery"]').val()
		edisonId: $('#edisonId').val()
	
	if (data.query.trim().length <= 0)
		alert('Query Required')
		return
	
	$.ajax
		type: 'post'
		url: '/box/box_addSong'
		data: data
		success: (res)->
			alert res.message
		error: (err)->
			alert 'Error submitting query, try again.'
	return
$(document).ready ()->
	currentSong = $('#currentSong').val()
	if currentSong >= 0
		$('#song'+currentSong).addClass('currentSong')
	
	$('form[name="songOption"]').submit (event) ->
		op = $("button[type=submit][over=true]").attr 'name'
		console.log 'Submitted ' + op
		
		data = 
			songId: $(this).attr('songId')
			edisonId: $('#edisonId').val()
			index: parseInt $(this).attr('index')
		
		if op == 'remove'
			zone = 'user'
		else
			zone = 'box'
		
		$.ajax
			type: 'post'
			url: '/'+zone+'/box_'+op+'Song'
			data: data
			success: (res)->
				alert res.message
			error: (err)->
				alert 'Error with preforming '+op+', try again.'
		return

$('form button[type="submit"]').hover ()->
		$(this).attr 'over', true
	, () ->
		$(this).attr 'over', false