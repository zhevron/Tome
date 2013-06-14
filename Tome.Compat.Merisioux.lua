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
function Tome.Compat.Merisioux.Serialize()
    --
end

-- This function deserializes data back into their objects
function Tome.Compat.Merisioux.Deserialize()
    --
end

-- This function implements a query for RP data from Merisioux
function Tome.Compat.Merisioux.Query(target)
    --
end

-- This function implements data exchange for RP data in Merisioux
function Tome.Compat.Merisioux.Send(target)
    --
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
    --
end

-- Set the addon to accept messages from the Merisioux identifiers
--

-- Attach to the message received event
Command.Event.Attach(
    Event.Message.Receive,
    Tome.Compat.Merisioux.Event_Message_Receive,
    "Tome_Compat_Merisioux_Event_Message_Receive"
)
