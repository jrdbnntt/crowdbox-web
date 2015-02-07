# Create express app
app = require('express')()

# Configure app
require('./config')(app)

# Set up routes
require('./routes')(app)

# Boot server
app.listen app.get('port'), ->
	console.log 'Listening on port ' + app.get('port')