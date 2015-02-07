# Requires login

module.exports = (app) ->
	class app.UserController
		
		@box = (req, res) ->
			res.render 'user/box',
				title: 'Your CrowdBox'
		
		@playlist = (req, res) ->
			res.render 'user/playlist',
				title: 'Edit Playlist'