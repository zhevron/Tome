--
-- Tome.UI.Layout.GuildView.lua
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
Tome.UI.Layouts.GuildView = UI.CreateFrame("Frame", "Tome_UI_Layout_GuildView", Tome.UI.Window)

-- Set the points for the layout
Tome.UI.Layouts.GuildView:SetPoint("TOPLEFT", Tome.UI.Window:GetContent(), "TOPLEFT", 20, 15)
Tome.UI.Layouts.GuildView:SetPoint("BOTTOMRIGHT", Tome.UI.Window:GetContent(), "BOTTOMRIGHT", -20, -15)

-- Create the Recruiting label
Tome.UI.Layouts.GuildView.Recruiting = UI.CreateFrame("Text", "Tome_UI_Layout_GuildView_Recruiting", Tome.UI.Layouts.GuildView)
Tome.UI.Layouts.GuildView.Recruiting:SetPoint("TOPRIGHT", Tome.UI.Layouts.GuildView, "TOPRIGHT", -5, 5)
Tome.UI.Layouts.GuildView.Recruiting:SetFontSize(13)

-- Create the Roleplaying label
Tome.UI.Layouts.GuildView.Roleplaying = UI.CreateFrame("Text", "Tome_UI_Layout_GuildView_Roleplaying", Tome.UI.Layouts.GuildView)
Tome.UI.Layouts.GuildView.Roleplaying:SetPoint("TOPLEFT", Tome.UI.Layouts.GuildView, "TOPLEFT", 5, 5)
Tome.UI.Layouts.GuildView.Roleplaying:SetFontSize(13)

-- Create the Name label
Tome.UI.Layouts.GuildView.Name = UI.CreateFrame("Text", "Tome_UI_Layout_GuildView_Name", Tome.UI.Layouts.GuildView)
Tome.UI.Layouts.GuildView.Name:SetFontSize(22)

-- Create the Subtitle label
Tome.UI.Layouts.GuildView.Subtitle = UI.CreateFrame("Text", "Tome_UI_Layout_GuildView_Subtitle", Tome.UI.Layouts.GuildView)
Tome.UI.Layouts.GuildView.Subtitle:SetFontSize(13)
Tome.UI.Layouts.GuildView.Subtitle:SetFontColor(1.0, 0.8, 0.0, 1.0)

-- Create the Description label
Tome.UI.Layouts.GuildView.Description = {}
Tome.UI.Layouts.GuildView.Description.Label = UI.CreateFrame("Text", "Tome_UI_Layout_GuildView_Description_Header", Tome.UI.Layouts.CharacterView)
Tome.UI.Layouts.GuildView.Description.Label:SetPoint("TOPLEFT", Tome.UI.Layouts.GuildView.Subtitle, "BOTTOMLEFT", 0, 30)
Tome.UI.Layouts.GuildView.Description.Label:SetPoint("TOPRIGHT", Tome.UI.Layouts.GuildView.Subtitle, "BOTTOMRIGHT", 0, 30)
Tome.UI.Layouts.GuildView.Description.Label:SetFontSize(13)
Tome.UI.Layouts.GuildView.Description.Label:SetText("Description:")
Tome.UI.Layouts.GuildView.Description.Text = Tome.Widget.TextArea.Create(
    Tome.UI.Layouts.GuildView,
    "Tome_UI_Layout_GuildView_Description_Text"
)
Tome.UI.Layouts.GuildView.Description.Text:SetPoint("TOPLEFT", Tome.UI.Layouts.GuildView.Description.Label, "BOTTOMLEFT", 0, 5)
Tome.UI.Layouts.GuildView.Description.Text:SetPoint("TOPRIGHT", Tome.UI.Layouts.GuildView.Description.Label, "BOTTOMRIGHT", 0, 5)
Tome.UI.Layouts.GuildView.Description.Text:SetHeight((Tome.UI.Window:GetContent():GetHeight() / 100) * 25)
Tome.UI.Layouts.GuildView.Description.Text:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
Tome.UI.Layouts.GuildView.Description.Text.Border = Tome.Widget.Border.Create(Tome.UI.Layouts.GuildView.Description.Text.Container, 1)

-- Create the Miscellaneous label
Tome.UI.Layouts.GuildView.Miscellaneous = {}
Tome.UI.Layouts.GuildView.Miscellaneous.Label = UI.CreateFrame("Text", "Tome_UI_Layout_GuildView_Miscellaneous_Header", Tome.UI.Layouts.CharacterView)
Tome.UI.Layouts.GuildView.Miscellaneous.Label:SetPoint("TOPLEFT", Tome.UI.Layouts.GuildView.Description.Text.Container, "BOTTOMLEFT", 0, 30)
Tome.UI.Layouts.GuildView.Miscellaneous.Label:SetPoint("TOPRIGHT", Tome.UI.Layouts.GuildView.Description.Text.Container, "BOTTOMRIGHT", 0, 30)
Tome.UI.Layouts.GuildView.Miscellaneous.Label:SetFontSize(13)
Tome.UI.Layouts.GuildView.Miscellaneous.Label:SetText("Miscellaneous:")
Tome.UI.Layouts.GuildView.Miscellaneous.Text = Tome.Widget.TextArea.Create(
    Tome.UI.Layouts.GuildView,
    "Tome_UI_Layout_GuildView_Miscellaneous_Text"
)
Tome.UI.Layouts.GuildView.Miscellaneous.Text:SetPoint("TOPLEFT", Tome.UI.Layouts.GuildView.Miscellaneous.Label, "BOTTOMLEFT", 0, 5)
Tome.UI.Layouts.GuildView.Miscellaneous.Text:SetPoint("TOPRIGHT", Tome.UI.Layouts.GuildView.Miscellaneous.Label, "BOTTOMRIGHT", 0, 5)
Tome.UI.Layouts.GuildView.Miscellaneous.Text:SetHeight((Tome.UI.Window:GetContent():GetHeight() / 100) * 25)
Tome.UI.Layouts.GuildView.Miscellaneous.Text:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
Tome.UI.Layouts.GuildView.Miscellaneous.Text.Border = Tome.Widget.Border.Create(Tome.UI.Layouts.GuildView.Miscellaneous.Text.Container, 1)

-- This function is used to update the layout whenever the data is changed
function Tome.UI.Layouts.GuildView.UpdateLayout()
    -- Store the width of the layout
    local width = Tome.UI.Layouts.GuildView:GetWidth()

    -- Calculate the offset for the Name label
    local offset = (width - Tome.UI.Layouts.GuildView.Name:GetWidth()) / 2

    -- Reposition the Name label
    Tome.UI.Layouts.GuildView.Name:SetPoint("TOPLEFT", Tome.UI.Layouts.GuildView.Roleplaying, "BOTTOMLEFT", offset, 10)

    -- Calculate the offset for the Subtitle label
    offset = (width - Tome.UI.Layouts.GuildView.Subtitle:GetWidth()) / 2

    -- Reposition the Subtitle label
    Tome.UI.Layouts.GuildView.Subtitle:SetPoint("TOPLEFT", Tome.UI.Layouts.GuildView.Roleplaying, "BOTTOMLEFT", offset, Tome.UI.Layouts.GuildView.Name:GetHeight() + 20)
end

-- This function removed key focus from all the text fields
function Tome.UI.Layouts.GuildView.ClearFocus()
    Tome.UI.Layouts.GuildView.Description.Text:SetKeyFocus(false)
    Tome.UI.Layouts.GuildView.Miscellaneous.Text:SetKeyFocus(false)
end

-- This function sets all the fields to match the supplied data
function Tome.UI.Layouts.GuildView.Populate(data)
    -- Check if we actually have any data to show
    if not data then
        -- Player is not in a guild
        Tome.UI.Layouts.GuildView.Name:SetText("No Guild")
        Tome.UI.Layouts.GuildView.Subtitle:SetText("")
        Tome.UI.Layouts.GuildView.Description.Text:SetText("")
        Tome.UI.Layouts.GuildView.Miscellaneous.Text:SetText("")
        Tome.UI.Layouts.GuildView.Recruiting:SetText("")
        Tome.UI.Layouts.GuildView.Roleplaying:SetText("")
    else
        -- Populate the name field
        if data.Name and data.Name ~= "" then
            Tome.UI.Layouts.GuildView.Name:SetText(data.Name)
        else
            Tome.UI.Layouts.GuildView.Name:SetText("")
        end

        -- Populate the subtitle field
        if data.Subtitle and data.Subtitle ~= "" then
            Tome.UI.Layouts.GuildView.Subtitle:SetText(data.Subtitle)
        else
            Tome.UI.Layouts.GuildView.Subtitle:SetText("")
        end

        -- Populate the description field
        if data.Description and data.Description ~= "" then
            Tome.UI.Layouts.GuildView.Description.Text:SetText(data.Description)
        else
            Tome.UI.Layouts.GuildView.Description.Text:SetText("")
        end

        -- Populate the miscellaneous field
        if data.Miscellaneous and data.Miscellaneous ~= "" then
            Tome.UI.Layouts.GuildView.Miscellaneous.Text:SetText(data.Miscellaneous)
        else
            Tome.UI.Layouts.GuildView.Miscellaneous.Text:SetText("")
        end

        -- Populate the recruiting button
        if data.Recruiting then
            Tome.UI.Layouts.GuildView.Recruiting:SetText("Recruiting")
            Tome.UI.Layouts.GuildView.Recruiting:SetFontColor(0.0, 1.0, 0.0, 1.0)
        else
            Tome.UI.Layouts.GuildView.Recruiting:SetText("Not Recruiting")
            Tome.UI.Layouts.GuildView.Recruiting:SetFontColor(0.78, 0.08, 0.08, 1.0)
        end

        -- Populate the roleplaying button
        if data.Roleplaying then
            Tome.UI.Layouts.GuildView.Roleplaying:SetText("Roleplaying")
            Tome.UI.Layouts.GuildView.Roleplaying:SetFontColor(0.0, 1.0, 0.0, 1.0)
        else
            Tome.UI.Layouts.GuildView.Roleplaying:SetText("Not Roleplaying")
            Tome.UI.Layouts.GuildView.Roleplaying:SetFontColor(0.78, 0.08, 0.08, 1.0)
        end
    end

    -- Fix positions for the fluid layout
    Tome.UI.Layouts.GuildView.UpdateLayout()
end
