--
-- Tome.Button.lua
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
Tome.Button = {}

-- Create a variable to store our current target in
Tome.Button.Target = nil

-- Create the context used to render the button
Tome.Button.Context = UI.CreateContext("Tome_Button_Context")

-- Create the button frame
Tome.Button.Frame = UI.CreateFrame("RiftButton", "Tome_Button_Frame", Tome.Button.Context)

-- Set the initial button position
Tome.Button.Frame:SetPoint("TOPLEFT", UI.Native.PortraitTarget, "TOPRIGHT", -5, 10)

-- Hide the button by default
Tome.Button.Frame:SetVisible(false)

-- Set the button text
Tome.Button.Frame:SetText("Tome")

-- This function is used by the Data module to notify the button that the cache has been updated
function Tome.Button.NotifyUpdate(name)
    -- Abort if we do not have a target
    if not Tome.Button.Target then
        return
    end

    -- Abort if this is not our current target
    if name ~= Tome.Button.Target.name then
        return
    end

    -- This is our target. Show the button
    Tome.Button.Frame:SetVisible(true)
end

-- This function is fired from the event API when the player switches target
function Tome.Button.Event_Target(handle, unit)
    -- Reset the target if the player cleared the target
    if not unit then
        Tome.Button.Target = nil
        Tome.Button.Frame:SetVisible(false)
        return
    end

    -- Get the new target details
    local target = Inspect.Unit.Detail(unit)

    -- Abort if we're unable to get any details or if it's not a player
    if not target or not target.player then
        Tome.Button.Target = nil
        Tome.Button.Frame:SetVisible(false)
        return
    end

    -- Store the target for later use
    Tome.Button.Target = target

    -- Get the name of the target and convert to uppercase
    local name = string.upper(target.name)

    -- Abort if we do not have any data in the cache for this target
    if not Tome_Cache[name] then
        Tome.Button.Frame:SetVisible(false)
        return
    end

    -- Show the button since we have data
    Tome.Button.Frame:SetVisible(true)
end

-- This function is fired from the event API when the button is clicked
function Tome.Button.Event_Clicked(handle)
    -- Abort if we do not have a target
    if not Tome.Button.Target then
        Tome.Button.Frame:SetVisible(false)
        return
    end

    -- Get the name of the target and convert to uppercase
    local name = string.upper(Tome.Button.Target.name)

    -- Verify that we have cached data and abort if not
    if not Tome_Cache[name] then
        Tome.Button.Frame:SetVisible(false)
        return
    end

    -- Target and data is valid, show the UI
    Tome.UI.Show(Tome_Cache[name])
end

-- Hook into the left click event of the button
Tome.Button.Frame:EventAttach(
    Event.UI.Input.Mouse.Left.Click,
    Tome.Button.Event_Clicked,
    "Tome_Button_Frame_Event_Click"
)

-- Hook into the target changed event
Command.Event.Attach(
    Library.LibUnitChange.Register("player.target"),
    Tome.Button.Event_Target,
    "Tome_Button_Frame_Event_Target"
)
