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
	
	# Edit Playlist (+ playlist id)
	app.get '/user/playlist', app.UserController.playlist
	
	
	
	####################################################
	# Static Pages
	####################################################
	# Create new Edison
	app.get '/parse/createEdison', app.StaticController.createEdison
	
	
	# Page not found (404)
	# This should always be the LAST route specified
	app.get '*', (req, res) ->
		res.render '404', title: 'Error 404'