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

function ActionIsLocal(actor)
    local party = AshitaCore:GetMemoryManager():GetParty()

    if not party then return false end

    -- Extract each party member's index and see if their ServerId matches actor
    for i = 0, party:GetAlliancePartyMemberCount1() - 1 do
        local serverId = party:GetMemberServerId(i)
        if serverId and (serverId == actor) then
            return true
        end
    end

    return false
end

function GetTargetIndex(target)
    if not target then return nil end

    local targetIndex = nil
    local packedIndex = bit.band(target, 0x7FF);

    if ((packedIndex < 0x400) and (AshitaCore:GetMemoryManager():GetEntity():GetServerId(packedIndex) == target)) then
        -- Target is a monster
        targetIndex = packedIndex
    else
        for i = 0x400,0x8FF do
            if (AshitaCore:GetMemoryManager():GetEntity():GetServerId(i) == target) then
                targetIndex = i;
                break;
            end
        end
    end

    return targetIndex
end
