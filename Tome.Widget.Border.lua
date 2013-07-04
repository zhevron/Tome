--
-- Tome.Widget.Border.lua
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
Tome.Widget.Border = {}

-- This function creates a new text area frame
function Tome.Widget.Border.Create(frame, thickness)
    -- Create a table to hold the border widget
    local border = {}

    -- Create a table to hold the border frames
    border.Frames = {}

    -- Create and position the frame for the top border
    border.Frames.Top = UI.CreateFrame("Frame", string.format("%s_Border_Top", frame:GetName()), frame)
    border.Frames.Top:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 0)
    border.Frames.Top:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 0)

    -- Create and position the frame for the bottom border
    border.Frames.Bottom = UI.CreateFrame("Frame", string.format("%s_Border_Bottom", frame:GetName()), frame)
    border.Frames.Bottom:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, 0)
    border.Frames.Bottom:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 0, 0)

    -- Create and position the frame for the left border
    border.Frames.Left = UI.CreateFrame("Frame", string.format("%s_Border_Left", frame:GetName()), frame)
    border.Frames.Left:SetPoint("TOPRIGHT", border.Frames.Top, "TOPLEFT", 0, 0)
    border.Frames.Left:SetPoint("BOTTOMRIGHT", border.Frames.Bottom, "BOTTOMLEFT", 0, 0)

    -- Create and position the frame for the right border
    border.Frames.Right = UI.CreateFrame("Frame", string.format("%s_Border_Right", frame:GetName()), frame)
    border.Frames.Right:SetPoint("TOPLEFT", border.Frames.Top, "TOPRIGHT", 0, 0)
    border.Frames.Right:SetPoint("BOTTOMLEFT", border.Frames.Bottom, "BOTTOMRIGHT", 0, 0)

    -- Attach the module methods
    border.SetThickness = Tome.Widget.Border.SetThickness
    border.SetBackgroundColor = Tome.Widget.Border.SetBackgroundColor

    -- Set the thickness for the border
    border:SetThickness(thickness)

    -- Assign the default color to the borders
    border:SetBackgroundColor(0.57, 0.55, 0.42, 1.0)

    return border
end

-- This function sets the thickness for the borders
function Tome.Widget.Border.SetThickness(self, thickness, borders)
    -- Default to all borders if nothing is specified
    borders = borders or "tlbr"

    -- Check if the top border was specified
    if string.find(borders, "t") and self.Frames.Top then
        -- Set the height of the top border frame
        self.Frames.Top:SetHeight(thickness)
    end

    -- Check if the left border was specified
    if string.find(borders, "l") and self.Frames.Left then
        -- Set the width of the left border frame
        self.Frames.Left:SetWidth(thickness)
    end

    -- Check if the bottom border was specified
    if string.find(borders, "b") and self.Frames.Bottom then
        -- Set the height of the bottom border frame
        self.Frames.Bottom:SetHeight(thickness)
    end

    -- Check if the right border was specified
    if string.find(borders, "r") and self.Frames.Right then
        -- Set the width of the right border frame
        self.Frames.Right:SetWidth(thickness)
    end
end

-- This function sets the background color for the borders
function Tome.Widget.Border.SetBackgroundColor(self, r, g, b, a, borders)
    -- Default to all borders if nothing is specified
    borders = borders or "tlbr"

    -- Check if the top border was specified
    if string.find(borders, "t") and self.Frames.Top then
        -- Set the background color of the top border frame
        self.Frames.Top:SetBackgroundColor(r, g, b, a)
    end

    -- Check if the left border was specified
    if string.find(borders, "l") and self.Frames.Left then
        -- Set the background color of the left border frame
        self.Frames.Left:SetBackgroundColor(r, g, b, a)
    end

    -- Check if the bottom border was specified
    if string.find(borders, "b") and self.Frames.Bottom then
        -- Set the background color of the bottom border frame
        self.Frames.Bottom:SetBackgroundColor(r, g, b, a)
    end

    -- Check if the right border was specified
    if string.find(borders, "r") and self.Frames.Right then
        -- Set the color of the right border frame
        self.Frames.Right:SetBackgroundColor(r, g, b, a)
    end
end
