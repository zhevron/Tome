--
-- Tome.UI.Layout.Character.lua
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
Tome.UI.Layouts.Character.Prefix:EventAttach(
    Event.UI.Input.Key.Focus.Gain,
    function(handle)
        -- Clear the text if it matches default
        if Tome.UI.Layouts.Character.Prefix:GetText() == "Prefix" then
            Tome.UI.Layouts.Character.Prefix:SetText("")
        end
    end,
    "Tome_UI_Layout_Character_Prefix_Focus_Gain"
)
Tome.UI.Layouts.Character.Prefix:EventAttach(
    Event.UI.Input.Key.Focus.Loss,
    function(handle)
        -- Set the default text if field is empty
        if Tome.UI.Layouts.Character.Prefix:GetText() == "" then
            Tome.UI.Layouts.Character.Prefix:SetText("Prefix")
        end
    end,
    "Tome_UI_Layout_Character_Prefix_Focus_Loss"
)
Tome.UI.Layouts.Character.Prefix:EventAttach(
    Event.UI.Input.Key.Up,
    function(handle, key)
        -- Enable the Save button
        Tome.UI.Save:SetEnabled(true)
    end,
    "Tome_UI_Layout_Character_Prefix_Change"
)

-- Create the Suffix field
Tome.UI.Layouts.Character.Suffix = UI.CreateFrame("RiftTextfield", "Tome_UI_Layout_Character_Suffix", Tome.UI.Layouts.Character)
Tome.UI.Layouts.Character.Suffix:SetPoint("TOPRIGHT", Tome.UI.Layouts.Character, "TOPRIGHT", -((Tome.UI.Layouts.Character:GetWidth() / 100) * 35), 2)
Tome.UI.Layouts.Character.Suffix:SetWidth(size)
Tome.UI.Layouts.Character.Suffix:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
Tome.UI.Layouts.Character.Suffix:SetText("Suffix")
Tome.UI.Layouts.Character.Suffix:EventAttach(
    Event.UI.Input.Key.Focus.Gain,
    function(handle)
        -- Clear the text if it matches default
        if Tome.UI.Layouts.Character.Suffix:GetText() == "Suffix" then
            Tome.UI.Layouts.Character.Suffix:SetText("")
        end
    end,
    "Tome_UI_Layout_Character_Suffix_Focus_Gain"
)
Tome.UI.Layouts.Character.Suffix:EventAttach(
    Event.UI.Input.Key.Focus.Loss,
    function(handle)
        -- Set the default text if field is empty
        if Tome.UI.Layouts.Character.Suffix:GetText() == "" then
            Tome.UI.Layouts.Character.Suffix:SetText("Suffix")
        end
    end,
    "Tome_UI_Layout_Character_Suffix_Focus_Loss"
)
Tome.UI.Layouts.Character.Suffix:EventAttach(
    Event.UI.Input.Key.Up,
    function(handle, key)
        -- Enable the Save button
        Tome.UI.Save:SetEnabled(true)
    end,
    "Tome_UI_Layout_Character_Suffix_Change"
)

-- Create the Name field
Tome.UI.Layouts.Character.Name = UI.CreateFrame("RiftTextfield", "Tome_UI_Layout_Character_Name", Tome.UI.Layouts.Character)
Tome.UI.Layouts.Character.Name:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.Prefix, "TOPRIGHT", 5, 0)
Tome.UI.Layouts.Character.Name:SetPoint("TOPRIGHT", Tome.UI.Layouts.Character.Suffix, "TOPLEFT", -5, 0)
Tome.UI.Layouts.Character.Name:SetWidth(size)
Tome.UI.Layouts.Character.Name:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
Tome.UI.Layouts.Character.Name:SetText("Name")
Tome.UI.Layouts.Character.Name:EventAttach(
    Event.UI.Input.Key.Focus.Gain,
    function(handle)
        -- Clear the text if it matches default
        if Tome.UI.Layouts.Character.Name:GetText() == "Name" then
            Tome.UI.Layouts.Character.Name:SetText("")
        end
    end,
    "Tome_UI_Layout_Character_Name_Focus_Gain"
)
Tome.UI.Layouts.Character.Name:EventAttach(
    Event.UI.Input.Key.Focus.Loss,
    function(handle)
        -- Set the default text if field is empty
        if Tome.UI.Layouts.Character.Name:GetText() == "" then
            Tome.UI.Layouts.Character.Name:SetText("Name")
        end
    end,
    "Tome_UI_Layout_Character_Name_Focus_Loss"
)
Tome.UI.Layouts.Character.Name:EventAttach(
    Event.UI.Input.Key.Up,
    function(handle, key)
        -- Enable the Save button
        Tome.UI.Save:SetEnabled(true)
    end,
    "Tome_UI_Layout_Character_Name_Change"
)

-- Create the Title field
Tome.UI.Layouts.Character.Title = UI.CreateFrame("RiftTextfield", "Tome_UI_Layout_Character_Title", Tome.UI.Layouts.Character)
Tome.UI.Layouts.Character.Title:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.Prefix, "BOTTOMLEFT", 0, 5)
Tome.UI.Layouts.Character.Title:SetPoint("TOPRIGHT", Tome.UI.Layouts.Character.Suffix, "BOTTOMRIGHT", 0, 5)
Tome.UI.Layouts.Character.Title:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
Tome.UI.Layouts.Character.Title:SetText("Title")
Tome.UI.Layouts.Character.Title:EventAttach(
    Event.UI.Input.Key.Focus.Gain,
    function(handle)
        -- Clear the text if it matches default
        if Tome.UI.Layouts.Character.Title:GetText() == "Title" then
            Tome.UI.Layouts.Character.Title:SetText("")
        end
    end,
    "Tome_UI_Layout_Character_Title_Focus_Gain"
)
Tome.UI.Layouts.Character.Title:EventAttach(
    Event.UI.Input.Key.Focus.Loss,
    function(handle)
        -- Set the default text if field is empty
        if Tome.UI.Layouts.Character.Title:GetText() == "" then
            Tome.UI.Layouts.Character.Title:SetText("Title")
        end
    end,
    "Tome_UI_Layout_Character_Title_Focus_Loss"
)
Tome.UI.Layouts.Character.Title:EventAttach(
    Event.UI.Input.Key.Up,
    function(handle, key)
        -- Enable the Save button
        Tome.UI.Save:SetEnabled(true)
    end,
    "Tome_UI_Layout_Character_Title_Change"
)

-- Create the Age field
Tome.UI.Layouts.Character.Age = UI.CreateFrame("RiftTextfield", "Tome_UI_Layout_Character_Age", Tome.UI.Layouts.Character)
Tome.UI.Layouts.Character.Age:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.Title, "BOTTOMLEFT", 0, 5)
Tome.UI.Layouts.Character.Age:SetWidth(size)
Tome.UI.Layouts.Character.Age:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
Tome.UI.Layouts.Character.Age:SetText("Age")
Tome.UI.Layouts.Character.Age:EventAttach(
    Event.UI.Input.Key.Focus.Gain,
    function(handle)
        -- Clear the text if it matches default
        if Tome.UI.Layouts.Character.Age:GetText() == "Age" then
            Tome.UI.Layouts.Character.Age:SetText("")
        end
    end,
    "Tome_UI_Layout_Character_Age_Focus_Gain"
)
Tome.UI.Layouts.Character.Age:EventAttach(
    Event.UI.Input.Key.Focus.Loss,
    function(handle)
        -- Set the default text if field is empty
        if Tome.UI.Layouts.Character.Age:GetText() == "" then
            Tome.UI.Layouts.Character.Age:SetText("Age")
        end
    end,
    "Tome_UI_Layout_Character_Age_Focus_Loss"
)
Tome.UI.Layouts.Character.Age:EventAttach(
    Event.UI.Input.Key.Up,
    function(handle, key)
        -- Enable the Save button
        Tome.UI.Save:SetEnabled(true)
    end,
    "Tome_UI_Layout_Character_Age_Change"
)

-- Create the Weight field
Tome.UI.Layouts.Character.Weight = UI.CreateFrame("RiftTextfield", "Tome_UI_Layout_Character_Weight", Tome.UI.Layouts.Character)
Tome.UI.Layouts.Character.Weight:SetPoint("TOPRIGHT", Tome.UI.Layouts.Character.Title, "BOTTOMRIGHT", 0, 5)
Tome.UI.Layouts.Character.Weight:SetWidth(size)
Tome.UI.Layouts.Character.Weight:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
Tome.UI.Layouts.Character.Weight:SetText("Weight")
Tome.UI.Layouts.Character.Weight:EventAttach(
    Event.UI.Input.Key.Focus.Gain,
    function(handle)
        -- Clear the text if it matches default
        if Tome.UI.Layouts.Character.Weight:GetText() == "Weight" then
            Tome.UI.Layouts.Character.Weight:SetText("")
        end
    end,
    "Tome_UI_Layout_Character_Weight_Focus_Gain"
)
Tome.UI.Layouts.Character.Weight:EventAttach(
    Event.UI.Input.Key.Focus.Loss,
    function(handle)
        -- Set the default text if field is empty
        if Tome.UI.Layouts.Character.Weight:GetText() == "" then
            Tome.UI.Layouts.Character.Weight:SetText("Weight")
        end
    end,
    "Tome_UI_Layout_Character_Weight_Focus_Loss"
)
Tome.UI.Layouts.Character.Weight:EventAttach(
    Event.UI.Input.Key.Up,
    function(handle, key)
        -- Enable the Save button
        Tome.UI.Save:SetEnabled(true)
    end,
    "Tome_UI_Layout_Character_Weight_Change"
)

-- Create the Height field
Tome.UI.Layouts.Character.Height = UI.CreateFrame("RiftTextfield", "Tome_UI_Layout_Character_Height", Tome.UI.Layouts.Character)
Tome.UI.Layouts.Character.Height:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.Age, "TOPRIGHT", 5, 0)
Tome.UI.Layouts.Character.Height:SetPoint("TOPRIGHT", Tome.UI.Layouts.Character.Weight, "TOPLEFT", -5, 0)
Tome.UI.Layouts.Character.Height:SetWidth(size)
Tome.UI.Layouts.Character.Height:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
Tome.UI.Layouts.Character.Height:SetText("Height")
Tome.UI.Layouts.Character.Height:EventAttach(
    Event.UI.Input.Key.Focus.Gain,
    function(handle)
        -- Clear the text if it matches default
        if Tome.UI.Layouts.Character.Height:GetText() == "Height" then
            Tome.UI.Layouts.Character.Height:SetText("")
        end
    end,
    "Tome_UI_Layout_Character_Height_Focus_Gain"
)
Tome.UI.Layouts.Character.Height:EventAttach(
    Event.UI.Input.Key.Focus.Loss,
    function(handle)
        -- Set the default text if field is empty
        if Tome.UI.Layouts.Character.Height:GetText() == "" then
            Tome.UI.Layouts.Character.Height:SetText("Height")
        end
    end,
    "Tome_UI_Layout_Character_Height_Focus_Loss"
)
Tome.UI.Layouts.Character.Height:EventAttach(
    Event.UI.Input.Key.Up,
    function(handle, key)
        -- Enable the Save button
        Tome.UI.Save:SetEnabled(true)
    end,
    "Tome_UI_Layout_Character_Height_Change"
)

size = (((Tome.UI.Layouts.Character:GetWidth() / 100) * 35) - 10)

-- Create the frame that holds the controls
Tome.UI.Layouts.Character.Controls = UI.CreateFrame("Frame", "Tome_UI_Layout_Character_Controls", Tome.UI.Layouts.Character)
Tome.UI.Layouts.Character.Controls:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.Suffix, "TOPRIGHT", 5, 0)
Tome.UI.Layouts.Character.Controls:SetPoint("BOTTOMLEFT", Tome.UI.Layouts.Character.Weight, "BOTTOMRIGHT", 5, 0)
Tome.UI.Layouts.Character.Controls:SetWidth(size)

-- Create the IC/OOC button
Tome.UI.Layouts.Character.InCharacter = UI.CreateFrame("RiftButton", "Tome_UI_Layout_Character_InCharacter", Tome.UI.Layouts.Character.Controls)
Tome.UI.Layouts.Character.InCharacter:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.Controls, "TOPLEFT", 0, 0)
Tome.UI.Layouts.Character.InCharacter:SetWidth(size / 2)
Tome.UI.Layouts.Character.InCharacter:SetText("IC/OOC")
Tome.UI.Layouts.Character.InCharacter:EventAttach(
    Event.UI.Input.Mouse.Left.Click,
    function(handle)
        -- Toggle the button based on current status
        if Tome.UI.Layouts.Character.InCharacter:GetText() == "IC" then
            Tome.UI.Layouts.Character.InCharacter:SetText("OOC")
        else
            Tome.UI.Layouts.Character.InCharacter:SetText("IC")
        end

        -- Enable the Save button
        Tome.UI.Save:SetEnabled(true)
    end,
    "Tome_UI_Layout_Character_InCharacter_Click"
)

-- Create the Tutor button
Tome.UI.Layouts.Character.Tutor = UI.CreateFrame("RiftButton", "Tome_UI_Layout_Character_Tutor", Tome.UI.Layouts.Character.Controls)
Tome.UI.Layouts.Character.Tutor:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.InCharacter, "TOPRIGHT", 5, 0)
Tome.UI.Layouts.Character.Tutor:SetWidth(size / 2)
Tome.UI.Layouts.Character.Tutor:SetText("Tutor")
Tome.UI.Layouts.Character.Tutor:EventAttach(
    Event.UI.Input.Mouse.Left.Click,
    function(handle)
        -- Toggle the button based on current status
        if Tome.UI.Layouts.Character.Tutor:GetText() == "Tutor: On" then
            Tome.UI.Layouts.Character.Tutor:SetText("Tutor: Off")
        else
            Tome.UI.Layouts.Character.Tutor:SetText("Tutor: On")
        end

        -- Enable the Save button
        Tome.UI.Save:SetEnabled(true)
    end,
    ""
)

-- Create a list of all the available flags
local flags = {}
for _, item in ipairs(Tome.Data.Flags) do
    flags[item.text] = item.id
end

size = (((Tome.UI.Layouts.Character:GetWidth() / 100) * 35) - 5)

-- Create the Flag dropdown menu
Tome.UI.Layouts.Character.Flag = Tome.Widget.Dropdown.Create(
    Tome.UI.Layouts.Character.Controls,
    "Tome_UI_Layout_Character_Flag",
    function()
        -- Enable the save button
        Tome.UI.Save:SetEnabled(true)
    end
)
Tome.UI.Layouts.Character.Flag:SetItems(flags)
Tome.UI.Layouts.Character.Flag:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.InCharacter, "BOTTOMLEFT", ((size - Tome.UI.Layouts.Character.Flag:GetWidth()) / 2), 10)
Tome.UI.Layouts.Character.Flag:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)

-- Create the Appearance field
Tome.UI.Layouts.Character.Appearance = {}
Tome.UI.Layouts.Character.Appearance.Label = UI.CreateFrame("Text", "Tome_UI_Layout_Character_Appearance_Label", Tome.UI.Layouts.Character)
Tome.UI.Layouts.Character.Appearance.Label:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.Age, "BOTTOMLEFT", 0, 10)
Tome.UI.Layouts.Character.Appearance.Label:SetPoint("TOPRIGHT", Tome.UI.Layouts.Character.Controls, "BOTTOMRIGHT", 0, 10)
Tome.UI.Layouts.Character.Appearance.Label:SetText("Appearance:")
Tome.UI.Layouts.Character.Appearance.Text = UI.CreateFrame("SimpleTextArea", "Tome_UI_Layout_Character_Appearance_Text", Tome.UI.Layouts.Character)
Tome.UI.Layouts.Character.Appearance.Text:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.Appearance.Label, "BOTTOMLEFT", 0, 5)
Tome.UI.Layouts.Character.Appearance.Text:SetPoint("TOPRIGHT", Tome.UI.Layouts.Character.Appearance.Label, "BOTTOMRIGHT", 0, 5)
Tome.UI.Layouts.Character.Appearance.Text:SetHeight((Tome.UI.Window:GetContent():GetHeight() / 100) * 25)
Tome.UI.Layouts.Character.Appearance.Text:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
Tome.UI.Layouts.Character.Appearance.Text:EventAttach(
    Event.UI.Input.Key.Up,
    function(handle, key)
        -- Enable the Save button
        Tome.UI.Save:SetEnabled(true)
    end,
    "Tome_UI_Layout_Character_Appearance_Text_Change"
)

-- Create the History field
Tome.UI.Layouts.Character.History = {}
Tome.UI.Layouts.Character.History.Label = UI.CreateFrame("Text", "Tome_UI_Layout_Character_History_Label", Tome.UI.Layouts.Character)
Tome.UI.Layouts.Character.History.Label:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.Appearance.Text, "BOTTOMLEFT", 0, 10)
Tome.UI.Layouts.Character.History.Label:SetPoint("TOPRIGHT", Tome.UI.Layouts.Character.Appearance.Text, "BOTTOMRIGHT", 0, 10)
Tome.UI.Layouts.Character.History.Label:SetText("History:")
Tome.UI.Layouts.Character.History.Text = UI.CreateFrame("SimpleTextArea", "Tome_UI_Layout_Character_History_Text", Tome.UI.Layouts.Character)
Tome.UI.Layouts.Character.History.Text:SetPoint("TOPLEFT", Tome.UI.Layouts.Character.History.Label, "BOTTOMLEFT", 0, 5)
Tome.UI.Layouts.Character.History.Text:SetPoint("TOPRIGHT", Tome.UI.Layouts.Character.History.Label, "BOTTOMRIGHT", 0, 5)
Tome.UI.Layouts.Character.History.Text:SetHeight((Tome.UI.Window:GetContent():GetHeight() / 100) * 25)
Tome.UI.Layouts.Character.History.Text:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
Tome.UI.Layouts.Character.History.Text:EventAttach(
    Event.UI.Input.Key.Up,
    function(handle, key)
        -- Enable the Save button
        Tome.UI.Save:SetEnabled(true)
    end,
    "Tome_UI_Layout_Character_History_Text_Change"
)

-- This function removed key focus from all the text fields
function Tome.UI.Layouts.Character.ClearFocus()
    Tome.UI.Layouts.Character.Prefix:SetKeyFocus(false)
    Tome.UI.Layouts.Character.Name:SetKeyFocus(false)
    Tome.UI.Layouts.Character.Suffix:SetKeyFocus(false)
    Tome.UI.Layouts.Character.Age:SetKeyFocus(false)
    Tome.UI.Layouts.Character.Height:SetKeyFocus(false)
    Tome.UI.Layouts.Character.Weight:SetKeyFocus(false)
    Tome.UI.Layouts.Character.Appearance.Text:SetKeyFocus(false)
    Tome.UI.Layouts.Character.History.Text:SetKeyFocus(false)
end

-- This function sets all the fields to match the supplied data
function Tome.UI.Layouts.Character.Populate(data)
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
end
