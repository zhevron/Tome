--
-- Tome.Compat.Merisioux.lua
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
Tome.Compat.Merisioux = {}

-- Store a table of statistics that can be used for debugging
Tome.Compat.Merisioux.Statistics = {
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
Tome.Compat.Merisioux.Error = {
    Target = "",
    Type = "",
    Count = 0
}

-- Serializes a variable so it can be transmitted across the network
function Tome.Compat.Merisioux.Serialize(data)
    --
end

-- This function deserializes data back into their objects
function Tome.Compat.Merisioux.Deserialize(data)
    -- Instantiate ZLIB to inflate the data
    local inflate = zlib.inflate()

    -- Inflate the compressed data
    local inflated, eof = inflate(data)

    -- Deserialize using loadstring
    local deserialized = loadstring(string.format("return %s", inflated))

    -- If it was successful, return the result of the code. Else, return nil
    if deserialized then
        return deserialized()
    else
        return nil
    end
end

-- This function adds specified data to the character data cache
function Tome.Compat.Merisioux.Cache(name, data)
    -- Interpret the Merisioux data and convert it to Tome data
    local tomedata = {
        Prefix = data.prefix and data.prefix or "",
        Name = data.override and data.override or name,
        Suffix = data.suffix and data.suffix or "",
        Title = data.title and data.title or "",
        Age = "",
        Height = "",
        Weight = "",
        Appearance = data.description and data.description or "",
        History = data.biography and data.biography or "",
        InCharacter = false,
        Tutor = false,
        Flag = 0
    }

    -- Interpret the Merisioux flags and set the equivalent Tome flags
    if data.flags then
        tomedata.InCharacter = string.find(data.flags, "c") and true or false
        tomedata.Tutor = string.find(data.flags, "h") and true or false
        tomedata.Flag = string.find(data.flags, "w") and 1 or 2
    end

    -- Set the time this entry was added so we can check for expiry later
    tomedata.Timestamp = os.time()

    -- Store the data in our cache
    Tome_Cache[string.upper(name)] = tomedata

    -- Notify the tooltip that we have an update in the cache
    Tome.Tooltip.NotifyUpdate(name)
end

-- This function implements a query for RP data from Merisioux
function Tome.Compat.Merisioux.Query(target, broadcast)
    -- Abort if no target is provided
    if not target then
        return
    end

    -- Check if this is a broadcast
    if not broadcast then
        -- Store the target name in case we have to try again
        Tome.Data.Error.Target = target
        Tome.Data.Error.Type = "Query"

        -- Send query to a single target
        Command.Message.Send(target, "rar_query", "merisioux_data", Tome.Compat.Merisioux.SendCallback)
    else
        -- Broadcast query to anyone in /say range
        Command.Message.Broadcast(target, nil, "rar_query", "merisioux_data")
    end
end

-- This function implements data exchange for RP data in Merisioux
function Tome.Compat.Merisioux.Send(target, broadcast)
    -- Abort if no target is provided
    if not target then
        return
    end

    -- Serialize character data for sending
    local data = Tome.Compat.Merisioux.Serialize(Tome_Character)

    -- Abort if the data serialization somehow failed
    if not data then
        return
    end

    -- Check if this is a broadcast
    if not broadcast then
        -- Store the target name in case we have to try again
        Tome.Data.Error.Target = target
        Tome.Data.Error.Type = "Send"

        -- Send data to a single target
        Command.Message.Send(target, "rar_datum", data, Tome.Compat.Merisioux.SendCallback)
    else
        -- Broadcast data to anyone in /say range
        Command.Message.Broadcast(target, nil, "rar_datum", data)
    end
end

-- This function is used as a callback to notify the player if an error occured while sending a message
function Tome.Compat.Merisioux.SendCallback(failure, message)
    -- If an error occured, notify the player
    if failure then
        -- If above he failure threshold, abort
        if (Tome.Compat.Merisioux.Error.Count >= 10) then
            -- Increment the statistics error counter
            if (Tome.Compat.Merisioux.Error.Type == "Query") then
                Tome.Compat.Merisioux.Statistics.Query.Errors = Tome.Compat.Merisioux.Statistics.Query.Errors + 1
            elseif (Tome.Compat.Merisioux.Error.Type == "Data") then
                Tome.Compat.Merisioux.Statistics.Data.Errors = Tome.Compat.Merisioux.Statistics.Data.Errors + 1
            end

            -- Reset the error counter
            Tome.Compat.Merisioux.Error.Count = 0
            return
        end

        -- Increase failure count
        Tome.Compat.Merisioux.Error.Count = Tome.Compat.Merisioux.Error.Count + 1

        -- Attempt to send again
        if (Tome.Compat.Merisioux.Error.Type == "Query") then
            Tome.Compat.Merisioux.Query(Tome.Compat.Merisioux.Error.Target)
        elseif (Tome.Compat.Merisioux.Error.Type == "Send") then
            Tome.Compat.Merisioux.Send(Tome.Compat.Merisioux.Error.Target)
        end
    else
        -- Increment the statistics sent counter
        if (Tome.Compat.Merisioux.Error.Type == "Query") then
            Tome.Compat.Merisioux.Statistics.Query.Sent = Tome.Compat.Merisioux.Statistics.Query.Sent + 1
        elseif (Tome.Compat.Merisioux.Error.Type == "Data") then
            Tome.Compat.Merisioux.Statistics.Data.Sent = Tome.Compat.Merisioux.Statistics.Data.Sent + 1
        end

        -- No errors, reset the error counter
        Tome.Compat.Merisioux.Error.Count = 0
    end
end

-- This function is triggered by the event API when an addon message is received
function Tome.Compat.Merisioux.Event_Message_Receive(handle, from, msgtype, channel, identifier, data)
    -- Discard if this is not a message from LibRarian
    if (identifier ~= "rar_query" and identifier ~= "rar_datum") then
        return
    end

    -- Determine the message type
    if identifier == "rar_query" then
        -- Discard if it's not requesting data from Merisioux
        if data ~= "merisioux_data" then
            return
        end

        -- Increment the query received counter
        Tome.Compat.Merisioux.Statistics.Query.Received = Tome.Compat.Merisioux.Statistics.Query.Received + 1

        -- It's a query. Send our data
        Tome.Compat.Merisioux.Send(from)
    elseif identifier == "rar_datum" then
        --
        local msgid, msgdata = string.match(data, '([^\1]+)\1(.*)')

        -- Discard if it's not a data message from Merisioux
        if msgid ~= "merisioux_data" then
            return
        end

        -- Increment the data received counter
        Tome.Compat.Merisioux.Statistics.Data.Received = Tome.Compat.Merisioux.Statistics.Data.Received + 1

        -- It's a data packet. Unserialize the data
        local deserialized = Tome.Compat.Merisioux.Deserialize(msgdata)

        -- Check that the data is valid and exit if it isn't
        if (type(deserialized) ~= "table") then
            return
        end

        -- Store the data in our cache
        Tome.Compat.Merisioux.Cache(from, deserialized)
    else
        --
    end
end

-- Set the addon to accept messages from the Merisioux identifiers
Command.Message.Accept(nil, "rar_query")
Command.Message.Accept(nil, "rar_datum")

-- Attach to the message received event
Command.Event.Attach(
    Event.Message.Receive,
    Tome.Compat.Merisioux.Event_Message_Receive,
    "Tome_Compat_Merisioux_Event_Message_Receive"
)
