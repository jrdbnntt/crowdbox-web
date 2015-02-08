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
			
		
		@playlist = (req, res) ->
			res.render 'user/playlist',
				title: 'Edit Playlist'