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

-- Store the normal line height for an editable textfield
local LINE_HEIGHT = 12.65

-- Store the normal line padding for an editable textfield
local LINE_PADDING = 4

-- Create the global module table for Tome.Widget if it doesn't exist
if not Tome.Widget then
    Tome.Widget = {}
end

-- Create the global module table
Tome.Widget.TextArea = {}

-- This function creates a new text area frame
function Tome.Widget.TextArea.Create(parent, name, editable, callback)
    -- Create the widget table
    local widget = {}

    -- Set the editable flag
    widget.Editable = editable

    -- Store the callback function
    widget.Callback = callback

    -- Create the widget frames
    widget.Container = UI.CreateFrame("Frame", string.format("%s_Container", name), parent)
    widget.Mask = UI.CreateFrame("Mask", string.format("%s_Mask", name), widget.Container)
    widget.Scrollbar = UI.CreateFrame("RiftScrollbar", string.format("%s_Scrollbar", name), widget.Container)

    -- If the text area is editable, create a textfield. Else, create a text label and enable word wrapping
    if widget.Editable then
        widget.Textfield = UI.CreateFrame("RiftTextfield", string.format("%s_Textfield", name), widget.Mask)
    else
        widget.Textfield = UI.CreateFrame("Text", string.format("%s_Textfield", name), widget.Mask)
        widget.Textfield:SetWordwrap(true)
    end

    -- Anchor the frames
    widget.Mask:SetPoint("TOPLEFT", widget.Container, "TOPLEFT", 0, 0)
    widget.Mask:SetPoint("BOTTOMRIGHT", widget.Container, "BOTTOMRIGHT", 0, 0)
    widget.Scrollbar:SetPoint("TOPRIGHT", widget.Container, "TOPRIGHT", 0, 0)
    widget.Scrollbar:SetPoint("BOTTOMRIGHT", widget.Container, "BOTTOMRIGHT", 0, 0)
    widget.Textfield:SetPoint("TOPLEFT", widget.Mask, "TOPLEFT", 0, 0)

    -- Set the width of the text field frame
    widget.Textfield:SetWidth(widget.Container:GetWidth() - widget.Scrollbar:GetWidth())

    -- Attach to the scrollwheel up event of the container frame
    widget.Container:EventAttach(
        Event.UI.Input.Mouse.Wheel.Forward,
        Tome.Widget.TextArea.Event_MouseWheel_Forward,
        string.format("%s_Event_MouseWheel_Forward", name)
    )

    -- Attach to the scrollwheel down event of the container frame
    widget.Container:EventAttach(
        Event.UI.Input.Mouse.Wheel.Back,
        Tome.Widget.TextArea.Event_MouseWheel_Back,
        string.format("%s_Event_MouseWheel_Back", name)
    )

    -- Attach to the scrollbar changed event of the scrollbar frame
    widget.Scrollbar:EventAttach(
        Event.UI.Scrollbar.Change,
        Tome.Widget.TextArea.Event_Scrollbar_Changed,
        string.format("%s_Scrollbar_Event_Changed", name)
    )

    if widget.Editable then
        -- Attach to the keyboard key up event of the textfield frame
        widget.Textfield:EventAttach(
            Event.UI.Input.Key.Up,
            Tome.Widget.TextArea.Event_Textfield_KeyUp,
            string.format("%s_Textfield_Event_KeyUp", name)
        )

        -- Attach to the left mouse click event of the mask frame
        widget.Mask:EventAttach(
            Event.UI.Input.Mouse.Left.Click,
            Tome.Widget.TextArea.Event_Mask_LeftMouse,
            string.format("%s_Mask_Event_LeftMouse", name)
        )
    end

    -- Store a reference to the widget in the container frame
    widget.Container.Widget = widget

    -- Store the name of the text area
    widget.Name = name

    -- Store the current scrollbar offset
    widget.Offset = 1

    -- Attach the module methods
    widget.GetName = Tome.Widget.TextArea.GetName
    widget.GetText = Tome.Widget.TextArea.GetText
    widget.SetText = Tome.Widget.TextArea.SetText
    widget.GetHeight = Tome.Widget.TextArea.GetHeight
    widget.SetHeight = Tome.Widget.TextArea.SetHeight
    widget.GetWidth = Tome.Widget.TextArea.GetWidth
    widget.SetWidth = Tome.Widget.TextArea.SetWidth
    widget.SetKeyFocus = Tome.Widget.TextArea.SetKeyFocus
    widget.GetLineCount = Tome.Widget.TextArea.GetLineCount
    widget.SizeToFit = Tome.Widget.TextArea.SizeToFit
    widget.SetBackgroundColor = Tome.Widget.TextArea.SetBackgroundColor
    widget.SetPoint = Tome.Widget.TextArea.SetPoint
    widget.UpdateScrollbar = Tome.Widget.TextArea.UpdateScrollbar
    widget.UpdatePosition = Tome.Widget.TextArea.UpdatePosition

    -- Update the scrollbar and content position
    widget:UpdateScrollbar()
    widget:UpdatePosition()

    return widget
end

-- This function returns the name of the text area
function Tome.Widget.TextArea.GetName(self)
    -- Get the name of the widget
    return self.Name
end

-- This function returns the text in the text area
function Tome.Widget.TextArea.GetText(self)
    -- Get the text of the textfield frame
    return self.Textfield:GetText()
end

-- This function sets the text in the text area
function Tome.Widget.TextArea.SetText(self, text)
    -- Set the text of the textfield frame
    self.Textfield:SetText(text)

    -- Resize the internal textfield to fit the text
    if self.Editable then
        self:SizeToFit()
    end

    -- Update the scrollbar and content position
    self:UpdateScrollbar()
    self:UpdatePosition()
end

-- This function returns the height of the text area
function Tome.Widget.TextArea.GetHeight(self)
    -- Get the height of the container frame
    return self.Container:GetHeight()
end

-- This function sets the height of the text area
function Tome.Widget.TextArea.SetHeight(self, height)
    -- Set the height of the container frame
    self.Container:SetHeight(height)

    -- Update the scrollbar and content position
    self:UpdateScrollbar()
    self:UpdatePosition()
end

-- This function returns the width of the text area
function Tome.Widget.TextArea.GetWidth(self)
    -- Get the width of the container frame
    return self.Container:GetWidth()
end

-- This function sets the width of the text area
function Tome.Widget.TextArea.SetWidth(self, width)
    -- Set the width of the container frame
    self.Container:SetWidth(width)

    -- Set the width of the text area frame
    self.Textfield:SetWidth(width - self.Scrollbar:GetWidth())

    -- Update the scrollbar and content position
    self:UpdateScrollbar()
    self:UpdatePosition()
end

-- This function sets the key focus for the text area
function Tome.Widget.TextArea.SetKeyFocus(self, focus)
    -- Set the key focus for the textfield if editable
    if self.Editable then
        self.Textfield:SetKeyFocus(focus)
    end
end

-- This function counts the number of lines in the entered text
function Tome.Widget.TextArea.GetLineCount(self, text)
    -- Default to the stored text if none is specified
    text = text or self.Textfield:GetText()

    -- Count the number of newlines in the text
    local lines = 1
    for item in string.gmatch(text, "[\r\n]") do
        lines = lines + 1
    end

    return lines
end

-- This function resizes the internal textfield to fit the entered text
function Tome.Widget.TextArea.SizeToFit(self)
    -- Calculate the new height of the textfield and set it
    self.Textfield:SetHeight(LINE_HEIGHT * self:GetLineCount() + LINE_PADDING * 2)
end

-- This function sets the background color of the text area
function Tome.Widget.TextArea.SetBackgroundColor(self, r, g, b, a)
    -- Call SetBackgroundColor on the container frame
    self.Container:SetBackgroundColor(r, g, b, a)
end

-- This function sets a specified anchor point for the text area
function Tome.Widget.TextArea.SetPoint(self, sourcepoint, targetframe, targetpoint, x, y)
    -- Set the X and Y paramenters to default 0 if not provided
    x = x or 0
    y = y or 0

    -- Call SetPoint on the container frame
    self.Container:SetPoint(sourcepoint, targetframe, targetpoint, x, y)

    -- Update width in case it has changed
    self.Textfield:SetWidth(self.Container:GetWidth() - self.Scrollbar:GetWidth())

    -- Update the scrollbar and content position
    self:UpdateScrollbar()
    self:UpdatePosition()
end

-- This function updates the scrollbar settings
function Tome.Widget.TextArea.UpdateScrollbar(self)
    -- Update the range of the scrollbar
    if math.max(0, self.Textfield:GetHeight() - self:GetHeight()) > 0 then
        self.Scrollbar:SetRange(1, math.max(0, self.Textfield:GetHeight() - self:GetHeight()))
    end

    -- Set the position of the scrollbar to match the offset
    self.Scrollbar:SetPosition(self.Offset)
end

-- This function updates the content position
function Tome.Widget.TextArea.UpdatePosition(self)
    -- Set the position of the content to the current offset
    self.Textfield:SetPoint("TOPLEFT", self.Container, "TOPLEFT", 0, -self.Offset)
end

-- This function is fired by the event API when the left mouse button is pressed inside the mask frame
function Tome.Widget.TextArea.Event_Mask_LeftMouse(handle)
    -- Set the focus to the textfield
    handle:GetParent().Widget.Textfield:SetKeyFocus(true)
end

-- This function is fired by the event API when the scrollwheel on the mouse is moved forward
function Tome.Widget.TextArea.Event_MouseWheel_Forward(handle)
    -- Move the scrollbar up
    handle.Widget.Scrollbar:Nudge(-(LINE_HEIGHT + LINE_PADDING))
end

-- THis function is fired by the event API when the scrollwheel on the mouse is moved backwards
function Tome.Widget.TextArea.Event_MouseWheel_Back(handle)
    -- Move the scrollbar down
    handle.Widget.Scrollbar:Nudge(LINE_HEIGHT + LINE_PADDING)
end

-- This function is fired by the event API when the position on the scrollbar changes
function Tome.Widget.TextArea.Event_Scrollbar_Changed(handle)
    -- Get the widget from the parent
    local widget = handle:GetParent().Widget

    -- Store the new scrollbar offset
    widget.Offset = handle:GetPosition()

    -- Update the content position
    widget:UpdatePosition()
end

-- This function is fired by the event API when a key is released inside the textfield frame
function Tome.Widget.TextArea.Event_Textfield_KeyUp(handle, unused, key)
    -- Get the widget from the parent
    local widget = handle:GetParent():GetParent().Widget

    -- Get the cursor position
    local cursor = widget.Textfield:GetCursor()

    -- Get the text before and after the cursor
    local prefix = string.sub(widget.Textfield:GetText(), 1, cursor)
    local suffix = string.sub(widget.Textfield:GetText(), cursor + 1)

    -- Check if the key pressed was TAB
    if key == "Tab" then
        -- Add a tab character to the textfield
        widget.Textfield:SetText(string.format("%s\t%s", prefix, suffix))

        -- Move the cursor
        widget.Textfield:SetSelection(cursor + 1, cursor + 2)
    end

    -- Check if the key pressed was ENTER
    if key == "Return" then
        -- Add a newline character to the textfield
        widget.Textfield:SetText(string.format("%s\n%s", prefix, suffix))

        -- Move the cursor
        widget.Textfield:SetSelection(cursor, cursor + 1)
    end

    -- Size the text area to fit the text
    widget:SizeToFit()

    -- Update the cursor position in case it has changed with a key hook
    cursor = widget.Textfield:GetCursor()

    -- Update the prefix text in case it changed with a key hook
    prefix = string.sub(widget.Textfield:GetText(), 1, cursor)

    -- Get the current line the cursor is on
    local line = widget:GetLineCount(prefix)

    -- Calculate the cursor offset
    local offset = (line - 1) * LINE_HEIGHT + LINE_PADDING

    if offset < widget.Offset then
        -- Calculate the new scrollbar position
        widget.Scrollbar:SetPosition(math.max(offset, 0))
    elseif offset > widget.Offset + widget:GetHeight() - LINE_HEIGHT then
        -- Get the max range from the scrollbar
        _, max = widget.Scrollbar:GetRange()

        -- Calculate the new scrollbar position
        widget.Scrollbar:SetPosition(math.min(offset - widget:GetHeight() + LINE_HEIGHT + LINE_PADDING, max))
    end

    -- Fire the callback function
    if widget.Callback and type(widget.Callback) == "function" then
        widget.Callback()
    end
end
