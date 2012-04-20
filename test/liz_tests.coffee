fs = require 'fs'
path = require 'path'
assert = require 'assert'
_ = require 'underscore'
hogan = require 'hogan.js'

liz = require '../liz'

describe 'liz', ->
    exampleDir =  path.join __dirname, 'example'
    output = path.join exampleDir, 'templates.js'
    firstFile = path.join(exampleDir, 'templates1.html') 
    secondFile = path.join(exampleDir, 'subfolder/moretemplates.html')
    glob = '**/*.html'

    it 'should collect matching files on multiple levels', ->                
        files = liz.findMatching exampleDir, glob        

        assert _.contains files, firstFile
        assert _.contains files, secondFile

    it 'should collect templates from a file', ->
        templates = liz.extractTemplates firstFile
        keys = _.keys templates

        assert.equal keys.length, 2

        assert.equal templates["first.template"], "template {{one}}"
        assert.equal templates["second.template"], "template {{two}}"

        moreTemplates = liz.extractTemplates secondFile
        keys = _.keys moreTemplates

        assert.equal keys.length, 1
        assert.equal moreTemplates["third.template"], "template {{three}}"

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

    it 'should create hogan.js function strings', ->
        templates = {
            't1': 'hello {{world}}'
            't2': 'bye bye {{thing}}'
        }
        
        compiledTemplates = liz.buildFunctions(templates)

        t1 = eval "new hogan.Template(#{compiledTemplates.t1})"
        t2 = eval "new hogan.Template(#{compiledTemplates.t2})"
        assert.equal 'hello earth', t1.render {world: 'earth'}
        assert.equal 'bye bye love', t2.render {thing: 'love'}

    it 'should tie it all together', ->
        if path.existsSync output then fs.unlinkSync output
        liz.manage exampleDir, glob, output
        assert path.existsSync output
        

        

