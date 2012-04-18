// Generated by CoffeeScript 1.3.1
var findMatching, glob, path;

glob = require('glob');

path = require('path');

module.exports.findMatching = findMatching = function(basePath, pattern) {
  return glob.sync(pattern, {
    cwd: basePath
  }).map(function(file) {
    return path.join(basePath, file);
  });
};
