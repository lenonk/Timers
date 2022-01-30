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

gData = {};

local ajaxValues = {
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0,
    [5] = 0,
    [6] = 0.01,
    [7] = 0.02,
    [8] = 0.03,
    [9] = 0.04,
    [10] = 0.05,
    [11] = 0.06,
    [12] = 0.07,
    [13] = 0.08,
    [14] = 0.09,
    [15] = 0.10
};
local rostamValues = {
    [1] = 1,
    [2] = 3,
    [3] = 5,
    [4] = 7,
    [5] = 9,
    [6] = 11,
    [7] = 13,
    [8] = 15,
    [9] = 17,
    [10] = 19,
    [11] = 21,
    [12] = 23,
    [13] = 25,
    [14] = 27,
    [15] = 30,
    [16] = 33,
    [17] = 36,
    [18] = 39,
    [19] = 42,
    [20] = 45,
    [21] = 48,
    [22] = 51,
    [23] = 53,
    [24] = 57,
    [25] = 60
};

gData.EquipSum = function(table)
    local total = 0;
    local equipment = gData.GetEquipmentTable();
    for _,equipPiece in pairs(equipment) do
        if equipPiece ~= nil and gData.GetMainJobLevel() >= gData.GetItemLevel(equipPiece.Id) then
            local value = table[equipPiece.Id];
            if value ~= nil then
                total = total + value;
            end
        end
    end
    return total;
end

gData.ParseAugments = function()
    local result = {};
    result.EnhancingDuration = 0;
    result.EnfeeblingDuration = 0;
    result.EnhancingReceived = 0;
    result.GeomancyDuration = 0;
    result.Generic = {};
    result.PhantomRoll = 0;

    local equipment = gData.GetEquipmentTable();
    for slot,equipPiece in pairs(equipment) do
        --Skip augments on anything we're wearing under a lower level sync
        if equipPiece ~= nil and gData.GetMainJobLevel() >= gData.GetItemLevel(equipPiece.Id) and equipPiece.ExtData ~= nil then
            local extData = equipPiece.ExtData;
            local augType = struct.unpack('B', extData, 1);
            if (augType == 2) or (augType == 3) then
                local augFlag = struct.unpack('B', extData, 2);
                if (augFlag % 64) >= 32 then
                    --Delve
                elseif (augFlag == 131) then
                    --Dynamis Augments

                    --Dls. Torques
                    if equipPiece.Id == 25441 or equipPiece.Id == 25442 or equipPiece.Id == 25443 then
                        local rankByte = struct.unpack('B', extData, 7);
                        local rank = ((rankByte % 128) - (rankByte % 4)) / 4;
                        result.EnhancingDuration = result.EnhancingDuration + (rank / 100);
                        result.EnfeeblingDuration = result.EnfeeblingDuration + (rank / 100);
                    end

                    --Bagua Charms
                    if equipPiece.Id == 25537 or equipPiece.Id == 25538 or equipPiece.Id == 25539 then
                        local rankByte = struct.unpack('B', extData, 7);
                        local rank = ((rankByte % 128) - (rankByte % 4)) / 4;
                        result.GeomancyDuration = result.GeomancyDuration + (rank / 100);
                    end
                    
                    --Ajax
                    if equipPiece.Id == 27639 then
                        local rankByte = struct.unpack('B', extData, 7);
                        local rank = ((rankByte % 128) - (rankByte % 4)) / 4;
                        if (rank > 0) then
                            result.EnhancingReceived = result.EnhancingReceived + ajaxValues[rank];
                        end
                    end

                    --Rostam/etc
                    if (slot == 1) and (T{21579, 21580, 21581}:contains(equipPiece.Id)) then
                        local rankByte = struct.unpack('B', extData, 7);
                        local rank = ((rankByte % 128) - (rankByte % 4)) / 4;
                        if (rank > 0) then
                            result.PhantomRoll = result.PhantomRoll + rostamValues[rank];
                        end                        
                    end
                elseif (augFlag % 16) >= 8 then
                    --Shield
                elseif (augFlag % 256) >= 128 then
                    --Evolith
                else
                    local maxAugments = 5;
                    if (augFlag % 128) >= 64 then --Magian
                        maxAugments = 4;
                    end
                    for i = 1,maxAugments,1 do
                        local augmentBytes = struct.unpack('H', extData, 1 + (2 * i));
                        local augmentId = augmentBytes % 0x800;
                        local augmentValue = (augmentBytes - augmentId) / 0x800;
                        if (augmentId == 0x4E0) then
                            result.EnhancingDuration = result.EnhancingDuration + ((augmentValue + 1) / 100);
                        elseif (augmentId == 0x4E1) then
                            result.EnhancingDuration = result.EnhancingDuration + ((augmentValue + 1) / 100);
                        elseif result.Generic[augmentId] == nil then
                            result.Generic[augmentId] = { augmentValue };
                        else
                            local augTable = result.Generic[augmentId];
                            augTable[#augTable + 1] = augmentValue;
                        end
                    end
                end
            end
        end
    end

    return result;
end

--Argument(id): Integer representation of a buff id.
--Return: Boolean
--Value: True if the buff id is present on the player, false if not.
gData.GetBuffActive = function(id)
    return (gPackets.GetBuffCount(id) > 0);
end

--Argument(id): Integer representation of a buff id.
--Return: Integer
--Value: The count of buff id on the player.
gData.GetBuffCount = function(id)
    return gPackets.GetBuffCount(id);
end

--Argument(id): Integer representation of skill ID, as listed in dats.
--Return: Integer
--Value: The player's current level in that skill.
gData.GetCombatSkill = function(id)
    return AshitaCore:GetMemoryManager():GetPlayer():GetCombatSkill(id):GetSkill();
end

--Return: Table with keys as 1-indexed integers representing equipment slot.  (Main = 1, Back = 16)
--Table.Id: The item's Id, or 0 if no item present.
--Table.ExtData: The item's 28 byte additional data field as a 1-indexed array of bytes, or a table with [1] = 0 if no item present.
gData.GetEquipmentTable = function()
    local retTable = {};
    for i = 1,16 do
        retTable[i] = {
            Id = 0,
            ExtData = nil
        };
        local itemloc = gPackets.GetEquipIndex(i);
        if not itemloc then
            local equippedItem = AshitaCore:GetMemoryManager():GetInventory():GetEquippedItem(i - 1);
            local index = bit.band(equippedItem.Index, 0x00FF);
            if index > 0 then
                itemloc = {
                    Container = bit.band(equippedItem.Index, 0xFF00) / 256;
                    Index = index;
                };
            end
        end
        if itemloc then
            local item = AshitaCore:GetMemoryManager():GetInventory():GetContainerItem(itemloc.Container, itemloc.Index);
            if (item.Id ~= 0) and (item.Count ~= 0) then
                retTable[i].Id = item.Id;
                retTable[i].ExtData = item.Extra;
            end
        end
    end
    return retTable;
end

--Argument(itemId): Integer representation of item ID.
--Return: The level required to equip an item, for use in evaluating if level sync blocks special stats.
gData.GetItemLevel = function(itemId)
    local resource = AshitaCore:GetResourceManager():GetItemById(itemId);
    if resource ~= nil then
        return resource.Level;
    else
        return 1000;
    end
end

--Return: Zero-indexed integer representing player's current main job (1 = war, 2 = mnk, 22 = run)
gData.GetMainJob = function()
    return AshitaCore:GetMemoryManager():GetPlayer():GetMainJob();
end

--Return: Integer representing player's current main job level.
gData.GetMainJobLevel = function()
    return AshitaCore:GetMemoryManager():GetPlayer():GetMainJobLevel();
end

--Argument(id): Integer representing a MERIT_TYPE(https://github.com/LandSandBoat/server/blob/base/src/map/merit.h)
--Return: Integer representing the number of merit upgrades the player has in this category.
gData.GetMeritCount = function(id)
    return gPackets.GetMeritCount(id);
end

--Argument(job): Zero-indexed integer representing a job (1 = war, 2 = mnk, 22 = run)
--Argument(category): Zero-indexed integer representing category(0-9)
--Return: Integer representing the number of job points the player has in this category.
gData.GetJobPoints = function(job, category)
    return gPackets.GetJobPoints(job, category);
end

--Argument(job): Zero-indexed integer representing a job (1 = war, 2 = mnk, 22 = run)
--Return: Integer representing the total number of spent job points the player has on this job(for gifts)
gData.GetJobPointTotal = function(job)
    return gPackets.GetJobPointTotal(job);
end

gData.GetWeaponskillCost = function()
    return gPackets.GetTP();
end

--Return: Integer matching the player's current Id.
gData.GetPlayerId = function()
    return gPackets.GetPlayerId();
end

--Return: Zero-indexed integer representing player's current main job (1 = war, 2 = mnk, 22 = run)
gData.GetSubJob = function()
    return AshitaCore:GetMemoryManager():GetPlayer():GetSubJob();
end

--Return: Integer representing player's current main job level.
gData.GetSubJobLevel = function()
    return AshitaCore:GetMemoryManager():GetPlayer():GetSubJobLevel();
end

--Return: Integer representing the player's current zone.
gData.GetZone = function()
    return AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0);
end

--Argument(entityId): The ID of an entity, to check if it is a notorious monster.
--Return: true or false
gData.IsNotoriousMonster = function(entityId)
    --Stub in case of future implementation, currently would only be used by saboteur.
    return false;
end
