--[[
* timers - Copyright (c) 2022 The Mystic
*
* This file is part of Timers for Ashita.
*
* Timers is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Timers is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with Timers.  If not, see <https://www.gnu.org/licenses/>.
--]]

require('timer')

local prims     = require('primitives');
local scaling   = require('scaling')

local default_settings = T{
    enabled = true,
    enable_background = true,
    font_height = 8,
    font_fg_color = 0xFFFFFFFF,
    font_bg_color = 0x00000000,
    font_outline_color = 0xFF000000,
    font_bg_visible = false,
    font_family = 'Arial',
    bar_height = 3,
    bar_width = 200,
    max_height = 500,
    enable_icons = true,
    icon_scale = 0.5,
    icon_offset_x = 0,
    icon_offset_y = 0,
    name_font_offset_x = 2,
    name_font_offset_y = 0,
    timer_font_offset_x = -2,
    timer_font_offset_y = 0,
    padding = T{ 5,2,5,2 },

    -- Background Primitive Settings
    background = T{
        border_visible = false,
        border_color = 0xFF000000,
        border_flags = FontBorderFlags.All,
        border_sizes = '1,1,1,1',
        visible = false,
        color = 0x40000000,
        can_focus = false,
        locked = true,
        width = 200,
        height = 0,
        position_x = 800,
        position_y = 500
    },

    thresholds = {
        t75 = 30,
        t50 = 20,
        t25 = 10,
    },

    colors = {
        color100 = 0xFF00FF00,
        color75  = 0xFFFFFF33,
        color50  = 0xFFFFA64D,
        color25  = 0xFFFF0000,
    },
}

TimerGroup = T{
    bg = nil,
    timers = {},
    active_timers = 0,

    settings = {}
}

function table.table_copy(t)
    local t2 = {}

    for k, v in pairs(t) do
        if type(v) == 'table' then
            t2[k] = table.table_copy(v)
        else
            t2[k] = v
        end
    end

    return t2
end

function TimerGroup:default_settings()
    return default_settings
end

function TimerGroup:new(o)
    local o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.settings = table.table_copy(default_settings)
    o.bg = prims.new(o.settings.background);

    -- Players can have no more than 32 statuses at once.
    -- Create 32 potential timer slots
    o.timers = {}
    for i = 0, 31 do
        local t = Timer:new(nil, nil, nil, 0, 0)
        t:hide()
        t.active = false
        t.thresholds = o.settings.thresholds
        t.colors = o.settings.colors

        o.timers[i + 1] = t
    end

    o.bg.width = o.settings.bar_width + o.settings.padding[1] + o.settings.padding[3]
    
    o:hide()
    return o
end

function TimerGroup:destroy()
    for k, v in pairs(self.timers) do
        if v then 
            v:destroy()
            self.timers[k] = nil
        end
    end

    self.bg:destroy()
end

function TimerGroup:clear()
    for k, v in pairs(self.timers) do
        if not v.active then break end
        if v then
            v.active = false
            v:hide()
        end
    end
end

function TimerGroup:clear_by_key(key)
    for k, v in pairs(self.timers) do
        if not v.active then break end
        if v and v.key == key then 
            v.active = false
            v:hide()
        end
    end
end

function TimerGroup:get_by_name(name)
    for _, v in pairs(self.timers) do
        if not v.active then break end
        if v and name:lower() == v.name:lower() then return v end
    end

    return nil
end

function TimerGroup:get_by_name_and_key(name, key)
    for _, v in pairs(self.timers) do
        if not v.active then break end
        if v and name:lower() == v.name:lower() and v.key == key then 
            return v
        end
    end

    return nil
end

function TimerGroup:get_by_key(key)
    for _, v in pairs(self.timers) do
        if not v.active then break end
        if v and v.key == key then return v end
    end

    return nil
end

function TimerGroup:hide()
    for _, v in pairs(self.timers) do
        if not v.active then break end
        if v then v:hide() end
    end

    self.bg.visible = false
end

function TimerGroup:show()
    -- Never show if the panel is set as hidden
    if not self.settings.enabled then
        -- And make sure that it's already hidden
        self:hide()
        return
    end

    self:move_to(self.settings.background.position_x, self.settings.background.position_y)
    self.bg.visible = self.settings.enable_background

    for _, v in pairs(self.timers) do
        if not v.active then break end
        if v then v:show() end
    end

end

function TimerGroup:move_to(x, y)
    self.bg.position_x = x
    self.bg.position_y = y

    -- Do this so the position gets saved in the settings
    self.settings.background.position_x = x
    self.settings.background.position_y = y

    for i = 0, 31 do
        self.timers[i+1].position_x = self.bg.position_x + self.settings.padding[1]
        self.timers[i+1].position_y = self.bg.position_y + self.settings.padding[2] +
            ((self.timers[i+1]:get_height() + self.settings.padding[4]) * i)
    end
end

function TimerGroup:update_timer_settings()
    for i = 1, 32 do
        local t = self.timers[i]

        t.bg.height = self.settings.bar_height
        t.width = self.settings.bar_width

        t.name_font.font_family = self.settings.font_family
        t.name_font.color = self.settings.font_fg_color
        t.name_font.font_height = scaling.scale_f(self.settings.font_height)
        t.name_font.color_outline = self.settings.font_outline_color
        t.name_font.background.color = self.settings.font_bg_color
        t.name_font.background.visible = self.settings.font_bg_visible

        t.time_font.font_family = self.settings.font_family
        t.time_font.color = self.settings.font_fg_color
        t.time_font.font_height = scaling.scale_f(self.settings.font_height)
        t.time_font.color_outline = self.settings.font_outline_color
        t.time_font.background.color = self.settings.font_bg_color
        t.time_font.background.visible = self.settings.font_bg_visible

        t.thresholds = self.settings.thresholds
        t.colors = self.settings.colors
        t.padding = self.settings.padding

        t.enable_icons = self.settings.enable_icons
        t.icon_scale = self.settings.icon_scale
        t.icon_offset_x = self.settings.icon_offset_x
        t.icon_offset_y = self.settings.icon_offset_y
        t.name_font_offset_x = self.settings.name_font_offset_x
        t.name_font_offset_y = self.settings.name_font_offset_y
        t.timer_font_offset_x = self.settings.timer_font_offset_x
        t.timer_font_offset_y = self.settings.timer_font_offset_y
    end
end

function TimerGroup:apply_settings()
    self.bg.border_visible = self.settings.background.border_visible
    self.bg.border_color = self.settings.background.border_color
    self.bg.border_sizes = self.settings.background.border_sizes
    self.bg.visible = self.settings.background.visible
    self.bg.color = self.settings.background.color

    self:update_timer_settings()
    self:move_to(self.settings.background.position_x, self.settings.background.position_y)
end

function TimerGroup:update_settings()
    -- Do this so these get saved in the settings
    self.settings.background.border_visible = self.bg.border_visible
    self.settings.background.border_color = self.bg.border_color
    self.settings.background.visible = self.bg.border_visible
    self.settings.background.color = self.bg.color

    self:update_timer_settings()
end

--[[
    Param is a table with the structure:
    {name=<name>, duration=<duration>, remains=<remains>, mode=<mode>, key=<key>, icon_id=<id>}
]]
function TimerGroup:render(timers)
    self:clear()

    if not self.settings.enabled or #timers <= 0 then
        self:hide()
        return
    else
        self:show()
    end

    for i = 1, #timers do
        if i > 32 then break end

        local next_y_pos = self.bg.position_y + self.settings.padding[2] +
            ((self.timers[i]:get_height() + self.settings.padding[4]) * i)

        if next_y_pos > self.bg.position_y + self.settings.max_height then
            -- The next timer would cause the panel to exceed the maximum height set in the settings
            if i == 0 then self:hide() end
            break
        end

        self.timers[i].name = timers[i].name or "Error: No Name"
        self.timers[i].duration = timers[i].duration or 0
        self.timers[i].remains = timers[i].remains or 0
        self.timers[i].mode = timers[i].mode or TimerMode.RightToLeft
        self.timers[i].key = timers[i].key or nil
        self.timers[i].icon_id = timers[i].icon_id or -1

        self.timers[i].active = true

        self.bg.height = (next_y_pos - self.bg.position_y)
        self.bg.width = self.settings.bar_width + self.settings.padding[1] + self.settings.padding[3]

        self.timers[i]:show()
        self.timers[i]:update()
    end
end