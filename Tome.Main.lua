--
-- Tome.Main.lua
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
Tome = {}

-- This function is triggered from the event API when a slash command is entered
function Tome.Event_Command_Slash(handle, commandline)
    -- Split the command line on space to get the parameters
    local parameters = {}
    for key in string.gmatch(commandline, "%S+") do
        if key then
            table.insert(parameters, key)
        end
    end

    -- The first element of the parameters is the command
    local command = table.remove(parameters, 1)

    if (command == "query") then
        local name = table.remove(parameters, 1)
        local data = Tome.Data.Get(name)

        if not data then
            return
        end

        print(string.format("Got flag: %d", data.Flag))
    elseif (command == "cache") then
        Tome_Cache = {}
    end
end

-- Attach to the slash command event using the "/tome" prefix
Command.Event.Attach(
    Command.Slash.Register("tome"),
    Tome.Event_Command_Slash,
    "Tome_Event_Command_Slash"
)
