fs = require 'fs'
path = require 'path'
assert = require 'assert'
_ = require 'underscore'
hogan = require 'hogan.js'
util = require 'util'
liz = require '../liz'

describe 'liz', ->
    exampleDir =  path.join __dirname, 'example'
    outputFile = path.join exampleDir, "templates#{new Date().toISOString()}.js"
    firstFile = path.join(exampleDir, 'templates1.html') 
    secondFile = path.join(exampleDir, 'subfolder/moretemplates.html')
    glob = '**/*.html'
    

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
        if path.existsSync outputFile then fs.unlinkSync outputFile
        liz.manage [firstFile, secondFile], outputFile
        assert path.existsSync outputFile        
        templates = require outputFile        
        assert.equal templates.third.template.render({three: '3'}), 'template 3'
        assert.equal templates.second.template.render({two: '2'}), 'template 2'
        assert.equal _.keys(templates.second).length, 1
        if path.existsSync outputFile then fs.unlinkSync outputFile
        

        

