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

-- This function returns the version of the addon
function Tome.GetVersion()
    -- Make a table for storing the version data
    local version = {}

    -- Get the addon information from the API
    local addon = Inspect.Addon.Detail(Inspect.Addon.Current())

    -- Check if this is a beta version
    if string.find(addon.toc.Version, "-beta") then
        version.Beta = true
    else
        version.Beta = false
    end

    -- Split the version string
    local tbl = {}
    for key, value in string.gmatch(string.gsub(addon.toc.Version, "-beta", ""), ".") do
        if key ~= "." then
            table.insert(tbl, key)
        end
    end

    -- Check that it is valid
    if table.getn(tbl) ~= 2 then
        return nil
    end
    if not tonumber(tbl[1]) or not tonumber(tbl[2]) then
        return nil
    end

    version.Major = tonumber(tbl[1])
    version.Minor = tonumber(tbl[2])

    return version
end

-- This function checks a version against the current version and notifies the player of updates
function Tome.CheckVersion(version)
    -- Get the local addon version
    local addon = Tome.GetVersion()

    -- Check if we have a new version only if both versions are either beta or release
    if addon.Beta == version.Beta and (version.Major > addon.Major or version.Minor > addon.Minor) then
        -- A newer version is available. Notify the player
        print(string.format(
            "A new version (%s.%s) is available! Download it from RiftUI, Curse or http://zhevron.github.io/Tome",
            version.Major,
            version.Minor
        ))
    end
end

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
    print("  debug cpu - Prints CPU usage debug information")
    print("  debug data - Prints the serialized character data")
    print("  debug cache - Prints information about the current cache status")
    print("  debug counters - Prints message counters")
    print("  debug merisioux - Prints message counters for Merisioux compatibility")
end

-- This function dumps some debug info about the addon
function Tome.ShowDebug(command)
    -- Check what information we need to print
    if (command == "cpu") then
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
    elseif (command == "data") then
        -- Dump the character information
        print("------- Character Info -------")
        print(Tome_Character)
    elseif (command == "cache") then
        -- Create variables to hold the total items in the cache and how many have expired
        local total = 0
        local expired = 0

        -- Loop the cache
        for _, item in pairs(Tome_Cache) do
            -- Increment the total counter
            total = total + 1

            -- Check if data has expired
            if (item.Timestamp + Tome_Config.Timeout) <= os.time() then
                -- Increment the expired counter
                expired = expired + 1
            end
        end

        -- Print the current cache status
        print("------- Cache Status -------")
        print(string.format("Total: %d", total))
        print(string.format("Expired: %d", expired))
        print(string.format("Valid: %d", total - expired))
    elseif (command == "counters") then
        -- Show counters for message data (Tome)
        print("------- Message Statistics -------")
        print("Tome Query:")
        print(string.format("  Sent: %d", Tome.Data.Statistics.Query.Sent))
        print(string.format("  Received: %d", Tome.Data.Statistics.Query.Received))
        print(string.format("  Errors: %d", Tome.Data.Statistics.Query.Errors))
        print("Tome Data:")
        print(string.format("  Sent: %d", Tome.Data.Statistics.Data.Sent))
        print(string.format("  Received: %d", Tome.Data.Statistics.Data.Received))
        print(string.format("  Errors: %d", Tome.Data.Statistics.Data.Errors))
    elseif (command == "merisioux") then
        -- Show counters for message data (Merisioux)
        print("------- Message Statistics -------")
        print("Merisioux Query:")
        print(string.format("  Sent: %d", Tome.Compat.Merisioux.Statistics.Query.Sent))
        print(string.format("  Received: %d", Tome.Compat.Merisioux.Statistics.Query.Received))
        print(string.format("  Errors: %d", Tome.Compat.Merisioux.Statistics.Query.Errors))
        print("Merisioux Data:")
        print(string.format("  Sent: %d", Tome.Compat.Merisioux.Statistics.Data.Sent))
        print(string.format("  Received: %d", Tome.Compat.Merisioux.Statistics.Data.Received))
        print(string.format("  Errors: %d", Tome.Compat.Merisioux.Statistics.Data.Errors))
    else
        --
    end
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

    -- Broadcast the new data
    Tome.Data.Send(nil, true)

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
        Tome.UI.Show()
        return
    end

    -- The first element of the parameters is the command
    local command = string.lower(table.remove(parameters, 1))

    if (command == "ic") then
        Tome_Character.InCharacter = true

        -- Broadcast the new data
        Tome.Data.Send(nil, true)

        print("You are now In Character")
    elseif (command == "ooc") then
        Tome_Character.InCharacter = false

        -- Broadcast the new data
        Tome.Data.Send(nil, true)

        print("You are now Out Of Character")
    elseif (command == "tutor") then
        Tome_Character.Tutor = not Tome_Character.Tutor

        -- Broadcast the new data
        Tome.Data.Send(nil, true)

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

        -- Show the character UI
        Tome.UI.Show(Tome_Cache[name])
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
        -- Abort if we do not have a debug command
        if (table.getn(parameters) ~= 1) then
            print("Incorrect parameter for command 'debug'")
            return
        end

        Tome.ShowDebug(string.lower(table.remove(parameters, 1)))
    else
        -- No commands mathes. Display help message
        Tome.ShowHelp()
    end
end

-- This function sets the default saved variables and should be able to upgrade from any version
function Tome.SetDefaults(defaults, current)
    -- Check that the defaults table is valid
    if type(defaults) ~= "table" then
        return
    end

    -- Loop the defaults table
    for key, value in pairs(defaults) do
        -- Check if the value is a table
        if type(value) == "table" then
            -- Recursively run this function on the value table
            current[key] = Tome.SetDefaults(value, current[key])
        else
            -- Check if the key exists in the current table
            if current[key] == nil then
                current[key] = value
            end
        end
    end

    return current
end

-- This function is fired by the event API when the variables for Tome are loaded
function Tome.Event_Loaded(handle, addonidentifier)
    if addonidentifier == Inspect.Addon.Current() then
        -- Set the default variables
        Tome_Config = Tome.SetDefaults(Tome_Defaults, Tome_Config)

        -- Get the addon version
        local version = Tome.GetVersion()

        -- Print a loaded message
        print(string.format(
            "Tome version %d.%d%s loaded!",
            version.Major,
            version.Minor,
            version.Beta and "-beta" or ""
        ))
        print("Type '/tome' to open the character window")
        print("Type '/tome help' for a listing of commands")
    end
end

-- Attach to the slash command event using the "/tome" prefix
Command.Event.Attach(
    Command.Slash.Register("tome"),
    Tome.Event_Command_Slash,
    "Tome_Event_Command_Slash"
)

-- Attach to the SavedVariables loaded event
Command.Event.Attach(
    Event.Addon.SavedVariables.Load.End,
    Tome.Event_Loaded,
    "Tome_Event_Loaded"
)
