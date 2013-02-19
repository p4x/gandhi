url = "http://localhost:31337/gandhi/new"
home = "http://localhost:31337/"

casper = require("casper").create(
  verbose: true
  logLevel: "debug"
  remoteScripts: ["/assets/application.js"]
)

passphrase = 'abcdefgHIJKLMN123456789!@#$%^&*()-+=<>:;{}[]|?'

casper.start url, ->
  @test.assertTitleMatch(/create message/i, 'create message is in the title')
  @test.assertNotVisible('div#messageCreatedModal', 'message created modal should be hidden')
  @fill('form#new-message', {
    'body':    'brand spankin new message gandhitheapp ABCDEFXYZ 123456789 !@#$%^&*()-+=<>:;{}[]|?',
    'passphrase':       passphrase
    })
  @click('button[type="submit"]')
  @wait 5000, ->
    @echo "waited 5 seconds for encryption to complete ..."
    @test.assertVisible('div#messageCreatedModal', 'message created modal should be visible')
    @test.assertExists('div[id="message-created"]', 'message was created')
    @click('a[href="/"]')
  
  @then ->
    @test.assertTitleMatch(/home/i, 'home is in the title')
    @fill('form#read-message', {
      'passphrase': passphrase
      })
    @click('button[type="submit"]')
    @wait 10000, ->
      @echo "waited ..."
      @test.assertVisible('div#showMessageModal', 'show message modal should be visible')
      @test.assertSelectorHasText('div#show-message-body', 'gandhitheapp', 'should show the decrypted message text')
      @test.assertSelectorHasText('div#show-message-body', '123456789', 'should show numbers from the message text')
      @test.assertSelectorHasText('div#show-message-body', '!@#$%^&*()-+=<>:;{}[]|?', 'should show special chars from the message text')
      @click('button[data-dismiss="modal"]')

      # Now let's make sure the message has self-destructed
      @click('a[href="/"]')

      @then ->
        @test.assertTitleMatch(/home/i, 'home is in the title')
        @fill('form#read-message', {
          'passphrase': passphrase
          })
        @click('button[type="submit"]')
        # This will trigger an alert which is hard to test for in Casper
        @wait 5000, ->
          @test.assertNotVisible('div#showMessageModal', 'show message modal should be visible')
          @test.assertSelectorDoesntHaveText('div#show-message-body', 'gandhitheapp', 'message body should not be in modal div')
          @test.assertSelectorDoesntHaveText('div#show-message-body', '!@#$%^&*()-+=<>:;{}[]|?', 'message body should not be in modal div')


casper.run ->
  @test.done 13
  @test.renderResults true
