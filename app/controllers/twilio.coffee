twilio = require('twilio')
handler = require('../helpers/twilio-handler')
Edison = require('../models/edison')

# Security by obscurity #hellyeah

module.exports = (app) ->
	class app.TwilioController
		
		@receive = (req, res) ->
			Edison.findByNumber(req.body.To).then (edison) ->
				handler(edison, req.body.Body)
			.then (txt) ->
				twiml = new twilio.TwimlResponse()
				twiml.message(txt)
				res.type('text/xml')
				res.send(twiml.toString())
