###
# Loads module dependencies and configures app.
#
# Author: Trevor Helms
###

# Module dependencies
bodyParser = require 'body-parser'
validator = require 'express-validator'
Mandrill = require 'mandrill-api/mandrill'
autoload = require '../lib/autoload'
session = require 'express-session'
dotenv = require 'dotenv'
acl = require '../lib/acl'
emailTemplates = require 'email-templates'
kaiseki = require 'kaiseki'

# Configuration
module.exports = (app) ->
	# Autoload controllers
	autoload 'app/controllers', app
	
	# Load env
	dotenv.load()
	
	app.models = models
	
	# sequelize = new Sequelize(con)
	
	# Configure app settings
	env = process.env.NODE_ENV || 'development'
	app.set 'port', process.env.PORT || 5000
	app.set 'views', __dirname + '/../app/views'
	app.set 'view engine', 'jade'
	app.use require('express').static __dirname + '/../public'
	app.use validator()
	app.use bodyParser.json()
	app.use bodyParser.urlencoded {extended: true} 
	
	# Development settings
	if (env == 'development')
		app.locals.pretty = true
		
	#Session settings
	app.use session 
		name: 'connect.sid'
		secret: process.env.SECRET + ' '
		cookie:
			maxAge: 864000		#10 days
		saveUninitialized: false
		resave: false
	app.use (req,res,next) ->
		res.locals.session = req.session;
		next();
	
	# Create Mandrill object
	app.mandrill = new Mandrill.Mandrill process.env.MANDRILL_KEY  
	# Load email template function
	app.emailTemplates = emailTemplates
	
	###
	# Sends email using the email-templates and mandrill libraries
	# @param eName = templateDirName (string)
	# @param eData = relevant sending data (see example)
	###
	app.emailTemplate = (eName,eData) ->
		# EXAMPLE eData
		# eData =
		# 	to_email: 'jrdbnntt@gmail.com'
		# 	from_email: 'register@hackfsu.com'
		# 	from_name: 'HackFSU'
		# 	subject: 'Rad Submission, Man'
		# 	locals:
		# 		firstName: "Jared"
		# 		lastName: "Bennett"
		# 	success: function(to_email) #called after mandrill success
		# 	error: function(to_email) #called after mandrill error
		
		# if eName && eData.emailTo && eData.locals
		
		path = require 'path'
		templatesDir = path.resolve(__dirname,'..', 'emails')
		app.emailTemplates templatesDir,  (err, template) ->
			if err
				console.log err
			else
				locals = eData.locals
				Render = (locals) ->
					this.locals = locals
					this.send = (err,html,text) ->
						# console.log " > EMAIL HTML:"
						# console.log html
						# console.log " > EMAIL TEXT:"
						# console.log text
						
						if !err
							console.log ' > Email-templates - Creation success'
							message = 
								html: html
								text: text
								subject: eData.subject
								from_email: eData.from_email
								from_name: eData.from_name
								to: [
									email: eData.to_email
									name: if eData.locals.firstName || 
										eData.locals.lastName then eData.locals.firstName + 
										' ' + eData.locals.lastName else eData.to_email
									type: 'to'
								]	
								
							app.mandrill.messages.send 'message': message, 'async': true, 
								(result) ->
									console.log ' > Mandrill - Email Sent Success - eData= ' + JSON.stringify eData
									if eData.success
										eData.success(eData.to_email)
								, (e) ->
									console.log ' > Mandrill - Error: ' + e.name + ' - ' + e.message
									if eData.error
										eData.error(eData.to_email)
						else
							console.log ' > Email-templates - Error: ' + err
							
					this.batch = (batch) ->
						batch this.locals, templatesDir, this.send
					
					return
				
				template eName, true, (err, batch) ->
					if this.err
						console.log this.err
					else
						render = new Render(locals)
						render.batch(batch)
					return
		# else
		# 	console.log
		# 	return null
		return
	
	
	# Enforce ACL (needs to be last)
	# app.use acl
	
	#debug crap
	console.log 'ENV VARS ->'
	console.log "> SECRET=" + process.env.SECRET
	console.log '> MANDRILL_KEY=' + process.env.MANDRILL_KEY
	console.log '-------------------------------'
		
		
			
