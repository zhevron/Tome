--
-- Tome.Tooltip.lua
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
Tome.Tooltip = {}

-- Create the tooltip UI context
Tome.Tooltip.Context = UI.CreateContext("Tome_Tooltip")

-- Set the context strata
Tome.Tooltip.Context:SetStrata("topmost")

-- Create the initial tooltip frame
Tome.Tooltip.Frame = UI.CreateFrame("Frame", "Tome_Tooltip_Frame", Tome.Tooltip.Context)

-- Hide the frame initially
Tome.Tooltip.Frame:SetVisible(false)

-- Create a table to store the border frames in
Tome.Tooltip.Borders = {}

-- Store the current tooltip target
Tome.Tooltip.Target = nil

-- Store the combat state of the player
Tome.Tooltip.InCombat = false

-- This function creates the tooltip frames
function Tome.Tooltip.Create()
    -- Set the initial anchor points for the tooltip frame
    Tome.Tooltip.Frame:SetPoint("TOPRIGHT", UI.Native.Tooltip, "TOPLEFT", -5, 10)
    Tome.Tooltip.Frame:SetPoint("BOTTOMRIGHT", UI.Native.Tooltip, "BOTTOMLEFT", -5, -3)

    -- Set the background colors of the frame
    Tome.Tooltip.Frame:SetBackgroundColor(0.1, 0.12, 0.1, 0.9)

    -- Create the border frames
    Tome.Tooltip.Borders.Top = UI.CreateFrame("Frame", "Tome_Tooltip_Border_Top", Tome.Tooltip.Frame)
    Tome.Tooltip.Borders.Left = UI.CreateFrame("Frame", "Tome_Tooltip_Border_Left", Tome.Tooltip.Frame)
    Tome.Tooltip.Borders.Bottom = UI.CreateFrame("Frame", "Tome_Tooltip_Border_Bottom", Tome.Tooltip.Frame)
    Tome.Tooltip.Borders.Right = UI.CreateFrame("Frame", "Tome_Tooltip_Border_Right", Tome.Tooltip.Frame)

    -- Set the positions of the borders frames
    Tome.Tooltip.Borders.Top:SetPoint("TOPLEFT", Tome.Tooltip.Frame, "TOPLEFT", 0, 0)
    Tome.Tooltip.Borders.Top:SetPoint("BOTTOMRIGHT", Tome.Tooltip.Frame, "TOPRIGHT", 0, 1)
    Tome.Tooltip.Borders.Left:SetPoint("TOPLEFT", Tome.Tooltip.Frame, "TOPLEFT", 0, 0)
    Tome.Tooltip.Borders.Left:SetPoint("BOTTOMRIGHT", Tome.Tooltip.Frame, "BOTTOMLEFT", 1, 0)
    Tome.Tooltip.Borders.Bottom:SetPoint("TOPLEFT", Tome.Tooltip.Frame, "BOTTOMLEFT", 0, -1)
    Tome.Tooltip.Borders.Bottom:SetPoint("BOTTOMRIGHT", Tome.Tooltip.Frame, "BOTTOMRIGHT", 0, 0)
    Tome.Tooltip.Borders.Right:SetPoint("TOPLEFT", Tome.Tooltip.Frame, "TOPRIGHT", -1, 0)
    Tome.Tooltip.Borders.Right:SetPoint("BOTTOMRIGHT", Tome.Tooltip.Frame, "BOTTOMRIGHT", 0, 0)

    -- Set the color of the border frames
    Tome.Tooltip.Borders.Top:SetBackgroundColor(0.57, 0.56, 0.44, 1.0)
    Tome.Tooltip.Borders.Left:SetBackgroundColor(0.57, 0.56, 0.44, 1.0)
    Tome.Tooltip.Borders.Bottom:SetBackgroundColor(0.57, 0.56, 0.44, 1.0)
    Tome.Tooltip.Borders.Right:SetBackgroundColor(0.57, 0.56, 0.44, 1.0)

    -- Create the name label frame
    Tome.Tooltip.Name = UI.CreateFrame("Text", "Tome_Tooltip_Name", Tome.Tooltip.Frame)
    Tome.Tooltip.Name:SetPoint("TOPLEFT", Tome.Tooltip.Frame, "TOPLEFT", 5, 5)
    Tome.Tooltip.Name:SetFontSize(15)

    -- Create the title label frame
    Tome.Tooltip.Title = UI.CreateFrame("Text", "Tome_Tooltip_Title", Tome.Tooltip.Frame)
    Tome.Tooltip.Title:SetPoint("TOPLEFT", Tome.Tooltip.Name, "BOTTOMLEFT", 0, -5)
    Tome.Tooltip.Title:SetFontColor(0.6, 0.6, 0.8, 1.0)

    -- Create the cache status label frame
    Tome.Tooltip.Cache = UI.CreateFrame("Text", "Tome_Tooltip_Cache", Tome.Tooltip.Frame)
    Tome.Tooltip.Cache:SetPoint("BOTTOMLEFT", Tome.Tooltip.Frame, "BOTTOMLEFT", 5, -5)

    -- Create the origin addon label frame
    Tome.Tooltip.Origin = UI.CreateFrame("Text", "Tome_Tooltip_Origin", Tome.Tooltip.Frame)
    Tome.Tooltip.Origin:SetPoint("BOTTOMRIGHT", Tome.Tooltip.Frame, "BOTTOMRIGHT", -5, -5)
    Tome.Tooltip.Origin:SetFontColor(1.0, 1.0, 0.8, 1.0)

    -- Create the flag label frame
    Tome.Tooltip.Flag = UI.CreateFrame("Text", "Tome_Tooltip_Flag", Tome.Tooltip.Frame)
    Tome.Tooltip.Flag:SetPoint("BOTTOMLEFT", Tome.Tooltip.Cache, "TOPLEFT", 0, -2)
    Tome.Tooltip.Flag:SetFontColor(0.2, 0.5, 0.9, 1.0)
    Tome.Tooltip.Flag:SetFontSize(13)

    -- Create the in character indicator label frame
    Tome.Tooltip.InCharacter = UI.CreateFrame("Text", "Tome_Tooltip_InCharacter", Tome.Tooltip.Frame)
    Tome.Tooltip.InCharacter:SetPoint("BOTTOMRIGHT", Tome.Tooltip.Origin, "TOPRIGHT", 0, -2)
    Tome.Tooltip.InCharacter:SetFontSize(13)
end

-- This function updates the tooltip with a specified unit
function Tome.Tooltip.Update(data)
    -- Check if data was manually supplied
    if not data then
        -- Convert the target name to uppercase
        local name = string.upper(Tome.Tooltip.Target.name)

        -- If we do not have this player in the cache, abort and make a query
        if not Tome_Cache[name] then
            Tome.Data.Query(Tome.Tooltip.Target.name)
            Tome.Tooltip.Frame:SetVisible(false)
            return
        end

        -- Fetch the data from the cache
        data = Tome_Cache[name]
    end

    -- Set the players title
    Tome.Tooltip.Title:SetText(data.Title)

    -- Make a temporary variable with the player name
    local name = data.Name

    -- Prepend the prefix if the player has one
    if data.Prefix and data.Prefix ~= "" then
        name = string.format("%s %s", data.Prefix, name)
    end

    -- Append the suffix if the player has one
    if data.Suffix and data.Suffix ~= "" then
        name = string.format("%s %s", name, data.Suffix)
    end

    -- Set the players name
    Tome.Tooltip.Name:SetText(name)

    -- Make a temporary variable to store our flag text
    local flagtext = ""

    -- Loop the flags
    for _, flag in pairs(Tome.Data.Flags) do
        -- Check if this is the players flag and set the text if it is
        if flag.id == data.Flag then
            flagtext = flag.text
        end
    end

    -- Check if the player is in tutor mode
    if data.Tutor then
        flagtext = string.format("%s (Tutor)", flagtext)
    end

    -- Set the players flag
    Tome.Tooltip.Flag:SetText(flagtext)

    -- Check if the player is in character
    if data.InCharacter then
        -- Set the players in character status and update the text color
        Tome.Tooltip.InCharacter:SetText("In Character")
        Tome.Tooltip.InCharacter:SetFontColor(0.0, 1.0, 0.0, 1.0)
    else
        -- Set the players in character status and update the text color
        Tome.Tooltip.InCharacter:SetText("Out of Character")
        Tome.Tooltip.InCharacter:SetFontColor(0.78, 0.08, 0.08, 1.0)
    end

    -- Display a message if the data is old
    if data.Expired then
        Tome.Tooltip.Cache:SetText("Expired")
    else
        Tome.Tooltip.Cache:SetText(" ")
    end

    -- Set the origin addon text
    if data.Origin then
        if data.Origin == "Tome" then
            local version = Tome.GetVersion()
            Tome.Tooltip.Origin:SetText(string.format(
                "%s %s.%s.%s%s",
                data.Origin,
                version.Major,
                version.Minor,
                version.Hotfix,
                version.Beta and "-beta" or ""
            ))
        else
            Tome.Tooltip.Origin:SetText(data.Origin)
        end
    end

    -- Update the tooltip width
    Tome.Tooltip.UpdateWidth()

    -- Show the frame
    Tome.Tooltip.Frame:SetVisible(true)
end

-- This function checks that the height of the tooltip exceeds the minimum and modifies the anchor accordingly
function Tome.Tooltip.UpdateHeight()
    -- Create a variable to store the minimum required height
    local height = 20

    -- Add the height of the name field
    height = height + Tome.Tooltip.Name:GetHeight()

    -- Add the height of the title field
    height = height + Tome.Tooltip.Title:GetHeight()

    -- Add the height of the flag field
    height = height + Tome.Tooltip.Flag:GetHeight()

    -- Add the height of the origin field
    height = height + Tome.Tooltip.Origin:GetHeight()

    -- Check if the height exceeds the minimum
    if Tome.Tooltip.Frame:GetHeight() >= height then
        -- Set the default TOPRIGHT anchor
        Tome.Tooltip.Frame:SetPoint("TOPRIGHT", UI.Native.Tooltip, "TOPLEFT", -5, 10)
    else
        print(string.format("Changing tooltip to match minimum height. Current=%d,Target=%d", Tome.Tooltip.Frame:GetHeight(), height))
        -- Move the anchor up so it fits the minimum height
        Tome.Tooltip.Frame:SetPoint("TOPRIGHT", UI.Native.Tooltip, "TOPLEFT", -5, 10 - (Tome.Tooltip.Frame:GetHeight() - height))
    end
end

-- This function sets the tooltip width so that all items fit
function Tome.Tooltip.UpdateWidth()
    -- Store the highest width we found
    local width = 0

    -- Check if the title is wider
    if Tome.Tooltip.Title:GetWidth() > width then
        width = Tome.Tooltip.Title:GetWidth()
    end

    -- Check if the name is wider
    if Tome.Tooltip.Name:GetWidth() > width then
        width = Tome.Tooltip.Name:GetWidth()
    end

    -- Check if the width of the flag and in character fields are wider
    local total = Tome.Tooltip.Flag:GetWidth() + Tome.Tooltip.InCharacter:GetWidth()
    if total > width then
        width = total
    end

    -- Set the tooltip width
    Tome.Tooltip.Frame:SetWidth(width + 30)
end

-- This funtion is used to notify the tooltip of an update in the data cache
function Tome.Tooltip.NotifyUpdate(name)
    -- Abort if we're currently not looking at any unit
    if not Tome.Tooltip.Target then
        return
    end

    -- Abort if this is not the unit we're currently looking at
    if name ~= Tome.Tooltip.Target.name then
        return
    end

    -- Get the data from the cache
    local data = Tome_Cache[string.upper(name)]

    -- Abort if we were unable to get the data from the cache
    if not data then
        return
    end

    -- Update the tooltip with the new data
    Tome.Tooltip.Update(data)
end

-- This function is triggered by the event API when the tooltip changes
function Tome.Tooltip.Event_Tooltip(handle, tiptype, shown, buff)
    -- Discard if it's not a unit tooltip and make sure our tooltip stays hidden
    if tiptype ~= "unit" then
        Tome.Tooltip.Frame:SetVisible(false)
        return
    end

    -- Discard the event if the tooltip should remain hidden in combat
    if Tome.Tooltip.InCombat then
        return
    end

    -- Get the detailed unit info
    local unit = Inspect.Unit.Detail(shown)

    -- Abort if we couldn't get the unit info and make sure our tooltip stays hidden
    if not unit then
        Tome.Tooltip.Frame:SetVisible(false)
        return
    end

    -- Discard if it's not a player and make sure our tooltip stays hidden
    if not unit.player then
        Tome.Tooltip.Frame:SetVisible(false)
        return
    end

    -- Discard if the player is blacklisted and make sure our tooltip stays hidden
    for _, value in pairs(Tome_Blacklist) do
        if string.lower(value) == string.lower(unit.name) then
            Tome.Tooltip.Frame:SetVisible(false)
            return
        end
    end

    -- Store the target
    Tome.Tooltip.Target = unit

    -- Update the tooltip with the unit shown
    Tome.Tooltip.Update()
end

-- This function is triggered by the event API when a frame is about to render
function Tome.Tooltip.Event_System_Update_Begin()
    -- Set the anchor point of the tooltip
    Tome.Tooltip.Frame:SetPoint("TOPRIGHT", UI.Native.Tooltip, "TOPLEFT", -5, 10)
end

-- This function is triggered by the event API when the UI enters secure mode
function Tome.Tooltip.Event_System_Secure_Enter()
    -- Check if we should modify the tooltip state in combat
    if Tome_Config.Tooltip.HideInCombat then
        -- Set the combat flag
        Tome.Tooltip.InCombat = true

        -- Hide the tooltip
        Tome.Tooltip.Frame:SetVisible(false)
    end
end

-- This function is triggered by the event API when the UI leaves secure mode
function Tome.Tooltip.Event_System_Secure_Leave()
    -- Check if we should modify the tooltip state in combat
    if Tome_Config.Tooltip.HideInCombat then
        -- Set the combat flag
        Tome.Tooltip.InCombat = false
    end
end

-- Call the tooltip frame creation function
Tome.Tooltip.Create()

-- Attach to the tooltip changed event
Command.Event.Attach(
    Event.Tooltip,
    Tome.Tooltip.Event_Tooltip,
    "Tome_Tooltip_Event_Tooltip"
)

-- Attach to the frame render begin event
Command.Event.Attach(
    Event.System.Update.Begin,
    Tome.Tooltip.Event_System_Update_Begin,
    "Tome_Tooltip_Event_System_Update_Begin"
)

-- Attach to the UI secure mode events
Command.Event.Attach(
    Event.System.Secure.Enter,
    Tome.Tooltip.Event_System_Secure_Enter,
    "Tome_Tooltip_Event_System_Secure_Enter"
)
Command.Event.Attach(
    Event.System.Secure.Leave,
    Tome.Tooltip.Event_System_Secure_Leave,
    "Tome_Tooltip_Event_System_Secure_Leave"
)
