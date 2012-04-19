fs = require 'fs'
path = require 'path'
assert = require 'assert'
_ = require 'underscore'

liz = require '../liz'

describe 'liz', ->
    exampleDir =  path.join __dirname, 'example'
    output = path.join exampleDir, 'templates.js'
    firstFile = path.join(exampleDir, 'templates1.html') 
    secondFile = path.join(exampleDir, 'subfolder/moretemplates.html')

    it 'should collect matching files on multiple levels', ->                
        files = liz.findMatching exampleDir, '**/*.html'        

        assert _.contains files, firstFile
        assert _.contains files, secondFile

    it 'should collect templates from a file', ->
        templates = liz.extractTemplates firstFile
        keys = _.keys templates

        assert.equal keys.length, 2

        assert.equal templates["first.template"], "template {{one}}"
        assert.equal templates["second.template"], "template {{two}}"

    it 'should create an namespace list', ->
        names = [            
            'account'
            'user.address'
            'user.info.name'
            'account.details'
            'ns1.ns2.ns3'
        ]
        namespaces = liz.createNamespaces names        
        expectedNamespaces = [
            'account'
            'account.details'
            'ns1'
            'ns1.ns2'
            'ns1.ns2.ns3'
            'user'
            'user.address'
            'user.info'
            'user.info.name'
        ]
        assert.equal _.difference(namespaces, expectedNamespaces).length, 0
        assert.equal namespaces.length, expectedNamespaces.length        


