--
-- Tome.Data.lua
-- Maintained by Lyrai @ Faeblight NA (Zhevron @ Github)
--
-- This file is part of Tome.
--
-- Tome is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- Tome is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with Tome. If not, see <http://www.gnu.org/licenses/>.
--

-- Create the global module table
Tome.Data = {}

-- Create a global table for compatibility modules to hook into
Tome.Compat = {}

-- Store the various RP status flags
Tome.Data.Flags = {
    { id = 0, text = "Non-Roleplayer" },
    { id = 1, text = "Fledgling Roleplayer" },
    { id = 2, text = "Roleplayer" },
    { id = 3, text = "Experienced Roleplayer" }
}

-- Store a table of statistics that can be used for debugging
Tome.Data.Statistics = {
    Query = {
        Sent = 0,
        Received = 0,
        Errors = 0
    },
    Data = {
        Sent = 0,
        Received = 0,
        Errors = 0
    }
}

-- Store a table that contains the send error data
Tome.Data.Error = {
    Target = "",
    Type = ""
}

-- Serializes a variable so it can be transmitted across the network
function Tome.Data.Serialize(data)
    -- Append the version to the data table
    data.Version = Tome.GetVersion()

    -- Use the Rift API serializer to serialize the data
    local serialized = Utility.Serialize.Inline(data)

    -- Instantiate ZLIB to deflate the data
    local deflate = zlib.deflate(zlib.BEST_COMPRESSION)

    -- Deflate the raw data
    local deflated = deflate(serialized, "finish")

    return deflated
end

-- This function deserializes data back into their objects
function Tome.Data.Deserialize(data)
    -- Instantiate ZLIB to inflate the data
    local inflate = zlib.inflate()

    -- Inflate the compressed data
    local inflated = inflate(data)

    -- Deserialize using loadstring
    local deserialized = loadstring(string.format("return %s", inflated))

    -- If it was successful, return the result of the code. Else, return nil
    if deserialized then
        return deserialized()
    else
        return nil
    end
end

-- This function gets data from the cache or sends a query if it doesn't exist
function Tome.Data.Get(name)
    -- Force the name to be uppercase
    name = string.upper(name)

    -- Check if we have the character data in our cache
    if Tome_Cache.Character[name] then
        -- Data is cached. Get the time that it will expire
        local expires = Tome_Cache.Character[name].Timestamp + Tome_Config.Timeout

        -- Send a new query if the data has expired and flag it
        if (expires <= os.time()) then
            Tome.Data.Query(name)
            Tome_Cache.Character[name].Expired = true
        end

        return Tome_Cache.Character[name]
    else
        -- Data is not present. Send a new query
        Tome.Data.Query(name)
    end

    return nil
end

-- This function adds specified data to the character data cache
function Tome.Data.Cache(name, data)
    -- Set the time this entry was added so we can check for expiry later
    data.Timestamp = os.time()

    -- Set the origin addon for the data
    data.Origin = "Tome"

    -- Store the players guild name in the data
    data.Guild = Inspect.Unit.Detail(name).guild

    -- Store the data in our cache
    Tome_Cache.Character[string.upper(name)] = data

    -- Notify the tooltip and button that we have an update in the cache
    Tome.Tooltip.NotifyUpdate(name)
    Tome.Button.NotifyUpdate(name)
end

-- This function sends a data query to the target or broadcasts if not target is provided
function Tome.Data.Query(target, bypassthrottle)
    -- Abort if no target is provided
    if not target then
        return
    end
    -- Check that the query should not be throttled
    if not bypassthrottle and Tome_Throttle[string.upper(target)] and Tome_Throttle[string.upper(target)] < os.time() then
        return
    end

    -- Set the throttle time
    Tome_Throttle[string.upper(target)] = os.time() + Tome_Config.Throttle

    -- Store the target name and message type
    Tome.Data.Error.Target = target
    Tome.Data.Error.Type = "Query"

    -- Send query to a single target
    Command.Message.Send(target, "Tome_Query", "", Tome.Data.SendCallback)

    -- Call the compatibility modules' query function
    for _, item in pairs(Tome.Compat) do
        item.Query(target)
    end
end

-- This function sends the character data to a target
function Tome.Data.Send(target, broadcast)
    -- Abort if no target is provided
    if not target then
        return
    end

    -- Check if this is a broadcast
    if not broadcast then
        -- Store the target name and message type
        Tome.Data.Error.Target = target
        Tome.Data.Error.Type = "Send"

        -- Serialize character data for sending
        local data = Tome.Data.Serialize(Tome_Character)

        -- Send data to a single target
        Command.Message.Send(target, "Tome_Data", data, Tome.Data.SendCallback)
    else
        -- Broadcast data to anyone in specified range
        Command.Message.Broadcast(target, nil, "Tome_Broadcast", "")
    end
end

-- This function is used as a callback to notify the player if an error occured while sending a message
function Tome.Data.SendCallback(failure, message)
    -- If an error occured, notify the player
    if failure then
        -- Increment the statistics error counter
        if (Tome.Data.Error.Type == "Query") then
            Tome.Data.Statistics.Query.Errors = Tome.Data.Statistics.Query.Errors + 1
        elseif (Tome.Data.Error.Type == "Data") then
            Tome.Data.Statistics.Data.Errors = Tome.Data.Statistics.Data.Errors + 1
        end
    else
        -- Increment the statistics sent counter
        if (Tome.Data.Error.Type == "Query") then
            Tome.Data.Statistics.Query.Sent = Tome.Data.Statistics.Query.Sent + 1
        elseif (Tome.Data.Error.Type == "Data") then
            Tome.Data.Statistics.Data.Sent = Tome.Data.Statistics.Data.Sent + 1
        end
    end
end

-- This function is triggered by the event API when an addon message is received
function Tome.Data.Event_Message_Receive(handle, from, msgtype, channel, identifier, data)
    -- Discard if it's not a message for Tome
    if (identifier ~= "Tome_Query" and identifier ~= "Tome_Data" and identifier ~= "Tome_Broadcast") then
        return
    end

    -- Since broadcasts hit ourselves, discard if it originated from the player
    if (from == Inspect.Unit.Detail("player").name) then
        return
    end

    -- Determine the message type
    if (identifier == "Tome_Query") then
        -- Increment the query received counter
        Tome.Data.Statistics.Query.Received = Tome.Data.Statistics.Query.Received + 1

        -- It's a query. Send our data
        Tome.Data.Send(from)
    elseif (identifier == "Tome_Data") then
        -- Increment the data received counter
        Tome.Data.Statistics.Data.Received = Tome.Data.Statistics.Data.Received + 1

        -- It's a data packet. Unserialize the data
        local deserialized = Tome.Data.Deserialize(data)

        -- Check that the data is valid and exit if it isn't
        if (type(deserialized) ~= "table") then
            return
        end

        -- Run a version check on the data
        if deserialized.Version then
            Tome.CheckVersion(deserialized.Version)
        end

        -- Store the data in our cache
        Tome.Data.Cache(from, deserialized)
    elseif (identifier == "Tome_Broadcast") then
        -- Someone just changed their details. Query for the new data
        Tome.Data.Query(from, true)
    else
        -- Somehow an unexpected message got through. Print an error
        print(string.format("Unexpected message with identifier '%s' received!", identifier))
    end
end

-- Set the addon to accept messages from the Tome identifiers
Command.Message.Accept(nil, "Tome_Query")
Command.Message.Accept(nil, "Tome_Data")
Command.Message.Accept(nil, "Tome_Broadcast")

-- Attach to the message received event
Command.Event.Attach(
    Event.Message.Receive,
    Tome.Data.Event_Message_Receive,
    "Tome_Data_Event_Message_Receive"
)
