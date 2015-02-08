Edison = require('../models/edison')

# Any public page

module.exports = (app) ->
	class app.PublicController
		@index = (req, res) ->
			res.render 'public/index',
				title: 'Home'
		
		@search = (req, res) ->
			#Pass all names and edison
			app.kaiseki.getUsers (err,rese,body,success)->
				eds = for u in body
					name: u.locationName
					serial: u.edisonId
					owner: u.firstName + " " + u.lastName
			
				res.render 'public/search',
					title: 'Search for A CrowdBox',
					eds: eds
		
		@view = (req, res) ->
			app.kaiseki.getObject 'Edison',
				where:
					serial: req.query['serial']
				, (error, response, body, success)->
					if success
						data = 
							usingDefault: body[1].usingDefault
							twilioNumber: body[1].twilioNumber
							currentSong: body[1].currentSong
							serial: body[1].serial
							locationName: req.query['name']
							owner: req.query['owner']
							edisonId: body[1].objectId
							songs: body[1].currentPlaylist
							isOwner: false
						
						res.render 'user/box',
							title: 'public/view',
							data: data
						
					else
						console.log 'Error loading playlist'
						res.redirect '/search'
				
		@signin = (req, res) ->
			res.render 'public/signin',
				title: 'Sign in'
		@signin_post = (req, res)->
			req.session.signin = 0
			
			if req.body.email? and
			req.body.password?
				# check parse
				app.kaiseki.loginUser req.body.email, req.body.password,
					(error, response, body, success) ->
						# log the result
						msgs = []
						
						if success
							console.log 'login success'
							req.session.parseSessionToken = body.sessionToken
							req.session.firstName = body.firstName
							req.session.lastName = body.lastName
							req.session.email = body.email
							req.session.userId = body.objectId
							req.session.signin = 1
							res.redirect '/user/box'
							
							console.log JSON.stringify body
																							
						else
							console.log 'login failure'
							req.session.signin = 0			
							res.redirect '/signin'
				
			else
				res.redirect '/signin'
			
			
				
		########################################################		
		@signup = (req, res) ->
			res.render 'public/signup',
				title: 'Sign up'
		
		@signup_post = (req, res) ->
			edisonId = req.body.edison_id
			data = 
				firstName: req.body.first_name
				lastName: req.body.last_name
				email: req.body.email
				password: req.body.password
				locationName: req.body.location_name
				usingDefault: true
			
				#Check if email is user TODO
			console.log JSON.stringify data, undefined, 2
			console.log edisonId
			if data?
				#Get Edison, then creat account with it
				app.kaiseki.getObjects 'Edison',
					where:
						serial: edisonId
				, (err, resp, body, success)->
					if success
						#make user
						data.edisonId = edisonId
						data.username = data.email
						app.kaiseki.createUser data, (err, resp, body, success)->
							if success
								res.send 
									success: true
									message: "Account Created!"
							else 
								res.send 
									success: false
									message: "Problem creating account!"
							return
					else
						res.send 
							success: false
							message: " Invalid Serial Number " 
					return
			else
				res.send 
					success: false
					message: "Validation errors: " + util.inspect(errors)
			return
			
		