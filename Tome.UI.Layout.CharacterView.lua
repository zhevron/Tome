--
-- Tome.UI.Layout.CharacterView.lua
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
Tome.UI.Layouts.CharacterView = UI.CreateFrame("Frame", "Tome_UI_Layout_CharacterView", Tome.UI.Window)

-- Set the points for the layout
Tome.UI.Layouts.CharacterView:SetPoint("TOPLEFT", Tome.UI.Window:GetContent(), "TOPLEFT", 20, 15)
Tome.UI.Layouts.CharacterView:SetPoint("BOTTOMRIGHT", Tome.UI.Window:GetContent(), "BOTTOMRIGHT", -40, -15)

-- Create the container frame for the fluid layout
Tome.UI.Layouts.CharacterView.Container = UI.CreateFrame("Frame", "Tome_UI_Layout_CharacterView_Container", Tome.UI.Layouts.CharacterView)
Tome.UI.Layouts.CharacterView.Container:SetPoint("TOPLEFT", Tome.UI.Layouts.CharacterView, "TOPLEFT", 10, 0)
Tome.UI.Layouts.CharacterView.Container:SetPoint("BOTTOMRIGHT", Tome.UI.Layouts.CharacterView, "TOPRIGHT", 10, 80)

-- Create the Flag label
Tome.UI.Layouts.CharacterView.Flag = UI.CreateFrame("Text", "Tome_UI_Layout_CharacterView_Flag", Tome.UI.Layouts.CharacterView.Container)
Tome.UI.Layouts.CharacterView.Flag:SetPoint("TOPLEFT", Tome.UI.Layouts.CharacterView.Container, "TOPLEFT", 0, -5)
Tome.UI.Layouts.CharacterView.Flag:SetFontColor(0.2, 0.5, 0.9, 1.0)

-- Create the IC/OCC label
Tome.UI.Layouts.CharacterView.InCharacter = UI.CreateFrame("Text", "Tome_UI_Layout_CharacterView_InCharacter", Tome.UI.Layouts.CharacterView.Container)
Tome.UI.Layouts.CharacterView.InCharacter:SetPoint("TOPRIGHT", Tome.UI.Layouts.CharacterView.Container, "TOPRIGHT", 0, -5)

-- Create the Name label
Tome.UI.Layouts.CharacterView.Name = UI.CreateFrame("Text", "Tome_UI_Layout_CharacterView_Name", Tome.UI.Layouts.CharacterView.Container)
Tome.UI.Layouts.CharacterView.Name:SetFontSize(22)

-- Create the Title label
Tome.UI.Layouts.CharacterView.Title = UI.CreateFrame("Text", "Tome_UI_Layout_CharacterView_Title", Tome.UI.Layouts.CharacterView.Container)
Tome.UI.Layouts.CharacterView.Title:SetFontSize(13)
Tome.UI.Layouts.CharacterView.Title:SetFontColor(1.0, 0.8, 0.0, 1.0)

-- Create the Height label
Tome.UI.Layouts.CharacterView.Height = UI.CreateFrame("Text", "Tome_UI_Layout_CharacterView_Height", Tome.UI.Layouts.CharacterView.Container)
Tome.UI.Layouts.CharacterView.Height:SetFontSize(13)

-- Create the Appearance label
Tome.UI.Layouts.CharacterView.Appearance = {}
Tome.UI.Layouts.CharacterView.Appearance.Label = UI.CreateFrame("Text", "Tome_UI_Layout_CharacterView_Appearance_Header", Tome.UI.Layouts.CharacterView)
Tome.UI.Layouts.CharacterView.Appearance.Label:SetPoint("TOPLEFT", Tome.UI.Layouts.CharacterView.Container, "BOTTOMLEFT", 0, 10)
Tome.UI.Layouts.CharacterView.Appearance.Label:SetPoint("TOPRIGHT", Tome.UI.Layouts.CharacterView.Container, "BOTTOMRIGHT", 0, 10)
Tome.UI.Layouts.CharacterView.Appearance.Label:SetFontSize(13)
Tome.UI.Layouts.CharacterView.Appearance.Label:SetText("Appearance:")
Tome.UI.Layouts.CharacterView.Appearance.Text = Tome.Widget.TextArea.Create(
    Tome.UI.Layouts.CharacterView,
    "Tome_UI_Layout_CharacterView_Appearance_Text"
)
Tome.UI.Layouts.CharacterView.Appearance.Text:SetPoint("TOPLEFT", Tome.UI.Layouts.CharacterView.Appearance.Label, "BOTTOMLEFT", 0, 5)
Tome.UI.Layouts.CharacterView.Appearance.Text:SetPoint("TOPRIGHT", Tome.UI.Layouts.CharacterView.Appearance.Label, "BOTTOMRIGHT", 0, 5)
Tome.UI.Layouts.CharacterView.Appearance.Text:SetHeight((Tome.UI.Window:GetContent():GetHeight() / 100) * 25)
Tome.UI.Layouts.CharacterView.Appearance.Text:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
Tome.UI.Layouts.CharacterView.Appearance.Text.Border = Tome.Widget.Border.Create(Tome.UI.Layouts.CharacterView.Appearance.Text.Container, 1)

-- Create the History label
Tome.UI.Layouts.CharacterView.History = {}
Tome.UI.Layouts.CharacterView.History.Label = UI.CreateFrame("Text", "Tome_UI_Layout_CharacterView_History_Header", Tome.UI.Layouts.CharacterView)
Tome.UI.Layouts.CharacterView.History.Label:SetPoint("TOPLEFT", Tome.UI.Layouts.CharacterView.Appearance.Text.Container, "BOTTOMLEFT", 0, 10)
Tome.UI.Layouts.CharacterView.History.Label:SetPoint("TOPRIGHT", Tome.UI.Layouts.CharacterView.Appearance.Text.Container, "BOTTOMRIGHT", 0, 10)
Tome.UI.Layouts.CharacterView.History.Label:SetFontSize(13)
Tome.UI.Layouts.CharacterView.History.Label:SetText("History:")
Tome.UI.Layouts.CharacterView.History.Text = Tome.Widget.TextArea.Create(
    Tome.UI.Layouts.CharacterView,
    "Tome_UI_Layout_CharacterView_History_Text"
)
Tome.UI.Layouts.CharacterView.History.Text:SetPoint("TOPLEFT", Tome.UI.Layouts.CharacterView.History.Label, "BOTTOMLEFT", 0, 5)
Tome.UI.Layouts.CharacterView.History.Text:SetPoint("TOPRIGHT", Tome.UI.Layouts.CharacterView.History.Label, "BOTTOMRIGHT", 0, 5)
Tome.UI.Layouts.CharacterView.History.Text:SetHeight((Tome.UI.Window:GetContent():GetHeight() / 100) * 25)
Tome.UI.Layouts.CharacterView.History.Text:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
Tome.UI.Layouts.CharacterView.History.Text.Border = Tome.Widget.Border.Create(Tome.UI.Layouts.CharacterView.History.Text.Container, 1)

-- Create the Age label
Tome.UI.Layouts.CharacterView.Age = UI.CreateFrame("Text", "Tome_UI_Layout_CharacterView_Age", Tome.UI.Layouts.CharacterView.Container)
Tome.UI.Layouts.CharacterView.Age:SetPoint("BOTTOMLEFT", Tome.UI.Layouts.CharacterView.Appearance.Label, "TOPLEFT", 0, -5)
Tome.UI.Layouts.CharacterView.Age:SetFontSize(13)

-- Create the Weight label
Tome.UI.Layouts.CharacterView.Weight = UI.CreateFrame("Text", "Tome_UI_Layout_CharacterView_Weight", Tome.UI.Layouts.CharacterView.Container)
Tome.UI.Layouts.CharacterView.Weight:SetPoint("BOTTOMRIGHT", Tome.UI.Layouts.CharacterView.Appearance.Label, "TOPRIGHT", 0, -5)
Tome.UI.Layouts.CharacterView.Weight:SetFontSize(13)

-- This function is used to update the layout whenever the data is changed
function Tome.UI.Layouts.CharacterView.UpdateLayout()
    -- Store the width of the container frame
    local width = Tome.UI.Layouts.CharacterView.Container:GetWidth()

    -- Calculate the offset for the Name label
    local offset = (width - Tome.UI.Layouts.CharacterView.Name:GetWidth()) / 2

    -- Reposition the Name label
    Tome.UI.Layouts.CharacterView.Name:SetPoint("TOPLEFT", Tome.UI.Layouts.CharacterView.Container, "TOPLEFT", offset, 10)

    -- Calculate the offset for the Title label
    offset = ((width - Tome.UI.Layouts.CharacterView.Title:GetWidth()) / 2) - offset

    -- Reposition the Title label
    Tome.UI.Layouts.CharacterView.Title:SetPoint("TOPLEFT", Tome.UI.Layouts.CharacterView.Name, "BOTTOMLEFT", offset, -3)

    -- Calculate the offset for the Height label
    offset = (width - Tome.UI.Layouts.CharacterView.Height:GetWidth()) / 2

    -- Reposition the Height label
    Tome.UI.Layouts.CharacterView.Height:SetPoint("BOTTOMLEFT", Tome.UI.Layouts.CharacterView.Appearance.Label, "TOPLEFT", offset, -5)
end

-- This function removed key focus from all the text fields
function Tome.UI.Layouts.CharacterView.ClearFocus()
    Tome.UI.Layouts.CharacterView.Appearance.Text:SetKeyFocus(false)
    Tome.UI.Layouts.CharacterView.History.Text:SetKeyFocus(false)
end

-- This function sets all the fields to match the supplied data
function Tome.UI.Layouts.CharacterView.Populate(data)
    local name = data.Name
    if data.Prefix and data.Prefix ~= "" then
        name = string.format("%s %s", data.Prefix, name)
    end
    if data.Suffix and data.Suffix ~= "" then
        name = string.format("%s %s", name, data.Suffix)
    end

    Tome.UI.Layouts.CharacterView.Name:SetText(name)
    Tome.UI.Layouts.CharacterView.Title:SetText(data.Title)
    if data.Age ~= "" then
        Tome.UI.Layouts.CharacterView.Age:SetText(string.format("Age: %s", data.Age))
    else
        Tome.UI.Layouts.CharacterView.Age:SetText("")
    end
    if data.Height ~= "" then
        Tome.UI.Layouts.CharacterView.Height:SetText(string.format("Height: %s", data.Height))
    else
        Tome.UI.Layouts.CharacterView.Height:SetText("")
    end
    if data.Weight ~= "" then
        Tome.UI.Layouts.CharacterView.Weight:SetText(string.format("Weight: %s", data.Weight))
    else
        Tome.UI.Layouts.CharacterView.Weight:SetText("")
    end
    local flag = ""
    for _, item in pairs(Tome.Data.Flags) do
        if item.id == data.Flag then
            flag = item.text
        end
    end
    if data.Tutor then
        flag = string.format("%s (Tutor)", flag)
    end
    Tome.UI.Layouts.CharacterView.Flag:SetText(flag)
    if data.InCharacter then
        Tome.UI.Layouts.CharacterView.InCharacter:SetText("In Character")
        Tome.UI.Layouts.CharacterView.InCharacter:SetFontColor(0.0, 1.0, 0.0, 1.0)
    else
        Tome.UI.Layouts.CharacterView.InCharacter:SetText("Out of Character")
        Tome.UI.Layouts.CharacterView.InCharacter:SetFontColor(0.78, 0.08, 0.08, 1.0)
    end
    Tome.UI.Layouts.CharacterView.Appearance.Text:SetText(data.Appearance)
    Tome.UI.Layouts.CharacterView.History.Text:SetText(data.History)

    Tome.UI.Layouts.CharacterView.UpdateLayout()
end
