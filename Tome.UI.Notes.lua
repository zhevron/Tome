--
-- Tome.UI.Notes.lua
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
Tome.UI.Notes = {}

-- Store the name we're currently taking notes for
Tome.UI.Notes.Name = nil

-- Create the window that will hold the controls
Tome.UI.Notes.Window = UI.CreateFrame("RiftWindow", "Tome_UI_Notes_Window", Tome.UI.Context)

-- Make the window draggable
Tome.Widget.Draggable.Create(Tome.UI.Notes.Window)

-- Set the initial window width
local width = (UIParent:GetWidth() / 100) * 20
if (width < 200) then
    width = 200
end
Tome.UI.Notes.Window:SetWidth(width)

-- Hide the window by default
Tome.UI.Notes.Window:SetVisible(false)

-- Create the close button
Tome.UI.Notes.Close = UI.CreateFrame("RiftButton", "Tome_UI_Notes_Close", Tome.UI.Notes.Window)
Tome.UI.Notes.Close:SetPoint("TOPRIGHT", Tome.UI.Notes.Window, "TOPRIGHT", -10, 17)
Tome.UI.Notes.Close:SetSkin("close")
Tome.UI.Notes.Close:EventAttach(
    Event.UI.Input.Mouse.Left.Click,
    function(handle)
        -- Clear the text area focus
        Tome.UI.Notes.Textfield:SetKeyFocus(false)

        -- Hide the window
        Tome.UI.Notes.Window:SetVisible(false)
    end,
    "Tome_UI_Notes_Close_Click"
)

-- Create the Notes field
Tome.UI.Notes.Textfield = Tome.Widget.TextArea.Create(
    Tome.UI.Notes.Window,
    "Tome_UI_Notes_Textfield",
    true,
    function()
        -- Enable the save button
        Tome.UI.Notes.Save:SetEnabled(true)
    end
)
Tome.UI.Notes.Textfield:SetPoint("TOPLEFT", Tome.UI.Notes.Window:GetContent(), "TOPLEFT", 13, 10)
Tome.UI.Notes.Textfield:SetPoint("TOPRIGHT", Tome.UI.Notes.Window:GetContent(), "TOPRIGHT", -13, 10)
Tome.UI.Notes.Textfield:SetHeight((Tome.UI.Notes.Window:GetContent():GetHeight() / 100) * 90)
Tome.UI.Notes.Textfield:SetBackgroundColor(0.0, 0.0, 0.0, 0.7)
Tome.UI.Notes.Textfield.Border = Tome.Widget.Border.Create(Tome.UI.Notes.Textfield.Container, 1)

-- Create the Save button
Tome.UI.Notes.Save = UI.CreateFrame("RiftButton", "Tome_UI_Notes_Save", Tome.UI.Notes.Window)
Tome.UI.Notes.Save:SetPoint("BOTTOMRIGHT", Tome.UI.Notes.Window, "BOTTOMRIGHT", -15, -15)
Tome.UI.Notes.Save:SetText("Save")
Tome.UI.Notes.Save:SetEnabled(false)
Tome.UI.Notes.Save:EventAttach(
    Event.UI.Input.Mouse.Left.Click,
    function(handle)
        -- Abort if the button is disabled
        if not Tome.UI.Notes.Save:GetEnabled() then
            return
        end

        -- Store the character notes
        Tome_Notes[Tome.UI.Notes.Name] = Tome.UI.Notes.Textfield:GetText()

        -- Disable the save button
        Tome.UI.Notes.Save:SetEnabled(false)
    end,
    "Tome_UI_Notes_Save_Click"
)

-- This function opens the window and fills it with the notes on the specified character
function Tome.UI.Notes.Show(name)
    -- Ignore if no name was provided
    if not name then
        return
    end

    -- Store the name
    Tome.UI.Notes.Name = name

    -- Update the window title
    Tome.UI.Notes.Window:SetTitle(string.format("NOTES: %s", name))

    -- Update the anchor position in case the parent window moved
    Tome.UI.Notes.Window:SetPoint("TOPLEFT", Tome.UI.Window, "TOPRIGHT", 10, 0)

    -- Check if we have any notes on this character
    if Tome_Notes[name] then
        -- Fill the text area with the notes
        Tome.UI.Notes.Textfield:SetText(Tome_Notes[name])
    else
        -- Reset the notes text area
        Tome.UI.Notes.Textfield:SetText("")
    end

    -- Disable the save button
    Tome.UI.Notes.Save:SetEnabled(false)

    -- Show the window
    Tome.UI.Notes.Window:SetVisible(true)
end
