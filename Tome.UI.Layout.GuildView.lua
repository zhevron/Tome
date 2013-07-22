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

-- This function removed key focus from all the text fields
function Tome.UI.Layouts.GuildView.ClearFocus()
    --
end

-- This function sets all the fields to match the supplied data
function Tome.UI.Layouts.GuildView.Populate(data)
    --
end
