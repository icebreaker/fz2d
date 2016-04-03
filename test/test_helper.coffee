# Public: Runs the unit tests by requiring all test files.
# This makes it easy for people to create a simple 'cake task' in their Cakefile.
# ```coffee
#  task 'test', 'runs all unit tests', () ->
#    require(path.join(__dirname, 'test', 'test_helper')).run()
# ```
exports.run = (type='unit') ->
  fs = require 'fs'
  path = require 'path'

  # FIXME: dry this up :)
  helper_dir = path.join(__dirname, 'helpers')

  if fs.existsSync(helper_dir)
    for file in fs.readdirSync(helper_dir)
      require(path.join(helper_dir, file)) if /_helper\.coffee$/.test(file) # ends with `_helper.coffee`

  dir = path.join(__dirname, type)

  if fs.existsSync(dir)
    for file in fs.readdirSync(dir)
      require(path.join(dir, file)) if /_test\.coffee$/.test(file) # ends with `_test.coffee`

# We allow people to run the unit tests by running `coffee test_helper.coffee` .
if module is require.main
  exports.run()
  process.exit()

test = {}

test.cases = []
test.reports = []

test.assert_count = 0
test.failure_count = 0
test.error_count = 0

test.assert = require('assert')

global.assert = (x, message='Failed assertion, no message given.') ->
  test.assert_count++
  test.assert.ok(x, message)

global.assert_equal = (a, b) ->
  test.assert_count++
  test.assert.equal(b, a)

global.test = (desc, cb) ->
  test.cases.push(desc: desc, cb: cb)

# Execute all 'registered' tests on exit.
process.on 'exit', ->
  time = new Date()
  process.stdout.write('# Running:\n\n')

  for test_case in test.cases
    try
      test_case.cb()
      process.stdout.write('.')
    catch e
      if e instanceof test.assert.AssertionError
        test.failure_count++
        process.stdout.write('F')

        line = e.stack.split('\n')[2]
        file = line.match(/\((.*?):(.*?):(.*?)(,.*?)?\)/)

        message = e.message
        eq = message.match(/^(.*?)\s+==\s+(.*?)$/)
        if eq?
          message = """
          Expected: #{eq[2]}
          Actual: #{eq[1]}
          """

        test.reports.push("""
          #{test.reports.length + 1}). Failure: 
          #{test_case.desc} [#{file[1]}:#{file[2]}]:
          #{message}
          """)
      else
        test.error_count++
        process.stdout.write('E')

        test.reports.push("""
          #{test.reports.length + 1}). Error: 
          #{test_case.desc}:
          #{e.stack.replace(/\n+$/, '')}
          """)
  
  process.stdout.write("\n\nFinished in #{((new Date() - time) / 1000).toPrecision(2)}s.")

  for report in test.reports
    process.stdout.write("\n\n#{report}")

  process.stdout.write("\n\n#{test.cases.length} runs, #{test.assert_count} assertions, #{test.failure_count} failures, #{test.error_count} errors.\n")

exports.test = test
