# Stacktician - CloudFormation web front-end for stackmate

[stackmate](https://github.com/chiradeep/stackmate.git) reads existing CloudFormation templates 
and executes them on a CloudStack deployment
Unlike CloudFormation, it does not (yet) run as a web application. 
Instead it runs everything on the client side. 

Stacktician embeds stackmate to provide the web front-end using a Rails application


Follow:
* \#cloudstack-dev on Freenode
* <http://cloudstack.apache.org/mailing-lists.html>
* [@chiradeep](http://twitter.com/chiradeep) on Twitter

## Dependencies

Stacktician uses [Bundler](http://gembundler.com/) to setup and maintain its
environment. Before running stackmate for the first time you need to install
Bundler (gem install bundler) and then run:

```bash
$ bundle install

```


## Getting started quickly

### Using the source

* Get the source files using git

```bash
$ git clone http://github.com/chiradeep/stacktician.git
$ cd stacktician
```

* Make sure every dependency is resolved

```bash
$ bundle install
```

* Create a seed of templates in the database

```bash
$ rake db:migrate
$ rake db:seed
```

* Stacktician lets you self-create a login. Sign in and create a Cloudformation stack!


## TODO
* Actually embed stackmate, after making stackmate a gem
* Admin interface to set up the CloudStack endpoint and API keys for the user

## Feedback & bug reports

Feedback and bug reports are welcome on the [mailing-list](dev@cloudstack.apache.org), or on the `#cloudstack-dev` IRC channel at Freenode.net.

## License

(The MIT License)

Copyright (c) 2013 Chiradeep Vittal

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Thanks

- The Ruby on Rails Tutorial (http://ruby.railstutorial.org/book/ruby-on-rails-tutorial) for a quick start

