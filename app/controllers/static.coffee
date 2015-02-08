# Static pages page

module.exports = (app) ->
	class app.StaticController
		
		@createEdison = (req,res) ->
			#create random default edison in parse, then go to '/'
			edison = 
				serial: Math.floor(Math.random()*1000000000).toString()
				usingDefault: false
				twilioNumber: '000-000-0000'
				currentSong: -1 #flag for none
				currentPlaylist: new Array()
				defaultPlaylist: new Array()
			
			app.kaiseki.createObject 'Edison', edison,
			(err,resp,body,success)->
				if success
					console.log 'CREATED EDISON'
				else
					console.log 'ERROR CREATING EDISON'
				console.log  JSON.stringify edison, undefined, 2
				
				res.redirect '/'
				
			return
		
		@edisonSync = (req,res) ->
			