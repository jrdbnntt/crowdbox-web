path = require('path')
Q = require('q')
ytSearch = require('../../lib/youtube-search')
ytDlMp3 = require('../../lib/youtube-download-mp3')

module.exports = 
	class Edison
		constructor: (kaiseki, obj) ->
			@kaiseki = kaiseki
			@obj = obj

		@findByNumber = (number, kaiseki) ->
		 	deferred = Q.defer()
		 	kaiseki.getObjects 'Edison', 
		 		where: 
		 			twilioNumber: "+14043692348"
		 		limit: 1
		 	, (err, res, body, success) ->
		 		if err
		 			deferred.reject(err)
		 		else if !success
		 			deferred.reject()
		 		else if !body or body.length < 1
		 			deferred.reject(new Error('Number not found'))
		 		else
		 			console.log(body)
		 			deferred.resolve(new Edison(kaiseki, body[0]))

		 	deferred.promise

		upvoteCurrentSong: =>
			@voteCurrentSong(1)

		downvoteCurrentSong: =>
			@voteCurrentSong(-1)

		voteCurrentSong: (num) =>
			deferred = Q.defer()

			@obj.currentPlaylist[@obj.currentSong].votes += num
			@kaiseki.updateObject 'Edison', 
				@obj.objectId,
				{currentPlaylist: @obj.currentPlaylist},
				(err, res, body, success) ->
					if err
						deferred.reject(err)
					else
						deferred.resolve(body)

			deferred.promise

		getCurrentSong: =>
			deferred = Q.defer()

			@kaiseki.getObject 'Song',
				@obj.currentPlaylist[@obj.currentSong].id,
				(err, res, body, success) ->
					if err
						deferred.reject(err)
					else
						deferred.resolve(body)

			deferred.promise

		requestSong: (query) =>
			deferred = Q.defer()
			ytSearch(query).then (videoData) ->
				console.log(videoData)
				ytDlMp3(videoData.url, path.join(__dirname, '../../tmp'))
			.then (data) =>
				@kaisei.createObject 'Song', 
					query: query
					title: data.info.title
					duration: data.info.length_seconds
					videoId: data.info.video_id
				@obj.currentPlaylist.push({id: data.info.video_id, votes: 0})
				@kaisei.updateObject 'Edison',
					@obj.objectId,
					{currentPlaylist: @obj.currentPlaylist},
					(err, res, body, success) ->
						deferred.resolve(data.info)
			, (err) ->
				deferred.reject(err)	
			deferred.promise