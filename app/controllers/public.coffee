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
				title: 'Signin'
				
		@signup = (req, res) ->
			res.render 'public/signup',
				title: 'Signup'