--
-- Tome.Guild.lua
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
Tome.Guild = {}

-- Store the identifier to use for the guild data in storage
Tome.Guild.Identifier = "TomeGuild"

-- Store an error counter so we can monitor errors
Tome.Guild.Errors = { Get = 0, Set = 0 }

-- This function checks if the player is in a guild
function Tome.Guild.PlayerInGuild()
    -- If the player is not iun a guild, return false
    if not Inspect.Unit.Detail("player").guild then
        return false
    end

    return true
end

-- This function checks if the player has permission to write to guild storage
function Tome.Guild.PlayerCanWrite()
    -- Return false if the player is not in a guild
    if not Tome.Guild.PlayerInGuild() then
        return false
    end

    -- Get the players guild roster details
    local player = Inspect.Guild.Roster.Detail(Inspect.Unit.Detail("player").name)

    -- Get the rank info for the players guild rank
    local rank = Inspect.Guild.Rank.Detail(player.rank)

    -- Return false if the player does not have write and delete permissions on guild storage
    if not (rank.addonStorageWrite and rank.addonStorageDelete) then
        return false
    end

    return true
end

-- This function is called by the event API when the query is sent
function Tome.Guild.QueryCallback(failure, message)
    -- Check if the query failed
    if failure then
        -- Increment the get error counter
        Tome.Guild.Errors.Get = Tome.Guild.Errors.Get + 1
    end
end

-- This function initiates a query for the information from guild storage
function Tome.Guild.Query()
    -- Abort if the player is not in a guild
    if not Tome.Guild.PlayerInGuild() then
        return
    end

    -- Send a storage query command to the RIFT API
    Command.Storage.Get(
        Inspect.Unit.Detail("player").name,
        "guild",
        Tome.Guild.Identifier,
        Tome.Guild.QueryCallback
    )
end

-- This function is called by the event API when the info is stored
function Tome.Guild.StoreCallback(failure, message)
    -- Check if the store failed
    if failure then
        -- Increment the set error counter
        Tome.Guild.Errors.Set = Tome.Guild.Errors.Set + 1
    end
end

-- This function stores the guild info in the guild storage
function Tome.Guild.Store()
    -- Abort if the player does not have write permissions to guild storage
    if not Tome.Guild.PlayerCanWrite() then
        return
    end

    -- Send a storage set command to the RIFT API
    Command.Storage.Set(
        "guild",
        Tome.Guild.Identifier,
        "public",
        "guild",
        Tome_Guild,
        Tome.Guild.StoreCallback
    )
end

-- This function is called by the event API when the guild info is returned from storage
function Tome.Guild.Event_Storage_Get(handle, target, segment, identifier, read, write, data)
    -- Abort if this is not guild info data
    if identifier ~= Tome.Guild.Identifier or segment ~= "guild" then
        return
    end

    -- Check if this is the players guild
    if target == Inspect.Unit.Detail("player").name then
        -- Store the retrieved guild info
        Tome_Guild = data
    else
        --
    end
end

-- Attach to the storage get event
Command.Event.Attach(
    Event.Storage.Get,
    Tome.Guild.Event_Storage_Get,
    "Tome_Guild_Event_Storage_Get"
)
