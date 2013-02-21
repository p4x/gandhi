We love pull requests. Here's a quick guide:

1. Fork the repo.

2. Run the tests.

Unit/functional:
```bash
rake```

Acceptance (powered by CasperJS + PhantomJS)

First, fire up the Gandhi app in the rails test environment:
```bash
./script/serve-casper
```

Run the CasperJS tests with:
```bash
rake casper
```

3. Add a test for your change.

4. Make the tests pass!

5. Push to your fork and submit a pull request.

Syntax:

* Two spaces, no tabs.
* No trailing whitespace. Blank lines should not have any space.
* Use JavaScript for new js in app/assets
* Use CoffeeScript for new CasperJS tests (for consistency)

Note: this guide is based on thoughtbot's factory_girl contributing guide:
https://github.com/thoughtbot/factory_girl_rails/blob/master/CONTRIBUTING.md

Thanks, thoughtbots!
