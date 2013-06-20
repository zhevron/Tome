--
-- Tome.Widget.TextArea.lua
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

-- Create the global module table for Tome.Widget if it doesn't exist
if not Tome.Widget then
    Tome.Widget = {}
end

-- Create the global module table
Tome.Widget.TextArea = {}

function Tome.Widget.TextArea.Create(parent, name)
    -- Create the widget table
    local widget = {}

    -- Create the widget frames
    widget.Container = UI.CreateFrame("Frame", string.format("%s_Container", name), parent)
    widget.Scrollbar = UI.CreateFrame("RiftScrollbar", string.format("%s_Scrollbar", name), widget.Container)
    widget.Textfield = UI.CreateFrame("RiftTextfield", string.format("%s_Textfield", name), widget.Container)

    -- Anchor the frames
    widget.Scrollbar:SetPoint("TOPRIGHT", widget.Container, "TOPRIGHT", 0, 0)
    widget.Scrollbar:SetPoint("BOTTOMRIGHT", widget.Container, "BOTTOMRIGHT", 0, 0)
    widget.Textfield:SetPoint("TOPLEFT", widget.Container, "TOPLEFT", 0, 0)
    widget.Textfield:SetPoint("BOTTOMRIGHT", widget.Scrollbar, "BOTTOMLEFT", 0, 0)

    -- Attach to container events
    widget.Container:EventAttach(
        Event.UI.Input.Key.Focus.Gain,
        function(handle)
            -- Set the focus to the textfield
            widget.Textfield:SetKeyFocus(true)
        end,
        string.format("%s_Event_Focus_Gain", name)
    )
    widget.Container:EventAttach(
        Event.UI.Input.Mouse.Wheel.Forward,
        function(handle)
            -- Move the scrollbar up
            widget.Scrollbar:Nudge(-3)
        end,
        string.format("%s_Event_MouseWheel_Forward", name)
    )
    widget.Container:EventAttach(
        Event.UI.Input.Mouse.Wheel.Back,
        function(handle)
            -- Move the scrollbar down
            widget.Scrollbar:Nudge(3)
        end,
        string.format("%s_Event_MouseWheel_Back", name)
    )

    -- Attach the module methods
    widget.GetText = Tome.Widget.TextArea.GetText
    widget.SetText = Tome.Widget.TextArea.SetText
    widget.GetHeight = Tome.Widget.TextArea.GetHeight
    widget.GetWidth = Tome.Widget.TextArea.GetWidth
    widget.SetBackgroundColor = Tome.Widget.TextArea.SetBackgroundColor
    widget.SetPoint = Tome.Widget.TextArea.SetPoint

    return widget
end

function Tome.Widget.TextArea.GetText(self)
    -- Get the text of the textfield frame
    return self.Textfield:GetText()
end

function Tome.Widget.TextArea.SetText(self, text)
    -- Set the text of the textfield frame
    self.Textfield:SetText(text)
end

function Tome.Widget.TextArea.GetHeight(self)
    -- Get the height of the container frame
    return self.Container:GetHeight()
end

function Tome.Widget.TextArea.GetWidth(self)
    -- Get the width of the container frame
    return self.Container:GetWidth()
end

function Tome.Widget.TextArea.SetBackgroundColor(self, r, g, b, a)
    -- Call SetBackgroundColor on the container frame
    self.Container:SetBackgroundColor(r, g, b, a)
end

function Tome.Widget.TextArea.SetPoint(self, sourcepoint, targetframe, targetpoint, x, y)
    -- Set the X and Y paramenters to default 0 if not provided
    x = x or 0
    y = y or 0

    -- Call SetPoint on the container frame
    self.Container:SetPoint(sourcepoint, targetframe, targetpoint, x, y)
end
