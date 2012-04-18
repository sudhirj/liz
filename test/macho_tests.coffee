fs = require 'fs'
path = require 'path'
assert = require 'assert'
_ = require 'underscore'

macho = require '../macho'

describe 'macho', ->
    it 'should collect matching files on multiple levels', ->
        exampleDir =  path.join __dirname, 'example'
        output = path.join exampleDir, 'templates.js'
        if fs.existsSync output then fs.unlinkSync output
        
        files = macho.findMatching exampleDir, '**/*.html'        
        
        assert _.contains files, path.join(exampleDir, 'templates1.html') 
        assert _.contains files, path.join(exampleDir, 'subfolder/moretemplates.html')



