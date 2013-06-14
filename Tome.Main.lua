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

-- Create a global table that UI modules than hook into
Tome.UI = {}

-- This function prints the help message
function Tome.ShowHelp()
    print("Available commands:")
    print("  ic - Marks you as in character")
    print("  ooc - Marks you as out of character")
    print("  tutor - Toggles your tutor status")
    print("  help - Shows this help message")
    print("  clear - Clears the internal data cache")
    print("  show <string> - Displays cached data for a character")
    print("  set prefix <string> - Sets your prefix")
    print("  set name <string> - Sets your name")
    print("  set suffix <string> - Sets your suffix")
    print("  set title <string> - Sets your title")
    print("  set age <string> - Sets your age")
    print("  set height <string> - Sets your height")
    print("  set weight <string> - Sets your weight")
    print("  set appearance <string> - Sets your appearance")
    print("  set history <string> - Sets your history")
    print("  set flag <int> - Sets your flag")
    print("  debug - Prints debug information about the addon")
end

-- This function dumps some debug info about the addon
function Tome.ShowDebug()
    -- Get CPU usage for all addons
    local cpu = Inspect.Addon.Cpu()

    -- Print CPU usage information
    if cpu[Inspect.Addon.Current()] then
        print("------- CPU Usage -------")
        for key, value in pairs(cpu[Inspect.Addon.Current()]) do
            print(string.format("%s = %02f%%", key, value * 100))
        end
    else
        print("Unable to get CPU usage information!")
    end

    -- Dump the serialized character information
    print("------- Character Info -------")
    print(Tome.Data.Serialize(Tome_Character))
end

-- This function sets different values of your Tome characters
function Tome.Set(key, value)
    -- Determine which setting to modify
    if (key == "prefix") then
        Tome_Character.Prefix = value
    elseif (key == "name") then
        Tome_Character.Name = value
    elseif (key == "suffix") then
        Tome_Character.Suffix = value
    elseif (key == "title") then
        Tome_Character.Title = value
    elseif (key == "age") then
        Tome_Character.Age = value
    elseif (key == "height") then
        Tome_Character.Height = value
    elseif (key == "weight") then
        Tome_Character.Weight = value
    elseif (key == "appearance") then
        Tome_Character.Appearance = value
    elseif (key == "history") then
        Tome_Character.History = value
    elseif (key == "flag") then
        -- Verify that the flag is numeric
        if not tonumber(value) then
            print("Non-numeric flag specified in command 'set'")
            return
        end

        -- Verify that the flag exists
        local exists = false
        for _, flag in pairs(Tome.Data.Flags) do
            if (flag.id == tonumber(value)) then
                exists = true
                break
            end
        end
        if not exists then
            print(string.format("Flag '%s' does not exist", value))
            return
        end

        Tome_Character.Flag = tonumber(value)
    else
        -- No settings matches. Notify the player and abort
        print(string.format("No setting named '%s'. Type '/tome help' for a list", key))
        return
    end

    -- Confirm to the player that we set the value
    print(string.format("Set your %s to: %s", key, value))
end

-- This function is triggered from the event API when a slash command is entered
function Tome.Event_Command_Slash(handle, commandline)
    -- Split the command line on space to get the parameters
    local parameters = {}
    for key in string.gmatch(commandline, "%S+") do
        if key then
            table.insert(parameters, key)
        end
    end

    -- If no parameters were provided, just display the config interface
    if (table.getn(parameters) == 0) then
        -- TODO: Show the config UI
        return
    end

    -- The first element of the parameters is the command
    local command = string.lower(table.remove(parameters, 1))

    if (command == "ic") then
        Tome_Character.InCharacter = true
        -- TODO: Trigger a broadcast update
        print("You are now In Character")
    elseif (command == "ooc") then
        Tome_Character.InCharacter = false
        -- TODO: Trigger a broadcast update
        print("You are now Out Of Character")
    elseif (command == "tutor") then
        Tome_Character.Tutor = not Tome_Character.Tutor
        -- TODO: Trigger a broadcast update
        if Tome_Character.Tutor then
            print("You are now in Tutor mode")
        else
            print("You are no longer in Tutor mode")
        end
    elseif (command == "help") then
        Tome.ShowHelp()
    elseif (command == "clear") then
        Tome_Cache = {}
        print("Cache cleared")
    elseif (command == "show") then
        -- Abort if we do not have a name
        if (table.getn(parameters) ~= 1) then
            print("Incorrect parameter for command 'show'")
            return
        end

        -- Get the name and uppercase it
        local name = string.upper(table.remove(parameters, 1))

        -- If we do not have the character in cache, abort
        if not Tome_Cache[name] then
            print("Character data not found in cache")
            return
        end

        -- TODO: Show the character UI
    elseif (command == "set") then
        -- Abort if we have less than two parameters
        if (table.getn(parameters) < 2) then
            print("Not enough parameters for command 'set'")
            return
        end

        -- Get the key and value
        local key = string.lower(table.remove(parameters, 1))
        local value = table.concat(parameters, " ")

        Tome.Set(key, value)
    elseif (command == "debug") then
        Tome.ShowDebug()
    else
        -- No commands mathes. Display help message
        Tome.ShowHelp()
    end
end

-- Attach to the slash command event using the "/tome" prefix
Command.Event.Attach(
    Command.Slash.Register("tome"),
    Tome.Event_Command_Slash,
    "Tome_Event_Command_Slash"
)
