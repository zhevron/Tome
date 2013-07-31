--
-- Tome.UI.Layout.Settings.lua
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

-- Create the layout frame
Tome.UI.Layouts.Settings = UI.CreateFrame("Frame", "Tome_UI_Layout_Settings", Tome.UI.Window)

-- Set the points for the layout
Tome.UI.Layouts.Settings:SetPoint("TOPLEFT", Tome.UI.Window:GetContent(), "TOPLEFT", 20, 15)
Tome.UI.Layouts.Settings:SetPoint("BOTTOMRIGHT", Tome.UI.Window:GetContent(), "BOTTOMRIGHT", -20, -15)

-- Create the navbutton bar frame
Tome.UI.Layouts.Settings.Navbar = UI.CreateFrame("Frame", "Tome_UI_Layout_Settings_Navbar", Tome.UI.Layouts.Settings)
Tome.UI.Layouts.Settings.Navbar.Buttons = {}

-- Create a frame to hold the current pane
Tome.UI.Layouts.Settings.Pane = UI.CreateFrame("Frame", "Tome_UI_Layout_Settings_Pane", Tome.UI.Layouts.Settings)
Tome.UI.Layouts.Settings.Pane:SetPoint("TOPLEFT", Tome.UI.Layouts.Settings, "TOPLEFT", 0, 0)
Tome.UI.Layouts.Settings.Pane:SetPoint("BOTTOMRIGHT", Tome.UI.Layouts.Settings.Navbar, "TOPRIGHT", 0, -5)

-- Create the Blacklist nav button
Tome.UI.Layouts.Settings.Navbar.Buttons.Blacklist = UI.CreateFrame("RiftButton", "Tome_UI_Layout_Settings_Navbar_Blacklist", Tome.UI.Layouts.Settings.Navbar)
Tome.UI.Layouts.Settings.Navbar.Buttons.Blacklist:SetPoint("BOTTOMRIGHT", Tome.UI.Layouts.Settings.Navbar, "BOTTOMRIGHT", 0, 0)
Tome.UI.Layouts.Settings.Navbar.Buttons.Blacklist:SetText("Blacklist")
Tome.UI.Layouts.Settings.Navbar.Buttons.Blacklist:EventAttach(
    Event.UI.Input.Mouse.Left.Click,
    function(handle)
        -- Abort if the button is disabled
        if not Tome.UI.Layouts.Settings.Navbar.Buttons.Blacklist:GetEnabled() then
            return
        end

        -- Enable all buttons
        for _, button in pairs(Tome.UI.Layouts.Settings.Navbar.Buttons) do
            button:SetEnabled(true)
        end

        -- Disable self
        Tome.UI.Layouts.Settings.Navbar.Buttons.Blacklist:SetEnabled(false)
    end,
    "Tome_UI_Layout_Settings_Navbar_Blacklist_Click"
)

-- Create the Profiles nav button
Tome.UI.Layouts.Settings.Navbar.Buttons.Profiles = UI.CreateFrame("RiftButton", "Tome_UI_Layout_Settings_Navbar_Profiles", Tome.UI.Layouts.Settings.Navbar)
Tome.UI.Layouts.Settings.Navbar.Buttons.Profiles:SetPoint("BOTTOMRIGHT", Tome.UI.Layouts.Settings.Navbar.Buttons.Blacklist, "BOTTOMLEFT", -5, 0)
Tome.UI.Layouts.Settings.Navbar.Buttons.Profiles:SetText("Profiles")
Tome.UI.Layouts.Settings.Navbar.Buttons.Profiles:EventAttach(
    Event.UI.Input.Mouse.Left.Click,
    function(handle)
        -- Abort if the button is disabled
        if not Tome.UI.Layouts.Settings.Navbar.Buttons.Profiles:GetEnabled() then
            return
        end

        -- Enable all buttons
        for _, button in pairs(Tome.UI.Layouts.Settings.Navbar.Buttons) do
            button:SetEnabled(true)
        end

        -- Disable self
        Tome.UI.Layouts.Settings.Navbar.Buttons.Profiles:SetEnabled(false)
    end,
    "Tome_UI_Layout_Settings_Navbar_Profiles_Click"
)

-- Create the Cache nav button
Tome.UI.Layouts.Settings.Navbar.Buttons.Cache = UI.CreateFrame("RiftButton", "Tome_UI_Layout_Settings_Navbar_Cache", Tome.UI.Layouts.Settings.Navbar)
Tome.UI.Layouts.Settings.Navbar.Buttons.Cache:SetPoint("BOTTOMRIGHT", Tome.UI.Layouts.Settings.Navbar.Buttons.Profiles, "BOTTOMLEFT", -5, 0)
Tome.UI.Layouts.Settings.Navbar.Buttons.Cache:SetText("Cache")
Tome.UI.Layouts.Settings.Navbar.Buttons.Cache:EventAttach(
    Event.UI.Input.Mouse.Left.Click,
    function(handle)
        -- Abort if the button is disabled
        if not Tome.UI.Layouts.Settings.Navbar.Buttons.Cache:GetEnabled() then
            return
        end

        -- Enable all buttons
        for _, button in pairs(Tome.UI.Layouts.Settings.Navbar.Buttons) do
            button:SetEnabled(true)
        end

        -- Disable self
        Tome.UI.Layouts.Settings.Navbar.Buttons.Cache:SetEnabled(false)
    end,
    "Tome_UI_Layout_Settings_Navbar_Cache_Click"
)

-- Create the General nav button
Tome.UI.Layouts.Settings.Navbar.Buttons.General = UI.CreateFrame("RiftButton", "Tome_UI_Layout_Settings_Navbar_General", Tome.UI.Layouts.Settings.Navbar)
Tome.UI.Layouts.Settings.Navbar.Buttons.General:SetPoint("BOTTOMRIGHT", Tome.UI.Layouts.Settings.Navbar.Buttons.Cache, "BOTTOMLEFT", -5, 0)
Tome.UI.Layouts.Settings.Navbar.Buttons.General:SetText("General")
Tome.UI.Layouts.Settings.Navbar.Buttons.General:SetEnabled(false)
Tome.UI.Layouts.Settings.Navbar.Buttons.General:EventAttach(
    Event.UI.Input.Mouse.Left.Click,
    function(handle)
        -- Abort if the button is disabled
        if not Tome.UI.Layouts.Settings.Navbar.Buttons.General:GetEnabled() then
            return
        end

        -- Enable all buttons
        for _, button in pairs(Tome.UI.Layouts.Settings.Navbar.Buttons) do
            button:SetEnabled(true)
        end

        -- Disable self
        Tome.UI.Layouts.Settings.Navbar.Buttons.General:SetEnabled(false)
    end,
    "Tome_UI_Layout_Settings_Navbar_General_Click"
)

-- Calculate the offset for the navbar buttons
local width = 15
for _, button in pairs(Tome.UI.Layouts.Settings.Navbar.Buttons) do
    width = width + button:GetWidth()
end
local offset = (Tome.UI.Layouts.Settings:GetWidth() - width ) / 2
Tome.UI.Layouts.Settings.Navbar:SetWidth(width)
Tome.UI.Layouts.Settings.Navbar:SetPoint("BOTTOMLEFT", Tome.UI.Layouts.Settings, "BOTTOMLEFT", offset, -15)

-- This function removed key focus from all the text fields
function Tome.UI.Layouts.Settings.ClearFocus()
    -- No text controls in this layout
end

-- This function sets all the fields to match the supplied data
function Tome.UI.Layouts.Settings.Populate(data)
    --
end
