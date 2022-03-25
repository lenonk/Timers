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

local chat = require('chat');
local Equip = {};
local JobPoints = {};
local JobPointInit = {
    Categories = false,
    Totals = false,
    Timer = os.clock() + 3
};
local Merits = {};
local Self = {
    Name = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0),
    Id = AshitaCore:GetMemoryManager():GetParty():GetMemberServerId(0),
    Buffs = {};
};

local function InitializeMerits()
    local inv = AshitaCore:GetPointerManager():Get('inventory');
    if (inv == 0) then
        return;
    end
    local ptr = ashita.memory.read_uint32(inv);
    if (ptr == 0) then
        return;
    end
    ptr = ashita.memory.read_uint32(ptr);
    if (ptr == 0) then
        return;
    end
    ptr = ptr + 0x2CFF4;
    local count = ashita.memory.read_uint16(ptr + 2);
    local meritptr = ashita.memory.read_uint32(ptr + 4);
    if (count > 0) then
        for i = 1,count do
            local meritId = ashita.memory.read_uint16(meritptr + 0);
            local meritUpgrades = ashita.memory.read_uint8(meritptr + 3);
            Merits[meritId] = meritUpgrades;
            meritptr = meritptr + 4;
        end
    end
end

InitializeMerits();

local buffs = AshitaCore:GetMemoryManager():GetPlayer():GetBuffs();
for i, buff in ipairs(buffs) do
    if buff ~= -1 then
        Self.Buffs[i] = buff;
    end
end

local function HandleZonePacket(e)
    local id = struct.unpack('L', e.data, 0x04 + 1);
    local name = struct.unpack('c16', e.data, 0x84 + 1);
    local i,j = string.find(name, '\0');
    if (i ~= nil) then
        name = string.sub(name, 1, i - 1);
    end
    
    if name ~= Self.Name or id ~= Self.Id then
        JobPointInit = { Categories = false, Totals = false, Timer = os.clock() + 10 };
        Equip = {};
        JobPoints = {};
        Merits = {};
        Self = {
            Name = name,
            Id = id,
            Buffs = {}
        };
    end
end

local function HandlePacket(e)
    if (e.id == 0x00A) then
        HandleZonePacket(e);
    elseif (e.id == 0x0DD) or (e.id == 0x0DF) or (e.id == 0x0E2) then
        --Storing the last recorded TP value of at least 1000 for use in calculating duration of buff/debuff WS.
        if (struct.unpack('L', e.data, 0x04 + 1) == Self.Id) then
            local tp = struct.unpack('L', e.data, 0x10 + 1);
            if tp >= 1000 then
                Self.TP = tp;
            end
        end
    elseif (e.id == 0x37) then
        Self.Buffs = {};
        for i = 1,32,1 do
            local buff = struct.unpack('B', e.data, 0x04 + i);
            if buff == 255 then
                break;
            end
            local bitMask = ashita.bits.unpack_be(e.data_raw, 0x4C, (i - 1) * 2, 2);
            Self.Buffs[i] = bit.lshift(bitMask, 8) + buff;
        end
    elseif (e.id == 0x50) then
        local slot = struct.unpack('B', e.data, 0x05 + 1);
        Equip[slot + 1] = {
            Container = struct.unpack('B', e.data, 0x06 + 1);
            Index = struct.unpack('B', e.data, 0x04 + 1);
        };
    elseif (e.id == 0x63) then
        if struct.unpack('B', e.data, 0x04 + 1) == 5 then
            for i = 1,22,1 do
                if JobPoints[i] == nil then
                    JobPoints[i] = {};
                end
                JobPoints[i].Total = struct.unpack('H', e.data, 0x0C + 0x04 + (6 * i) + 1);
                --print('Job:' .. i .. ' JP:' .. struct.unpack('H', e.data, 0x0C + 0x04 + (6 * i) + 1));
            end
            JobPointInit.Totals = true;
        end
    elseif (e.id == 0x08C) then
        local meritCount = struct.unpack('B', e.data, 0x04 + 1);
        for i = 1,meritCount,1 do
            local id = struct.unpack('H', e.data, 0x04 + (4 * i) + 1);
            local count = struct.unpack('B', e.data, 0x04 + (4 * i) + 4);
            Merits[id] = count;
            --print('Merit:' .. id .. ' Points:' .. count);
        end        
    elseif (e.id == 0x08D) then        
        local jobPointCount = (e.size / 4) - 1;
        for i = 1,jobPointCount,1 do
            local offset = i * 4;
            local index = ashita.bits.unpack_be(e.data_raw, offset, 0, 5);
            local job = ashita.bits.unpack_be(e.data_raw, offset, 5, 11);
            local count = ashita.bits.unpack_be(e.data_raw, offset + 3, 2, 6);
            if job ~= 0 then
                if JobPoints[job] == nil then
                    JobPoints[job] = {};
                end
                if JobPoints[job].Categories == nil then
                    JobPoints[job].Categories = {};
                end
                JobPoints[job].Categories[index + 1] = count;
            end
            JobPointInit.Categories = true;
            --print('Job:' .. job .. ' Category:' .. index .. ' Count:' .. count);
        end
    end
end;

local interface = {};

interface.GetBuffCount = function(buff)
    local buffs = Self.Buffs;
    local count = 0;
    for i = 1,#buffs do
        if (buffs[i] == buff) then
            count = count + 1;
        end
    end
    return count;
end

interface.GetEquipIndex = function(slot)
    return Equip[slot];
end

interface.GetJobPoints = function(job, category)
    if JobPoints[job] == nil then
        return 0;
    elseif JobPoints[job].Categories == nil then
        return 0;
    end
    local value = JobPoints[job].Categories[category + 1];
    if value then
        return value;
    else
        return 0;
    end
end

interface.GetJobPointTotal = function(job)
    if JobPoints[job] == nil then
        return 0;
    end
    local value = JobPoints[job].Total;
    if value then
        return value;
    else
        return 0;
    end
end

interface.GetMeritCount = function(id)
    local value = Merits[id];
    if value then
        return value;
    else
        return 0;
    end
end

interface.GetPlayerId = function()
    local value = Self.Id;
    if value then
        return value;
    else
        return 0;
    end
end

interface.GetTP = function()
    local value = Self.TP;
    if value then
        return value;
    else
        return 1000;
    end
end

interface.HandlePacket = HandlePacket;

ashita.events.register('packet_out', 'packet_out_cb', function (e)
    if (e.id == 0x15) and (os.clock() > JobPointInit.Timer) and (AshitaCore:GetMemoryManager():GetPlayer():GetMainJobLevel() == 99) then
        if (JobPointInit.Totals == false) then
            local packet = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
            AshitaCore:GetPacketManager():AddOutgoingPacket(0x61, packet);
            print(chat.header('Timers') .. chat.message('Sending main menu packet to initialize job point totals.'));
        end
        if (JobPointInit.Categories == false) then
            local packet = { 0x00, 0x00, 0x00, 0x00 };
            AshitaCore:GetPacketManager():AddOutgoingPacket(0xC0, packet);
            print(chat.header('Timers') .. chat.message('Sending job point menu packet to initialize job point categories.'));
        end
        JobPointInit.Timer = os.clock() + 15;
    end
end);

return interface;