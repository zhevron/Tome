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

-- Store the various RP status flags
Tome.Data.Flags = {
    { id = 0, text = "Non-Roleplayer" },
    { id = 1, text = "" },
    { id = 2, text = "" },
    { id = 3, text = "" },
    { id = 4, text = "" }
}

-- Store a table that contains the send error data
Tome.Data.Error = {
    Target = "",
    Type = "",
    Count = 0
}

-- Serializes a variable so it can be transmitted across the network
function Tome.Data.Serialize(value, name, depth)
    -- Set depth to 0 if we're just starting the serialization
    depth = depth or 0

    -- Create the variable to store the serialized string
    local serialized = ""

    -- If a variable name is provided, serialize it.
    if name then
        if (type(name) == "number") then
            -- Name is a numeric value
            serialized = string.format("%s[%d]=", serialized, name)
        else
            -- Name is a string value
            serialized = string.format("%s%s=", serialized, name)
        end
    else
        -- No variable name at 0 depth. Prepend return statement
        if depth == 0 then
            serialized = "return "
        end
    end

    -- Determine type of the value and serialize accordingly
    if (type(value) == "table") then
        -- Table value. Append opening bracket
        serialized = string.format("%s{", serialized)

        -- Recurse through the table and serialize all levels
        for key, val in pairs(value) do
            serialized = string.format("%s%s,", serialized, Tome.Data.Serialize(val, key, depth + 1))
        end

        -- Remove the last superflous comma
        serialized = string.sub(serialized, 1, -2)

        -- Append closing bracket
        serialized = string.format("%s}", serialized)
    elseif (type(value) == "number" or type(value) == "boolean") then
        -- Integer or boolean. Convert to string and append to the serialized string
        serialized = string.format("%s%s", serialized, tostring(value))
    elseif (type(value) == "string") then
        -- String type. Append to the end of the serialized string
        serialized = string.format("%s\"%s\"", serialized, value)
    else
        -- Unsupported type. Print error and return nil
        print(string.format("Attempted to serialize unsupported type '%s'!", type(value)))
        return nil
    end

    return serialized;
end

-- This function deserializes data back into their objects
function Tome.Data.Deserialize(data)
    -- Deserialize using loadstring
    local deserialized = loadstring(data)

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
    if Tome_Cache[name] then
        -- Data is cached. Get the time that it will expire
        local expires = Tome_Cache[name].Timestamp + Tome_Config.Timeout

        -- Check that the data hasn't expired
        if (expires >= os.time()) then
            -- Data is still valid. Return it
            return Tome_Cache[name]
        else
            -- Data has expires. Send a new query
            Tome.Data.Query(name)
        end
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

    -- Store the data in our cache
    Tome_Cache[string.upper(name)] = data
end

-- This function sends a data query to the target or broadcasts if not target is provided
function Tome.Data.Query(target, broadcast)
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
        Command.Message.Send(target, "Tome_Query", "", Tome.Data.SendCallback)
    else
        -- Broadcast query to anyone in /say range
        Command.Message.Broadcast(target, nil, "Tome_Query", "")
    end
end

-- This function is used as a callback to notify the player if an error occured while sending a message
function Tome.Data.SendCallback(failure, message)
    -- If an error occured, notify the player
    if failure then
        -- If above he failure threshold, abort
        if (Tome.Data.Error.Count >= 10) then
            -- Reset the error counter
            Tome.Data.Error.Count = 0
            return
        end

        -- Increase failure count
        Tome.Data.Error.Count = Tome.Data.Error.Count + 1

        -- Attempt to send again
        if (Tome.Data.Error.Type == "Query") then
            Tome.Data.Query(Tome.Data.Error.Target)
        elseif (Tome.Data.Error.Type == "Send") then
            Tome.Data.Send(Tome.Data.Error.Target)
        end
    else
        -- No errors, reset the error counter
        Tome.Data.Error.Count = 0
    end
end

-- This function sends the character data to a target or broadcasts if no target is provided
function Tome.Data.Send(target, broadcast)
    -- Abort if no target is provided
    if not target then
        return
    end

    -- Serialize character data for sending
    local data = Tome.Data.Serialize(Tome_Character)

    -- Check if this is a broadcast
    if not broadcast then
        -- Store the target name in case we have to try again
        Tome.Data.Error.Target = target
        Tome.Data.Error.Type = "Send"

        -- Send data to a single target
        Command.Message.Send(target, "Tome_Data", data, Tome.Data.SendCallback)
    else
        -- Broadcast data to anyone in /say range
        Command.Message.Broadcast(target, nil, "Tome_Data", data)
    end
end

-- This function is triggered by the event API when an addon message is received
function Tome.Data.Event_Message_Receive(handle, from, msgtype, channel, identifier, data)
    -- Discard if it's not a message for Tome
    if (identifier ~= "Tome_Query" and identifier ~= "Tome_Data") then
        return
    end

    -- Determine the message type
    if (identifier == "Tome_Query") then
        -- It's a query. Send our data
        Tome.Data.Send(from)
    elseif (identifier == "Tome_Data") then
        -- It's a data packet. Unserialize the data
        local deserialized = Tome.Data.Deserialize(data)

        -- Check that the data is valid and exit if it isn't
        if (type(deserialized) ~= "table") then
            return
        end

        -- Store the data in our cache
        Tome.Data.Cache(from, deserialized)
    else
        -- Somehow an unexpected message got through. Print an error
        print(string.format("Unexpected message with identifier '%s' received!", identifier))
    end
end

-- Set the addon to accept messages from the Tome identifiers
Command.Message.Accept(nil, "Tome_Query")
Command.Message.Accept(nil, "Tome_Data")

-- Attach to the message received event
Command.Event.Attach(
    Event.Message.Receive,
    Tome.Data.Event_Message_Receive,
    "Tome_Data_Event_Message_Receive"
)
