#Macho

Macho lets you organize your JS templates in any file and directory structure that you want, and compiles all your templates into one tight JS file when run. 

Macho is specially built to work with [Hogan.js](http://twitter.github.com/hogan.js/), but it can be adapted to help you with plain [Mustache](http://mustache.github.com/) (or any other) templating engine. It derives heavily from and is a lot like [`hulk`](https://github.com/twitter/hogan.js/blob/master/bin/hulk), except that you don't need to have one template per file. 

##Usage

```
$ npm install macho -g
$ macho <input_path> <output_file>
```
For instance, if you've got 
####templates/users.html

    <template name="user.greeting">
        <p>Hello, {{name}}</p>
    </template>

    <script name="user.outro" type="text/x-mustache">
        </p></div>And that's the end of it.
    </script>

Using `template` tags is easier - most editors will continue to give you HTML syntax highlighting and help. Or you can use `script` tags like [John Resig says](http://ejohn.org/blog/javascript-micro-templating/); especially when you're writing templates that don't validate as HTML.

Running 

    $ macho templates/**/*.html templates.js

should give you   


####templates.js 
    module.exports.user = {};
    module.exports.user.greeting = new Hogan.Template(function(c,p,i){var _=this;_.b(i=i||"");_.b("<p>Hello, ");_.b(_.v(_.f("name",c,p,0)));_.b("</p>");return _.fl();;});
    module.exports.user.outro = new Hogan.Template(function(c,p,i){var _=this;_.b(i=i||"");_.b("</p></div>And that's the end of it.");return _.fl();;});
    
    
   



   


    








 