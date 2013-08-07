--[[ LibRarian

     An addon for sharing data with others.

     LibRarian.store(identifier, access, data)
        stores data in local savedvariables
	if data == nil, removes local data

     LibRarian.retrieve(target, identifier, callback, server_only)
        attempts to retrieve identified data from target, calling
     	callback(target, identifier, data, error)
	If data is not nil, then error is nil.  If data is nil, and
	error is also nil, the intent was actually to represent a nil
	value.
	If server_only is set, this checks Storage, but does not use
	messaging or check the local cache.

     LibRarian.info()
        yields a table of { id, data, access, access_count } for the
	local storage.


     The sneaky part:  Both store and retrieve may, at their discretion,
     try to use the *.Storage.* API.  The only real guarantee here is that
     if an identifier is already in the storage system, LibRarian will
     either replace it or remove it when replacing that identifier.

     LibRarianData holds the data; please don't mess with it.
]]--

local addoninfo, rar = ...
if not Library then Library = {} end
Library.LibRarian = rar

rar.debug = false

rar.cache = { players = {} }
rar.pending = {}
rar.timer_queue = {}

local printf = Library.printf.printf

local function rardebug(...)
  if rar.debug then
    printf(...)
  end
end

function rar.ignore()
end

-- if we failed to send the storage query, let's bounce it back.
function rar.storage_callback(item, err, data)
  if err then
    rar.timeout_item(item, 'EACCESS')
  end
end

function rar.query_callback(item, err, data)
  if err then
    rar.timeout_item(item, 'EACCESS')
  end
end

function rar.need_more(target)
  return rar.pending[target] and next(rar.pending[target]) ~= nil
end

function rar.error_handler(err)
  printf("Error in callback: %s", tostring(err))
  print(debug.traceback())
end

function rar.data_got(target, identifier, data, error)
  if rar.pending[target] and rar.pending[target][identifier] then
    for i = 1, #rar.pending[target][identifier] do
      item = rar.pending[target][identifier][i]
      -- remove callbacks once we get a response
      rar.dequeue_item(item)
      xpcall(function() item.callback(target, identifier, data, error) end, rar.error_handler)
    end
    rar.pending[target][identifier] = nil
  end
end

function rar.storage_get(event, target, segment, identifier, read, write, data)
  if segment ~= 'player' then
    return
  end
  local stash
  if target == rar.whoami then
    stash = rar.data.stash
  else
    rar.cache.players[target] = rar.cache.players[target] or {}
    stash = rar.cache.players[target]
  end

  stash[identifier] = stash[identifier] or { count = 0 }
  stash[identifier].cksum = Utility.Storage.Checksum(data)
  -- restore any serialized things
  data = rar.from_data(data)
  stash[identifier].data = data
  -- we don't care about write access; if it's our storage, we have it,
  -- and if it's theirs, we don't.
  stash[identifier].access = 'read'
  rar.data_got(target, identifier, data)
end

function rar.message_receive(event, from, class, channel, identifier, data)
  if identifier == 'rar_nquery' then
    -- handle new-format query
    local version, data = data:match('(%d+):(.*)')
    if tonumber(version) > 1 then
      -- let them know the highest version we support.
      Command.Message.Send(from, 'rar_error', data .. '\1' .. 'ENOSYS[1]', rar.ignore)
    else
      local item = rar.data.stash[data]
      if item then
	item.count = item.count + 1
        if item.access == 'private' then
	  Command.Message.Send(from, 'rar_error', data .. '\1' .. 'EACCES', rar.ignore)
	  return
        end
        Command.Message.Send(from, 'rar_ndatum', data .. '\1' .. item.data, rar.ignore)
      else
        Command.Message.Send(from, 'rar_error', data .. '\1' .. 'ENOENT', rar.ignore)
      end
    end
  elseif identifier == 'rar_ndatum' then
    -- handle new-format data
    local id, datum = string.match(data, '([^\1]+)\1(.*)')
    if id and datum and id ~= '' then
      rar.data_got(from:lower(), id, rar.from_data(datum))
    else
      printf("Invalid rar_datum from %s.", from)
    end
    rardebug("got rar_ndatum response for %s/%s", from, id)
  elseif identifier == 'rar_query' then
    local item = rar.data.stash[data]
    if item then
      if item.access == 'private' then
	Command.Message.Send(from, 'rar_error', data .. '\1' .. 'EACCES', rar.ignore)
	return
      end
      -- old style: don't try to compress
      item.count = item.count + 1
      Command.Message.Send(from, 'rar_datum', data .. '\1' .. rar.from_data(item.data), rar.ignore)
    else
      Command.Message.Send(from, 'rar_error', data .. '\1' .. 'ENOENT', rar.ignore)
    end
  elseif identifier == 'rar_datum' then
    local id, datum = string.match(data, '([^\1]+)\1(.*)')
    if id and datum and id ~= '' then
      rar.data_got(string.lower(from), id, datum)
    else
      printf("Invalid rar_datum from %s.", from)
    end
  elseif identifier == 'rar_error' then
    local id, datum = string.match(data, '([^\1]+)\1(.*)')
    if id and datum and id ~= '' then
      -- pass the datum as an error
      rar.data_got(string.lower(from), id, nil, datum)
    else
      printf("Invalid rar_datum from %s: %s", from, data)
    end
  end
end

function rar.variables_loaded(event, addon)
  rar.whoami = string.lower(Inspect.Unit.Detail('player').name or 'unknown')
  if addon == 'LibRarian' then
    if not LibRarianData then
      LibRarianData = { stash = {}, version = 1 }
    end
    rar.data = LibRarianData
    -- upgrade database
    if not rar.data.version then
      printf("LibRarian: Updating stashed data.")
      -- zipped data prefixed with a "1" for strings
      for k, v in pairs(rar.data.stash) do
	local item = v
	v.data = '1' .. rar.zip(v.data)
      end
      rar.data.version = 1
    end
    Command.Event.Attach(Event.Storage.Get, rar.storage_get, "storage data callback")
    -- old protocol (soon to go away)
    Command.Message.Accept(nil, 'rar_query')
    Command.Message.Accept(nil, 'rar_datum')
    Command.Message.Accept(nil, 'rar_error')
    -- new protocol
    Command.Message.Accept(nil, 'rar_nquery')
    Command.Message.Accept(nil, 'rar_ndatum')
    Command.Message.Accept(nil, 'rar_nerror')
    Command.Event.Attach(Event.Message.Receive, rar.message_receive, "message received callback")
  end
end

function rar.to_data(data)
  if type(data) ~= 'string' then
    return '2' .. rar.zip(Utility.Serialize.Inline(data))
  else
    return '1' .. rar.zip(data)
  end
end

function rar.from_data(data)
  local str = rar.unzip(data:sub(2))
  if data:sub(1, 1) == '1' then
    return str
  else
    local func, err = loadstring('return ' .. str)
    if func then
      setfenv(func, {})
      local status, value = pcall(func)
      -- if this yielded something, then great, we have a thing. We return it.
      if status then
        return value
      end
    end
  end
  return nil
end

function rar.store(identifier, access, data, push_to_server)
  if data ~= nil then
    data = rar.to_data(data)
    rar.data.stash[identifier] = { data = data, access = access, cksum = Utility.Storage.Checksum(data), count = 0, stamp = Inspect.Time.Server() }
    if push_to_server then
      Command.Storage.Set('player', identifier, 'public', 'private', data, rar.ignore)
    end
  else
    rar.data.stash[identifier] = nil
    if push_to_server then
      Command.Storage.Clear('player', identifier, rar.ignore)
    end
  end
end

function rar.retrieve(target, identifier, callback, server_only)
  if not callback then
    printf("LibRarian.retrieve: The callback function is not optional.")
    return
  end
  if type(identifier) ~= 'string' then
    xpcall(function() callback(target, identifier, nil, "No valid identifier.") end, rar.error_handler)
    return
  end
  if type(target) ~= 'string' then
    xpcall(function() callback(target, identifier, nil, "No valid target.") end, rar.error_handler)
    return
  end
  target = string.lower(target)
  if target == rar.whoami and not server_only then
    xpcall(function() callback(target, identifier, rar.data.stash[identifier] and rar.data.stash[identifier].data, nil) end, rar.error_handler)
  else
    rar.pending[target] = rar.pending[target] or {}
    local event = { callback = callback, state = 'storage', target = target, identifier = identifier, stamp = Inspect.Time.Frame(), server_only = server_only }
    if rar.pending[target][identifier] then
      rar.pending[target][identifier][#rar.pending[target][identifier] + 1] = event
    else
      rar.pending[target][identifier] = { event }
      -- Don't add more requests if we're already trying to get this.
      -- When the one that's in the queue succeeds or fails, the others
      -- will go with it.
      rar.timer_queue[#rar.timer_queue + 1] = event
      rardebug("Adding new query (%s/%s) to timer queue.", target, identifier)
      local status, value = pcall(rar.do_get, event, target, identifier)
      if not status then
        rar.storage_callback(event, "error calling Command.Storage.Get", nil)
      end
    end
  end
end

function rar.do_get(event, target, identifier)
  Command.Storage.Get(target, 'player', identifier,
    function(f, e) rar.storage_callback(event, f, e) end)
end

function rar.info()
  printf("Stored:")
  for identifier, object in pairs(rar.data.stash) do
    printf("  %s: %db, checksum %s, queries %d.",
      identifier, #object.data, object.cksum, object.count)
  end
  printf("Pending:")
  for target, details in pairs(rar.pending) do
    printf("  %s:", target)
    for identifier, callbacks in pairs(details) do
      printf("    %s: %d callbacks", identifier, #callbacks)
    end
  end
end

function rar.zip(data, header)
  local deflate = zlib.deflate(zlib.BEST_COMPRESSION)
  local h_deflated, h_eof, h_bytes_in, h_bytes_out
  if header then
    h_deflated, h_eof, h_bytes_in, h_bytes_out = deflate(header, "sync")
    printf("%d header bytes in, %d bytes out", h_bytes_in, h_bytes_out)
  end
  local deflated, eof, bytes_in, bytes_out = deflate(data, "finish")
  return deflated, #data, #deflated, h_deflated
end

function rar.unzip(data, h_data)
  local inflate = zlib.inflate()
  if h_data then
    h_inflated = inflate(h_data)
  end
  inflated, eof = inflate(data)
  return inflated
end

function rar.dequeue_item(item)
  -- remove the item from the list, if it's there.
  for i = 1, #rar.timer_queue do
    if rar.timer_queue[i] == item then
      table.remove(rar.timer_queue, i)
      break
    end
  end
end

-- item has timed out, let's try a new method
function rar.timeout_item(item, error)
  rardebug("updating %s/%s, state %s.",
    item.target, item.identifier, item.state)
  rar.dequeue_item(item)
  item.stamp = Inspect.Time.Frame()
  if item.state == 'storage' then
    -- okay, that failed. Let's try a new query.
    if item.server_only then
      -- we have failed. report failure and don't re-add the item.
      rar.data_got(item.target, item.identifier, nil, error or 'ENOENT')
    else
      item.state = 'nquery'
      Command.Message.Send(item.target, 'rar_nquery', '1:' .. item.identifier,
    	  function(f, e) rar.query_callback(item, f, e) end)
      rar.timer_queue[#rar.timer_queue + 1] = item
    end
  elseif item.state == 'nquery' then
    -- the old mechanism.
    item.state = 'query'
    Command.Message.Send(item.target, 'rar_query', item.identifier,
    	function(f, e) rar.query_callback(item, f, e) end)
    rar.timer_queue[#rar.timer_queue + 1] = item
  elseif item.state == 'query' then
    -- we have failed. report failure and don't re-add the item.
    rar.data_got(item.target, item.identifier, nil, error or 'ENOENT')
  else
    -- I don't think I should be able to get here, but just in case:
    rar.data_got(item.target, item.identifier, nil, error or 'ENOENT')
  end
end

function rar.update_hook()
  local now = Inspect.Time.Frame()
  while #rar.timer_queue > 0 do
    if (now - rar.timer_queue[1].stamp) > 1 then
      -- update this one, whch may result on it going on the end of the list
      rardebug("timeout for %s[%s]", rar.timer_queue[1].target, rar.timer_queue[1].identifier)
      rar.timeout_item(rar.timer_queue[1], 'ENOENT')
    else
      break
    end
  end
end

Command.Event.Attach(Event.Addon.SavedVariables.Load.End, rar.variables_loaded, "variable loaded hook")
Command.Event.Attach(Event.Addon.Startup.End, function() Library.LibCron.recurring(0.5, rar.update_hook) end, "request timeouts")
