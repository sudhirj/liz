glob = require 'glob'
path = require 'path'

module.exports.findMatching = findMatching = (basePath, pattern) ->
    glob.sync(pattern, { cwd: basePath }).map (file) -> path.join basePath, file



