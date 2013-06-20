--
-- Tome.Widget.Dropdown.lua
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
Tome.Widget.Dropdown = {}

function Tome.Widget.Dropdown.Create(parent, name)
    -- Create the widget table
    local widget = {}

    -- Create the widget frames
    widget.Container = UI.CreateFrame("Frame", string.format("%s_Container", name), parent)

    -- Attach the module methods
    widget.GetHeight = Tome.Widget.Dropdown.GetHeight
    widget.GetWidth = Tome.Widget.Dropdown.GetWidth
    widget.SetBackgroundColor = Tome.Widget.Dropdown.SetBackgroundColor
    widget.SetPoint = Tome.Widget.Dropdown.SetPoint

    return widget
end

function Tome.Widget.Dropdown.GetHeight(self)
    -- Get the height of the container frame
    return self.Container:GetHeight()
end

function Tome.Widget.Dropdown.GetWidth(self)
    -- Get the width of the container frame
    return self.Container:GetWidth()
end

function Tome.Widget.Dropdown.SetBackgroundColor(self, r, g, b, a)
    -- Call SetBackgroundColor on the container frame
    self.Container:SetBackgroundColor(r, g, b, a)
end

function Tome.Widget.Dropdown.SetPoint(self, sourcepoint, targetframe, targetpoint, x, y)
    -- Set the X and Y paramenters to default 0 if not provided
    x = x or 0
    y = y or 0

    -- Call SetPoint on the container frame
    self.Container:SetPoint(sourcepoint, targetframe, targetpoint, x, y)
end
