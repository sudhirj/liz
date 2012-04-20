// Generated by CoffeeScript 1.3.1
var buildFunctions, createNamespaces, extractTemplates, findMatching, fs, glob, hogan, htmlparser, manage, path, select, sets, u, _;

glob = require('glob');

path = require('path');

select = require('soupselect').select;

u = require('util');

fs = require('fs');

sets = require('simplesets');

htmlparser = require('htmlparser');

hogan = require('hogan.js');

_ = require('underscore');

module.exports.findMatching = findMatching = function(basePath, pattern) {
  return glob.sync(pattern, {
    cwd: basePath
  }).map(function(file) {
    return path.join(basePath, file);
  });
};

module.exports.extractTemplates = extractTemplates = function(file) {
  var handler, parser, templates;
  templates = {};
  handler = new htmlparser.DefaultHandler(function(err, dom) {
    var loadTemplates;
    if (err) {
      u.debug(err);
    }
    loadTemplates = function(template) {
      return templates[template.attribs.name] = template.children[0].raw.trim();
    };
    select(dom, 'template').forEach(loadTemplates);
    return select(dom, 'script').forEach(loadTemplates);
  });
  parser = new htmlparser.Parser(handler);
  parser.parseComplete(fs.readFileSync(file, 'utf-8'));
  return templates;
};

module.exports.createNamespaces = createNamespaces = function(names) {
  var nameSet, namespaces;
  nameSet = new sets.Set(names);
  namespaces = new sets.Set([]);
  nameSet.each(function(name) {
    return name.split('.').reduce(function(ns, part) {
      ns.push(part);
      namespaces.add(ns.join('.'));
      return ns;
    }, []);
  });
  return namespaces.array().sort();
};

module.exports.buildFunctions = buildFunctions = function(templates) {
  return _.keys(templates).reduce(function(container, key) {
    container[key] = hogan.compile(templates[key], {
      asString: true
    });
    return container;
  }, {});
};

module.exports.manage = manage = function(base, parseGlob, outputFile) {
  if (path.existsSync(outputFile)) {
    return fs.unlinkSync(outputFile);
  }
};
