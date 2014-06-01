casper.loadCookie()
casper.test.begin 'dressup', (test) ->
  casper.start "http://#{casper.options.piggEnv.domain['sp-pigg']}/dressup"
  casper.then ->
    urlPattern = new RegExp "#{casper.options.piggEnv.domain['sp-pigg']}/dressup"
    test.assertUrlMatch urlPattern
    casper.wait 500, ->
      casper.capture 'tmp/evidence/dressup-init.png'
  casper.thenClick '#remove', ->
    casper.waitWhileVisible '#popup-yes', ->
      casper.thenClick '#popup-yes', ->
        casper.capture 'tmp/evidence/dressup-removeAll.png'
  casper.thenClick '#category-new', ->
    casper.wait 1000, ->
      casper.evaluate ->
        for i in [0..9]
          $(".itemlist li:eq(#{i}) button").click()
      casper.capture 'tmp/evidence/dressup-change.png'
  casper.run ->
    test.done()
