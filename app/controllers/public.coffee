# Any public page

module.exports = (app) ->
	class app.PublicController
		
		@index = (req, res) ->
			res.render 'public/index',
				title: 'Home'
		
		@search = (req, res) ->
			res.render 'public/search',
				title: 'Search for CrowdBox'
		
		@view = (req, res) ->
			res.render 'public/view',
				title: 'View CrowdBox'
				
		@signin = (req, res) ->
			res.render 'public/signin',
				title: 'Sign in'
				
		########################################################		
		@signup = (req, res) ->
			res.render 'public/signup',
				title: 'Sign up'
		
		@signup_post = (req, res) ->
			data = 
				first_name: req.body.first_name
				last_name: req.body.last_name
				email: req.body.email
				password: req.body.password
				edison_id: req.body.edison_id
				location_name: req.body.location_name
			
				#Check if email is user TODO
			console.log JSON.stringify data, undefined, 2
			if data?
				sql = "INSERT INTO user " + 
				'(first_name,last_name,email,password,edison_id) VALUES '+
				'("'+data.first_name+'","'+data.last_name+'","'+data.password+'",'+data.edison_id+')'
				# 'WHERE EXISTS(SELECT * FROM edison WHERE edison_id = ' + data.edison_id + ')'
				console.log sql
				app.db.con.query sql, (err, result)->
					if err
						res.send 
							success: false
							message: "Saving errors: " + err
						return
					else
						#update location
						sql = "UPDATE edison SET location_name = "+data.location_name+
						"WHERE edison_id = " + data.edison_id
						app.db.con.query sql, (err, result)->
							if err
								res.send 
									success: false
									message: "Saving errors: " + err
								return
							else
								res.send 
									success: true
									message: "Save suclcess!"
				
				
				
			else
				res.send 
					success: false
					message: "Validation errors: " + util.inspect(errors)
			return