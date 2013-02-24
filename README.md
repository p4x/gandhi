Gandhi, the App
===============

*Gandhi, the App* is a Ruby on Rails application that allows parties to communicate privately using a shared passphrase.

[Try the Demo App now](http://gandhi-demo.herokuapp.com/ "Gandhi demo app")
-----------------------------------------------------------------

A demo of *Gandhi, the App* is online at:

[http://gandhi-demo.herokuapp.com/](http://gandhi-demo.herokuapp.com/)


Screenshots
-----------

![Gandhi - Home](https://raw.github.com/p4x/gandhi/master/doc/screenshots/for_github/gandhi_home.png)

![Gandhi - Create Message](https://raw.github.com/p4x/gandhi/master/doc/screenshots/for_github/gandhi_create_message.png)

![Gandhi - Read Message](https://raw.github.com/p4x/gandhi/master/doc/screenshots/for_github/gandhi_read_message.png)


How Gandhi Works
----------------
Let's say you want to communicate securely and privately with a friend or trusted partner.

First, find a trusted *Gandhi*-powered website, or alternatively, you could set one up yourself. Next, tell your friend via a secure channel which *Gandhi* server you are going to use. Share with them (ahead of time) an agreed-upon passphrase (any UTF-8 string of characters, including letters, numbers, spaces, special characters--even Braille!--up to 255 characters long).

(If you want to get crafty, you could even tell your friend, "Check the NY Times each day. The passphrase will the be seventh word of the front-page article, the last word of the lead op-ed piece, and the predicted high temperature for Manhattan tomorrow.")

Next, visit the agreed-upon *Gandhi* server using any web browser. Enter your message text and passphrase (where you can also specify message expiration and self-destruct settings as well).

Anytime before your message is set to expire, your friend would then visit the same *Gandhi* server, type in the shared passphrase, and read your message.


Potential Uses
--------------

Gandhi was designed for maximum flexibility and thus can be used for many purposes, such as:

+ For whistleblowers and reporters to communicate securely
+ For organizing a peaceful protest ("Let's meet at Tahrir square at 2pm")
+ For political dissidents to communicate freely in a climate of censorship
+ For sharing banned texts (share *The Catcher in the Rye* in Tehran, or *Zhuan Falun* in Beijing)
+ For flirting with secret lovers
+ For joking around with friends, without pesky chat log transcripts
+ ... and sharing ASCII pictures of cats, of course.

In addition, Gandhi ships with a builtin API so that you can:
+ Roll your own mobile client
+ Build command-line tools
+ etc!

Installation
------------

*Gandhi, the App* is a standard Ruby on Rails 3.2.x application. Installation is fairly straightforward.

Dependencies:
+ Ruby 1.9.3
+ PostgreSQL

**Configurations that are known to work well with Gandhi**

Development environment:
+ OS X Mountain Lion
+ Ruby 1.9.3 (via RVM)
+ PostgreSQL 9.2.2

Have you deployed Gandhi in production? Let us know!

You should probably use Gandhi over SSL to prevent a variety of attacks, but for flexibility this is not a strict requirement.

**How to Install**

Checkout the repository:
```bash
git clone https://github.com/p4x/gandhi.git
```

Change directories into the app dir (of course!).

Install gems via Bundler:
```bash
bundle install
````

Run the gandhi rake setup task:
```bash
rake gandhi:setup
```

This is simply a rake task that runs two sub-tasks ('rake gandhi:copy_settings' and 'rake gandhi:salt').

You can run these tasks independently as well (if you'd like).

Copy the exeample settings file to RAILS_ROOT/config/settings.yml by running:
```bash
rake gandhi:copy_settings
```

Generate application-wide salts (one for the JavaScript client, one for rails):
```bash
rake gandhi:salt
```

Next, copy 'config/database.example.yml' to 'config/database.yml' and setup your database. It may be as simple as running:
```bash
rake db:create
```

Run the migrations
```bash
rake db:migrate
```

Start the app:
```bash
rails server
```

If all went well, your new Gandhi app should be up and humming like a well-oiled machine!

Builtin API
-----------

*Gandhi, the App* ships with a builtin API, so you can roll your own mobile client, command-line tools, etc.

There are only two API methods: create_message and view_message

See app/controllers/api_controller.rb for more details.

Note: Gandhi will let you submit *un*-encrypted data via the API. This is why data is encrypted a second time on the server, just in case the client is submitting raw, unencrypted message text. (this is unadvisable, yet possible)

License
-------

Gandhi is released under the MIT License. See LICENSE for more info.

Contributing
------------

See CONTRIBUTING.md for more info.

Fairly usual/straightforward guide to contributing: fork the repo, get the tests passing, add your changes, add passing tests, push your fork and submit a pull request.


On the Shoulder of Giants
----------------------------------------------

We'd like to thank the creators of the following libraries and frameworks. Without their contributions, *Gandhi* would not be possible.

+ Ruby http://www.ruby-lang.org/
+ Ruby on Rails http://rubyonrails.org/
+ jQuery http://jquery.com/
+ CryptoJS http://code.google.com/p/crypto-js
* jQuery Validation Plugin https://github.com/jzaefferer/jquery-validation
* jQuery showpassword Plugin http://unwrongest.com/projects/show-password/
* Twitter Bootstrap http://twitter.github.com/bootstrap/
* PostgreSQL http://www.postgresql.org/
* pg gem https://rubygems.org/gems/pg
* pbkdf2 gem https://rubygems.org/gems/pbkdf2
* Thin web server http://code.macournoyer.com/thin/
* CasperJS http://casperjs.org/
* PhantomJS http://phantomjs.org/

A Guide to Testing Gandhi
-------------------------

First, setup your test database in config/database.yml.

Create your test database:
```bash
rake db:create
```

Or manually via psql, Navicat, etc.

Run the unit/functional tests:
```bash
rake
```

To run the acceptance tests (written in CasperJS), first start the rails app under the test environment.

The `./script/serve-casper` script sets up the test database and starts the server on the expected port (31337).

Start the rails app for the test environment:
```bash
./script/serve-capser
```

Visit `http://localhost:31337/` and ensure that the app is running.

Install node.js if you have not done so already.

Install coffeelint:
```bash
npm install -g coffeelint
```

Install PhantomJS via homebrew:
```bash
brew update && brew install phantomjs
```

Install CasperJS via homebrew:
```bash
brew install casperjs
```

You should now be ready to run the CasperJS tests.

Execute the CasperJS tests using the following rake task:
```bash
rake casper
```

Good luck!

*[ Be the change. Use gandhi for good. -pax ]*


