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

* You can run Stacktician in NOOP mode: in this case it will not try to create resources on CloudStack, but just update the database with success. Before you run the Rails server:

```
$ export DEMO_MODE=NOOP
```

Otherwise, the following environment variables need to be set (change to your environment's specifics)

```
CS_URL=http://localhost:8080/client/api
CS_ADMIN_APIKEY=6b4IAqDFqSfpBqap1GEhKS4U8PIOpxnoS0tuAX46jXAiE7hCBO-l2zKvWm-FuyTQUFddfR59oNqMSUbSCZgoQw
CS_ADMIN_SECKEY=WM9HIBLc59XYhr2kCAS94eCrGp789cSYwSys1pgEUuV2_rhFxej8vds-sd9eMu6RtxM7Kk0K0k9G8Rtl1oxl-A
CS_LOCAL="---\nservice_offerings:\n  m1.small: 1c8db272-f95a-406c-bce3-39192ce965fa\ntemplates:\n  ami-1b814f72: 3ea4563e-c7eb-11e2-b0ed-7f3baba63e45\nzoneid: b3409835-02b0-4d21-bba4-1f659402117e\n"
```

CS_LOCAL is a YAML string that provides the mappings from AWS entities to your CloudStack entities.

* Heroku

There should be a demo app (NOOP mode) running at http://stacktician.herokuapp.com/
If you want to deploy to Heroku, you can use heroku config:set to set the environment variables.


* Stacktician lets you self-create a login. Sign in and create a Cloudformation stack!


## TODO
* Query-based API server (http://awsdocs.s3.amazonaws.com/AWSCloudFormation/latest/qrc_cfn_api.pdf)
* Allow users to specify stack template URL
* Update stack / delete stack
* Metadata server to serve cfn-get-metadata
* Performance (use queue (Resque for ex)  to queue API jobs)
* Rollback

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

