--[[
Copyright (c) 2022 Thorny

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

local AbilityCalculators = {};
local MobAbilityCalculators = {};
local PetAbilityCalculators = {};
local SpellCalculators = {};
local WeaponSkillCalculators = {};

require('ashita4data');
require('duration.bluemagic')(SpellCalculators);
require('duration.dark')(SpellCalculators);
require('duration.enfeebling')(SpellCalculators);
require('duration.enhancing')(SpellCalculators);
require('duration.geomancy')(SpellCalculators);
require('duration.incidental')(SpellCalculators);
require('duration.miscspells')(SpellCalculators);
require('duration.ninjutsu')(SpellCalculators);
require('duration.songs')(SpellCalculators);
require('duration.weaponskills')(WeaponSkillCalculators);
require('duration.abilities')(AbilityCalculators);

local exports = {};

exports.GetAbilityDuration = function(Id, targetId)
    local calculator =AbilityCalculators[Id];
    if calculator ~= nil then
        return calculator(targetId);
    else
        return nil;
    end
end

exports.GetMobAbilityDuration = function(Id, targetId)
    local calculator = MobAbilityCalculators[Id];
    if calculator ~= nil then
        return calculator(targetId);
    else
        return nil;
    end
end

exports.GetPetAbilityDuration = function(Id, targetId)
    local calculator = PetAbilityCalculators[Id];
    if calculator ~= nil then
        return calculator(targetId);
    else
        return nil;
    end
end

exports.GetSpellDuration = function(Id, targetId)
    local calculator = SpellCalculators[Id];
    if calculator ~= nil then
        return calculator(targetId);
    else
        return nil;
    end
end

return exports;
