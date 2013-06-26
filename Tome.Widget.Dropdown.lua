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

-- This function creates a new dropdown menu frame
function Tome.Widget.Dropdown.Create(parent, name, callback)
    -- Create the widget table
    local widget = {}

    -- Store the callback function
    widget.Callback = callback

    -- Create the widget frames
    widget.Container = UI.CreateFrame("Frame", string.format("%s_Container", name), parent)
    widget.Selected = UI.CreateFrame("Text", string.format("%s_Selected", name), widget.Container)
    widget.ItemContainer = UI.CreateFrame("Frame", string.format("%s_ItemContainer", name), widget.Container)

    -- Set the anchor points for the frames
    widget.Selected:SetPoint("TOPLEFT", widget.Container, "TOPLEFT", 0, 0)
    widget.Selected:SetPoint("TOPRIGHT", widget.Container, "TOPRIGHT", 0, 0)
    widget.ItemContainer:SetPoint("TOPLEFT", widget.Selected, "BOTTOMLEFT", 0, 0)
    widget.ItemContainer:SetPoint("TOPRIGHT", widget.Selected, "BOTTOMRIGHT", 0, 0)

    -- Attach to the left mouse click event of the selected text label
    widget.Selected:EventAttach(
        Event.UI.Input.Mouse.Left.Click,
        Tome.Widget.Dropdown.Event_Selected_LeftMouse,
        string.format("%s_Selected_Event_LeftMouse", name)
    )

    -- Create a variable to hold the item frames
    widget.ItemFrames = {}

    -- Create a variable for the items
    widget.Items = {}

    -- Create variables to store the selected key and value
    widget.SelectedKey = nil
    widget.SelectedValue = nil

    -- Attach the module methods
    widget.GetHeight = Tome.Widget.Dropdown.GetHeight
    widget.SetHeight = Tome.Widget.Dropdown.SetHeight
    widget.GetWidth = Tome.Widget.Dropdown.GetWidth
    widget.SetWidth = Tome.Widget.Dropdown.SetWidth
    widget.SizeToFit = Tome.Widget.Dropdown.SizeToFit
    widget.SetBackgroundColor = Tome.Widget.Dropdown.SetBackgroundColor
    widget.SetPoint = Tome.Widget.Dropdown.SetPoint
    widget.GetItems = Tome.Widget.Dropdown.GetItems
    widget.SetItems = Tome.Widget.Dropdown.SetItems
    widget.GetSelectedKey = Tome.Widget.Dropdown.GetSelectedKey
    widget.SetSelectedKey = Tome.Widget.Dropdown.SetSelectedKey
    widget.GetSelectedValue = Tome.Widget.Dropdown.GetSelectedValue
    widget.SetSelectedValue = Tome.Widget.Dropdown.SetSelectedValue

    return widget
end

-- This function creates a new item frame and attaches the events
function Tome.Widget.Dropdown.CreateItemFrame(parent, name)
    -- Create the new frame
    local frame = UI.CreateFrame("Text", name, parent)

    -- Attach to the mouse in event of the frame
    frame:EventAttach(
        Event.UI.Input.Mouse.Cursor.In,
        Tome.Widget.Dropdown.Event_ItemFrame_MouseIn,
        string.format("%s_Event_MouseIn", name)
    )

    -- Attach to the mouse out event of the frame
    frame:EventAttach(
        Event.UI.Input.Mouse.Cursor.Out,
        Tome.Widget.Dropdown.Event_ItemFrame_MouseOut,
        string.format("%s_Event_MouseOut", name)
    )

    -- Attach to the left mouse click event of the frame
    frame:EventAttach(
        Event.UI.Input.Mouse.Left.Click,
        Tome.Widget.Dropdown.Event_ItemFrame_LeftMouse,
        string.format("%s_Event_LeftMouse", name)
    )

    return frame
end

-- This function returns the height of the dropdown
function Tome.Widget.Dropdown.GetHeight(self)
    -- Get the height of the container frame
    return self.Container:GetHeight()
end

-- This function sets the height of the dropdown
function Tome.Widget.Dropdown.SetHeight(self, height)
    -- Set the height of the container and selected item frames
    self.Container:SetHeight(height)
    self.Selected:SetHeight(height)
end

-- This function returns the width of the dropdown
function Tome.Widget.Dropdown.GetWidth(self)
    -- Get the width of the container frame
    return self.Container:GetWidth()
end

-- This function sets the width of the dropdown
function Tome.Widget.Dropdown.SetWidth(self, width)
    -- Set the width of the container and selected item frames
    self.Container:SetWidth(width)
    self.Selected:SetWidth(width)
end

-- This function resizes the dropdown to fit the text
function Tome.Widget.Dropdown.SizeToFit(self)
    -- Abort if we do not have any item frames
    if #self.ItemFrames == 0 then
        return
    end

    -- Get the text height
    local height = self.Items[1]:GetHeight()

    -- Set the height
    self:SetHeight(height)

    -- Get the width of the widest item
    local width = 0
    for _, item in ipairs(self.ItemFrames) do
        if item:GetWidth() > width then
            width = item:GetWidth()
        end
    end

    -- Set the width
    self:SetWidth(width)
end

-- This function sets the background color of the dropdown
function Tome.Widget.Dropdown.SetBackgroundColor(self, r, g, b, a)
    -- Call SetBackgroundColor on the container frame
    self.Container:SetBackgroundColor(r, g, b, a)
end

-- This function sets a specified anchor point for the dropdown
function Tome.Widget.Dropdown.SetPoint(self, sourcepoint, targetframe, targetpoint, x, y)
    -- Set the X and Y paramenters to default 0 if not provided
    x = x or 0
    y = y or 0

    -- Call SetPoint on the container frame
    self.Container:SetPoint(sourcepoint, targetframe, targetpoint, x, y)
end

-- This function returns the item table of the dropdown
function Tome.Widget.Dropdown.GetItems(self)
    -- Return the Items table
    return self.Items
end

-- This function sets the item table of the dropdown and creates the item frames
function Tome.Widget.Dropdown.SetItems(self, items)
    -- Check that we have a valid table
    if type(items) ~= "table" then
        return
    end

    -- Overwrite the Items table
    self.Items = items

    -- Abort if the table is empty
    if #self.Items == 0 then
        return
    end

    -- Loop the items and set up the frames
    local count = 1
    for key, value in pairs(self.Items) do
        -- Check if the frame exists and create it if not
        if not self.ItemFrames[count] then
            self.ItemFrames[count] = Tome.Widget.Dropdown.CreateItemFrame(
                self.ItemContainer,
                string.format("%s_ItemFrame_%d", self:GetName(), count)
            )
            if count == 1 then
                self.ItemFrames[count]:SetPoint("TOPLEFT", self.ItemContainer, "TOPLEFT", 0, 0)
            else
                self.ItemFrames[count]:SetPoint("TOPLEFT", self.ItemFrames[count - 1], "BOTTOMLEFT", 0, 0)
            end
        end

        -- Set the text to the item key
        self.ItemFrames[count]:SetText(key)

        -- If this is the first item, set it as the selected
        if count == 1 then
            self.SelectedKey = key
            self.SelectedValue = value
            self.Selected:SetText(key)
        end

        -- Increment the counter
        count = count + 1
    end

    -- Resize the dropdown to fit the items
    self:SizeToFit()
end

-- This function returns the selected table key of the dropdown
function Tome.Widget.Dropdown.GetSelectedKey(self)
    -- Get the selected key
    return self.SelectedKey
end

-- This function sets the selected table key of the dropdown
function Tome.Widget.Dropdown.SetSelectedKey(self, key)
    -- Abort of the key does not exist
    if not self.Items[key] then
        return
    end

    -- Set the selected item
    self.SelectedKey = key
    self.SelectedValue = self.Items[key]

    -- Update the selected item text
    self.Selected:SetText(key)
end

-- This function returns the selected table value of the dropdown
function Tome.Widget.Dropdown.GetSelectedValue(self)
    -- Get the selected value
    return self.SelectedValue
end

-- This function sets the selected table value of the dropdown
function Tome.Widget.Dropdown.SetSelectedValue(self, value)
    -- Get the key for the specified value
    local key = nil
    for k, v in pairs(self.Items) do
        if v == value then
            key = k
        end
    end

    -- Abort if the key could not be found
    if not key then
        return
    end

    -- Set the selected item
    self.SelectedKey = key
    self.SelectedValue = value

    -- Update the selected item text
    self.Selected:SetText(key)
end

-- This function is fired by the event API when the dropdown is clicked
function Tome.Widget.Dropdown.Event_Selected_LeftMouse(handle)
    -- Get the parent frame
    local widget = handle:GetParent()

    -- Toggle the dropdown menu
    widget.ItemContainer:SetVisible(not widget.ItemContainer:GetVisible())
end

-- This function is fired by the event API when the cursor is over a dropdown item
function Tome.Widget.Dropdown.Event_ItemFrame_MouseIn(handle)
    -- Get the parent frame
    local widget = handle:GetParent()

    -- Get the parent alpha value
    local _, _, _, a = widget.Container:GetBackgroundColor()

    -- Set the background color
    handle:SetBackgroundColor(1.0, 0.8, 0.4, a)
end

-- This function is fired by the event API when the cursor moves off a dropdown item
function Tome.Widget.Dropdown.Event_ItemFrame_MouseOut(handle)
    -- Get the parent frame
    local widget = handle:GetParent()

    -- Get the parent background color
    local r, g, b, a = widget.Container:GetBackgroundColor()

    -- Set the background color
    handle:SetBackgroundColor(r, g, b, a)
end

-- This function is fired by the event API when a dropdown item is clicked
function Tome.Widget.Dropdown.Event_ItemFrame_LeftMouse(handle)
    -- Get the parent frame
    local widget = handle:GetParent()

    -- Check if this is the same key that was already selected
    if widget.SelectedKey ~= handle:GetText() then
        -- Get the value of the item that was clicked
        local value = widget.Items[handle:GetText()]

        -- Abort if the value was not found
        if not value then
            return
        end

        -- Set the selected item
        widget.SelectedKey = handle:GetText()
        widget.SelectedValue = value

        -- Update the selected item text
        widget.Selected:SetText(handle:GetText())

        -- Trigger the callback function
        if widget.Callback and type(widget.Callback) == "function" then
            widget.Callback()
        end
    end

    -- Hide the dropdown menu
    widget.ItemContainer:SetVisible(false)
end
