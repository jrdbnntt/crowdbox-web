###
	Handles ACL, run before each HTTP reqest.
	Blocks request if not allowed. Only checks for restriced paths
###

module.exports = acl = (req,res,next) ->
	isAllowedAccess = true
	
	path = req.path.split '/'
	
	# path[1] = controller
	
	`
	switch(path[1]) {
		case "user":
			if(res.locals.session.signin != 1)
				isAllowedAccess = false;
		break;
	}
	`
	
	
	if isAllowedAccess
		next()
	else
		# Does not have access to this page
		res.redirect '/'
		
		# res.render 'public/error',
		# 	title: "Error!"
		# 	errorData: 
		# 		msg: "Access Denied. Please sign in to access this page."
		# 		returnLocation: "/signin"
		# 		returnMsg: "Sign in"
	