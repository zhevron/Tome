--
-- Tome.UI.Layout.Guild.lua
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
Tome.UI.Layouts.Guild = UI.CreateFrame("Frame", "Tome_UI_Layout_Guild", Tome.UI.Window)

-- Set the points for the layout
Tome.UI.Layouts.Guild:SetPoint("TOPLEFT", Tome.UI.Window:GetContent(), "TOPLEFT", 20, 15)
Tome.UI.Layouts.Guild:SetPoint("BOTTOMRIGHT", Tome.UI.Window:GetContent(), "BOTTOMRIGHT", -20, -15)

-- Create the Name field
Tome.UI.Layouts.Guild.Name = UI.CreateFrame("RiftTextfield", "Tome_UI_Layout_Guild_Name", Tome.UI.Layouts.Guild)
Tome.UI.Layouts.Guild.Name:SetPoint("TOPLEFT", Tome.UI.Layouts.Guild, "TOPLEFT", 0, 2)
Tome.UI.Layouts.Guild.Name:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
Tome.UI.Layouts.Guild.Name:SetText("Name")
Tome.UI.Layouts.Guild.Name.Border = Tome.Widget.Border.Create(Tome.UI.Layouts.Guild.Name, 1)
Tome.UI.Layouts.Guild.Name:EventAttach(
    Event.UI.Input.Key.Focus.Gain,
    function(handle)
        -- Clear the text if it matches default
        if Tome.UI.Layouts.Guild.Name:GetText() == "Name" then
            Tome.UI.Layouts.Guild.Name:SetText("")
        end
    end,
    "Tome_UI_Layout_Guild_Name_Focus_Gain"
)
Tome.UI.Layouts.Guild.Name:EventAttach(
    Event.UI.Input.Key.Focus.Loss,
    function(handle)
        -- Set the default text if field is empty
        if Tome.UI.Layouts.Guild.Name:GetText() == "" then
            Tome.UI.Layouts.Guild.Name:SetText("Name")
        end
    end,
    "Tome_UI_Layout_Guild_Name_Focus_Loss"
)
Tome.UI.Layouts.Guild.Name:EventAttach(
    Event.UI.Input.Key.Up,
    function(handle, key)
        -- Enable the Save button
        Tome.UI.Save:SetEnabled(true)
    end,
    "Tome_UI_Layout_Guild_Name_Change"
)

-- Create the Subtitle field
Tome.UI.Layouts.Guild.Subtitle = UI.CreateFrame("RiftTextfield", "Tome_UI_Layout_Guild_Subtitle", Tome.UI.Layouts.Guild)
Tome.UI.Layouts.Guild.Subtitle:SetPoint("TOPLEFT", Tome.UI.Layouts.Guild.Name, "BOTTOMLEFT", 0, 2)
Tome.UI.Layouts.Guild.Subtitle:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
Tome.UI.Layouts.Guild.Subtitle:SetText("Subtitle")
Tome.UI.Layouts.Guild.Subtitle.Border = Tome.Widget.Border.Create(Tome.UI.Layouts.Guild.Subtitle, 1)
Tome.UI.Layouts.Guild.Subtitle:EventAttach(
    Event.UI.Input.Key.Focus.Gain,
    function(handle)
        -- Clear the text if it matches default
        if Tome.UI.Layouts.Guild.Subtitle:GetText() == "Subtitle" then
            Tome.UI.Layouts.Guild.Subtitle:SetText("")
        end
    end,
    "Tome_UI_Layout_Guild_Subtitle_Focus_Gain"
)
Tome.UI.Layouts.Guild.Subtitle:EventAttach(
    Event.UI.Input.Key.Focus.Loss,
    function(handle)
        -- Set the default text if field is empty
        if Tome.UI.Layouts.Guild.Subtitle:GetText() == "" then
            Tome.UI.Layouts.Guild.Subtitle:SetText("Subtitle")
        end
    end,
    "Tome_UI_Layout_Guild_Subtitle_Focus_Loss"
)
Tome.UI.Layouts.Guild.Subtitle:EventAttach(
    Event.UI.Input.Key.Up,
    function(handle, key)
        -- Enable the Save button
        Tome.UI.Save:SetEnabled(true)
    end,
    "Tome_UI_Layout_Guild_Subtitle_Change"
)

-- Create the Recruiting button
Tome.UI.Layouts.Guild.Recruiting = UI.CreateFrame("RiftButton", "Tome_UI_Layout_Guild_Recruiting", Tome.UI.Layouts.Guild)
Tome.UI.Layouts.Guild.Recruiting:SetPoint("TOPRIGHT", Tome.UI.Layouts.Guild, "TOPRIGHT", 0, 0)
Tome.UI.Layouts.Guild.Recruiting:SetText("Recruiting")
Tome.UI.Layouts.Guild.Recruiting:EventAttach(
    Event.UI.Input.Mouse.Left.Click,
    function(handle)
        -- Toggle the button based on current status
        if Tome.UI.Layouts.Guild.Recruiting:GetText() == "Recruiting" then
            Tome.UI.Layouts.Guild.Recruiting:SetText("Not Recruiting")
        else
            Tome.UI.Layouts.Guild.Recruiting:SetText("Recruiting")
        end

        -- Enable the Save button
        Tome.UI.Save:SetEnabled(true)
    end,
    "Tome_UI_Layout_Guild_Recruiting_Click"
)

-- Create the Roleplaying button
Tome.UI.Layouts.Guild.Roleplaying = UI.CreateFrame("RiftButton", "Tome_UI_Layout_Guild_Roleplaying", Tome.UI.Layouts.Guild)
Tome.UI.Layouts.Guild.Roleplaying:SetPoint("TOPRIGHT", Tome.UI.Layouts.Guild.Recruiting, "BOTTOMRIGHT", 0, 0)
Tome.UI.Layouts.Guild.Roleplaying:SetText("RP")
Tome.UI.Layouts.Guild.Roleplaying:EventAttach(
    Event.UI.Input.Mouse.Left.Click,
    function(handle)
        -- Toggle the button based on current status
        if Tome.UI.Layouts.Guild.Roleplaying:GetText() == "RP" then
            Tome.UI.Layouts.Guild.Roleplaying:SetText("No RP")
        else
            Tome.UI.Layouts.Guild.Roleplaying:SetText("RP")
        end

        -- Enable the Save button
        Tome.UI.Save:SetEnabled(true)
    end,
    "Tome_UI_Layout_Guild_Roleplaying_Click"
)

-- Create the Description field
Tome.UI.Layouts.Guild.Description = {}
Tome.UI.Layouts.Guild.Description.Label = UI.CreateFrame("Text", "Tome_UI_Layout_Guild_Description_Label", Tome.UI.Layouts.Guild)
Tome.UI.Layouts.Guild.Description.Label:SetPoint("TOPLEFT", Tome.UI.Layouts.Guild.Subtitle, "BOTTOMLEFT", 0, 10)
Tome.UI.Layouts.Guild.Description.Label:SetPoint("TOPRIGHT", Tome.UI.Layouts.Guild.Roleplaying, "BOTTOMRIGHT", 0, 10)
Tome.UI.Layouts.Guild.Description.Label:SetText("Description:")
Tome.UI.Layouts.Guild.Description.Text = Tome.Widget.TextArea.Create(
    Tome.UI.Layouts.Guild,
    "Tome_UI_Layout_Guild_Description_Text",
    true,
    function()
        -- Enable the save button
        Tome.UI.Save:SetEnabled(true)
    end
)
Tome.UI.Layouts.Guild.Description.Text:SetPoint("TOPLEFT", Tome.UI.Layouts.Guild.Description.Label, "BOTTOMLEFT", 0, 5)
Tome.UI.Layouts.Guild.Description.Text:SetPoint("TOPRIGHT", Tome.UI.Layouts.Guild.Description.Label, "BOTTOMRIGHT", 0, 5)
Tome.UI.Layouts.Guild.Description.Text:SetHeight((Tome.UI.Window:GetContent():GetHeight() / 100) * 22)
Tome.UI.Layouts.Guild.Description.Text:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
Tome.UI.Layouts.Guild.Description.Text.Border = Tome.Widget.Border.Create(Tome.UI.Layouts.Guild.Description.Text.Container, 1)

-- Create the Miscellaneous field
Tome.UI.Layouts.Guild.Miscellaneous = {}
Tome.UI.Layouts.Guild.Miscellaneous.Label = UI.CreateFrame("Text", "Tome_UI_Layout_Guild_Miscellaneous_Label", Tome.UI.Layouts.Guild)
Tome.UI.Layouts.Guild.Miscellaneous.Label:SetPoint("TOPLEFT", Tome.UI.Layouts.Guild.Description.Text.Container, "BOTTOMLEFT", 0, 10)
Tome.UI.Layouts.Guild.Miscellaneous.Label:SetPoint("TOPRIGHT", Tome.UI.Layouts.Guild.Description.Text.Container, "BOTTOMRIGHT", 0, 10)
Tome.UI.Layouts.Guild.Miscellaneous.Label:SetText("Miscellaneous:")
Tome.UI.Layouts.Guild.Miscellaneous.Text = Tome.Widget.TextArea.Create(
    Tome.UI.Layouts.Guild,
    "Tome_UI_Layout_Guild_Miscellaneous_Text",
    true,
    function()
        -- Enable the save button
        Tome.UI.Save:SetEnabled(true)
    end
)
Tome.UI.Layouts.Guild.Miscellaneous.Text:SetPoint("TOPLEFT", Tome.UI.Layouts.Guild.Miscellaneous.Label, "BOTTOMLEFT", 0, 5)
Tome.UI.Layouts.Guild.Miscellaneous.Text:SetPoint("TOPRIGHT", Tome.UI.Layouts.Guild.Miscellaneous.Label, "BOTTOMRIGHT", 0, 5)
Tome.UI.Layouts.Guild.Miscellaneous.Text:SetHeight((Tome.UI.Window:GetContent():GetHeight() / 100) * 22)
Tome.UI.Layouts.Guild.Miscellaneous.Text:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
Tome.UI.Layouts.Guild.Miscellaneous.Text.Border = Tome.Widget.Border.Create(Tome.UI.Layouts.Guild.Miscellaneous.Text.Container, 1)

-- This function removed key focus from all the text fields
function Tome.UI.Layouts.Guild.ClearFocus()
    Tome.UI.Layouts.Guild.Name:SetKeyFocus(false)
    Tome.UI.Layouts.Guild.Subtitle:SetKeyFocus(false)
    Tome.UI.Layouts.Guild.Description.Text:SetKeyFocus(false)
    Tome.UI.Layouts.Guild.Miscellaneous.Text:SetKeyFocus(false)
end

-- This function sets all the fields to match the supplied data
function Tome.UI.Layouts.Guild.Populate(data)
    --
end
