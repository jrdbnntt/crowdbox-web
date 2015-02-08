Edison = require('../models/edison')

# Requires login

module.exports = (app) ->
	class app.UserController
		
		@box = (req, res) ->
			title = 'Your CrowdBox'
			#get edison id
			app.kaiseki.getUser req.session.userId, (error, response, bodyu, success) ->
				if success
					#pull full data
					app.kaiseki.getObjects 'Edison',
						where:
							serial: bodyu.edisonId
						, (error, response, body, success)->
							if success
								data = 
									usingDefault: body[0].usingDefault
									twilioNumber: body[0].twilioNumber
									currentSong: body[0].currentSong
									serial: body[0].serial
									locationName: bodyu.locationName
									owner: bodyu.firstName + " " +  bodyu.lastName
								
								if data.usingDefault
									data.songs = body[0].defaultPlaylist
								else
									data.songs = body[0].currentPlaylist
								
								console.log JSON.stringify data, undefined, 2
								
								res.render 'user/box',
									title: title
									data: data
								
							else
								console.log 'Error loading playlist'
								res.render 'user/box',
									title: title
				
				else 
					console.log 'Error loading user'
					res.render 'user/box',
						title: title
		
		# Adds a song to the given playlist
		# body =
		# 		query
		# 		edisonId
		# 		toDefault -- ignored for now
		@box_addSong = (req, res) ->
			
			# #Generate 120 rand videoId 
			# #[a-z]=[97-122] [A-Z]=[65-90] [0-9]=[48-57] ->62
			# for i in [0...120]
			# 	n = Math.floor(Math.random()*62)
			# 	if n < 26 then videoId += String.fromCharCode(97+n)
			# 	else if n < 52 then videoId += String.fromCharCode(65+n-26)
			# 	else if n < 62 then videoId += String.fromCharCode(48+n-52)
			
			# console.log "VID ID=" + videoId
			
			app.kaiseki.getObject 'Edison', req.body.edisonId, (err, resp, data, success) ->
				if err or !success
					console.error(err)
					res.send
						success: false
						message: 'Error preforming song request, try again.'
					return
	
				edison  = new Edison(app.kaiseki, data)
				p = edison.requestSong(req.body.query)
				p.then (info) ->
					console.log 'VIDEO DL SUCCESS: '+ info
				, (err) ->
					console.log 'VIDEO DL ERROR: ' + err
				res.send
					success: true
					message: 'Request submitted. The song will be added soon.'
		
		
		@playlist = (req, res) ->
			res.render 'user/playlist',
				title: 'Edit Playlist'