casper.test.begin 'local test', (test) ->
  casper.start 'http://localhost/casperjs-test'
  casper.then ->
    test.assertExists '#message', '#message is exists'
    casper.evaluate ->
      __utils__.echo $('#message').text()
  casper.run ->
    test.done()
