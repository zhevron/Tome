--
-- Tome.Widget.Draggable.lua
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
Tome.Widget.Draggable = {}

-- This function applies the draggable behavior to a frame
function Tome.Widget.Draggable.Create(frame)
    if not frame:GetBorder() then
        -- TODO: Implement an overlay draggable frame
    else
        -- Apply the draggable behavior to the border
        Tome.Widget.Draggable.ApplyBorders(frame)
    end
end

-- This function applies the draggable behavior to a window's border
function Tome.Widget.Draggable.ApplyBorders(frame)
    -- Create the flag variable for the left button down event
    frame.IsLeftButtonDown = false

    -- Create a couple of variables to hold the last position of the mouse
    frame.LastMouseX = 0
    frame.LastMouseY = 0

    -- Attach to the mouse cursor moved event of the border frame
    frame:GetBorder():EventAttach(
        Event.UI.Input.Mouse.Cursor.Move,
        function(handle)
            Tome.Widget.Draggable.Event_Border_Mouse_Move(frame)
        end,
        string.format("%s_Draggable_Event_Border_Mouse_Move", frame:GetName())
    )

    -- Attach to the left mouse button down event of the border frame
    frame:GetBorder():EventAttach(
        Event.UI.Input.Mouse.Left.Down,
        function(handle)
            Tome.Widget.Draggable.Event_Border_Mouse_LeftDown(frame)
        end,
        string.format("%s_Draggable_Event_Border_Mouse_LeftDown", frame:GetName())
    )

    -- Attach to the left mouse button up event of the border frame
    frame:GetBorder():EventAttach(
        Event.UI.Input.Mouse.Left.Up,
        function(handle)
            Tome.Widget.Draggable.Event_Border_Mouse_LeftUp(frame)
        end,
        string.format("%s_Draggable_Event_Border_Mouse_LeftUp", frame:GetName())
    )
    frame:GetBorder():EventAttach(
        Event.UI.Input.Mouse.Left.Upoutside,
        function(handle)
            Tome.Widget.Draggable.Event_Border_Mouse_LeftUp(frame)
        end,
        string.format("%s_Draggable_Event_Border_Mouse_LeftUpOutside", frame:GetName())
    )
end

-- This function is fired by the event API when the mouse moves inside the draggable frame
function Tome.Widget.Draggable.Event_Border_Mouse_Move(frame)
    -- Abort if the left button is not pressed
    if not frame.IsLeftButtonDown then
        return
    end

    -- Get the mouse position
    local mouse = Inspect.Mouse()

    -- Calculate the number of pixels to move the frame
    local OffsetX = mouse.x - frame.LastMouseX
    local OffsetY = mouse.y - frame.LastMouseY

    -- Store the current mouse position in the frame
    frame.LastMouseX = mouse.x
    frame.LastMouseY = mouse.y

    -- Get the current frame anchor point
    local PositionX, PositionY = frame:GetBounds()

    -- Move the frame anchor point
    frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", PositionX + OffsetX, PositionY + OffsetY)
end

-- This function is fired by the event API when the left mouse button is pressed on the border
function Tome.Widget.Draggable.Event_Border_Mouse_LeftDown(frame)
    -- Get the mouse position and store it in the frame
    local mouse = Inspect.Mouse()
    frame.LastMouseX = mouse.x
    frame.LastMouseY = mouse.y

    -- Get the current frame anchor point
    local left, top, right, bottom = frame:GetBounds()

    -- Clear all anchor points from the frame
    frame:ClearAll()

    -- Set a new anchor point for the frame
    frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", left, top)

    -- Set the frame height and width
    frame:SetHeight(bottom - top)
    frame:SetWidth(right - left)

    -- Set the left button down flag to true
    frame.IsLeftButtonDown = true
end

-- This function is fired by the event API when the left mouse button is released
function Tome.Widget.Draggable.Event_Border_Mouse_LeftUp(frame)
    -- Set the left button down flag to false
    frame.IsLeftButtonDown = false
end
