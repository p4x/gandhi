url = "http://localhost:31337/"

casper = require("casper").create(
  verbose: true
  logLevel: "debug"
  remoteScripts: ["/assets/application.js"]
)

casper.start url, ->
  @test.assertMatch(@getTitle(), /gandhi/i, 'Gandhi is in the title')
  @test.assertExists('a[href="/gandhi/new"]', 'has a link to the create message page')
  @click('a[href="/gandhi/new"]')

casper.then ->
  @test.assertMatch(@getTitle(), /create message/i, 'create message is in the title')
  @test.assertNotVisible('div#messageCreatedModal', 'message created modal should be hidden')
  @fill('form#new-message', {
    'body':    'hello world',
    'passphrase':       'swordfish lulz 69'
    })
  @click('button[type="submit"]')
  @wait 10000, ->
    @echo "waited ..."
    @test.assertVisible('div#messageCreatedModal', 'message created modal should be visible')
    @test.assertExists('div[id="message-created"]', 'message was created')
    @click('button[data-dismiss="modal"]')
    @wait 1000, ->
      form_vals = @getFormValues('form#new-message')
      @echo "Passphrase: " + form_vals.passphrase
      #info = @getElementInfo('#message-body')
      #body = @valuate ->
      #  document.querySelector('#message-body').value
      @echo "MSG TEXT: " + form_vals.body
      @test.assert( form_vals.body is '', 'message body should be set to blank now')
      @test.assert( form_vals.passphrase is '', 'passphrase should be set to blank now')
      #@test.assert( form_vals.)
#      message_body = @getElementAttribute('#message-body', 'value')
#      @echo "Message body: " + message_body
#      @test.assert( (@getElementAttribute('#message-body', 'value') is ''), 'message body in form should be blank now')
      #text = @fetchText('form#new-message')
      #@echo "Textarea body: " + text

casper.run ->
  @test.done 8
  @test.renderResults true
