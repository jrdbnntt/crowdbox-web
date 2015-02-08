positive = /// ^ (
		up\W?vote
	| like
	| love
	) ///

negative = /// ^ (
		down\W?vote
	| dislike
	| hate
	) ///

what = /// ^ (
		what
	| current
	| wtf
	) ///

request = /^(requ?e?s?t?) (.*)/

module.exports = (edison, message) ->
	errFn = -> 'Error, please try again later.'

	if message.match(positive)
		return edison.upvoteCurrentSong().then ->
			'Thanks! You have upvoted the current song.'
		, errFn

	else if message.match(negative)
		return edison.downvoteCurrentSong().then ->
			'Thanks! You have downvoted the current song.'
		, errFn

	else if message.match(what)
		return edison.getCurrentSong().then (song) ->
			if song
				"Current song is #{song.title}."
			else
				'There is no song currently playing.'
		, errFn

	else if (match = message.match(request))
		query = match[2]
		return edison.requestSong(query).then (song)->
			"Thanks for your request! Your song is queued: #{song.title}"
		, errFn
