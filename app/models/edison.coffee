Q = require('q')

module.exports = 
	class Edison
		constructor: ->
			# ...

		@findByNumber = (number) ->
		 	deferred = Q.defer()
		 	deferred.resolve(new Edison())
		 	deferred.promise

		upvoteCurrentSong: ->
			@voteCurrentSong(1)

		downvoteCurrentSong: ->
			@voteCurrentSong(-1)

		voteCurrentSong: (num) ->
			deferred = Q.defer()
			deferred.resolve()
			deferred.promise

		getCurrentSong: ->
			deferred = Q.defer()
			deferred.resolve('Beyoncé - Pretty Hurts')
			deferred.promise

		requestSong: (song) ->
			deferred = Q.defer()
			deferred.reject()
			deferred.promise
