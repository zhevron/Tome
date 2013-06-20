--
-- Tome.UI.lua
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
Tome.UI = {}

-- Create the context used to render the character window
Tome.UI.Context = UI.CreateContext("Tome_Character_Context")

-- Create the window that will hold the controls
Tome.UI.Window = UI.CreateFrame("SimpleWindow", "Tome_Character_Window", Tome.UI.Context)

-- Set the initial window width
local width = (UIParent:GetWidth() / 100) * 40
if (width < 750) then
    width = 750
end
Tome.UI.Window:SetWidth(width)

-- Set the initial position of the window
Tome.UI.Window:SetPoint("CENTER", UIParent, "CENTER")

-- Hide the window by default
Tome.UI.Window:SetVisible(false)

-- Set the title of the window
Tome.UI.Window:SetTitle("TOME")

-- Create a table to hold the nav buttons
Tome.UI.NavButtons = {}

-- Create a table to hold the layouts
Tome.UI.Layouts = {}

-- Create the close button
Tome.UI.NavButtons.Close = UI.CreateFrame("RiftButton", "Tome_UI_NavButton_Close", Tome.UI.Window)
Tome.UI.NavButtons.Close:SetPoint("TOPRIGHT", Tome.UI.Window, "TOPRIGHT", -10, 17)
Tome.UI.NavButtons.Close:SetSkin("close")
Tome.UI.NavButtons.Close:EventAttach(
    Event.UI.Input.Mouse.Left.Click,
    function(handle)
        -- Remove focus from all layouts
        for _, layout in pairs(Tome.UI.Layouts) do
            layout.ClearFocus()
        end

        -- Hide the window
        Tome.UI.Window:SetVisible(false)
    end,
    "Tome_UI_NavButton_Close_Click"
)

-- Create the Character tab button
Tome.UI.NavButtons.Character = UI.CreateFrame("RiftButton", "Tome_UI_NavButton_Character", Tome.UI.Window)
Tome.UI.NavButtons.Character:SetPoint("BOTTOMLEFT", Tome.UI.Window, "BOTTOMLEFT", 15, -15)
Tome.UI.NavButtons.Character:SetText("Character")
Tome.UI.NavButtons.Character:EventAttach(
    Event.UI.Input.Mouse.Left.Click,
    function(handle)
        -- Abort if the button is disabled
        if not Tome.UI.NavButtons.Character:GetEnabled() then
            return
        end

        -- Disable all layouts
        for _, layout in pairs(Tome.UI.Layouts) do
            layout:SetVisible(false)
        end

        -- Show the Character tab
        Tome.UI.Layouts.Character:SetVisible(true)
    end,
    "Tome_UI_NavButton_Character_Click"
)

-- Create the Guild tab button
Tome.UI.NavButtons.Guild = UI.CreateFrame("RiftButton", "Tome_UI_NavButton_Guild", Tome.UI.Window)
Tome.UI.NavButtons.Guild:SetPoint("BOTTOMLEFT", Tome.UI.NavButtons.Character, "BOTTOMRIGHT", 0, 0)
Tome.UI.NavButtons.Guild:SetText("Guild")
Tome.UI.NavButtons.Guild:SetEnabled(false)
Tome.UI.NavButtons.Guild:EventAttach(
    Event.UI.Input.Mouse.Left.Click,
    function(handle)
        -- Abort if the button is disabled
        if not Tome.UI.NavButtons.Guild:GetEnabled() then
            return
        end

        -- Disable all layouts
        for _, layout in pairs(Tome.UI.Layouts) do
            layout:SetVisible(false)
        end

        -- Show the Guild tab
        Tome.UI.Layouts.Guild:SetVisible(true)
    end,
    "Tome_UI_NavButton_Guild_Click"
)

-- Create the Save button
Tome.UI.NavButtons.Save = UI.CreateFrame("RiftButton", "Tome_UI_NavButton_Save", Tome.UI.Window)
Tome.UI.NavButtons.Save:SetPoint("BOTTOMRIGHT", Tome.UI.Window, "BOTTOMRIGHT", -15, -15)
Tome.UI.NavButtons.Save:SetText("Save")
Tome.UI.NavButtons.Save:SetEnabled(false)
Tome.UI.NavButtons.Save:EventAttach(
    Event.UI.Input.Mouse.Left.Click,
    function(handle)
        -- Abort if the button is disabled
        if not Tome.UI.NavButtons.Save:GetEnabled() then
            return
        end

        -- Save the settings
        Tome_Character.Prefix = string.gsub(Tome.UI.Layouts.Character.Prefix:GetText(), "Prefix", "")
        Tome_Character.Name = string.gsub(Tome.UI.Layouts.Character.Name:GetText(), "Name", "")
        Tome_Character.Suffix = string.gsub(Tome.UI.Layouts.Character.Suffix:GetText(), "Suffix", "")
        Tome_Character.Title = string.gsub(Tome.UI.Layouts.Character.Title:GetText(), "Title", "")
        Tome_Character.Age = string.gsub(Tome.UI.Layouts.Character.Age:GetText(), "Age", "")
        Tome_Character.Height = string.gsub(Tome.UI.Layouts.Character.Height:GetText(), "Height", "")
        Tome_Character.Weight = string.gsub(Tome.UI.Layouts.Character.Weight:GetText(), "Weight", "")
        Tome_Character.InCharacter = string.find(Tome.UI.Layouts.Character.InCharacter:GetText(), "IC") and true or false
        Tome_Character.Tutor = string.find(Tome.UI.Layouts.Character.Tutor:GetText(), "Tutor: On") and true or false
        Tome_Character.Flag = Tome.UI.Layouts.Character.Flag:GetSelectedValue()
        Tome_Character.Appearance = Tome.UI.Layouts.Character.Appearance.Text:GetText()
        Tome_Character.History = Tome.UI.Layouts.Character.History.Text:GetText()

        -- Broadcast the new data
        Tome.Data.Send(nil, true)

        -- Disable the save button
        Tome.UI.NavButtons.Save:SetEnabled(false)
    end,
    "Tome_UI_NavButton_Save_Click"
)

-- Create the Settings tab button
Tome.UI.NavButtons.Settings = UI.CreateFrame("RiftButton", "Tome_UI_NavButton_Settings", Tome.UI.Window)
Tome.UI.NavButtons.Settings:SetPoint("BOTTOMRIGHT", Tome.UI.NavButtons.Save, "BOTTOMLEFT", 0, 0)
Tome.UI.NavButtons.Settings:SetText("Settings")
Tome.UI.NavButtons.Settings:SetEnabled(false)
Tome.UI.NavButtons.Settings:EventAttach(
    Event.UI.Input.Mouse.Left.Click,
    function(handle)
        -- Abort if the button is disabled
        if not Tome.UI.NavButtons.Settings:GetEnabled() then
            return
        end

        -- Disable all layouts
        for _, layout in pairs(Tome.UI.Layouts) do
            layout:SetVisible(false)
        end

        -- Show the Settings tab
        Tome.UI.Layouts.Settings:SetVisible(true)
    end,
    "Tome_UI_NavButton_Settings_Click"
)

-- Create the Preview tab button
Tome.UI.NavButtons.Preview = UI.CreateFrame("RiftButton", "Tome_UI_NavButton_Preview", Tome.UI.Window)
Tome.UI.NavButtons.Preview:SetPoint("BOTTOMRIGHT", Tome.UI.NavButtons.Settings, "BOTTOMLEFT", 0, 0)
Tome.UI.NavButtons.Preview:SetText("Preview")
Tome.UI.NavButtons.Preview:SetEnabled(false)
Tome.UI.NavButtons.Preview:EventAttach(
    Event.UI.Input.Mouse.Left.Click,
    function(handle)
        -- Abort if the button is disabled
        if not Tome.UI.NavButtons.Preview:GetEnabled() then
            return
        end

        -- Disable all layouts
        for _, layout in pairs(Tome.UI.Layouts) do
            layout:SetVisible(false)
        end

        -- Show the Preview tab
        Tome.UI.Layouts.Preview:SetVisible(true)
    end,
    "Tome_UI_NavButton_Preview_Click"
)

-- This function shows the character window
function Tome.UI.Show(data)
    -- Disable all layouts
    for _, layout in pairs(Tome.UI.Layouts) do
        layout:SetVisible(false)
    end

    -- If data is manually supplied, disable all the edit boxes
    if data then
        -- Disable the navbar buttons
        for _, button in pairs(Tome.UI.NavButtons) do
            button:SetVisible(false)
        end

        -- Enable the View layout
        Tome.UI.Layouts.View:SetVisible(true)

        -- TODO: Set all the fields to current data
    else
        -- Enable the navbar buttons
        for _, button in pairs(Tome.UI.NavButtons) do
            button:SetVisible(true)
        end

        -- Enable the Character layout
        Tome.UI.Layouts.Character:SetVisible(true)

        -- Get the player data instead
        data = Tome_Character

        -- Set all the fields to current data
        Tome.UI.Layouts.Character.Prefix:SetText((data.Prefix ~= "") and data.Prefix or "Prefix")
        Tome.UI.Layouts.Character.Name:SetText((data.Name ~= "") and data.Name or "Name")
        Tome.UI.Layouts.Character.Suffix:SetText((data.Suffix ~= "") and data.Suffix or "Suffix")
        Tome.UI.Layouts.Character.Title:SetText((data.Title ~= "") and data.Title or "Title")
        Tome.UI.Layouts.Character.Age:SetText((data.Age ~= "") and data.Age or "Age")
        Tome.UI.Layouts.Character.Height:SetText((data.Height ~= "") and data.Height or "Height")
        Tome.UI.Layouts.Character.Weight:SetText((data.Weight ~= "") and data.Weight or "Weight")
        Tome.UI.Layouts.Character.InCharacter:SetText(data.InCharacter and "IC" or "OOC")
        Tome.UI.Layouts.Character.Tutor:SetText(data.Tutor and "Tutor: On" or "Tutor: Off")
        Tome.UI.Layouts.Character.Flag:SetSelectedValue(data.Flag)
        Tome.UI.Layouts.Character.Appearance.Text:SetText(data.Appearance)
        Tome.UI.Layouts.Character.History.Text:SetText(data.History)

        -- Disable the save button
        Tome.UI.NavButtons.Save:SetEnabled(false)
    end

    -- Set the title of the window
    Tome.UI.Window:SetTitle(string.format("TOME: %s", string.upper((data.Name ~= "") and data.Name or "CHARACTER")))

    -- Show the window
    Tome.UI.Window:SetVisible(true)
end
