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
Tome.UI.Window = UI.CreateFrame("RiftWindow", "Tome_Character_Window", Tome.UI.Context)

-- Make the window draggable
Tome.Widget.Draggable.Create(Tome.UI.Window)

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

-- Store a variable referring to whether the player is viewing their own data
Tome.UI.ShowingSelf = false

-- Create the close button
Tome.UI.Close = UI.CreateFrame("RiftButton", "Tome_UI_NavButton_Close", Tome.UI.Window)
Tome.UI.Close:SetPoint("TOPRIGHT", Tome.UI.Window, "TOPRIGHT", -10, 17)
Tome.UI.Close:SetSkin("close")
Tome.UI.Close:EventAttach(
    Event.UI.Input.Mouse.Left.Click,
    function(handle)
        -- Remove focus from all layouts
        for _, layout in pairs(Tome.UI.Layouts) do
            layout.ClearFocus()
        end

        -- Hide the window
        Tome.UI.Window:SetVisible(false)
    end,
    "Tome_UI_Close_Click"
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

        -- Check if this is the players own data
        if Tome.UI.ShowingSelf then
            -- Show the Character tab
            Tome.UI.Layouts.Character:SetVisible(true)

            -- Enable all buttons and disable this button
            for _, button in pairs(Tome.UI.NavButtons) do
                button:SetEnabled(true)
            end
            Tome.UI.NavButtons.Character:SetEnabled(false)
        else
            -- Show the CharacterView layout
            Tome.UI.Layouts.CharacterView:SetVisible(true)
        end
    end,
    "Tome_UI_NavButton_Character_Click"
)

-- Create the Guild tab button
Tome.UI.NavButtons.Guild = UI.CreateFrame("RiftButton", "Tome_UI_NavButton_Guild", Tome.UI.Window)
Tome.UI.NavButtons.Guild:SetPoint("BOTTOMLEFT", Tome.UI.NavButtons.Character, "BOTTOMRIGHT", 0, 0)
Tome.UI.NavButtons.Guild:SetText("Guild")
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

        -- Check if this is the players own data
        if Tome.UI.ShowingSelf then
            -- Show the Guild tab
            if Tome.Guild.PlayerCanWrite() then
                Tome.UI.Layouts.Guild:SetVisible(true)
            else
                Tome.UI.Layouts.GuildView:SetVisible(true)
            end

            -- Enable all buttons and disable this button
            for _, button in pairs(Tome.UI.NavButtons) do
                button:SetEnabled(true)
            end
            Tome.UI.NavButtons.Guild:SetEnabled(false)
        else
            -- Show the GuildView layout
            Tome.UI.Layouts.GuildView:SetVisible(true)
        end
    end,
    "Tome_UI_NavButton_Guild_Click"
)

-- Create the Save button
Tome.UI.Save = UI.CreateFrame("RiftButton", "Tome_UI_NavButton_Save", Tome.UI.Window)
Tome.UI.Save:SetPoint("BOTTOMRIGHT", Tome.UI.Window, "BOTTOMRIGHT", -15, -15)
Tome.UI.Save:SetText("Save")
Tome.UI.Save:SetEnabled(false)
Tome.UI.Save:EventAttach(
    Event.UI.Input.Mouse.Left.Click,
    function(handle)
        -- Abort if the button is disabled
        if not Tome.UI.Save:GetEnabled() then
            return
        end

        -- Check what layout we're saving from
        if Tome.UI.Layouts.Character:GetVisible() then
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
            Tome.Data.Send("say", true)
        elseif Tome.UI.Layouts.Guild:GetVisible() then
            -- Abort if the player is not allowed to save details
            if not Tome.Guild.PlayerCanWrite() then
                return
            end

            -- Save the settings
            Tome_Guild.Name = string.gsub(Tome.UI.Layouts.Guild.Name:GetText(), "Name", "")
            Tome_Guild.Subtitle = string.gsub(Tome.UI.Layouts.Guild.Subtitle:GetText(), "Subtitle", "")
            Tome_Guild.Description = Tome.UI.Layouts.Guild.Description.Text:GetText()
            Tome_Guild.Miscellaneous = Tome.UI.Layouts.Guild.Miscellaneous.Text:GetText()
            Tome_Guild.Recruiting = string.find(Tome.UI.Layouts.Guild.Recruiting:GetText(), "Not Recruiting") and false or true
            Tome_Guild.Roleplaying = string.find(Tome.UI.Layouts.Guild.Roleplaying:GetText(), "No RP") and false or true

            -- Send data to server storage
            Tome.Guild.Store()
        end

        -- Disable the save button
        Tome.UI.Save:SetEnabled(false)
    end,
    "Tome_UI_NavButton_Save_Click"
)

-- Create the Settings tab button
Tome.UI.NavButtons.Settings = UI.CreateFrame("RiftButton", "Tome_UI_NavButton_Settings", Tome.UI.Window)
Tome.UI.NavButtons.Settings:SetPoint("BOTTOMRIGHT", Tome.UI.Save, "BOTTOMLEFT", 0, 0)
Tome.UI.NavButtons.Settings:SetText("Settings")
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

        -- Enable all buttons and disable this button
        for _, button in pairs(Tome.UI.NavButtons) do
            button:SetEnabled(true)
        end
        Tome.UI.NavButtons.Settings:SetEnabled(false)
    end,
    "Tome_UI_NavButton_Settings_Click"
)

-- Create the Preview tab button
Tome.UI.NavButtons.Preview = UI.CreateFrame("RiftButton", "Tome_UI_NavButton_Preview", Tome.UI.Window)
Tome.UI.NavButtons.Preview:SetPoint("BOTTOMRIGHT", Tome.UI.NavButtons.Settings, "BOTTOMLEFT", 0, 0)
Tome.UI.NavButtons.Preview:SetText("Preview")
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

        -- Populate the View layout
        Tome.UI.Layouts.CharacterView.Populate(Tome_Character)

        -- Show the View layout
        Tome.UI.Layouts.CharacterView:SetVisible(true)

        -- Enable all buttons and disable this button
        for _, button in pairs(Tome.UI.NavButtons) do
            button:SetEnabled(true)
        end
        Tome.UI.NavButtons.Preview:SetEnabled(false)
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

        -- Disable the save button
        Tome.UI.Save:SetVisible(false)

        -- Enable the character and guild buttons
        Tome.UI.NavButtons.Character:SetVisible(true)
        Tome.UI.NavButtons.Guild:SetVisible(true)

        -- Store that this is not the players own data
        Tome.UI.ShowingSelf = false

        -- Populate the CharacterView layout
        Tome.UI.Layouts.CharacterView.Populate(data)

        -- Populate the GuildView layout
        if data.Guild and Tome_Cache.Guild[string.upper(data.Guild)] then
            Tome.UI.Layouts.GuildView.Populate(Tome_Cache.Guild[string.upper(data.Guild)])
        else
            Tome.UI.Layouts.GuildView.Populate(nil)
        end

        -- Enable the CharacterView layout
        Tome.UI.Layouts.CharacterView:SetVisible(true)
    else
        -- Enable the navbar buttons
        for _, button in pairs(Tome.UI.NavButtons) do
            button:SetVisible(true)
        end

        -- Disable the character button
        Tome.UI.NavButtons.Character:SetEnabled(false)

        -- Enable the Character layout
        Tome.UI.Layouts.Character:SetVisible(true)

        -- Store that this is the players own data
        Tome.UI.ShowingSelf = true

        -- Get the player data instead
        data = Tome_Character

        -- Populate the Character layout
        Tome.UI.Layouts.Character.Populate(data)

        -- Populate the GuildView layout
        if Inspect.Unit.Detail("player").guild then
            Tome.UI.Layouts.Guild.Populate(Tome_Guild)
            Tome.UI.Layouts.GuildView.Populate(Tome_Guild)
        else
            Tome.UI.Layouts.Guild.Populate(nil)
            Tome.UI.Layouts.GuildView.Populate(nil)
        end

        -- Show and disable the save button
        Tome.UI.Save:SetVisible(true)
        Tome.UI.Save:SetEnabled(false)
    end

    -- Set the title of the window
    Tome.UI.Window:SetTitle(string.format("TOME: %s", string.upper((data.Name ~= "") and data.Name or "CHARACTER")))

    -- Show the window
    Tome.UI.Window:SetVisible(true)
end
