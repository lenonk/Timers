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

require 'timer_group'

gPackets = require 'packetdata'

local recasts = {
    abils = {},
    spells = {},
};

local resMgr    = AshitaCore:GetResourceManager();

local OneHourAbilities = T{
    [1] = 'Mighty Strikes',
    [2] = 'Hundred Fists',
    [3] = 'Benediction',
    [4] = 'Manafont',
    [5] = 'Chainspell',
    [6] = 'Perfect Dodge',
    [7] = 'Invincible',
    [8] = 'Blood Weapon',
    [9] = 'Familiar',
    [10] = 'Soul Voice',
    [11] = 'Eagle Eye Shot',
    [12] = 'Meikyo Shisui',
    [13] = 'Mijin Gakure',
    [14] = 'Spirit Surge',
    [15] = 'Astral Flow',
    [16] = 'Azure Lore',
    [17] = 'Wild Card',
    [18] = 'Overdrive',
    [19] = 'Trance',
    [20] = 'Tabula Rasa',
    [21] = 'Bolster',
    [22] = 'Elemental Sforzo'
};

local SecondaryOneHourAbilities = T{
    [1] = 'Brazen Rush',
    [2] = 'Inner Strength',
    [3] = 'Asylum',
    [4] = 'Subtle Sorcery',
    [5] = 'Stymie',
    [6] = 'Larceny',
    [7] = 'Intervene',
    [8] = 'Soul Enslavement',
    [9] = 'Unleash',
    [10] = 'Clarion Call',
    [11] = 'Overkill',
    [12] = 'Yaegasumi',
    [13] = 'Mikage',
    [14] = 'Fly High',
    [15] = 'Astral Conduit',
    [16] = 'Unbridled Wisdom',
    [17] = 'Cutting Cards',
    [18] = 'Heady Artifice',
    [19] = 'Grand Pas',
    [20] = 'Caper Emissarius',
    [21] = 'Widened Compass',
    [22] = 'Odyllic Subterfuge'
};

local AbilityNameOverrides = T{
    [12] = 'Cascade',
    [231] = 'Stratagems',
    [242] = 'Jigs'
}

local AbilityBlocks = T{
    10,
    218
}

local function GetAbilityName(id)
    if id == 0 then
        local name = OneHourAbilities[AshitaCore:GetMemoryManager():GetPlayer():GetMainJob()];
        if name == nil then
            return '(Primary SP)';
        else
            return name;
        end
    elseif id == 254 then
        local name = SecondaryOneHourAbilities[AshitaCore:GetMemoryManager():GetPlayer():GetMainJob()];
        if name == nil then
            return '(Secondary SP)';
        else
            return name;
        end
    else
        local name = AbilityNameOverrides[id];
        if name ~= nil then
            return name;
        end
        local resource = AshitaCore:GetResourceManager():GetAbilityByTimerId(id);
        if resource ~= nil then
            return resource.Name[1];
        else
            return '(Unknown Ability)';
        end
    end
end

local function GetSpellName(id)
    local resource = resMgr:GetSpellById(id);
    if resource ~= nil then
        return resource.Name[1];
    else
        return '(Unknown Spell)';
    end
end

local function GetMemoryMod(recastId)
    local ptr = AshitaCore:GetPointerManager():Get("recast.abilities");
    local base = ashita.memory.read_uint32(ptr);
    for i = 1,32,1 do
        local id = ashita.memory.read_uint8(base + (i * 8) + 3);
        if id == recastId then
            return ashita.memory.read_int16(base + (i * 8) + 4);
        end
    end
    return 0;
end
 
local function ProcessReady(timer)
    --Memory modifier stores the number of seconds shaved off of initial 90 second recast.
    local readyId = 0x66;
    local reduction = GetMemoryMod(readyId);
    
    --Multiplying by 60 to get the same format as timer is stored in.
    local baseRecast = 60 * (90 + reduction);
    
    --Charges are treated as evenly divided between remaining recast by the server.
    local chargeValue = baseRecast / 3;
    
    --Basic math..
    local remainingCharges = math.floor((baseRecast - timer) / chargeValue);
    local timeUntilNextCharge = math.fmod(timer, chargeValue);

    return ('Ready [%d]'):fmt(remainingCharges), timeUntilNextCharge
end

local function ProcessQuickDraw(timer)
    --Memory modifier stores the number of seconds shaved off of initial 120 second recast.
    local quickDrawId = 0xC3;
    local reduction = GetMemoryMod(quickDrawId);

    --Multiplying by 60 to get the same format as timer is stored in.
    local baseRecast = 60 * (120 + reduction);

    --Charges are treated as evenly divided between remaining recast by the server.
    local chargeValue = baseRecast / 2;

    --Basic math..
    local remainingCharges = math.floor((baseRecast - timer) / chargeValue);
    local timeUntilNextCharge = math.fmod(timer, chargeValue);

    return ('Quick Draw [%d]'):fmt(remainingCharges), timeUntilNextCharge
end

local function ProcessStratagems(timer)
    -- Determine the players SCH level..
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    local lvl = (player:GetMainJob() == 20) and player:GetMainJobLevel() or player:GetSubJobLevel();

    -- Adjust the timer offset by the players level..
    local recast = 48;
    if (lvl < 30) then
        recast = 240;
    elseif (lvl < 50) then
        recast = 120;
    elseif (lvl < 70)then
        recast = 80;
    elseif (lvl < 90) then
        recast = 60;
    end

    -- Calculate the stratagems amount..
    local charges = 0;
    if (lvl == 99 and gPackets.GetJobPointTotal(20) >= 550) then
        recast = 33;
        charges = math.floor((165 - (timer / 60)) / recast);
    else
        charges = math.floor((240 - (timer / 60)) / recast);
    end

    local abil = {}
    timer = math.ceil(timer % (recast * 60))

    return ('Strategems [%d]'):fmt(charges), timer
end

local function Render(timers)
    local bars = {}
    for _, abil in pairs(recasts.abils) do
        table.insert(bars, { name=abil.Name, duration=abil.Duration, remains=abil.Remains, mode=TimerMode.LeftToRight });
    end

    for _, spell in pairs(recasts.spells) do
        table.insert(bars, { name=spell.Name, duration=spell.Duration, remains=spell.Remains, mode=TimerMode.LeftToRight });
    end

    timers:render(bars)
end

local function UpdateRecasts(timers)
    local swapAbilities = {}
    local mmRecast  = AshitaCore:GetMemoryManager():GetRecast()
    for i = 0,31 do
        local id = mmRecast:GetAbilityTimerId(i)
        local timer = mmRecast:GetAbilityTimer(i)
        if ((id ~= 0 or i == 0) and timer > 0 and (AbilityBlocks:contains(id) == false)) then
            local abil = {}
            if id == 0xC3 then -- Quick Draw
                abil.Name, abil.Remains = ProcessQuickDraw(timer)
            elseif id == 0x66 then -- Ready
                abil.Name, abil.Remains = ProcessReady(timer)
            elseif id == 0xE7 then -- Strategems
                abil.Name, abil.Remains = ProcessStratagems(timer)
            else
                abil.Name = GetAbilityName(id)
                abil.Remains = timer
            end

            if recasts.abils[id] ~= nil then
                if abil.Remains > recasts.abils[id].Duration then
                    abil.Duration = abil.Remains
                else
                    abil.Duration = recasts.abils[id].Duration
                end
            else
                abil.Duration = timer
            end
            swapAbilities[id] = abil
        end
    end
    recasts.abils = swapAbilities;

    local swapSpells = {};
    for i = 0, 1024 do
        local timer = mmRecast:GetSpellTimer(i);

        if (timer > 0) then
            local spell = {}
            spell.Name = GetSpellName(i)
            spell.Remains = timer
            if recasts.spells[i] ~= nil then
                spell.Duration = recasts.spells[i].Duration
            else
                spell.Duration = timer
            end
            swapSpells[i] = spell
        end
    end
    recasts.spells = swapSpells

    Render(timers);
end

recasts.Update = UpdateRecasts

return recasts;