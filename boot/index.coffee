# app = require('express')()
# server = require('http').Server(app)
# io = require('socket.io')(server)
# server.listen 5000
# app.get '/', (req, res) ->
#   res.sendfile __dirname + '/index.html'
#   return
# io.on 'connection', (socket) ->
#   socket.emit 'fuck', hello: 'world'
#   socket.on 'my other event', (data) ->
#     console.log data
#     return
#   return

# Create express app
app = require('express')()

# Configure app
require('./config')(app)

# Set up routes
require('./routes')(app)

#boot server
app.listen app.get('port'), ()->
	console.log 'Listening on port ' + app.get('port')