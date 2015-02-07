# Requires login

module.exports = (app) ->
	class app.UserController
		
		@box = (req, res) ->
			res.render 'public/box',
				title: 'Your CrowdBox'
		
		@playlist = (req, res) ->
			res.render 'public/playlist',
				title: 'Edit Playlist'