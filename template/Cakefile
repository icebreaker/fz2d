fs = require 'fs'
http = require 'http'
connect = require 'connect'
logger = require 'morgan'
serve_static = require 'serve-static'
socketio = require 'socket.io'
url = require 'url'
path = require 'path'
open = require 'open'
{execSync, spawn} = require 'child_process'

puts = console.log

system_with_echo = (cmd) ->
  puts cmd
  execSync cmd, (err, stdout, stderr) ->
    throw err if err
    if stdout.length || stderr.length
      puts stdout + stderr

spawn_with_echo = (cmd, cb) ->
  puts cmd
  args = cmd.split(' ')
  e = spawn args.shift(), args
  e.stdout.on 'data', (data) ->
    puts data.toString()
  e.stderr.on 'data', (data) ->
    puts data.toString()
  e.on 'close', cb if cb?()
  e

process.env['PATH'] = path.join(__dirname, 'node_modules/.bin') + ':' + process.env['PATH']

default_port = 3000
default_refresh = 500

option '-p', '--port [PORT]', "server port (default: #{default_port})"
option '-r', '--refresh [MS]', "refresh frequency (default: #{default_refresh} ms)"

minify = (options) ->
  system_with_echo 'uglifyjs --no-dead-code -o js/game.min.js js/game.js'

compile = (options) ->
  cmd = "coffee -o js/ -j js/game.js -cb#{options.opts || ''} src"

  if options.sync
    system_with_echo(cmd)
  else
    spawn_with_echo(cmd)

  minify(options) if options.minify

watch_file = (filename, refresh, cb) ->
  fs.watchFile path.join(__dirname, filename), interval: refresh, cb

watch_files = (filenames, refresh, io, cb) ->
  for filename in filenames
    watch_file filename, refresh, io, cb

watch_directory = (directory, refresh, cb) ->
  fs.watch path.join(__dirname, directory), interval: refresh, cb

watch_directories = (directories, refresh, cb) ->
  for directory in directories
    watch_directory directory, refresh, cb

watch_server_request = (req, res, next) ->
  if url.parse(req.url).pathname != '/'
    next()
    return
    
  fs.readFile path.join(__dirname, 'index.html'), (err, data) ->
    if err
      next()
      return

    js = """
      <script type="text/javascript">
      (function()
      {
        var ios = document.createElement('script'); ios.type = 'text/javascript'; ios.async = true;
        ios.onload = function() 
        {
          var socket = io.connect(window.location.url);
          socket.on('refresh', function(data)
          {
            console.log('refreshing ...');
            window.location.reload(true);
          });
          socket.on('disconnect', function(data)
          {
             console.log('closing ...');
             window.open('', '_self').close();
          });
          if(window.Event)
          {
            // FIXME: use Event() instead of this mockery :)
            var evt = document.createEvent('Event');
            evt.initEvent('io', true, true);
            document.dispatchEvent(evt);
          }
        };
        ios.src = '/socket.io/socket.io.js';
        ios.id  = '_fz2d_development';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ios, s);
      })();
      </script>
    """
    
    content = data.toString().replace('</body>', "#{js}\n</body>")
    content = content.replace(/\.min\.js/g, '.js') # in development mode use non minified versions

    res.setHeader 'Content-Type', 'text/html'
    res.setHeader 'Content-Length', content.length
    res.end content

create_server = (port, refresh) ->
  puts "== Server on http://127.0.0.1:#{port}/"
  app = connect()
  app.use logger('dev')
  app.use watch_server_request if refresh?
  app.use serve_static(__dirname)

  server = http.createServer app
  
  if refresh?
    puts "== Socket.io Server on http://127.0.0.1:#{port}/"
    io = socketio.listen server
    io.sockets.on 'connection', (socket) ->
      socket.on 'disconnect', () ->
        puts "== Tab closed/refreshed"
      socket.on 'log', (data) ->
        console.log.apply(console, data.args)

  server.listen port, () ->
    if refresh? and io?
      puts "== Watching files (#{refresh} ms) ..."
      initial = true

      watch_files ['js/game.js'], refresh, ->
        if initial
          initial = false
          return

        minify()
        io.sockets.emit 'refresh', {}

      watch_files ['js/fz2d.js', 'index.html'], refresh, ->
        io.sockets.emit 'refresh', {}

      watch_directories ['assets/textures', 'assets/sounds', 'assets/json'], refresh, ->
        io.sockets.emit 'refresh', {}

    puts "== Opening Browser on http://127.0.0.1:#{port}/"
    open("http://127.0.0.1:#{port}/")

    puts 'Press Ctrl + C to stop.'

  process.on 'SIGINT', () ->
    puts 'Bye, bye ...'
    process.exit()

task 'make', 'compiles everything', (options) ->
  compile(minify: true, sync: true)

task 'build', 'starts a server in development mode', (options) ->
  invoke 'make'

  port = options.port || default_port
  refresh = options.refresh || default_refresh
  create_server port, refresh

  compile(opts: 'w')

task 'server', 'starts a server on localhost', (options) ->
  port = options.port || default_port
  create_server port
