glob = require 'glob'
path = require 'path'
select = require('soupselect').select
u = require 'util'
fs = require 'fs'
sets = require 'simplesets'
htmlparser = require 'htmlparser'
hogan = require 'hogan.js'
_ = require 'underscore'

module.exports.findMatching = findMatching = (basePath, pattern) ->
    glob.sync(pattern, {cwd: basePath}).map (file) -> path.join basePath, file

module.exports.extractTemplates = extractTemplates = (file) ->        
    templates = {}

    handler = new htmlparser.DefaultHandler (err, dom) ->
        if err then u.debug err
        loadTemplates = (template) -> templates[template.attribs.name] = template.children[0].raw.trim()
        select(dom, 'template').forEach loadTemplates
        select(dom, 'script').forEach loadTemplates
                
    parser = new htmlparser.Parser handler
    parser.parseComplete fs.readFileSync file, 'utf-8'
    templates

module.exports.createNamespaces = createNamespaces = (names) ->
    nameSet = new sets.Set names
    namespaces = new sets.Set []

    nameSet.each (name) ->        
        name.split('.').reduce (ns, part) ->
            ns.push part            
            namespaces.add ns.join '.'
            ns
        , []

    namespaces.array().sort()

module.exports.buildFunctions = buildFunctions = (templates) ->
    _.keys(templates).reduce (container, key) ->         
        container[key] = hogan.compile templates[key], {asString: true}
        container
    , {}

module.exports.manage = manage = (base, parseGlob, outputFile) ->
    if path.existsSync outputFile then fs.unlinkSync outputFile


    
    
