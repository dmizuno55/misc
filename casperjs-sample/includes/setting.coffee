do ->
  # PhantomJS bug patch
  userAgent = 'Mozilla/6.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A403 Safari/8536.25'
  casper.on 'page.initialized', (page) ->
    setupNavigator = (ua) ->
      window.navigator = Object.create window.navigator
      window.navigator.userAgent = ua
      window.navigator.onLine = true
      for i in window.navigator
        console.log "#{i}=#{window.navigator[i]}"
    page.evaluate setupNavigator, userAgent

  # User Agent for smartphone
  casper.userAgent userAgent
  
  # debug log
#  casper.on 'resource.received', (resource) ->
#  casper.echo "response: #{resource.status} #{resource.url}"
  
#  casper.on 'resource.requested', (request) ->
#    casper.echo "request: #{request.url}"
  
  casper.on 'page.error', (msg, trace) ->
    casper.echo "page.error: #{msg} #{JSON.stringify trace}"

#  casper.on 'resource.error', (error) ->
#    casper.echo "resource.error: #{JSON.stringify error}"

  casper.on 'remote.message', (msg) ->
    casper.echo "log: #{msg}"

