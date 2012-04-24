#Template Management for Hogan.js

Liz is a manger for [Hogan.js](http://twitter.github.com/hogan.js/) templates. lets you organize and manage your JS templates in any file and directory structure that you want - it then compiles all your templates into one compact executable JS file. 

Liz can also be adapted to help you with plain [Mustache](http://mustache.github.com/) (or any other) templating engine. It is similar to [`hulk`](https://github.com/twitter/hogan.js/blob/master/bin/hulk), except that you don't need to have one template per file. Liz also **namespaces** your temlates based so you can access them easily in code.  

###Usage

First do:

```
$ npm install liz -g
$ liz <input_files> -o <output_file>
```
Then write your templates in `template` or `script` tags:
    
    <!--templates/users.html-->

    <template name="user.greeting">
        <p>Hello, {{name}}</p>
    </template>

    <script name="user.outro" type="text/x-mustache">
        </p></div>And that's the end of it.
    </script>

Using `template` tags is usually easier - most editors will continue to give you HTML syntax highlighting and help. Or you can use `script` tags like [John Resig says](http://ejohn.org/blog/javascript-micro-templating/); especially when you're writing templates that don't validate as HTML.

Then run:

    $ liz templates/**/*.html -o templates.js

And you have:   


    // templates.js 
    var hogan = require('hogan.js');
    exports.user = {};
    exports.user.greeting = new Hogan.Template(function(c,p,i){var _=this;_.b(i=i||"");_.b("<p>Hello, ");_.b(_.v(_.f("name",c,p,0)));_.b("</p>");return _.fl();;});
    exports.user.outro = new Hogan.Template(function(c,p,i){var _=this;_.b(i=i||"");_.b("</p></div>And that's the end of it.");return _.fl();;});

You can then render templates easily in your code:

    templates = require('./templates');
    templates.user.greeting.render({name: 'Miss Elizabeth'});
    
###Roadmap
* Browsers will work only if your project uses [Stitch][stitch] or [OneJS](https://github.com/azer/onejs) - change this so `require` and `exports` code can be turned off with a flag. 
* Support for other templating engines. 

###Contributions
Well tested (preferably TDD'd) contributions are welcome via pull requests. Personally Liz already fits all my needs - I'm using Hogan.js and [Stitch][stitch] - so most of the roadmap will have to be driven by contributions. 

[stitch]:https://github.com/sstephenson/stitch

