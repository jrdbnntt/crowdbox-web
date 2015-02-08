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
			@upvoteSong(@obj.currentSong)
		downvoteCurrentSong: =>
			@downvoteSong(@obj.currentSong)
		
		upvoteSong: (songIndex) =>
			@voteSong(songIndex, 1)
		downvoteSong: (songIndex) =>
			@voteSong(songIndex, -1)
		
		voteCurrentSong: (num) =>
			@voteSong(@obj.currentSong, num)
		
		voteSong: (songIndex, num) =>
			deferred = Q.defer()

			@obj.currentPlaylist[songIndex].rep += num
			@kaiseki.updateObject 'Edison', 
				@obj.objectId,
				{currentPlaylist: @obj.currentPlaylist},
				(err, res, body, success) ->
					if err
						deferred.reject(err)
					else
						deferred.resolve(body)

			deferred.promise
		
		getAll: =>
			deferred = Q.defer()
			@kaiseki.getObjects 'Edison', 
				(err,res,body,success) ->
					if err
						deferred.reject(err)
					else
						deferred.resolve(body)
			deferred.promise
		
		getAllUsers: =>
			deferred = Q.defer()
			@kaiseki.getObjects 'User', 
				(err,res,body,success) ->
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
			console.log(query)
			ytSearch(query).then (videoData) ->
				console.log(videoData)
				ytDlMp3(videoData.url, path.join(__dirname, '../../public/tmp'))
			.then (data) =>
				@kaiseki.createObject 'Song', 
					query: query
					title: data.info.title
					duration: data.info.length_seconds
					videoId: data.info.video_id
				, (->)
				@obj.currentPlaylist.push({title: data.info.title, id: data.info.video_id, rep: 0})
				@kaiseki.updateObject 'Edison',
					@obj.objectId,
					{currentPlaylist: @obj.currentPlaylist},
					(err, res, body, success) ->
						deferred.resolve(data.info)
			, (err) ->
				deferred.reject(err)	
			deferred.promise