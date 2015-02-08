###
	Specify all routes here.
	
###

module.exports = (app) ->
	####################################################
	# Public Access
	####################################################
	
	# Home
	app.get '/', app.PublicController.index
	app.get '/index', app.PublicController.index
	app.get '/home', app.PublicController.index
	
	# Search
	app.get '/search', app.PublicController.search
	
	# View
	app.get '/view', app.PublicController.view
	
	# Signin
	app.get '/signin', app.PublicController.signin
	app.post '/signin_post', app.PublicController.signin_post
	
	# Signup
	app.get '/signup', app.PublicController.signup
	app.post '/signup_post', app.PublicController.signup_post
	
	####################################################
	# User Access
	####################################################
	
	# Edit Crowdbox (as a whole)
	app.get '/user/box', app.UserController.box
	app.post '/box/box_addSong', app.UserController.box_addSong
	app.post '/box/box_downSong', app.UserController.box_downSong
	app.post '/box/box_upSong', app.UserController.box_upSong
	app.post '/user/box_removeSong', app.UserController.box_removeSong
	
	# Edit Playlist (+ playlist id)
	app.get '/user/playlist', app.UserController.playlist

	
	####################################################
	# Twilio Access
	####################################################
	
	# Receive message
	app.post '/twilio/receive', app.TwilioController.receive

	
	
	
	####################################################
	# Static Pages
	####################################################
	# Create new Edison
	app.get '/parse/createEdison', app.StaticController.createEdison
	
	# Page not found (404)
	# This should always be the LAST route specified
	app.get '*', (req, res) ->
		res.render '404', title: 'Error 404'
		
		
		# [
		# 	{
		# 		"id":"fhpwCXN5wf",
		# 		"vote":"2"
		# 	},
		# 	{
		# 		"id":"kx1QBg9war",
		# 		"vote":"-3"
		# 	}
		# ]
		# 