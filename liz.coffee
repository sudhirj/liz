glob = require 'glob'
path = require 'path'
select = require('soupselect').select
parser = require 'htmlparser'
u = require 'util'
fs = require 'fs'
sets = require 'simplesets'

module.exports.findMatching = findMatching = (basePath, pattern) ->
    glob.sync(pattern, {cwd: basePath}).map (file) -> path.join basePath, file

module.exports.extractTemplates = extractTemplates = (file) ->    
    templates = {}
    handler = new parser.DefaultHandler (err, dom) ->
        if err then u.debug err
        select(dom, 'template').forEach (template) ->
            templates[template.attribs.name] = template.children[0].raw.trim()
    
    parser = new parser.Parser handler
    parser.parseComplete fs.readFileSync file, 'utf-8'
    templates

module.exports.createNamespaces = createNamespaces = (names) ->
    nameSet = new sets.Set names
    namespaces = new sets.Set []

    nameSet.each (name) ->
        parts = name.split '.'
        parts.reduce (ns, part) ->
            ns.push part            
            namespaces.add ns.join '.'
            ns
        , []
    namespaces.array().sort()

