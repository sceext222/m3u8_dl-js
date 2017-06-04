# util.coffee, m3u8_dl-js/src/
path = require 'path'
url = require 'url'

async_ = require './async'
log = require './log'


last_update = ->
  new Date().toISOString()

# pretty-print JSON text
print_json = (data) ->
  JSON.stringify data, '', '    '


WRITE_REPLACE_FILE_SUFFIX = '.tmp'
# atomic write-replace for a file
write_file = (file_path, text) ->
  tmp_file = file_path + WRITE_REPLACE_FILE_SUFFIX
  await async_.write_file tmp_file, text
  await async_.mv tmp_file, file_path

create_lock_file = (file_path) ->
  try
    fd = await async_.fs_open file_path, 'wx'
    # FIXME TODO remove LOCK file on process exit
    return fd
  catch e
    log.e "can not create LOCK file #{file_path} "
    throw e

get_base_url = (full_url) ->
  o = url.parse full_url
  # clear values
  o.hash = null
  o.search = null
  o.query = null
  o.path = null
  o.href = null

  o.pathname = path.posix.dirname o.pathname
  url.format(o)


module.exports = {
  last_update
  print_json

  WRITE_REPLACE_FILE_SUFFIX
  write_file  # async

  create_lock_file  # async

  get_base_url
}
