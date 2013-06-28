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
        return Tome.Widget.Draggable.ApplyBorders(frame)
    end
end

-- This function applies the draggable behavior to a window's border
function Tome.Widget.Draggable.ApplyBorders(frame)
    -- Create the flag variable for the left button down event
    frame.IsLeftButtonDown = false

    -- Attach to the mouse cursor moved event of the border frame
    frame:GetBorder():EventAttach(
        Event.UI.Input.Mouse.Cursor.Move,
        Tome.Widget.Draggable.Event_Border_Mouse_Move,
        string.format("%s_Draggable_Event_Border_Mouse_Move", frame:GetName())
    )

    -- Attach to the left mouse button down event of the border frame
    frame:GetBorder():EventAttach(
        Event.UI.Input.Mouse.Left.Down,
        Tome.Widget.Draggable.Event_Border_Mouse_LeftDown,
        string.format("%s_Draggable_Event_Border_Mouse_LeftDown", frame:GetName())
    )

    -- Attach to the left mouse button up event of the border frame
    frame:GetBorder():EventAttach(
        Event.UI.Input.Mouse.Left.Up,
        Tome.Widget.Draggable.Event_Border_Mouse_LeftUp,
        string.format("%s_Draggable_Event_Border_Mouse_LeftUp", frame:GetName())
    )
    frame:GetBorder():EventAttach(
        Event.UI.Input.Mouse.Left.Upoutside,
        Tome.Widget.Draggable.Event_Border_Mouse_LeftUp,
        string.format("%s_Draggable_Event_Border_Mouse_LeftUpOutside", frame:GetName())
    )
end

-- This function is fired by the event API when the mouse moves inside the draggable frame
function Tome.Widget.Draggable.Event_Border_Mouse_Move(handle)
    -- Get the parent frame
    local frame = handle:GetParent()

    -- Abort if the left button is not pressed
    if not frame.IsLeftButtonDown then
        return
    end

    -- TODO: Implement movement of the frame
end

-- This function is fired by the event API when the left mouse button is pressed on the border
function Tome.Widget.Draggable.Event_Border_Mouse_LeftDown(handle)
    -- Set the left button down flag to true
    handle:GetParent().IsLeftButtonDown = true
end

-- This function is fired by the event API when the left mouse button is released
function Tome.Widget.Draggable.Event_Border_Mouse_LeftUp(handle)
    -- Set the left button down flag to false
    handle:GetParent().IsLeftButtonDown = false
end
