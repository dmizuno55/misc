casper.test.begin 'login', (test) ->
  domainPattern = new RegExp casper.options.piggEnv.domain['sp-pigg']

  casper.start "http://#{casper.options.piggEnv.domain['sp-pigg']}"
  casper.then ->
    casper.click '#top-start-area .start'

  casper.then ->
    casper.clickLabel 'アメーバIDでログイン'

  casper.then ->
    casper.fillSelectors 'form[name="srvLoginForm"]',
      'input[name="username"]': 'sp-tnk',
      'input[name="password"]': 'key456'
    ,
    true

  casper.waitForUrl domainPattern, ->
    test.assertUrlMatch domainPattern, 'login success'

  casper.run ->
    casper.saveCookie()
    test.done()
