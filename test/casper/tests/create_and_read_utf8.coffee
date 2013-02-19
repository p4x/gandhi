url = "http://localhost:31337/gandhi/new"
home = "http://localhost:31337/"

casper = require("casper").create(
  verbose: true
  logLevel: "debug"
  remoteScripts: ["/assets/application.js"]
)

passphrase = 'abc123 काचंὕαλΜπορòmăâMýᚉᚑᚅéid⠉⠁⠝⠀⠑⠁⠞⠀⠛⠇etiðåсуликадо আমিகண்ணாடிతినیں ہوتی خوږويتوانم بدونِيؤلمنيמזיק לינישטلَافِىَاက္ယ္ဝ些 𣎏ຂອ້ຍກິฉันम काँཤེལ་我能吞我能吞私は나는ᐊᓕᒍᖅTsésǫ'

body = 'abc123 काचंὕαλΜπορòmăâMýᚉᚑᚅéid⠉⠁⠝⠀⠑⠁⠞⠀⠛⠇etiðåсуликадо আমিகண்ணாடிతినیں ہوتی خوږويتوانم بدونِيؤلمنيמזיק לינישטلَافِىَاက္ယ္ဝ些 𣎏ຂອ້ຍກິฉันम काँཤེལ་我能吞我能吞私は나는ᐊᓕᒍᖅTsésǫ\nकाचंὕαλΜπορòmăâMýᚉᚑᚅéid⠉⠁⠝⠀⠑⠁⠞⠀⠛⠇etiðåсуликадо আমিகண்ணாடிతినیں ہوتی خوږويتوانم بدونِيؤلمنيמזיק לינישטلَافِىَاက္ယ္ဝ些 𣎏ຂອ້ຍກິฉันम काँཤེལ་我能吞我能吞私は나는ᐊᓕᒍᖅTsésǫ'

casper.start url, ->
  @test.assertTitleMatch(/create message/i, 'create message is in the title')
  @test.assertNotVisible('div#messageCreatedModal', 'message created modal should be hidden')
  @fill('form#new-message', {
    'body':    body,
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
      @test.assertSelectorHasText('div#show-message-body', body, 'should show the decrypted message text')
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
          @test.assertSelectorDoesntHaveText('div#show-message-body', body, 'message body should not be in modal div')
          @test.assertSelectorDoesntHaveText('div#show-message-body', 'abc123', 'message body text should not be in modal div')


casper.run ->
  @test.done 11
  @test.renderResults true
