# Public: Local Storage
class Fz2D.Storage
  # Public: Returns a deserialized value from local storage.
  # 
  # name - key of the value
  # value - default value (default: 0)
  #
  # Returns deserialized value or default if not set.
  get: (name, value=0) ->
    JSON.parse(localStorage.getItem(name) || value)

  # Public: Stores a serialized value in local storage.
  #
  # name - key of the value
  # value - the value itself (unserialized)
  set: (name, value) ->
    localStorage.setItem(name, JSON.stringify(value))

  # Public: Removes a value from local storage.
  #
  # name - key of the value
  remove: (name) ->
    localStorage.removeItem(name)
