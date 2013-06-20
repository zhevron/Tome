--
-- Tome.UI.Layout.View.lua
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
Tome.UI.Layouts.View = UI.CreateFrame("Frame", "Tome_UI_Layout_View", Tome.UI.Window)

-- Set the points for the layout
Tome.UI.Layouts.View:SetPoint("TOPLEFT", Tome.UI.Window:GetContent(), "TOPLEFT", 20, 15)
Tome.UI.Layouts.View:SetPoint("BOTTOMRIGHT", Tome.UI.Window:GetContent(), "BOTTOMRIGHT", -20, -15)

-- Create the container frame for the fluid layout
Tome.UI.Layouts.View.Container = UI.CreateFrame("Frame", "Tome_UI_Layout_View_Container", Tome.UI.Layouts.View)
Tome.UI.Layouts.View.Container:SetPoint("TOPLEFT", Tome.UI.Layouts.View, "TOPLEFT", 10, 0)

-- Create the Name label
Tome.UI.Layouts.View.Name = UI.CreateFrame("Text", "Tome_UI_Layout_View_Name", Tome.UI.Layouts.View.Container)
Tome.UI.Layouts.View.Name:SetFontSize(15)

-- Create the Title label
Tome.UI.Layouts.View.Title = UI.CreateFrame("Text", "Tome_UI_Layout_View_Title", Tome.UI.Layouts.View.Container)
Tome.UI.Layouts.View.Title:SetFontSize(13)
Tome.UI.Layouts.View.Title:SetFontColor(1.0, 0.8, 0.0, 1.0)

-- Create the Height label
Tome.UI.Layouts.View.Height = UI.CreateFrame("Text", "Tome_UI_Layout_View_Height", Tome.UI.Layouts.View.Container)
Tome.UI.Layouts.View.Height:SetFontSize(13)

-- Create the Age label
Tome.UI.Layouts.View.Age = UI.CreateFrame("Text", "Tome_UI_Layout_View_Age", Tome.UI.Layouts.View.Container)
Tome.UI.Layouts.View.Age:SetPoint("TOPRIGHT", Tome.UI.Layouts.View.Height, "TOPLEFT", 10, 0)
Tome.UI.Layouts.View.Age:SetFontSize(13)

-- Create the Weight label
Tome.UI.Layouts.View.Weight = UI.CreateFrame("Text", "Tome_UI_Layout_View_Weight", Tome.UI.Layouts.View.Container)
Tome.UI.Layouts.View.Weight:SetPoint("TOPLEFT", Tome.UI.Layouts.View.Height, "TOPRIGHT", 10, 0)
Tome.UI.Layouts.View.Weight:SetFontSize(13)

-- Create the Appearance label
Tome.UI.Layouts.View.Appearance = {}
Tome.UI.Layouts.View.Appearance.Label = UI.CreateFrame("Text", "Tome_UI_Layout_View_Appearance_Header", Tome.UI.Layouts.View)
Tome.UI.Layouts.View.Appearance.Label:SetPoint("TOPLEFT", Tome.UI.Layouts.View.Container, "BOTTOMLEFT", 0, 10)
Tome.UI.Layouts.View.Appearance.Label:SetFontSize(13)
Tome.UI.Layouts.View.Appearance.Label:SetText("Appearance:")
Tome.UI.Layouts.View.Appearance.Text = UI.CreateFrame("Text", "Tome_UI_Layout_View_Appearance_Text", Tome.UI.Layouts.View)
Tome.UI.Layouts.View.Appearance.Text:SetPoint("TOPLEFT", Tome.UI.Layouts.View.Appearance.Label, "BOTTOMLEFT", 0, 5)
Tome.UI.Layouts.View.Appearance.Text:SetWordwrap(true)

-- Create the History label
Tome.UI.Layouts.View.History = {}
Tome.UI.Layouts.View.History.Label = UI.CreateFrame("Text", "Tome_UI_Layout_View_History_Header", Tome.UI.Layouts.View)
Tome.UI.Layouts.View.History.Label:SetPoint("TOPLEFT", Tome.UI.Layouts.View.Appearance.Text, "BOTTOMLEFT", 0, 10)
Tome.UI.Layouts.View.History.Label:SetFontSize(13)
Tome.UI.Layouts.View.History.Label:SetText("History:")
Tome.UI.Layouts.View.History.Text = UI.CreateFrame("Text", "Tome_UI_Layout_View_History_Text", Tome.UI.Layouts.View)
Tome.UI.Layouts.View.History.Text:SetPoint("TOPLEFT", Tome.UI.Layouts.View.Appearance.Label, "BOTTOMLEFT", 0, 5)
Tome.UI.Layouts.View.History.Text:SetWordwrap(true)

-- This function is used to update the layout whenever the data is changed
function Tome.UI.Layouts.View.UpdateLayout()
    -- Store the width of the container frame
    local width = Tome.UI.Layouts.View.Container:GetWidth()

    -- Calculate the offset for the Name label
    local offset = (width - Tome.UI.Layouts.View.Name:GetWidth()) / 2

    -- Reposition the Name label
    Tome.UI.Layouts.View.Name:SetPoint("TOPLEFT", Tome.UI.Layouts.View.Container, "TOPLEFT", offset, 10)

    -- Calculate the offset for the Title label
    offset = ((width - Tome.UI.Layouts.View.Title:GetWidth()) / 2) - offset

    -- Reposition the Title label
    Tome.UI.Layouts.View.Title:SetPoint("TOPLEFT", Tome.UI.Layouts.View.Name, "BOTTOMLEFT", offset, 5)

    -- Calculate the offset for the Height label
    offset = (width - Tome.UI.Layouts.View.Height:GetWidth()) / 2

    -- Reposition the Height label
    Tome.UI.Layouts.View.Height:SetPoint("BOTTOMLEFT", Tome.UI.Layouts.View.Container, "BOTTOMLEFT", offset, 0)
end

-- This function removed key focus from all the text fields
function Tome.UI.Layouts.View.ClearFocus()
    -- This layout has no fields, return
    return
end

-- This function sets all the fields to match the supplied data
function Tome.UI.Layouts.View.Populate(self, data)
    local name = data.Name
    if data.Prefix and data.Prefix ~= "" then
        name = string.format("%s %s", data.Prefix, name)
    end
    if data.Suffix and data.Suffix ~= "" then
        name = string.format("%s %s", name, data.Suffix)
    end

    Tome.UI.Layouts.View.Name:SetText(name)
    Tome.UI.Layouts.View.Title:SetText(data.Title)
    Tome.UI.Layouts.View.Age:SetText(string.format("Age: %s", data.Age))
    Tome.UI.Layouts.View.Height:SetText(string.format("Height: %s", data.Height))
    Tome.UI.Layouts.View.Weight:SetText(string.format("Weight: %s", data.Weight))
    -- TODO: Set flag, tutor status and IC/OOC status
    Tome.UI.Layouts.View.Appearance.Text:SetText(data.Appearance)
    Tome.UI.Layouts.View.History.Text:SetText(data.History)

    Tome.UI.Layouts.View.UpdateLayout()
end
