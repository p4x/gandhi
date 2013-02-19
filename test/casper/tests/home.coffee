url = "http://localhost:31337/"

casper.start url, ->
  @test.assertMatch(@getTitle(), /gandhi/i, 'Gandhi is in the title')
  @test.assertExists('form[id="read-message"]', 'has a read message form')
  @test.assertExists('input[name="passphrase"]', 'has a passphrase input field')
  @test.assertExists('a[href="/gandhi/new"]', 'has a link to the create message page')

casper.run ->
  @test.done 4
  @test.renderResults true
