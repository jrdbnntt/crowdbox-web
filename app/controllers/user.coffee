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
									edisonId: body[0].objectId
									songs: body[0].currentPlaylist
									isOwner: true
								
								# console.log JSON.stringify data, undefined, 2
								
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
			console.log JSON.stringify req.body, undefined, 2
			
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
		
		
		@box_downSong = (req, res)->
			console.log 'BOX CALL: Downvote song '+req.body.songId+' on '+req.body.edisonId
			
			app.kaiseki.getObject 'Edison', req.body.edisonId, (err, resp, data, success) ->
				if err or !success
					console.error(err)
					res.send
						success: false
						message: 'Error preforming song request, try again.'
					return
			
				edison  = new Edison(app.kaiseki, data)
				edison.downvoteSong(req.body.index)
					
				res.send 
					success: true
					message: 'Song downvoted!'
				return
		
		@box_upSong = (req, res)->
			console.log 'BOX CALL: Upvote song '+req.body.songId+' on '+req.body.edisonId
			app.kaiseki.getObject 'Edison', req.body.edisonId, (err, resp, data, success) ->
				if err or !success
					console.error(err)
					res.send
						success: false
						message: 'Error preforming song request, try again.'
					return
			
				edison  = new Edison(app.kaiseki, data)
				edison.upvoteSong(req.body.index)
			
				res.send 
					success: true
					message: 'Song upvoted!'
				return
		
		@box_removeSong = (req, res)->
			console.log 'BOX CALL: Remove song '+req.body.songId+' from '+req.body.edisonId
			
			
			res.send 
				success: true
				message: 'Song removed!'
			return
		
		@playlist = (req, res) ->
			res.render 'user/playlist',
				title: 'Edit Playlist'