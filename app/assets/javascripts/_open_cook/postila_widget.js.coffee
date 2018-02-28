do ->
  return if document.pnctLoadStarted

  d = document.createElement('div')
  d.setAttribute 'id', 'pnctPreloader'
  d.setAttribute 'style', 'position:fixed;top:0;bottom:0;left:0;right:0;z-index:100501;background-color:rgba(255,255,255,.9);padding:20px;text-align:center;font-family:helvetica;font-size:20px;font-weight:bold;'
  d.innerHTML = 'Loading...<a%20id=&quot;pnctCancelBtn&quot;%20href=&quot;#&quot;%20style=&quot;float:right;width:24px;height:24px;text-decoration:none;border:1px%20solid%20#ccc;border-radius:5px&quot;><img src=&quot;//postila.ru/images/window_close.png&quot; alt=&quot;x&quot;/></a>'
  document.body.appendChild d
  document.pnctLoadStarted = (new Date).getTime()

  document.pnctCnclLoad = ->
    document.pnctLoadStarted = 0
    pl = document.getElementById('pnctPreloader')

    if pl
      pl.parentNode.removeChild pl

    return

  document.getElementById('pnctCancelBtn').addEventListener 'click', (e) ->
    e.preventDefault()
    document.pnctCnclLoad()
    return
  setTimeout (->
    st = document.pnctLoadStarted
    _time = (new Date).getTime() - st >= 14000
    if st > 0 and _time
      document.pnctCnclLoad()
    return
  ), 15000
  e = document.createElement('script')
  e.setAttribute 'type', 'text/javascript'
  e.setAttribute 'charset', 'UTF-8'
  e.setAttribute 'src', '//postila.ru/post.js?ver=1&m=b&rnd=' + Math.random() * 99999999
  document.body.appendChild e
  return


(function() {
    if (document.pnctLoadStarted) return;
    var  d = document.createElement('div');
    d.setAttribute('id', 'pnctPreloader');
    d.setAttribute('style', 'position:fixed;top:0;bottom:0;left:0;right:0;z-index:100501;background-color:rgba(255,255,255,.9);padding:20px;text-align:center;font-family:helvetica;font-size:20px;font-weight:bold;');

    d.innerHTML = 'Loading...<a%20id=&quot;pnctCancelBtn&quot;%20href=&quot;#&quot;%20style=&quot;float:right;width:24px;height:24px;text-decoration:none;border:1px%20solid%20#ccc;border-radius:5px&quot;><img src=&quot;//postila.ru/images/window_close.png&quot; alt=&quot;x&quot;/></a>';

    document.body.appendChild(d);
    document.pnctLoadStarted = (new Date()).getTime();

    document.pnctCnclLoad = function() {
        document.pnctLoadStarted = 0;
        pl = document.getElementById('pnctPreloader');
        if (pl) pl.parentNode.removeChild(pl)
    };

    document.getElementById('pnctCancelBtn').addEventListener('click', function(e) {
        e.preventDefault();
        document.pnctCnclLoad()
    });

    setTimeout(function() {
        var  st   = document.pnctLoadStarted;
        var _time = ((new  Date()).getTime() - st) >= 14000);
        if (st > 0 && _time) {
          document.pnctCnclLoad();
        }
    }, 15000);

    var e = document.createElement('script');
    e.setAttribute('type', 'text/javascript');
    e.setAttribute('charset', 'UTF-8');
    e.setAttribute('src', '//postila.ru/post.js?ver=1&m=b&rnd=' + Math.random() * 99999999);
    document.body.appendChild(e)
})()