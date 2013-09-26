--
-- Tome.Defaults.lua
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

-- Get the character details
local detail = Inspect.Unit.Detail("player")

Tome_Defaults = {
    Timeout = 3600,
    Throttle = 60,
    Tooltip = {
        HideInCombat = true
    }
}

Tome_Character_Defaults = {
    Prefix = "",
    Name = detail and detail.name or "",
    Suffix = "",
    Title = "",
    Age = "",
    Height = "",
    Weight = "",
    Appearance = "",
    History = "",
    Currently ="",
    InCharacter = false,
    Tutor = false,
    Flag = 0,
    Origin = "Tome"
}

Tome_Notes = {}

Tome_Guild_Defaults = {
    Name = detail and detail.guild or "",
    Subtitle = "",
    Description = "",
    Miscellaneous = "",
    Recruiting = false,
    Roleplaying = false
}

Tome_Blacklist = {}

Tome_Cache_Defaults = {
    Character = {},
    Guild = {}
}

Tome_Throttle = {}

Tome_Config = Tome_Defaults

Tome_Character = Tome_Character_Defaults

Tome_Guild = Tome_Guild_Defaults

Tome_Cache = Tome_Cache_Defaults
