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

# build directory
build = path.join(__dirname, 'build')

# source directory
source = path.join(__dirname, 'src')

# template directory
template = path.join(__dirname, 'template')

# demos directory
demos = path.join(__dirname, 'docs', 'demos')

# default watch and recompile interval
default_interval = 500

option '-p', '--path [PATH]', 'specifies destination directory for the create or update tasks'
option '-n', '--name [NAME]', 'specifies a project name for the create task'
option '-i', '--interval [MS]', "specifies the watch and recompile interval (default: #{default_interval} ms)"

minify = (options) ->
  input  = path.join(build, 'fz2d.js')
  output = path.join(build, 'fz2d.min.js')

  system_with_echo 'npm run uglifyjs -- --no-dead-code -o ' + output + ' ' + input
  
  options.path = template
  invoke 'update'

  # FIXME: iterate over all demos and update them
  for name in ['fuzed', 'fillrate']
    options.path = path.join(demos, name)
    invoke 'update'

task 'make', 'compiles everything', (options) ->
  output = path.join(build, 'fz2d.js')
  system_with_echo 'npm run coffee -- -o ' + build + '/ -j '+ output + ' -cb ' + source, ->
  minify(options)

task 'build', 'watches and recompiles everything on any change', (options) ->
  output = path.join(build, 'fz2d.js')
  spawn_with_echo 'npm run coffee -- -o ' + build + '/ -j ' + output + ' -cwb ' + source

  interval = options.interval || default_interval
  fs.watchFile output, interval: interval, (curr, prev) ->
    minify(options)

task 'docs', 'generates documentation', () ->
  system_with_echo 'npm run biscotto -- --title Fz2D --output-dir docs/docs'

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
    fs.copySync(path.join(build, 'fz2d.js'), path.join(options.path, 'js', 'fz2d.js'))
    fs.copySync(path.join(build, 'fz2d.min.js'), path.join(options.path, 'js', 'fz2d.min.js'))
    puts 'Updated existing project in ' + options.path + ' ...'

task 'test', 'runs all unit tests', () ->
  require(path.join(__dirname, 'test', 'test_helper')).run()
