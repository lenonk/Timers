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

addon.name      = 'Timers';
addon.author    = 'The Mystic';
addon.version   = '1.0.1';
addon.desc      = 'Displays the duration of spells and abilities you\'ve used';
addon.link      = 'https://github.com/lenonk/Timers';

require('common');
require('ffi')
require('timer_group')
require('helpers')

local settings  = require('settings');

gRecast     = require('recasts');
gDebuff     = require('debuffs');
gBuff       = require('buffs');
gPacketData = require('packetdata')
gDuration   = require('duration.duration')
gGui        = require('conf_ui')

gShiftDown = false;

-- Default Settings
local default_settings = T{
    opacity = 1.0,
    padding = 1.0,
    scale = 1.0,
    locked = false,
    party_buffs = true,

    -- Timers movement variables..
    move = T{
        dragging = false,
        drag_x = 0,
        drag_y = 0,
        shift_down = false,
    },
}

local timers = T{
    recasts = {
        settings = T{ },
        -- Currently displayed recast timers
        timers = nil,
    },
    debuffs = {
        settings = T{ },
        -- Currently displayed debuff timers
        timers = nil,
    },
    buffs = {
        settings = T{ },
        -- Currently displayed buff timers
        timers = nil,
    },
}

local function is_player_valid()
    if AshitaCore:GetMemoryManager():GetParty():GetMemberServerId(0) ~= 0 then
        return AshitaCore:GetMemoryManager():GetPlayer():GetIsZoning() == 0
    end

    return false
end

local function save_settings()
    settings.save('recast_panel_settings')
    settings.save('debuff_panel_settings')
    settings.save('buff_panel_settings')

    settings.save('recast_timer_settings')
    settings.save('debuff_timer_settings')
    settings.save('buff_timer_settings')
end

settings.register('recast_panel_settings', 'recast_panel_settings_update', function(s)
    if s ~= nil then timers.recasts.settings = s end
    settings.save('recast_panel_settings')
end)

settings.register('debuff_panel_settings', 'debuff_panel_settings_update', function(s)
    if s ~= nil then timers.debuffs.settings = s end
    settings.save('debuff_panel_settings')
end)

settings.register('buff_panel_settings', 'buff_panel_settings_update', function(s)
    if s ~= nil then timers.buffs.settings = s end
    settings.save('buff_panel_settings')
end)

settings.register('recast_timer_settings', 'recast_timer_settings_update', function(s)
    if s ~= nil then timers.recasts.timers.settings = s end
    settings.save('recast_timer_settings')
    if timers.recasts.timers then timers.recasts.timers:apply_settings() end
end)

settings.register('debuff_timer_settings', 'debuff_timer_settings_update', function(s)
    if s ~= nil then timers.debuffs.timers.settings = s end
    settings.save('debuff_timer_settings')
    if timers.debuffs.timers then timers.debuffs.timers:apply_settings() end
end)

settings.register('buff_timer_settings', 'buff_timer_settings_update', function(s)
    if s ~= nil then timers.buffs.timers.settings = s end
    settings.save('buff_timer_settings')
    if timers.buffs.timers then timers.buffs.timers:apply_settings() end
end)

--[[
* event: key
* desc : Event called when the addon is loaded
--]]
ashita.events.register('load', 'load_cb', function ()
    timers.recasts.settings = settings.load(default_settings, 'recast_panel_settings')
    timers.debuffs.settings = settings.load(default_settings, 'debuff_panel_settings')
    timers.buffs.settings = settings.load(default_settings, 'buff_panel_settings')

    timers.recasts.timers = TimerGroup:new()
    timers.debuffs.timers = TimerGroup:new()
    timers.buffs.timers = TimerGroup:new()

    timers.recasts.timers.settings = settings.load(TimerGroup:default_settings(), 'recast_timer_settings')
    timers.debuffs.timers.settings = settings.load(TimerGroup:default_settings(), 'debuff_timer_settings')
    timers.buffs.timers.settings = settings.load(TimerGroup:default_settings(), 'buff_timer_settings')

    timers.recasts.timers:apply_settings()
    timers.debuffs.timers:apply_settings()
    timers.buffs.timers:apply_settings()

    local pm = AshitaCore:GetPointerManager();
    if (pm:Get(REALUTCSTAMP_ID) == 0) then
        pm:Add(REALUTCSTAMP_ID, 'FFXiMain.dll', '8B0D????????8B410C8B49108D04808D04808D04808D04C1C3', 2, 0);
    end

    gBuff.SyncBuffs()
end);

--[[
* event: key
* desc : Event called when the addon is unloaded
--]]
ashita.events.register('unload', 'unload_cb', function ()
    save_settings()

    if timers.recasts.timers then timers.recasts.timers:destroy() end
    if timers.debuffs.timers then timers.debuffs.timers:destroy() end
    if timers.buffs.timers then timers.buffs.timers:destroy() end

    local pm = AshitaCore:GetPointerManager();
    if (pm:Get(REALUTCSTAMP_ID) ~= 0) then
        pm:Delete(REALUTCSTAMP_ID);
    end
end);

--[[
* event: packet
* desc : Event called when a packet is received from the server
--]]
ashita.events.register('packet_in', 'packet_in_cb', function(e)
    if gPacketData then gPacketData.HandlePacket(e) end
    if gBuff then gBuff.HandlePacket(e) end
    if gDebuff then gDebuff.HandlePacket(e) end
end)

--[[
* event: key
* desc : Event called when the Direct3D device is presenting a scene
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    if not is_player_valid() then return end

    gBuff.ShowPartyBuffs(timers.recasts.settings.party_buffs)

    gRecast.Update(timers.recasts.timers)
    gDebuff.Update(timers.debuffs.timers)
    gBuff.Update(timers.buffs.timers)

    gGui.render_config_ui(timers)
end);

--[[
* event: command
* desc : Event called when a / command is entered
--]]
ashita.events.register('command', 'command_cb', function (e)
    if string.lower(e.command) == '/timers' then
        gGui.is_open[1] = not gGui.is_open[1]
        e.blocked = true
    elseif string.lower(e.command) == '/timers lock' then
        timers.recasts.settings.locked = true
        timers.debuffs.settings.locked = true
        timers.buffs.settings.locked = true
        e.blocked = true;
    elseif string.lower(e.command) == '/timers unlock' then
        timers.recasts.settings.locked = false
        timers.debuffs.settings.locked = false
        timers.buffs.settings.locked = false
        e.blocked = true;
    elseif string.lower(e.command) == '/timers test' then
        e.blocked = true;
    end
end);

--[[
* event: key
* desc : Event called when the addon is processing keyboard input. (WNDPROC)
--]]
ashita.events.register('key', 'key_callback', function (e)
    -- Key: VK_SHIFT
    if (e.wparam == 0x10) then
        gShiftDown = not (bit.band(e.lparam, bit.lshift(0x8000, 0x10)) == bit.lshift(0x8000, 0x10));
        return;
    end
end);

--[[
* event: mouse
* desc : Event called when the addon is processing mouse input. (WNDPROC)
--]]
ashita.events.register('mouse', 'mouse_cb', function (e)

    -- Tests if the given coords are within the timers area.
    local function HitTest(panel, x, y)
        if (not panel.timers or not panel.timers.bg) then
            return false
        end

        -- We've already performed a hit test, and it was true, and the mouse
        -- button has not yet been released.  This provents the cursor
        -- from moving outside the border of the background and dropping
        -- the panel inappropriately while the mouse button is still down.
        if panel.settings.move.dragging then return true end

        local e_x = panel.timers.bg.position_x;
        local e_y = panel.timers.bg.position_y;
        local e_w = panel.timers.bg.width;
        local e_h = panel.timers.bg.height;

        return ((e_x <= x) and (e_x + e_w) >= x) and ((e_y <= y) and (e_y + e_h) >= y);
    end

    local panel = nil
    if HitTest(timers.recasts, e.x, e.y) then
        panel = timers.recasts
    elseif HitTest(timers.debuffs, e.x, e.y) then
        panel = timers.debuffs
    elseif HitTest(timers.buffs, e.x, e.y) then
        panel = timers.buffs
    end

    if not panel then return end

    local function is_dragging() return panel.settings.move.dragging; end

    -- Handle the various mouse messages..
    switch(e.message, {
        -- Event: Mouse Move
        [512] = (function ()
            panel.timers:move_to(
                e.x - panel.settings.move.drag_x,
                e.y - panel.settings.move.drag_y
            )

            e.blocked = true;
        end):cond(is_dragging),

        -- Event: Mouse Left Button Down
        [513] = (function ()
            if (gShiftDown and not panel.settings.locked) then
                panel.settings.move.dragging = true;
                panel.settings.move.drag_x = e.x - panel.timers.bg.position_x;
                panel.settings.move.drag_y = e.y - panel.timers.bg.position_y;

                e.blocked = true;
            end
        end):cond(HitTest:bindn(panel, e.x, e.y)),

        -- Event: Mouse Left Button Up
        [514] = (function ()
            if (panel.settings.move.dragging) then
                panel.settings.move.dragging = false;

                save_settings()

                e.blocked = true;
            end
        end):cond(is_dragging),

        -- Event: Mouse Wheel Scroll
        [522] = (function ()
            if (e.delta < 0) then
                panel.settings.opacity[1] = panel.settings.opacity[1] - 0.125;
            else
                panel.settings.opacity[1] = panel.settings.opacity[1] + 0.125;
            end
            panel.settings.opacity[1] = panel.settings.opacity[1]:clamp(0.125, 1);

            e.blocked = true;
        end):cond(HitTest:bindn(panel, e.x, e.y)),
    })
end)
