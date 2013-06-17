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

-- This function is called by the event API when the Character button is pressed
function Tome.UI.Event_Button_Character()
    --Tome.UI.Layouts.Guild:SetVisible(false)
    --Tome.UI.Layouts.Preview:SetVisible(false)
    --Tome.UI.Layouts.Settings:SetVisible(false)
    Tome.UI.Layouts.Character:SetVisible(true)
end

-- This function is called by the event API when the Guild button is pressed
function Tome.UI.Event_Button_Guild()
    Tome.UI.Layouts.Character:SetVisible(false)
    --Tome.UI.Layouts.Preview:SetVisible(false)
    --Tome.UI.Layouts.Settings:SetVisible(false)
    --Tome.UI.Layouts.Guild:SetVisible(true)
end

-- This function is called by the event API when the Preview button is pressed
function Tome.UI.Event_Button_Preview()
    Tome.UI.Layouts.Character:SetVisible(false)
    --Tome.UI.Layouts.Guild:SetVisible(false)
    --Tome.UI.Layouts.Settings:SetVisible(false)
    --Tome.UI.Layouts.Preview:SetVisible(true)
end

-- This function is called by the event API when the Settings button is pressed
function Tome.UI.Event_Button_Settings()
    Tome.UI.Layouts.Character:SetVisible(false)
    --Tome.UI.Layouts.Guild:SetVisible(false)
    --Tome.UI.Layouts.Preview:SetVisible(false)
    --Tome.UI.Layouts.Settings:SetVisible(true)
end

-- This function is called by the event API when the Save button is pressed
function Tome.UI.Event_Button_Save()
    -- Save the settings
    Tome_Character.Prefix = string.gsub(Tome.UI.Layouts.Character.Prefix:GetText(), "Prefix", "")
    Tome_Character.Name = string.gsub(Tome.UI.Layouts.Character.Name:GetText(), "Name", "")
    Tome_Character.Suffix = string.gsub(Tome.UI.Layouts.Character.Suffix:GetText(), "Suffix", "")
    Tome_Character.Title = string.gsub(Tome.UI.Layouts.Character.Title:GetText(), "Title", "")
    Tome_Character.InCharacter = string.find(Tome.UI.Layouts.Character.InCharacter:GetText(), "IC") and true or false
    Tome_Character.Tutor = string.find(Tome.UI.Layouts.Character.Tutor:GetText(), "Tutor: On") and true or false
    Tome_Character.Flag = Tome.UI.Layouts.Character.Flag:GetSelectedValue()
    Tome_Character.Appearance = Tome.UI.Layouts.Character.Appearance.Text:GetText()
    Tome_Character.History = Tome.UI.Layouts.Character.History.Text:GetText()

    -- Broadcast the new data
    Tome.Data.Send(nil, true)

    -- Disable the save button
    Tome.UI.NavButtons.Save:SetEnabled(false)
end

-- This function is called by the event API when the Close button is pressed
function Tome.UI.Event_Button_Close()
    -- Remove focus from all fields
    Tome.UI.Layouts.Character.Prefix:SetKeyFocus(false)
    Tome.UI.Layouts.Character.Name:SetKeyFocus(false)
    Tome.UI.Layouts.Character.Suffix:SetKeyFocus(false)
    Tome.UI.Layouts.Character.Title:SetKeyFocus(false)
    Tome.UI.Layouts.Character.Appearance.Text:SetKeyFocus(false)
    Tome.UI.Layouts.Character.History.Text:SetKeyFocus(false)

    -- Hide the window
    Tome.UI.Window:SetVisible(false)
end

-- This function shows the character window
function Tome.UI.Show(data)
    -- If data is manually supplied, disable all the edit boxes
    if data then
        -- Disable the fields
        Tome.UI.Layouts.Character.Prefix:SetEnabled(false)
        Tome.UI.Layouts.Character.Name:SetEnabled(false)
        Tome.UI.Layouts.Character.Suffix:SetEnabled(false)
        Tome.UI.Layouts.Character.Title:SetEnabled(false)
        Tome.UI.Layouts.Character.InCharacter:SetEnabled(false)
        Tome.UI.Layouts.Character.Tutor:SetEnabled(false)
        Tome.UI.Layouts.Character.Flag:SetEnabled(false)
        Tome.UI.Layouts.Character.Appearance.Text:SetEnabled(false)
        Tome.UI.Layouts.Character.History.Text:SetEnabled(false)
    else
        -- Get the player data instead
        data = Tome_Character

        -- Enable the fields
        Tome.UI.Layouts.Character.Prefix:SetEnabled(true)
        Tome.UI.Layouts.Character.Name:SetEnabled(true)
        Tome.UI.Layouts.Character.Suffix:SetEnabled(true)
        Tome.UI.Layouts.Character.Title:SetEnabled(true)
        Tome.UI.Layouts.Character.InCharacter:SetEnabled(true)
        Tome.UI.Layouts.Character.Tutor:SetEnabled(true)
        Tome.UI.Layouts.Character.Flag:SetEnabled(true)
        Tome.UI.Layouts.Character.Appearance.Text:SetEnabled(true)
        Tome.UI.Layouts.Character.History.Text:SetEnabled(true)
    end

    -- Set all the fields to current data
    Tome.UI.Layouts.Character.Prefix:SetText((data.Prefix ~= "") and data.Prefix or "Prefix")
    Tome.UI.Layouts.Character.Name:SetText((data.Name ~= "") and data.Name or "Name")
    Tome.UI.Layouts.Character.Suffix:SetText((data.Suffix ~= "") and data.Suffix or "Suffix")
    Tome.UI.Layouts.Character.Title:SetText((data.Title ~= "") and data.Title or "Title")
    Tome.UI.Layouts.Character.InCharacter:SetText(data.InCharacter and "IC" or "OOC")
    Tome.UI.Layouts.Character.Tutor:SetText(data.Tutor and "Tutor: On" or "Tutor: Off")
    Tome.UI.Layouts.Character.Flag:SetSelectedValue(data.Flag)
    Tome.UI.Layouts.Character.Appearance.Text:SetText(data.Appearance)
    Tome.UI.Layouts.Character.History.Text:SetText(data.History)

    -- Show the window
    Tome.UI.Window:SetVisible(true)
end

-- This function creates the navigation buttons
function Tome.UI.CreateNavButtons()
    -- Create the close button
    Tome.UI.NavButtons.Close = UI.CreateFrame("RiftButton", "Tome_UI_NavButton_Close", Tome.UI.Window)
    Tome.UI.NavButtons.Close:SetPoint("TOPRIGHT", Tome.UI.Window, "TOPRIGHT", -10, 17)
    Tome.UI.NavButtons.Close:SetSkin("close")
    Tome.UI.NavButtons.Close.Event.LeftClick = Tome.UI.Event_Button_Close

    -- Create the Character tab button
    Tome.UI.NavButtons.Character = UI.CreateFrame("RiftButton", "Tome_UI_NavButton_Character", Tome.UI.Window)
    Tome.UI.NavButtons.Character:SetPoint("BOTTOMLEFT", Tome.UI.Window, "BOTTOMLEFT", 15, -15)
    Tome.UI.NavButtons.Character:SetText("Character")
    Tome.UI.NavButtons.Character.Event.LeftClick = Tome.UI.Event_Button_Character

    -- Create the Guild tab button
    Tome.UI.NavButtons.Guild = UI.CreateFrame("RiftButton", "Tome_UI_NavButton_Guild", Tome.UI.Window)
    Tome.UI.NavButtons.Guild:SetPoint("BOTTOMLEFT", Tome.UI.NavButtons.Character, "BOTTOMRIGHT", 0, 0)
    Tome.UI.NavButtons.Guild:SetText("Guild")
    Tome.UI.NavButtons.Guild:SetEnabled(false)
    Tome.UI.NavButtons.Guild.Event.LeftClick = Tome.UI.Event_Button_Guild

    -- Create the Save button
    Tome.UI.NavButtons.Save = UI.CreateFrame("RiftButton", "Tome_UI_NavButton_Save", Tome.UI.Window)
    Tome.UI.NavButtons.Save:SetPoint("BOTTOMRIGHT", Tome.UI.Window, "BOTTOMRIGHT", -15, -15)
    Tome.UI.NavButtons.Save:SetText("Save")
    Tome.UI.NavButtons.Save:SetEnabled(false)
    Tome.UI.NavButtons.Save.Event.LeftClick = Tome.UI.Event_Button_Save

    -- Create the Settings tab button
    Tome.UI.NavButtons.Settings = UI.CreateFrame("RiftButton", "Tome_UI_NavButton_Settings", Tome.UI.Window)
    Tome.UI.NavButtons.Settings:SetPoint("BOTTOMRIGHT", Tome.UI.NavButtons.Save, "BOTTOMLEFT", 0, 0)
    Tome.UI.NavButtons.Settings:SetText("Settings")
    Tome.UI.NavButtons.Settings:SetEnabled(false)
    Tome.UI.NavButtons.Settings.Event.LeftClick = Tome.UI.Event_Button_Settings

    -- Create the Preview tab button
    Tome.UI.NavButtons.Preview = UI.CreateFrame("RiftButton", "Tome_UI_NavButton_Preview", Tome.UI.Window)
    Tome.UI.NavButtons.Preview:SetPoint("BOTTOMRIGHT", Tome.UI.NavButtons.Settings, "BOTTOMLEFT", 0, 0)
    Tome.UI.NavButtons.Preview:SetText("Preview")
    Tome.UI.NavButtons.Preview:SetEnabled(false)
    Tome.UI.NavButtons.Preview.Event.LeftClick = Tome.UI.Event_Button_Preview
end

-- This function creates the Character layout
function Tome.UI.CreateCharacterLayout()
    -- Create the layout frame
    Tome.UI.Layouts.Character = UI.CreateFrame("Frame", "Tome_UI_Layout_Character", Tome.UI.Window)

    -- Set the points for the layout
    Tome.UI.Layouts.Character:SetPoint("TOPLEFT", Tome.UI.Window:GetContent(), "TOPLEFT", 20, 15)
    Tome.UI.Layouts.Character:SetPoint("BOTTOMRIGHT", Tome.UI.Window:GetContent(), "BOTTOMRIGHT", -20, -15)

    local size = (((Tome.UI.Layouts.Character:GetWidth() / 100) * 65) - 10) / 3

    -- Create the Prefix field
    Tome.UI.Layouts.Character.Prefix = UI.CreateFrame("RiftTextfield", "Tome_UI_Layout_Character_Prefix", Tome.UI.Layouts.Character)
    Tome.UI.Layouts.Character.Prefix:SetPoint("TOPLEFT", Tome.UI.Layouts.Character, "TOPLEFT", 0, 2)
    Tome.UI.Layouts.Character.Prefix:SetWidth(size)
    Tome.UI.Layouts.Character.Prefix:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
    Tome.UI.Layouts.Character.Prefix:SetText("Prefix")
    Tome.UI.Layouts.Character.Prefix.Event.KeyFocusGain = function()
        -- Clear the text if it matches default
        if Tome.UI.Layouts.Character.Prefix:GetText() == "Prefix" then
            Tome.UI.Layouts.Character.Prefix:SetText("")
        end
    end
    Tome.UI.Layouts.Character.Prefix.Event.KeyFocusLoss = function()
        -- Set the default text if field is empty
        if Tome.UI.Layouts.Character.Prefix:GetText() == "" then
            Tome.UI.Layouts.Character.Prefix:SetText("Prefix")
        end
    end
    Tome.UI.Layouts.Character.Prefix.Event.TextfieldChange = function()
        -- Enable the Save button
        Tome.UI.NavButtons.Save:SetEnabled(true)
    end

    -- Create the Suffix field
    Tome.UI.Layouts.Character.Suffix = UI.CreateFrame("RiftTextfield", "Tome_UI_Layout_Character_Suffix", Tome.UI.Layouts.Character)
    Tome.UI.Layouts.Character.Suffix:SetPoint("TOPRIGHT", Tome.UI.Layouts.Character, "TOPRIGHT", -((Tome.UI.Layouts.Character:GetWidth() / 100) * 35), 2)
    Tome.UI.Layouts.Character.Suffix:SetWidth(size)
    Tome.UI.Layouts.Character.Suffix:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
    Tome.UI.Layouts.Character.Suffix:SetText("Suffix")
    Tome.UI.Layouts.Character.Suffix.Event.KeyFocusGain = function()
        -- Clear the text if it matches default
        if Tome.UI.Layouts.Character.Suffix:GetText() == "Suffix" then
            Tome.UI.Layouts.Character.Suffix:SetText("")
        end
    end
    Tome.UI.Layouts.Character.Suffix.Event.KeyFocusLoss = function()
        -- Set the default text if field is empty
        if Tome.UI.Layouts.Character.Suffix:GetText() == "" then
            Tome.UI.Layouts.Character.Suffix:SetText("Suffix")
        end
    end
    Tome.UI.Layouts.Character.Suffix.Event.TextfieldChange = function()
        -- Enable the Save button
        Tome.UI.NavButtons.Save:SetEnabled(true)
    end

    -- Create the Name field
    Tome.UI.Layouts.Character.Name = UI.CreateFrame("RiftTextfield", "Tome_UI_Layout_Character_Name", Tome.UI.Layouts.Character)
    Tome.UI.Layouts.Character.Name:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.Prefix, "TOPRIGHT", 5, 0)
    Tome.UI.Layouts.Character.Name:SetPoint("TOPRIGHT", Tome.UI.Layouts.Character.Suffix, "TOPLEFT", -5, 0)
    Tome.UI.Layouts.Character.Name:SetWidth(size)
    Tome.UI.Layouts.Character.Name:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
    Tome.UI.Layouts.Character.Name:SetText("Name")
    Tome.UI.Layouts.Character.Name.Event.KeyFocusGain = function()
        -- Clear the text if it matches default
        if Tome.UI.Layouts.Character.Name:GetText() == "Name" then
            Tome.UI.Layouts.Character.Name:SetText("")
        end
    end
    Tome.UI.Layouts.Character.Name.Event.KeyFocusLoss = function()
        -- Set the default text if field is empty
        if Tome.UI.Layouts.Character.Name:GetText() == "" then
            Tome.UI.Layouts.Character.Name:SetText("Name")
        end
    end
    Tome.UI.Layouts.Character.Name.Event.TextfieldChange = function()
        -- Enable the Save button
        Tome.UI.NavButtons.Save:SetEnabled(true)
    end

    -- Create the Title field
    Tome.UI.Layouts.Character.Title = UI.CreateFrame("RiftTextfield", "Tome_UI_Layout_Character_Title", Tome.UI.Layouts.Character)
    Tome.UI.Layouts.Character.Title:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.Prefix, "BOTTOMLEFT", 0, 10)
    Tome.UI.Layouts.Character.Title:SetPoint("TOPRIGHT", Tome.UI.Layouts.Character.Suffix, "BOTTOMRIGHT", 0, 10)
    Tome.UI.Layouts.Character.Title:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
    Tome.UI.Layouts.Character.Title:SetText("Title")
    Tome.UI.Layouts.Character.Title.Event.KeyFocusGain = function()
        -- Clear the text if it matches default
        if Tome.UI.Layouts.Character.Title:GetText() == "Title" then
            Tome.UI.Layouts.Character.Title:SetText("")
        end
    end
    Tome.UI.Layouts.Character.Title.Event.KeyFocusLoss = function()
        -- Set the default text if field is empty
        if Tome.UI.Layouts.Character.Title:GetText() == "" then
            Tome.UI.Layouts.Character.Title:SetText("Title")
        end
    end
    Tome.UI.Layouts.Character.Title.Event.TextfieldChange = function()
        -- Enable the Save button
        Tome.UI.NavButtons.Save:SetEnabled(true)
    end

    size = (((Tome.UI.Layouts.Character:GetWidth() / 100) * 35) - 10) / 2

    -- Create the IC/OOC button
    Tome.UI.Layouts.Character.InCharacter = UI.CreateFrame("RiftButton", "Tome_UI_Layout_Character_InCharacter", Tome.UI.Layouts.Character)
    Tome.UI.Layouts.Character.InCharacter:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.Suffix, "TOPRIGHT", 5, -7)
    Tome.UI.Layouts.Character.InCharacter:SetWidth(size)
    Tome.UI.Layouts.Character.InCharacter:SetText("IC/OOC")
    Tome.UI.Layouts.Character.InCharacter.Event.LeftClick = function()
        -- Toggle the button based on current status
        if Tome.UI.Layouts.Character.InCharacter:GetText() == "IC" then
            Tome.UI.Layouts.Character.InCharacter:SetText("OOC")
        else
            Tome.UI.Layouts.Character.InCharacter:SetText("IC")
        end

        -- Enable the Save button
        Tome.UI.NavButtons.Save:SetEnabled(true)
    end

    -- Create the Tutor button
    Tome.UI.Layouts.Character.Tutor = UI.CreateFrame("RiftButton", "Tome_UI_Layout_Character_Tutor", Tome.UI.Layouts.Character)
    Tome.UI.Layouts.Character.Tutor:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.InCharacter, "TOPRIGHT", 5, 0)
    Tome.UI.Layouts.Character.Tutor:SetWidth(size)
    Tome.UI.Layouts.Character.Tutor:SetText("Tutor")
    Tome.UI.Layouts.Character.Tutor.Event.LeftClick = function()
        -- Toggle the button based on current status
        if Tome.UI.Layouts.Character.Tutor:GetText() == "Tutor: On" then
            Tome.UI.Layouts.Character.Tutor:SetText("Tutor: Off")
        else
            Tome.UI.Layouts.Character.Tutor:SetText("Tutor: On")
        end

        -- Enable the Save button
        Tome.UI.NavButtons.Save:SetEnabled(true)
    end

    -- Create a list of all the available flags
    local flagtext = {}
    local flagvalue = {}
    local index = 1
    for _, item in ipairs(Tome.Data.Flags) do
        flagtext[index] = item.text
        flagvalue[index] = item.id
        index = index + 1
    end

    -- Create the Flag dropdown menu
    Tome.UI.Layouts.Character.Flag = UI.CreateFrame("SimpleSelect", "Tome_UI_Layout_Character_Flag", Tome.UI.Layouts.Character)
    Tome.UI.Layouts.Character.Flag:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.Title, "TOPRIGHT", 5, 0)
    Tome.UI.Layouts.Character.Flag:SetPoint("TOPRIGHT", Tome.UI.Layouts.Character.Tutor, 0, 5)
    Tome.UI.Layouts.Character.Flag:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
    Tome.UI.Layouts.Character.Flag:SetItems(flagtext, flagvalue)
    Tome.UI.Layouts.Character.Flag.Event.ItemSelect = function(item, value, index)
        -- Enable the Save button
        Tome.UI.NavButtons.Save:SetEnabled(true)
    end

    -- Create the Appearance field
    Tome.UI.Layouts.Character.Appearance = {}
    Tome.UI.Layouts.Character.Appearance.Label = UI.CreateFrame("Text", "Tome_UI_Layout_Character_Appearance_Label", Tome.UI.Layouts.Character)
    Tome.UI.Layouts.Character.Appearance.Label:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.Title, "BOTTOMLEFT", 0, 10)
    Tome.UI.Layouts.Character.Appearance.Label:SetPoint("TOPRIGHT", Tome.UI.Layouts.Character.Flag, "BOTTOMRIGHT", 0, 10)
    Tome.UI.Layouts.Character.Appearance.Label:SetText("Appearance:")
    Tome.UI.Layouts.Character.Appearance.Text = UI.CreateFrame("SimpleTextArea", "Tome_UI_Layout_Character_Appearance_Text", Tome.UI.Layouts.Character)
    Tome.UI.Layouts.Character.Appearance.Text:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.Appearance.Label, "BOTTOMLEFT", 0, 5)
    Tome.UI.Layouts.Character.Appearance.Text:SetPoint("TOPRIGHT", Tome.UI.Layouts.Character.Appearance.Label, "BOTTOMRIGHT", 0, 5)
    Tome.UI.Layouts.Character.Appearance.Text:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
    Tome.UI.Layouts.Character.Appearance.Text.Event.TextfieldChange = function()
        -- Enable the Save button
        Tome.UI.NavButtons.Save:SetEnabled(true)
    end

    -- Create the History field
    Tome.UI.Layouts.Character.History = {}
    Tome.UI.Layouts.Character.History.Label = UI.CreateFrame("Text", "Tome_UI_Layout_Character_History_Label", Tome.UI.Layouts.Character)
    Tome.UI.Layouts.Character.History.Label:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.Appearance.Text, "BOTTOMLEFT", 0, 10)
    Tome.UI.Layouts.Character.History.Label:SetPoint("TOPRIGHT", Tome.UI.Layouts.Character.Appearance.Text, "BOTTOMRIGHT", 0, 10)
    Tome.UI.Layouts.Character.History.Label:SetText("History:")
    Tome.UI.Layouts.Character.History.Text = UI.CreateFrame("SimpleTextArea", "Tome_UI_Layout_Character_History_Text", Tome.UI.Layouts.Character)
    Tome.UI.Layouts.Character.History.Text:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.History.Label, "BOTTOMLEFT", 0, 5)
    Tome.UI.Layouts.Character.History.Text:SetPoint("TOPRIGHT", Tome.UI.Layouts.Character.History.Label, "BOTTOMRIGHT", 0, 5)
    Tome.UI.Layouts.Character.History.Text:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
    Tome.UI.Layouts.Character.History.Text.Event.TextfieldChange = function()
        -- Enable the Save button
        Tome.UI.NavButtons.Save:SetEnabled(true)
    end
end

-- This function creates the Guild layout
function Tome.UI.CreateGuildLayout()
    -- TODO: Create guild layout
end

-- This function creates the Preview layout
function Tome.UI.CreatePreviewLayout()
    -- TODO: Create preview layout
end

-- This function creates the Settings layout
function Tome.UI.CreateSettingsLayout()
    -- TODO: Create settings layout
end

-- Create the nav buttons
Tome.UI.CreateNavButtons()

--- Create the character layout
Tome.UI.CreateCharacterLayout()

-- Create the guild layout
Tome.UI.CreateGuildLayout()

-- Create the preview layout
Tome.UI.CreatePreviewLayout()

-- Create the settings layout
Tome.UI.CreateSettingsLayout()
