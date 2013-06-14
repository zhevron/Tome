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

Tome_Config = {
    Timeout = 3600
}

Tome_Character = {
    Prefix = detail and detail.titlePrefixName or "",
    Name = detail and detail.name or "",
    Suffix = detail and detail.titleSuffixName or "",
    Title = "",
    Age = "",
    Height = "",
    Weight = "",
    Appearance = "",
    History = "",
    InCharacter = false,
    Tutor = false,
    Flag = 0,
}

Tome_Cache = {}
