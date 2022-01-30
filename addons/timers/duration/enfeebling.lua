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

local enfeeblingDuration = {
    [25827] = 0.20, --Regal Cuffs
    [26109] = 0.10, --Snotra Earring
    [26188] = 0.10, --Kishar Ring
    [26363] = 0.05 --Obstin. Sash
};
local saboteurModifiers = {
    [11208] = 0.05, --Estq. Ganthrt. +1
    [11108] = 0.10, --Estq. Ganthrt. +2
    [27060] = 0.11, --Leth. Gantherots
    [27061] = 0.12 --Leth. Gantherots +1
};

local function ApplyEnfeeblingAdditions(duration, augments)
    if gData.GetMainJob() ~= 5 then
        return duration;
    end

    local mainJobLevel = gData.GetMainJobLevel();
    if mainJobLevel >= 75 then
        local merits = gData.GetMeritCount(0x90C);
        if merits > 0 then
            local multiplier = 6;
            if (augments.Generic[0x548]) then
                multiplier = 9;
            end
            duration = duration + (merits * multiplier);
        end
    end

    if mainJobLevel == 99 then
        --General enfeebling duration job points
        local jobPoints = gData.GetJobPoints(5, 7);
        duration = duration + jobPoints;

        --Stymie
        if gData.GetBuffActive(494) then
            jobPoints = gData.GetJobPoints(5, 1);
            duration = duration + jobPoints;
        end
    end

    return duration;
end

local function ApplyEnfeeblingMultipliers(duration, augments)
    local enfeeblingGear = 1.0 + gData.EquipSum(enfeeblingDuration);
    local enfeeblingAugments = 1.0 + augments.EnfeeblingDuration;
    return duration * enfeeblingGear * enfeeblingAugments;
end

local function ApplySaboteurMultipliers(duration, targetId)
    if not gData.GetBuffActive(454) then
        return duration;
    end

    local saboteur = 2.0;
    if gData.IsNotoriousMonster(targetId) then
        saboteur = 1.25;
    end

    saboteur = saboteur + gData.EquipSum(saboteurModifiers);
    return duration * saboteur;
end

local function CalculateEnfeeblingDuration(base, targetId)
    local duration = base;
    local augments = gData.ParseAugments();
    duration = ApplySaboteurMultipliers(duration, targetId);
    duration = ApplyEnfeeblingAdditions(duration, augments);
    duration = ApplyEnfeeblingMultipliers(duration, augments);
    return duration;
end

local function CalculateHelixDuration(base)
    local duration = 30;

    local schLevel = 0;
    if gData.GetMainJob() == 20 then
        schLevel = gData.GetMainJobLevel();
    else
        schLevel = gData.GetSubJobLevel();
    end
    
    if schLevel > 59 then
        duration = 90;
    elseif schLevel > 39 then
        duration = 60;
    end
    
    --Dark Arts
    if gData.GetBuffActive(359) or gData.GetBuffActive(402) then
        --No idea here... various suggestions online.  Using rough estimation, accurate at 99.
        if schLevel > 25 then
            local seconds = math.floor(78 * (schLevel / 99));
            if gData.GetBuffActive(377) then
                seconds = seconds * 2;
            end
            duration = duration + seconds;
        end

        if schLevel == 99 then
            duration = duration + (3 * gData.GetJobPoints(20, 3));
        end
    end

    
    local augments = gData.ParseAugments();
    local helixDuration = augments.Generic[0x4E1];
    if helixDuration then
        for _,v in pairs(helixDuration) do
            duration = duration + v + 1;
        end
    end

    return duration;
end

local function FillSpellTable(spellTable)
	--Dia
	spellTable[23] = function(targetId)
		return CalculateEnfeeblingDuration(60, targetId);
	end

	--Dia II
	spellTable[24] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId);
	end

	--Dia III
	spellTable[25] = function(targetId)
		return CalculateEnfeeblingDuration(180, targetId);
	end

	--Diaga
	spellTable[33] = function(targetId)
		return CalculateEnfeeblingDuration(60, targetId);
	end

	--Slow
	spellTable[56] = function(targetId)
		return CalculateEnfeeblingDuration(180, targetId);
	end

	--Paralyze
	spellTable[58] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId);
	end

	--Silence
	spellTable[59] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId);
	end

	--Slow II
	spellTable[79] = function(targetId)
		return CalculateEnfeeblingDuration(180, targetId);
	end

	--Paralyze II
	spellTable[80] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId);
	end

	--Repose
	spellTable[98] = function(targetId)
		return 90;
	end

	--Gravity
	spellTable[216] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId);
	end

	--Gravity II
	spellTable[217] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId);
	end

	--Poison
	spellTable[220] = function(targetId)
		return CalculateEnfeeblingDuration(90, targetId);
	end

	--Poison II
	spellTable[221] = function(targetId)
		return CalculateEnfeeblingDuration(120, targetId);
	end

	--Poisonga
	spellTable[225] = function(targetId)
		return CalculateEnfeeblingDuration(30, targetId);
	end

	--Bio
	spellTable[230] = function(targetId)
		return 60;
	end

	--Bio II
	spellTable[231] = function(targetId)
		return 120;
	end

	--Bio III
	spellTable[232] = function(targetId)
		return 180;
	end

	--Burn
	spellTable[235] = function(targetId)
		return 90;
	end

	--Frost
	spellTable[236] = function(targetId)
		return 90;
	end

	--Choke
	spellTable[237] = function(targetId)
		return 90;
	end

	--Rasp
	spellTable[238] = function(targetId)
		return 90;
	end

	--Shock
	spellTable[239] = function(targetId)
		return 90;
	end

	--Drown
	spellTable[240] = function(targetId)
		return 90;
	end
	--Sleep
	spellTable[253] = function(targetId)
		return CalculateEnfeeblingDuration(60, targetId);
	end

	--Blind
	spellTable[254] = function(targetId)
		return CalculateEnfeeblingDuration(180, targetId);
	end

	--Break
	spellTable[255] = function(targetId)
		return CalculateEnfeeblingDuration(30, targetId);
	end

	--[[UNKNOWN
    --Bind
	spellTable[258] = function(targetId)
		return CalculateEnfeeblingDuration(40, targetId);
	end
    ]]--

	--Sleep II
	spellTable[259] = function(targetId)
		return CalculateEnfeeblingDuration(90, targetId);
	end

	--Sleepga
	spellTable[273] = function(targetId)
		return CalculateEnfeeblingDuration(60, targetId);
	end

	--Sleepga II
	spellTable[274] = function(targetId)
		return CalculateEnfeeblingDuration(90, targetId);
	end
    
	--Blind II
	spellTable[276] = function(targetId)
		return CalculateEnfeeblingDuration(180, targetId);
	end    

    --UNKNOWN
	--Addle
	spellTable[286] = function(targetId)
    -- Stubbed with base duration
		return CalculateEnfeeblingDuration(180, targetId);
	end

	--Geohelix
	spellTable[278] = function(targetId)
		return CalculateHelixDuration();
	end

	--Hydrohelix
	spellTable[279] = function(targetId)
		return CalculateHelixDuration();
	end

	--Anemohelix
	spellTable[280] = function(targetId)
		return CalculateHelixDuration();
	end

	--Pyrohelix
	spellTable[281] = function(targetId)
		return CalculateHelixDuration();
	end

	--Cryohelix
	spellTable[282] = function(targetId)
		return CalculateHelixDuration();
	end

	--Ionohelix
	spellTable[283] = function(targetId)
		return CalculateHelixDuration();
	end

	--Noctohelix
	spellTable[284] = function(targetId)
		return CalculateHelixDuration();
	end

	--Luminohelix
	spellTable[285] = function(targetId)
		return CalculateHelixDuration();
	end

	--Sleepga
	spellTable[363] = function(targetId)
		return CalculateEnfeeblingDuration(60, targetId);
	end

	--Sleepga II
	spellTable[364] = function(targetId)
		return CalculateEnfeeblingDuration(90, targetId);
	end

	--Breakga
	spellTable[365] = function(targetId)
		return CalculateEnfeeblingDuration(30, targetId);
	end
    
	--Kaustra
	spellTable[502] = function(targetId)
        local ticks = 1 + math.floor(gData.GetCombatSkill(37 / 11));
		return ticks * 3;
	end

	--Impact
	spellTable[503] = function(targetId)
		return 180;
	end

	--Distract
	spellTable[841] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId);
	end

	--Distract II
	spellTable[842] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId);
	end

	--Frazzle
	spellTable[843] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId);
	end

	--Frazzle II
	spellTable[844] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId);
	end

    --[[UNKNOWN
	--Addle II
	spellTable[884] = function(targetId)
		return 0;
	end
    ]]--    

	--Inundation
	spellTable[879] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId);
	end

    --Distract III
	spellTable[882] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId);
	end

	--Frazzle III
	spellTable[883] = function(targetId)
		return CalculateEnfeeblingDuration(300, targetId);
	end

	--Geohelix II
	spellTable[885] = function(targetId)
		return CalculateHelixDuration();
	end

	--Hydrohelix II
	spellTable[886] = function(targetId)
		return CalculateHelixDuration();
	end

	--Anemohelix II
	spellTable[887] = function(targetId)
		return CalculateHelixDuration();
	end

	--Pyrohelix II
	spellTable[888] = function(targetId)
		return CalculateHelixDuration();
	end

	--Cryohelix II
	spellTable[889] = function(targetId)
		return CalculateHelixDuration();
	end

	--Ionohelix II
	spellTable[890] = function(targetId)
		return CalculateHelixDuration();
	end

	--Noctohelix II
	spellTable[891] = function(targetId)
		return CalculateHelixDuration();
	end

	--Luminohelix II
	spellTable[892] = function(targetId)
		return CalculateHelixDuration();
	end
end

return FillSpellTable;
