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

local prims     = require('primitives');
local fonts     = require('fonts');
local scaling   = require('scaling');

local gIconSize = 32

TimerMode = {
    LeftToRight = 1,
    RightToLeft = 2
}

-- Timer Object
Timer = {
    background = {
        border_visible = true,
        border_color = 0x80000000,
        border_flags = FontBorderFlags.All,
        border_sizes = '1,1,1,1',
        visible = true,
        color = 0x80000000,
        can_focus = false,
        locked = true,
        width = 225,
        height = 3,
        position_x = 0,
        position_y = 0,
    },

    foreground = {
        visible = true,
        color = 0xFFFF0000,
        can_focus = false,
        locked = true,
        width = 223,
        height = 3,
        position_x = 0,
        position_y = 0,
    },

    icon_prim = {
        visible = true,
        can_focus = false,
        locked = true,
        width = 16,
        height = 16,
        position_x = 0,
        position_y = 0,
    },

    font = T{
        visible = true,
        font_family = 'Arial',
        font_height = scaling.scale_f(8),
        color = 0xFFFFFFFF,
        color_outline = 0xFF000000,
        bold = false,
        draw_flags = bit.bor(FontDrawFlags.Outlined, FontDrawFlags.ManualRender),
        position_x = 0,
        position_y = 0,
        background = T{
            visible = false,
        },
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

    padding = T{ 5,2,5,2 },

    active = false,
    mode = TimerMode.RightToLeft,
    bg = nil,
    fg = nil,
    name_font = nil,
    time_font = nil,
    duration = nil,
    remains = nil,
    width = 200,
    height = 8,
    name = nil,
    key = nil,
    icon = nil,
    icon_id = 0,
    enable_icons = true,
    icon_scale = 0.5,
    icon_offset_x = 0,
    icon_offset_y = 0,
    name_font_offset_x = 2,
    name_font_offset_y = 0,
    timer_font_offset_x = -2,
    timer_font_offset_y = 0,
    position_y = 0,
    position_x = 0,
    flash_frame = 0,
}

function table.length(t) 
    local z = 0
    if not t then return 0 end
    for _ in pairs(t) do z = z + 1 end
    return z
end

local function format_timestamp(timer)
    if timer >= 600 then -- 10 seconds or more remaining
        local t = timer / 60;
        local h = math.floor(t / (60 * 60));
        local m = math.floor(t / 60 - h * 60);
        local s = math.ceil(t - (m + h * 60) * 60);
        local f = ''
        if h ~= 0 then
            f = string.format('%02i:', h)
        end

        -- We should never see a timer like 60:60
        -- Instead it should be 01:01:00
        if m == 60 then
            h = h + 1
            m = 0
        end

        if s == 60 then
            m = m + 1
            s = 0
        end

        return ('%s%02i:%02i'):fmt(f, m, s);
    else
        return ('%.2fs'):fmt(timer / 60.0)
    end
end

function Timer:new(name, duration, remains, pos_x, pos_y, mode, key, icon_id)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.name = name or ''
    o.duration = duration or 0
    o.remains = remains or 0
    o.key = key or nil
    o.mode = mode or TimerMode.RightToLeft
    o.icon_id = icon_id or -1

    o.bg = prims.new(self.background)
    o.bg.position_x = pos_x or 0
    o.bg.position_y = pos_y or 0

    o.fg = prims.new(self.foreground)
    o.fg.position_x = o.bg.position_x
    o.fg.position_y = o.bg.position_y

    o.name_font = fonts.new(self.font)
    o.time_font = fonts.new(self.font)

    o.icon = prims.new(self.icon_prim)

    return o
end

function Timer:hide()
    if self.bg then self.bg.visible = false end
    if self.fg then self.fg.visible = false end
    if self.name_font then self.name_font.visible = false end
    if self.time_font then self.time_font.visible = false end
    if self.icon then self.icon.visible = false end
end

function Timer:show()
    if self.bg then self.bg.visible = true end
    if self.fg then self.fg.visible = true end
    if self.name_font then self.name_font.visible = true end
    if self.time_font then self.time_font.visible = true end
    if self.icon then self.icon.visible = true end
end

function Timer:destroy()
    if self.bg then self.bg:destroy() end
    if self.fg then self.fg:destroy() end
    if self.name_font then self.name_font:destroy() end
    if self.time_font then self.time_font:destroy() end
    if self.icon then self.icon:destroy() end

    self.bg = nil
    self.fg = nil
    self.name_font = nil
    self.time_font = nil
    self.icon = nil
end

function Timer:get_height()
    local i_height = 0
    if self.icon_id >= 0 and self.enable_icons then
        i_height = math.floor(self.icon.height * self.icon_scale)
    end
    local nf_height = self.name_font.background.height
    local tf_height = self.time_font.background.height
    local bg_height = self.bg.height

    return math.max(i_height, math.max(nf_height, math.max(tf_height, bg_height)))
end

function Timer:get_icon_vec4()
    if self.icon_id < 0 then return { 0,0,0,0 } end

    local x = self.icon.position_x
    local y = self.icon.position_y
    local w = self.icon.width
    local h = self.icon.height
    return {x=x, y=y, width=w * self.icon_scale, height=h * self.icon_scale }
end

function Timer:update()
    local pct = 0
    if self.duration == -1 then
        -- Effect has expired.  We are now flashing the border
        if self.flash_frame == 5 and self.bg.border_color ~= 0x80FFDC00 then
            self.bg.border_color = 0x80FFDC00
            self.flash_frame = 0
        else
            self.bg.border_color = 0x80000000
            self.flash_frame = self.flash_frame + 1
        end
    else
        if self.duration ~= -2 then
            pct = (self.remains / self.duration)
            if self.remains <= 0 then pct = 0 end
        end
        self.bg.border_color = 0x80000000 -- Ensure that the border color is reset to the normal value
        self.flash_frame = 0
    end

    self.bg.width = self.width
    self.bg.position_x = self.position_x
    self.bg.position_y = (self.position_y + self:get_height()) - self.bg.height

    if self.icon_id >= 0 and self.enable_icons then
        local icon_data = AshitaCore:GetResourceManager():GetStatusIconById(self.icon_id)

        if icon_data ~= nil then
            self.icon.visible = true
            self.icon.position_x = self.position_x + self.icon_offset_x
            self.icon.position_y = self.position_y + self.icon_offset_y
            self.icon:SetTextureFromMemory(icon_data.Bitmap, #icon_data.Bitmap, 0xFF000000)
            self.icon.scale_x = self.icon_scale
            self.icon.scale_y = self.icon_scale

            local icon_vec_4 = self:get_icon_vec4()

            -- Adjust the background width for the width of the icon
            self.bg.width = self.bg.width - icon_vec_4.width

            -- Adjust the x pos of the background for the width of the icon
            self.bg.position_x = self.bg.position_x + icon_vec_4.width
        end
    else
        self.icon.visible = false
    end

    self.fg.position_x = self.bg.position_x
    self.fg.position_y = self.bg.position_y
    if self.mode == TimerMode.LeftToRight then
        self.fg.width = math.ceil(self.bg.width * (1 - pct))
    else
        self.fg.width = math.ceil(self.bg.width *  pct)
    end
    self.fg.height = self.bg.height

    local s_left = self.remains / 60.0
    if s_left >= self.thresholds.t75 then
        self.fg.color = self.colors.color100
    elseif s_left >= self.thresholds.t50 then
        self.fg.color = self.colors.color75
    elseif s_left >= self.thresholds.t25 then
        self.fg.color = self.colors.color50
    else 
        self.fg.color = self.colors.color25
    end

    if self.duration == -2 then
        self.name_font.color = 0xFFFF0000
    else
        self.name_font.color = 0xFFFFFFFF
    end
    self.name_font.text = self.name
    self.name_font.position_x = self.bg.position_x + self.name_font_offset_x
    self.name_font.position_y = math.max(self.position_y,
                                  self.bg.position_y - self.name_font.background.height) + self.name_font_offset_y
    self.name_font:render()

    if self.duration < 0 then
        self.time_font.text = '--:--'
    else
        self.time_font.text = format_timestamp(self.remains)
    end
    self.time_font.position_x = (self.bg.position_x + self.bg.width) + self.timer_font_offset_x
    self.time_font.position_y = math.max(self.position_y,
                                  self.bg.position_y - self.time_font.background.height) + self.timer_font_offset_y
    self.time_font.right_justified = true
    self.time_font:render()

    return true
end
