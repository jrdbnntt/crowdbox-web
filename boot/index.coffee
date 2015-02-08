app = require('express')()
server = require('http').Server(app)
io = require('socket.io')(server)
server.listen 5000
app.get '/', (req, res) ->
  res.sendfile __dirname + '/index.html'
  return
io.on 'connection', (socket) ->
  socket.emit 'fuck', hello: 'world'
  socket.on 'my other event', (data) ->
    console.log data
    return
  return