path = require 'path'
fs = require 'fs-extra'
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

# prepend local node.js packages/modules `bin` directory to the PATH
process.env['PATH'] = path.join(__dirname, 'node_modules/.bin') + ':' + process.env['PATH']

# build directory
build = path.join(__dirname, 'build')

# source directory
source = path.join(__dirname, 'src')

# template directory
template = path.join(__dirname, 'template')

# docs directory
docs = path.join(__dirname, 'docs')

# default watch and recompile interval
default_interval = 500

option '-p', '--path [PATH]', 'specifies destination directory for the create or update tasks'
option '-i', '--interval [MS]', "specifies the watch and recompile interval (default: #{default_interval} ms)"

minify = (options) ->
  system_with_echo 'uglifyjs --no-dead-code -o ' + build + '/fz2d.min.js ' + build + '/fz2d.js'
  
  options.path ?= template
  invoke 'update'

task 'make', 'compiles everything', (options) ->
  system_with_echo 'coffee -o ' + build + ' -j '+ build + '/fz2d.js -cb ' + source, ->
  minify(options)

task 'build', 'watches and recompiles everything on any change', (options) ->
  spawn_with_echo 'coffee -o ' + build + ' -j ' + build + '/fz2d.js -cwb ' + source

  interval = options.interval || default_interval
  fs.watchFile build + '/fz2d.js', interval: interval, (curr, prev) ->
    minify(options)

task 'docs', 'generates documentation', () ->
  system_with_echo 'biscotto --title Fz2D --output-dir docs'

task 'create', 'creates a new project using the template', (options) ->
  if not options.path or fs.existsSync(path.join(options.path, 'Cakefile'))
    puts 'You cannot create a project in the given directory. Not empty?'
  else
    fs.mkdirpSync(options.path)
    fs.copySync(template, options.path)
    puts 'Created new project in ' + options.path + ' ...'

task 'update', 'updates an existing project using the template', (options) ->
  if not options.path or
     not fs.existsSync(path.join(options.path, 'Cakefile')) or
     not fs.existsSync(path.join(options.path, 'js'))
    puts 'You cannot update the project in the given directory. Not valid?'
  else
    fs.copySync(path.join(build, 'fz2d.js'), path.join(options.path, '/js/fz2d.js'))
    fs.copySync(path.join(build, 'fz2d.min.js'), path.join(options.path, '/js/fz2d.min.js'))
    puts 'Updated existing project in ' + options.path + ' ...'

task 'test', 'runs all unit tests', () ->
  require(path.join(__dirname, 'test', 'test_helper')).run()
