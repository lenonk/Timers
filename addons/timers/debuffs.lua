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

require('timer_group')
require('action_packets')
require('timer_common')

local debuffs = {
    debuffs = {},
};

local Overwrites = require('overwrites')

local EffectOverride = T{
    -- Dia
    [23]  = T{status=134}, -- I
    [24]  = T{status=134}, -- II
    [25]  = T{status=134}, -- III
    [26]  = T{status=134}, -- IV
    [27]  = T{status=134}, -- V

    -- Bio
    [230] = T{status=135}, -- I
    [231] = T{status=135}, -- II
    [232] = T{status=135}, -- III
    [233] = T{status=135}, -- IV
    [234] = T{status=135}, -- V

    -- Steps
    [201] = T{status=386}, -- Quickstep
    [202] = T{status=391}, -- Box Step
    [203] = T{status=396}, -- Stutter Step
    [312] = T{status=448}, -- Feather Step
}

local function GetEffectOverride(spell, default)
    if EffectOverride:haskey(spell) then
        return EffectOverride[spell].status
    end

    return default
end

local function CanApplyEffect(spell, target)
    for id, effect in pairs(debuffs.debuffs[target].effects) do
        -- Check if there is an existing debuff that this spell overwrites
        if Overwrites:haskey(spell) and Overwrites[spell].overwrites:hasval(effect.spell) then
            debuffs.debuffs[target].effects[id] = nil
            return true
        -- Check if there is an existing debuff that overwrites this spell
        elseif Overwrites:haskey(effect.spell) and Overwrites[effect.spell].overwrites:hasval(spell) then
            return false
        end
    end

    return true
end

local function ApplyDebuff(target, effect, spell, actor, type, param)
    if not debuffs.debuffs[target] then
        debuffs.debuffs[target] = {}
        debuffs.debuffs[target].effects = {}
    end
    
    local resMan = AshitaCore:GetResourceManager()

    -- Create timer
    local duration = nil
    local name = nil
    if T{ 201,202,203,312 }:hasval(spell) and type == 14 then
        -- Steps
        duration = gDuration.GetAbilityDuration(spell, target)
        duration = (duration and duration * 60) or nil
        local a = resMan:GetAbilityById(spell + 512)
        name = (a and a.Name[1]) or 'Unknown'
        name = ('%s [%d]'):fmt(name, param)
        if debuffs.debuffs[target].effects[effect] and duration then
            local e = debuffs.debuffs[target].effects[effect]
            duration = math.min(120 * 60, e.duration + (30 * 60))
        end
    elseif type == 3 or type == 14 then
        duration = gDuration.GetAbilityDuration(spell, target)
        duration = (duration and duration * 60) or nil
        local a = resMan:GetAbilityById(spell + 512)
        name = (a and a.Name[1]) or 'Unknown'
    elseif type == 4 then
        duration = gDuration.GetSpellDuration(spell, target)
        duration = (duration and duration * 60) or nil
        local s = resMan:GetSpellById(spell)
        name = (s and s.Name[1]) or 'Unknown'
    else 
        local t = GetEntity(GetTargetIndex(actor))
        local name = (t and t.Name) or nil
        print(('Unknown action [%d] with type [%d] used by %s'):fmt(spell, type, name or 'Unknown'))
    end

    if not duration then return end

    if CanApplyEffect(spell, target) then
        debuffs.debuffs[target].effects[effect] = {name=name, spell=spell, o_time=ashita.time.clock()['ms'], 
                                                duration=duration, actor=actor,
                                                t_index=GetTargetIndex(target)}
    end
end

local function HandleAction(act)
    local message = act.targets[1].actions[1].message

    if not ActionIsLocal(act.actor_id) then return end

    -- Spells
    -- 2,252 Are damaging spells
    -- 236,237,268,271 Are Non-damaging spells
    -- 127,519,520 Are abilities
    -- 327 is BLU magic
    if T{ 2,252,127,236,237,268,271,519,520 }:hasval(message) then
        local spell = act.param
        local target = act.targets[1].id
        local actor = act.actor_id
        local type = act['type']
        local effect = GetEffectOverride(spell, act.targets[1].actions[1].param)
        -- effect and param are usually the same, but sometimes they're not.
        -- In those cases, param is usually not needed, but sometimes it is. /sigh SE...
        local param = act.targets[1].actions[1].param

        --print(('%d, %d, %d, %d'):fmt(spell, type, act.targets[1].actions[1].effect, effect))
        if effect then
            ApplyDebuff(target, effect, spell, actor, type, param)
        end
    end
end

local function HandleActionMessage(data)
    local message = {}
    message.target_id = struct.unpack('I', data, 0x09)
    message.param_1 = struct.unpack('I', data, 0x0D)
    message.message_id = struct.unpack('H', data, 0x19) % 32768
        
    local db_target = debuffs.debuffs[message.target_id] or nil

    -- Target died
    if T{6, 20, 113, 406, 605, 646}:hasval(message.message_id) then
        debuffs.debuffs[message.target_id] = nil
        
    -- Debuff expired
    elseif T{64, 204, 206, 350, 531}:hasval(message.message_id) then
        if db_target and db_target.effects[message.param_1] then
            db_target.effects[message.param_1].duration = -1
            db_target.effects[message.param_1].o_time = ashita.time.clock()['ms']
        end
    end
end

local function HandlePacket(e)
    if e.blocked then return end

    if e.id == 0x028 then
        HandleAction(ParseActionPacket(e.data_modified))
    elseif e.id == 0x029 then
        HandleActionMessage(e.data_modified)
    elseif e.id == 0x000A then -- Zone Enter
        debuffs.debuffs = {}
    end
end

local function UpdateDebuffs(timers)
    local bars = {}
    for target, data in pairs(debuffs.debuffs) do
        if data then
            for id, effect in pairs(data.effects) do
                local t_entity = GetEntity(effect.t_index)
                local t_name = (t_entity and t_entity.Name) or 'Unknown'

                local timer_name = ("%s (%s)"):fmt(effect.name, t_name)
                local diff = ((ashita.time.clock()['ms'] - effect.o_time) / 1000.0) * 60.0
                if effect.duration == -1 and diff > 120 then -- 2 seconds
                    -- Being an elseif, this causes us to lose one frame of display.  I don't think it's an
                    -- issue though
                    debuffs.debuffs[target].effects[id].duration = -2
                elseif effect.duration == -2 and diff > 720 then
                    -- Wait an additional 10 seconds before retiring the debuff from the display
                    debuffs.debuffs[target].effects[id] = nil
                else 
                    local e = AshitaCore:GetMemoryManager():GetEntity()
                    if bit.band(e:GetRenderFlags0(effect.t_index), 0x200) == 0x200 then
                        local remains = effect.duration - diff
                        table.insert(bars, { name=timer_name, duration=effect.duration, 
                                             remains=remains, key=target, icon_id=id })
                    end
                end
            end
        end
    end

    timers:render(bars)
end

debuffs.Update = UpdateDebuffs
debuffs.HandlePacket = HandlePacket

return debuffs

