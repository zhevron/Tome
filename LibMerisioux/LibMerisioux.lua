--[[ LibMerisioux

     Generic addon for exchanging RP data.

     {
       prefix = "",
       override = "",
       suffix = "",
       title = "",
       description = "",
       biography = "",
       meta = "",
       flags = "",
       version = "",
       age = "",
       height = "",
       weight = "",
     }

     snoop(char, callback, query)
     	=> calls callback(char, data, error)
	If query is true, always query.  If query is false, never query.
	Otherwise, tries to use cached data if it's under a minute old,
	and uses cached data if a query fails.  WARNING:  If you want to
	mess with the table, copy it!  I am not copying tables.

     flaunt(table)
     flaunt(field, value)
     	=> Sets data about this character.  If the argument is a table,
	it's treated as { field = value } pairs.  A boolean false clears
	a value.

     setflag(c, state)
        => Sets the given flag (or unsets it if state is false), returning
	any flags which were unset as a result.  Note:  For purposes
	of this function, 'nil' is a kind of true; you must use an
	explicit false to unset a flag.  This sets a special 'editing' flag
	set (to allow you to edit flags non-destructively).  To save it,
	flaunt('flags').

     addon(addon_identifier, newer)
     	=> Tells LibMerisioux that it is being used by 'addon_identifier',
	and provides a callback to use if a newer version of that particular
	addon is observed.

     info()
        => displays info about character

     list(flags)
        => a list of characters currently known (who have all of the
	   listed flags)

     fields()
        => a list of fields currently known.
		field = {
		  max = n,
		  help = "description",
		}
	Again, NOT A COPY.  Copy it before you change it.

     flags()
        => table, string
	Table is a list of known flags, string is a canonical sorted order
	for the flags.
	Again, NOT A COPY.  Do not change this.
		character => { name =, description =, excludes = }

     prettyname(name, data)
        => A prettied up string from the prefix, override, and suffix fields.

]]--

local addoninfo, meri = ...
Library = Library or {}
Library.LibMerisioux = meri
local rar = Library.LibRarian
meri.data_version = "0"
meri.version = "0.11-130804-20:56:36"
meri.callbacks = {}
meri.callback_times = {}

local printf = Library.printf.printf

-- logical groupings: cfo lhw enm vp ri PdR
meri.sorted_flags = "cfolhwenmvpriPdR"

meri.flagtable = {
  e = { name = 'ERP',
	description = 'ERP-friendly.',
	excludes = 'mn', },
  n = { name = 'No ERP',
	description = 'No ERP.',
	excludes = 'em', },
  m = { name = 'Mature',
        description = 'Sexual themes acceptable when they fit the story.',
	excludes = 'en', },
  v = { name = 'Conflict',
        description = 'Comfortable with high-conflict storylines and RP.',
	excludes = 'p', },
  p = { name = 'Peaceful',
        description = 'Uncomfortable with high-conflict storylines and RP.',
	excludes = 'v', },
  h = { name = 'Helper',
        description = 'Newbie-helper',
	excludes = 'w' },
  w = { name = 'Newbie',
        description = 'New to the game or to RP.',
	excludes = 'h', },
  l = { name = 'Looking',
        description = 'Looking for contacts or RP.',
	excludes = '', },
  f = { name = 'Full-time',
        description = 'Full-time RP.',
	excludes = 'o', },
  c = { name = 'IC',
  	description = 'In character.',
	excludes = 'o', },
  o = { name = 'OOC',
  	description = 'Out of character.',
	excludes = 'cf', },
  r = { name = 'Lore',
        description = 'Following lore/setting.',
	excludes = 'i', },
  i = { name = 'Non-Lore',
        description = 'Ignoring lore/setting.',
	excludes = 'r', },
  P = { name = 'PvP',
        description = 'PvP to resolve fights.',
	excludes = '', },
  d = { name = 'Dice',
        description = 'Dice to resolve fights.',
	excludes = '', },
  R = { name = 'Roleplay',
        description = 'Roleplay to resolve fights.',
	excludes = '', },
}

function meri.addon(identifier, callback)
  local addoninfo = Inspect.Addon.Detail(identifier)
  if addoninfo then
    meri.addon_name = identifier
    meri.addon_info = string.format("%s:%s", identifier, addoninfo.toc.Version or 'unknown')
    -- this used to try to update the stored data with the new version.
    -- that could interfere with the check for saved data; instead, we just
    -- figure you'll eventually save things with the new version, and
    -- then things will work. Note that "eventually" may be "as soon as the
    -- stored data callback completes".
    meri.addon_callback = callback
  else
    printf("Help:  LibMerisioux was told to use addon ID '%s', but can't find it.", tostring(identifier))
  end
end

function meri.fields()
  return meri.template
end

function meri.flags()
  return meri.flagtable, meri.sorted_flags
end

meri.template = {
  prefix = { max = 15,
    help = "A prefix to display before the character's name.",
  },
  override = { max = 15,
    help = "A name to display in place of the character name.",
  },
  suffix = { max = 15,
    help = "A suffix to display after the character's name.",
  },
  title = { max = 35,
    help = "A title to display.",
  },
  description = { max = 2048,
    help = "A description of externally-observable traits or details.",
  },
  biography = { max = 2048,
    help = "Character backstory, need not be externally-observable.",
  },
  meta = { max = 2048,
    help = "OOC notes about preferred RP style or play; notes for players, not characters.",
  },
  flags = { max = 26,
    help = "A series of flags indicating things about your character.",
  },
  stamp = { max = 16,
    help = "A timestamp for this bio."
  },
  age = { max = 32,
    help = "The character's approximate age."
  },
  height = { max = 32,
    help = "The character's height."
  },
  weight = { max = 32,
    help = "The character's weight."
  },
}

-- just in case...
function meri.sanity_check()
  local missed = {}
  local extra = {}
  for k, v in pairs(meri.flagtable) do
    missed[k] = true
  end
  for c in string.gmatch(meri.sorted_flags, '.') do
    if missed[c] then
      missed[c] = nil
    else
      extra[c] = true
    end
  end
  for k, v in pairs(extra) do
    printf("Warning:  Sort order specified for nonexistent flag %s.", k)
  end
  for k, v in pairs(missed) do
    printf("Warning:  No sort order specified for flag %s.", k)
  end
  if meri.self then
    if meri.self.version then
      if meri.self.version ~= meri.data_version then
        printf("Whoops, someone forgot to add version upgrades to LibMerisioux.")
	printf("This profile is version %d, LibMerisioux is version %d.", meri.self.version, meri.data_version)
      end
    else
      -- probably harmless
      meri.self.version = meri.data_version
    end
  end
end

function meri.variables_loaded(event, name)
  if name == 'LibMerisioux' then
    LibMerisiouxData = LibMerisiouxData or { shards = {} }
    local shard = Inspect.Shard().name
    LibMerisiouxData.shards[shard] = LibMerisiouxData.shards[shard] or {}
    if not LibMerisiouxData.last_version_seen then
      LibMerisiouxData.last_version_seen = meri.version
    else
      local comp = Library.LibVersion.compare(LibMerisiouxData.last_version_seen, meri.version)
      if comp == -1 then
        LibMerisiouxData.last_version_seen = meri.version
      elseif comp == 1 then
        printf("LibMerisioux:  Saw newer version %s, you have %s.",
	    LibMerisiouxData.last_version_seen, meri.version)
      end
    end
    meri.data = LibMerisiouxData.shards[shard]
    meri.whoami = string.lower(Inspect.Unit.Detail('player').name)
    meri.data[meri.whoami] = meri.data[meri.whoami] or { }
    if not meri.data[meri.whoami].data then
      meri.data[meri.whoami].data = { version = meri.data_version }
    end
    meri.self = meri.data[meri.whoami].data
    -- Most likely, you wrote it in 1970.
    if not meri.self.stamp then
      printf("Found no existing stamp. Adding.")
      meri.self.stamp = 1
    end
    -- remember values which were stored locally, never delete them
    meri.data[meri.whoami].self = true
    -- this will call us back when it knows what was on the server, if
    -- anything.
    rar.retrieve(meri.whoami, 'merisioux_data', meri.maybe_newer_data, true)
    meri.sanity_check()
  end
end

function meri.clean_variables()
  if not meri.data then
    return
  end
  for k, v in pairs(meri.data) do
    if v.error and not v.self and not v.data then
      meri.data[k] = nil
    end
  end
end

function meri.inflater(x)
  local inflate = zlib.inflate()
  return inflate(x)
end

function meri.parse(data, error)
  if not data then
    return data, error
  end
  local status, value
  -- Future directions: In a future release, we will stop doing the
  -- compression in LibMerisioux, because LibRarian does it automatically.
  -- So for now, we will accept either of two results.
  if type(data) == 'table' then
    value = data
  else
    status, value = pcall(meri.inflater, data)
    if status then
      local func, err = loadstring('return ' .. value)
      if func then
	setfenv(func, {})
	status, value = pcall(func)
	if not status then
	  return nil, "Failed to execute: " .. value
	else
	  if type(value) ~= 'table' then
	    return nil, "Invalid data format recieved."
	  end
	end
      else
	return nil, "Couldn't parse returned value."
      end
    end
  end

  local found_version = nil
  local cleaned = {}
  for k, v in pairs(value) do
    if meri.template[k] then
      if type(v) == 'string' then
        cleaned[k] = string.sub(v, 1, meri.template[k].max)
      elseif type(v) == 'number' then
        cleaned[k] = v
      end
    elseif k == 'libversion' then
      -- ignore "dev" versions.
      if not v:match('dev') then
        local comp = Library.LibVersion.compare(LibMerisiouxData.last_version_seen, v)
        if comp == -1 then
	  printf("LibMerisioux:  Saw newer version %s, you have %s.",
	      v, meri.version)
	  LibMerisiouxData.last_version_seen = v
        end
      end
    elseif k == 'addonversion' then
      -- The addon we're using might care, if we have one.
      local name, version = string.match(v, '([^:]*):(.*)')

      if name == meri.addon_name and meri.addon_callback then
	Utility.Dispatch(function() meri.addon_callback(version) end, meri.addon_name, 'new version callback')
      end
    elseif k == 'version' and type(v) == 'number' then
      -- we might someday use this to translate from older
      -- versions...
      found_version = v
      if v > meri.data_version then
	printf("Warning:  LibMerisioux version %d got a version %d profile.  You may need to upgrade.", meri.data_version, v)
      end
    end
  end
  return cleaned, nil
end

function meri.maybe_newer_data(char, identifier, data, error)
  if char ~= meri.whoami or identifier ~= 'merisioux_data' then
    meri.update_local(true)
    return
  end

  if error then
    -- nope, no newer data
    meri.update_local(true)
    return
  end

  data, error = meri.parse(data, error)
  if not data then
    meri.update_local(true)
    return
  end

  local newer = nil
  local older = nil
  if data.stamp then
    if data.stamp > meri.self.stamp then
      newer = true
    elseif data.stamp < meri.self.stamp then 
      older = true
    end
  elseif meri.self.stamp == 1 then
    -- the data on the server had no timestamp, so it's from 0.17. You
    -- haven't updated since you got this newer version, and anyway, if you
    -- had updated, it would have gone to the server, right? So.
    newer = true
    -- we don't have a stamp from the server, so we'll stamp it as "now".
    data.stamp = Inspect.Time.Server()
  else
    -- Your data is definitely newer than the server's data.
    older = true
  end
  if older then
    printf("Found existing data on server, but it's older. Saving it as %s_server.", meri.whoami)
    meri.data[meri.whoami .. '_server'] = { stamp = data.stamp or Inspect.Time.Server(), data = data, self = true }
  elseif newer then
    printf("Found existing data on server, and it's newer. Saving any local settings as %s_local.", meri.whoami)
    meri.data[meri.whoami .. '_local'] = { stamp = meri.self.stamp or 1, data = meri.self, self = true }
    meri.data[meri.whoami] = { stamp = data.stamp or Inspect.Time.Server(), data = data, self = true }
    meri.self = meri.data[meri.whoami].data
  end
  meri.update_local(true)
end

function meri.snoop_callback(char, identifier, data, error)
  if not meri.callbacks[char] then
    return
  end
  -- and remove the callback time record for this character, so we don't
  -- report it as timed out later.
  meri.callback_times[char] = nil
  data, error = meri.parse(data, error)
  if char ~= meri.whoami then
    if data then
      meri.data[char] = { stamp = Inspect.Time.Server(), data = data }
    else
      -- use old value if we have it
      if meri.data[char] and meri.data[char].data then
	data = meri.data[char].data
	error = meri.data[char].error or error
      else
	meri.data[char] = { stamp = Inspect.Time.Server(), error = error }
      end
    end
  end
  for _, cb in ipairs(meri.callbacks[char]) do
    -- cb[1] = callback, cb[2] = addon identifier
    Utility.Dispatch(function() cb[1](char, data, error) end, cb[2], 'LibMerisioux data callback')

  end
  meri.callbacks[char] = nil
end

-- query can be true, false, or nil. nil means use an existing value
-- if it's recent. false means use only local cache. true means always
-- query even if there's an existing cached value.
function meri.snoop(char, callback, query)
  local addon = Inspect.Addon.Current()
  if type(char) ~= 'string' then
    Utility.Dispatch(function() callback(char, nil, "Character name must be a string.") end, addon, 'LibMerisioux snoop callback')
    return
  end
  char = string.lower(char)
  if char == meri.whoami then
    if meri.self then
      Utility.Dispatch(function() callback(meri.whoami, meri.self, nil) end, addon, 'LibMerisioux snoop callback')
    else
      Utility.Dispatch(function() callback(meri.whoami, nil, 'ENOENT') end, addon, 'LibMerisioux snoop callback')
    end
    return
  end
  if not rar then
    Utility.Dispatch(function() callback(char, nil, "Can't find LibRarian to snoop on people") end, addon, 'LibMerisioux snoop callback')
    return
  end
  if query == false then
    if meri.char.data then
      Utility.Dispatch(function() callback(char, meri.data[char].data, meri.data[char].error) end, addon, 'LibMerisioux snoop callback')
      return
    else
      Utility.Dispatch(function() callback(char, nil, "ENOENT") end, addon, 'LibMerisioux snoop callback')
      return
    end
  end
  if meri.data[char] and not query then
    if Inspect.Time.Server() - (meri.data[char].stamp or 0) < 600 then
      Utility.Dispatch(function() callback(char, meri.data[char].data, meri.data[char].error) end, addon, 'LibMerisioux snoop callback')
      return
    end
  end
  if not meri.callbacks[char] then
    meri.callbacks[char] = { { callback, Inspect.Addon.Current() } }
    meri.callback_times[char] = Inspect.Time.Frame()
    rar.retrieve(char, 'merisioux_data', meri.snoop_callback)
  else
    meri.callbacks[char][#meri.callbacks[char] + 1] = { callback, Inspect.Addon.Current() }
  end
end

function meri.update_hook()
  local now = Inspect.Time.Frame()
  local removes = {}
  for char, time in pairs(meri.callback_times) do
    if now - time >= 2 then
      meri.snoop_callback(char, identifier, nil, 'Timed out.')
      table.insert(removes, char)
    end
  end
  for _, char in ipairs(removes) do
    meri.callback_times[char] = nil
  end
end

function meri.flaunt_specific(field, value)
  if value == false then
    if meri.template[field] then
      meri.self[field] = nil
      return
    else
      printf("I've never heard of a '%s', how can I not flaunt it?",
	tostring(field))
    end
  end
  if type(value) ~= 'string' then
    printf("Oh, I can't flaunt *that*, it's a %s.", type(value))
    return
  end
  if meri.template[field] then
    meri.self[field] = string.sub(value, 1, meri.template[field].max)
  else
    printf("I've never heard of a '%s', how can I flaunt it?",
      tostring(field))
  end
end

function meri.update_local(skip_stamp)
  if meri.self then
    meri.self.version = meri.data_version
    if not skip_stamp then
      meri.self.stamp = Inspect.Time.Server()
    end
    if meri.addon_info then
      meri.self.addonversion = meri.addon_info
    else
      meri.self.addonversion = nil
    end
    meri.self.libversion = meri.version
    local verbose = Utility.Serialize.Inline(meri.self)
    local deflate = zlib.deflate(zlib.BEST_COMPRESSION)
    local deflated, eof, bytes_in, bytes_out = deflate(verbose, "finish")
    rar.store('merisioux_data', 'public', deflated, true)
    return bytes_in, bytes_out
  else
    rar.store('merisioux_data', 'public', nil, true)
    return 0, 0
  end
end

function meri.setflag(c, state)
  if not meri.flagtable[c] then
    return ''
  end
  if not meri.self.flags then
    meri.self.flags = ''
  end
  if not meri.self.editing_flags then
    meri.self.editing_flags = meri.self.flags
  end
  if state ~= false then
    local removed = ''
    if not string.find(meri.self.editing_flags, c) then
      meri.self.editing_flags = meri.self.editing_flags .. c
    end
    if meri.flagtable[c].excludes and meri.flagtable[c].excludes ~= '' then
      for c2 in string.gmatch(meri.flagtable[c].excludes, '.') do
        if string.find(meri.self.editing_flags, c2) then
	  meri.self.editing_flags = string.gsub(meri.self.editing_flags, c2, '')
          removed = removed .. c2
        end
      end
    end
    return removed
  else
    meri.self.editing_flags = string.gsub(meri.self.editing_flags, c, '')
    return ''
  end
end

function meri.flaunt(field_or_table, value)
  -- special case to support the crufty flag editing
  if field_or_table == 'flags' and not value then
    meri.self.flags = meri.self.editing_flags
    return meri.update_local()
  end
  if not field_or_table then
    return nil, "You can't flaunt it if you haven't got it."
  end
  if value then
    meri.flaunt_specific(field_or_table, value)
    return meri.update_local()
  end
  if type(field_or_table) ~= 'table' then
    return nil, string.format("I really don't see how I can flaunt a %s.", type(field_or_table))
  end
  for k, v in pairs(field_or_table) do
    meri.flaunt_specific(k, v)
  end
  return meri.update_local()
end

function meri.prettyname(name, data)
  local prefix = data and data.prefix or ''
  local suffix = data and data.suffix or ''
  local override = data and data.override or ''

  if override ~= '' then
    name = override
  end
  name = string.upper(string.sub(name, 1, 1)) .. string.lower(string.sub(name, 2))

  local pretty = prefix

  if prefix ~= '' and name ~= '' then
    pretty = pretty .. ' '
  end

  pretty = pretty .. name

  if name ~= '' and suffix ~= '' then
    pretty = pretty .. ' '
  end

  pretty = pretty .. suffix

  return pretty
end

function meri.list(flagstring)
  local flags = {}
  if flagstring then
    for i = 1, #flagstring do
      flags[#flags + 1] = flagstring:sub(i, i)
    end
  end
  local known = {}
  for char, details in pairs(meri.data) do
    local stash = true
    if #flags > 0 then
      if details.data and details.data.flags then
        for i = 1, #flags do
	  if not details.data.flags:match(flags[i]) then
	    stash = false
	    break
	  end
	end
      else
        stash = false
      end
    end
    if stash then
      known[#known + 1] = char
    end
  end
  return known
end

Command.Event.Attach(Event.Addon.SavedVariables.Load.End, meri.variables_loaded, "variable loaded hook")
Command.Event.Attach(Event.Addon.Startup.End, function() Library.LibCron.recurring(1, meri.update_hook) end, "request timeouts")
Command.Event.Attach(Event.Addon.Shutdown.Begin, meri.clean_variables, "variable cleanup")
