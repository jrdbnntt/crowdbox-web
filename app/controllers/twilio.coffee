twilio = require('twilio')
handler = require('../helpers/twilio-handler')
Edison = require('../models/edison')

# Security by obscurity #hellyeah

module.exports = (app) ->
	class app.TwilioController
		
		@receive = (req, res) ->
			console.log 'received msg', JSON.stringify req.body, undefined, 2
			Edison.findByNumber(req.body.To, app.kaiseki).then (edison) ->
				handler(edison, req.body.Body)
			.then (txt) ->
				twiml = new twilio.TwimlResponse()
				twiml.message(txt)
				res.type('text/xml')
				res.send(twiml.toString())
			, (err) ->
				console.log("err: #{err}")