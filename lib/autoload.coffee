fs = require 'fs'
path = require 'path'

module.exports = autoload = (dir, app) ->
	return unless fs.existsSync dir 

	for file in fs.readdirSync(dir)
		pathname = path.join dir, file

		if fs.lstatSync(pathname).isDirectory()
			autoload pathname, app
		else
			require(__dirname + '/../' + pathname)?(app)