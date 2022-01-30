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

local enhancingDuration = {
    [22055] = 0.10, --Oranyan
    [22097] = 0.10, --Argute Staff
    [22098] = 0.15, --Pedagogy Staff
    [22099] = 0.20, --Musa
    [23134] = 0.10, --Viti. Tabard +2
    [23469] = 0.15, --Viti. Tabard +3
    [23149] = 0.08, --Peda. Gown +2
    [23484] = 0.12, --Peda. Gown +3
    [27947] = 0.15, --Atrophy Gloves
    [27968] = 0.16, --Atrophy Gloves +1
    [23178] = 0.18, --Atrophy Gloves +2
    [23513] = 0.20, --Atrophy Gloves +3
    [27194] = 0.10, --Futhark Trousers
    [27195] = 0.20, --Futhark Trousers +1
    [23285] = 0.25, --Futhark Trousers +2
    [23620] = 0.30, --Futhark Trousers +3
    [23310] = 0.05, --Theo. Duckbills +2
    [23645] = 0.10, --Theo. Duckbills +31
    [11248] = 0.10, --Estq. Houseaux +1
    [11148] = 0.20, --Estq. Houseaux +2
    [27419] = 0.25, --Leth. Houseaux
    [27420] = 0.30, --Leth. Houseaux +1
    [25824] = 0.20, --Regal Gauntlets
    [26250] = 0.20, --Sucellos's Cape
    [26354] = 0.10, --Embla Sash
    [26419] = 0.10, --Ammurapi Shield
    [26782] = 0.10, --Erilaz Galea
    [26783] = 0.15, --Erilaz Galea +
    [27891] = 0.09, --Shabti Cuirass
    [27892] = 0.10, --Shab. Cuirass +1
    [28034] = 0.05, --Dynasty Mitts
    [16204] = 0.10 --Estoqueur's Cape
};

local perpetuanceDuration = {
    [11223] = 0.25,     --Svnt. Bracers +1
    [11123] = 0.5,      --Svnt. Bracers +2
    [27090] = 0.5,      --Arbatel Bracers
    [27091] = 0.55      --Arbatel Bracers +1
};

local regenDuration = {
    [28092] = 18, --Theo. Pantaloons
    [28113] = 18, --Theo. Pant. +1
    [23243] = 21, --Th. Pantaloons +2
    [23578] = 24, --Th. Pant. +3
    [11206] = 10, --Orison Mitts +1
    [11106] = 18, --Orison Mitts +2
    [27056] = 20, --Ebers Mitts
    [27057] = 22, --Ebers Mitts +1
    [27787] = 20, --Runeist Bandeau
    [27706] = 21, --Rune. Bandeau +1
    [23062] = 24, --Rune. Bandeau +2
    [23397] = 27, --Rune. Bandeau +3
    [26894] = 12, --Telchine Chas.
    [26265] = 15, --Lugh's Cape
    [21175] = 12 --Coeus
};

local refreshReceived = {
    [26323] = 20, --Gishdubar Sash
    [27464] = 15, --Inspirited Boots
    [28316] = 15, --Shabti Sabatons
    [28317] = 21, --Shab. Sabatons +1
    [11575] = 30 --Grapevine Cape
};

local function ApplyEnhancingAdditions(duration, augments)
    if gData.GetMainJob() ~= 5 then
        return duration;
    end

    local mainJobLevel = gData.GetMainJobLevel();    
    if mainJobLevel >= 75 then
        local merits = gData.GetMeritCount(0x910);
        if merits > 0 then
            local multiplier = 6;
            if (augments.Generic[0x54A]) then -- Dls. Gloves variants
                multiplier = 9;
            end
            duration = duration + (merits * multiplier);
        end
    end
    
    if mainJobLevel == 99 then
        local jobPoints = gData.GetJobPoints(5, 9);
        duration = duration + jobPoints;
    end

    return duration;
end

local function ApplyEnhancingMultipliers(duration, augments)
    local enhancingGear = 1.0 + gData.EquipSum(enhancingDuration);
    local enhancingAugments = 1.0 + augments.EnhancingDuration;
    return duration * enhancingGear * enhancingAugments;
end

local function ApplyComposureModifiers(duration, targetId)
    if not gData.GetBuffActive(419) then
        return duration;
    end

    if (targetId == gData.GetPlayerId()) then
        return duration * 3;
    else
        --return duration * GetComposureMod();
        return duration;
    end
end

local function ApplyPerpetuanceModifiers(duration)
    if not gData.GetBuffActive(469) then
        return duration;
    end

    local modifier = 2.0;
    local handModifier = perpetuanceDuration[gData.GetEquipmentTable()[7].Id];
    if handModifier ~= nil then
        modifier = modifier + handModifier;
    end
    return duration * modifier;
end

local function ApplyReceivedModifiers(duration, augments)
    local enhancingReceived = 1.0;

    if gData.GetBuffActive(534) then
        enhancingReceived = 0.5;
        local embolden = augments.Generic[0x174];
        if embolden then            
            for _,v in pairs(embolden) do
                enhancingReceived = enhancingReceived + (0.01 * (v + 1));
            end
        end
    end

    enhancingReceived = enhancingReceived + augments.EnhancingReceived;

    if (gData.GetMainJob() == 22) and (gData.GetMainJobLevel() == 99) then
        local jobPoints = gData.GetJobPointTotal(22);
        if (jobPoints >= 100) then
            enhancingReceived = enhancingReceived + 0.10;
        end
        if (jobPoints >= 1200) then
            enhancingReceived = enhancingReceived + 0.10;
        end
    end

    return duration * enhancingReceived;
end

local function CalculateEnhancingDuration(baseDuration, targetId)
    local duration = baseDuration;
    local augments = gData.ParseAugments();
    if (targetId == gData.GetPlayerId()) then
        duration = ApplyReceivedModifiers(duration, augments);
    end
    duration = ApplyEnhancingAdditions(duration, augments);
    duration = ApplyEnhancingMultipliers(duration, augments);
    duration = ApplyComposureModifiers(duration, targetId);
    duration = ApplyPerpetuanceModifiers(duration);
    return duration;
end

local function CalculateBarelementDuration(targetId)
    local duration = 480;
    local enhancingSkill = gData.GetCombatSkill(34);
    if (enhancingSkill < 240) then
        duration = enhancingSkill * 2;
    end    
    return CalculateEnhancingDuration(duration, targetId);
end

local function CalculateBarstatusDuration(targetId)
    local duration = 480;
    local enhancingSkill = gData.GetCombatSkill(34);
    if (enhancingSkill < 240) then
        duration = enhancingSkill * 2;
    end
    return CalculateEnhancingDuration(duration, targetId);
end

local function CalculateEnspellDuration(targetId)
    return CalculateEnhancingDuration(180, targetId);
end

--Includes boost spells.
local function CalculateGainDuration(targetId)
    return CalculateEnhancingDuration(300, targetId);
end

--Includes all protect(ra) and shell(ra) tiers
local function CalculateProtectDuration(targetId)
    local duration = 1800;
    local augments = gData.ParseAugments();
    if (targetId == gData.GetPlayerId()) then
        duration = ApplyReceivedModifiers(duration, augments);
    end
    duration = ApplyEnhancingAdditions(duration, augments);
    duration = ApplyEnhancingMultipliers(duration, augments);
    duration = ApplyPerpetuanceModifiers(duration);
    return duration;
end

local function CalculateRegenDuration(baseDuration, targetId)    
    local duration = baseDuration;
    local augments = gData.ParseAugments();
    if (targetId == gData.GetPlayerId()) then
        duration = ApplyReceivedModifiers(duration, augments);
    end
    duration = ApplyEnhancingAdditions(duration, augments);
    duration = duration + gData.EquipSum(regenDuration);
    if gData.GetMainJob() == 3 and gData.GetMainJobLevel() == 99 then
        duration = duration + (3 * gData.GetJobPoints(3, 8));
    end
    
    --Light Arts
    if gData.GetBuffActive(358) or gData.GetBuffActive(401) then
        local schLevel = 0;
        if gData.GetMainJob() == 20 then
            schLevel = gData.GetMainJobLevel();
            if schLevel == 99 then
                duration = duration + (3 * gData.GetJobPoints(20, 2));
            end
        else
            schLevel = gData.GetSubJobLevel();
        end

        --Stepwise 25,28,31,34,37,40 = 3,6,9,12,15,18... untested, absolute guesswork
        --https://www.bluegartr.com/threads/109412-Regen-Spells-amp-Light-Arts?p=5067176&viewfull=1#post5067176
        --Not verified for every single level.
        if schLevel > 25 then
            local seconds = math.floor(((schLevel - 22) / 3) * 3);
            if schLevel > 40 then
                seconds = math.floor((schLevel - 1) / 4) * 2;
            end
            if gData.GetBuffActive(377) then
                seconds = seconds * 2;
            end
            duration = duration + seconds;
        end
    end

    duration = ApplyEnhancingMultipliers(duration, augments);
    duration = ApplyComposureModifiers(duration, targetId);
    duration = ApplyPerpetuanceModifiers(duration);
    return duration;
end

local function CalculateRefreshDuration(targetId)
    local duration = 150;
    local augments = gData.ParseAugments();
    if (targetId == gData.GetPlayerId()) then
        duration = ApplyReceivedModifiers(duration, augments);
    end
    duration = ApplyEnhancingAdditions(duration, augments);
    if (targetId == gData.GetPlayerId()) then
        duration = duration + gData.EquipSum(refreshReceived);
    end
    duration = ApplyEnhancingMultipliers(duration, augments);
    duration = ApplyComposureModifiers(duration, targetId);
    duration = ApplyPerpetuanceModifiers(duration);
    return duration;
end

--No perpetuance for spikes because they're dark magic.
local function CalculateSpikesDuration(targetId)
    local duration = 180;
    local augments = gData.ParseAugments();
    if (targetId == gData.GetPlayerId()) then
        duration = ApplyReceivedModifiers(duration, augments);
    end
    duration = ApplyEnhancingAdditions(duration, augments);
    duration = ApplyEnhancingMultipliers(duration, augments);
    duration = ApplyComposureModifiers(duration, targetId);
    return duration;
end

local function CalculateStormDuration(targetId)
    return CalculateEnhancingDuration(180, targetId);
end

local function FillSpellTable(spellTable)
    --Protect
    spellTable[43] = function(targetId)
        return CalculateProtectDuration(targetId);
    end

    --Protect II
    spellTable[44] = function(targetId)
        return CalculateProtectDuration(targetId);
    end

    --Protect III
    spellTable[45] = function(targetId)
        return CalculateProtectDuration(targetId);
    end

    --Protect IV
    spellTable[46] = function(targetId)
        return CalculateProtectDuration(targetId);
    end

    --Protect V
    spellTable[47] = function(targetId)
        return CalculateProtectDuration(targetId);
    end

    --Shell
    spellTable[48] = function(targetId)
        return CalculateProtectDuration(targetId);
    end

    --Shell II
    spellTable[49] = function(targetId)
        return CalculateProtectDuration(targetId);
    end

    --Shell III
    spellTable[50] = function(targetId)
        return CalculateProtectDuration(targetId);
    end

    --Shell IV
    spellTable[51] = function(targetId)
        return CalculateProtectDuration(targetId);
    end

    --Shell V
    spellTable[52] = function(targetId)
        return CalculateProtectDuration(targetId);
    end

    --Blink
    spellTable[53] = function(targetId)
        return CalculateEnhancingDuration(300, targetId);
    end

    --Stoneskin
    spellTable[54] = function(targetId)
        return CalculateEnhancingDuration(300, targetId);
    end

    --Aquaveil
    spellTable[55] = function(targetId)
        local duration = CalculateEnhancingDuration(600, targetId);
        if duration > 1800 then
            return 1800;
        else
            return duration;
        end
    end

    --Haste
    spellTable[57] = function(targetId)
        return CalculateEnhancingDuration(180, targetId);
    end

    --Barfire
    spellTable[60] = function(targetId)
        return CalculateBarelementDuration(targetId);
    end

    --Barblizzard
    spellTable[61] = function(targetId)
        return CalculateBarelementDuration(targetId);
    end

    --Baraero
    spellTable[62] = function(targetId)
        return CalculateBarelementDuration(targetId);
    end

    --Barstone
    spellTable[63] = function(targetId)
        return CalculateBarelementDuration(targetId);
    end

    --Barthunder
    spellTable[64] = function(targetId)
        return CalculateBarelementDuration(targetId);
    end

    --Barwater
    spellTable[65] = function(targetId)
        return CalculateBarelementDuration(targetId);
    end

    --Barfira
    spellTable[66] = function(targetId)
        return CalculateBarelementDuration(targetId);
    end

    --Barblizzara
    spellTable[67] = function(targetId)
        return CalculateBarelementDuration(targetId);
    end

    --Baraera
    spellTable[68] = function(targetId)
        return CalculateBarelementDuration(targetId);
    end

    --Barstonra
    spellTable[69] = function(targetId)
        return CalculateBarelementDuration(targetId);
    end

    --Barthundra
    spellTable[70] = function(targetId)
        return CalculateBarelementDuration(targetId);
    end

    --Barwatera
    spellTable[71] = function(targetId)
        return CalculateBarelementDuration(targetId);
    end

    --Barsleep
    spellTable[72] = function(targetId)
        return CalculateBarstatusDuration(targetId);
    end

    --Barpoison
    spellTable[73] = function(targetId)
        return CalculateBarstatusDuration(targetId);
    end

    --Barparalyze
    spellTable[74] = function(targetId)
        return CalculateBarstatusDuration(targetId);
    end

    --Barblind
    spellTable[75] = function(targetId)
        return CalculateBarstatusDuration(targetId);
    end

    --Barsilence
    spellTable[76] = function(targetId)
        return CalculateBarstatusDuration(targetId);
    end

    --Barpetrify
    spellTable[77] = function(targetId)
        return CalculateBarstatusDuration(targetId);
    end

    --Barvirus
    spellTable[78] = function(targetId)
        return CalculateBarstatusDuration(targetId);
    end

    --Baramnesia
    spellTable[84] = function(targetId)
        return CalculateBarstatusDuration(targetId);
    end

    --Baramnesra
    spellTable[85] = function(targetId)
        return CalculateBarstatusDuration(targetId);
    end

    --Barsleepra
    spellTable[86] = function(targetId)
        return CalculateBarstatusDuration(targetId);
    end

    --Barpoisonra
    spellTable[87] = function(targetId)
        return CalculateBarstatusDuration(targetId);
    end

    --Barparalyzra
    spellTable[88] = function(targetId)
        return CalculateBarstatusDuration(targetId);
    end

    --Barblindra
    spellTable[89] = function(targetId)
        return CalculateBarstatusDuration(targetId);
    end

    --Barsilencera
    spellTable[90] = function(targetId)
        return CalculateBarstatusDuration(targetId);
    end

    --Barpetra
    spellTable[91] = function(targetId)
        return CalculateBarstatusDuration(targetId);
    end

    --Barvira
    spellTable[92] = function(targetId)
        return CalculateBarstatusDuration(targetId);
    end

    --Auspice
    spellTable[96] = function(targetId)
        return CalculateEnhancingDuration(180, targetId);
    end

    --Reprisal
    spellTable[97] = function(targetId)
        return CalculateEnhancingDuration(60, targetId);
    end

    --Sandstorm
    spellTable[99] = function(targetId)
        return CalculateStormDuration(targetId);
    end

    --Enfire
    spellTable[100] = function(targetId)
        return CalculateEnspellDuration(targetId);
    end

    --Enblizzard
    spellTable[101] = function(targetId)
        return CalculateEnspellDuration(targetId);
    end

    --Enaero
    spellTable[102] = function(targetId)
        return CalculateEnspellDuration(targetId);
    end

    --Enstone
    spellTable[103] = function(targetId)
        return CalculateEnspellDuration(targetId);
    end

    --Enthunder
    spellTable[104] = function(targetId)
        return CalculateEnspellDuration(targetId);
    end

    --Enwater
    spellTable[105] = function(targetId)
        return CalculateEnspellDuration(targetId);
    end

    --Phalanx
    spellTable[106] = function(targetId)
        return CalculateEnhancingDuration(180, targetId);
    end

    --Phalanx II
    spellTable[107] = function(targetId)
        return CalculateEnhancingDuration(240, targetId);
    end

    --Regen
    spellTable[108] = function(targetId)
        return CalculateRegenDuration(75, targetId);
    end

    --Refresh
    spellTable[109] = function(targetId)
        return CalculateRefreshDuration(targetId);
    end

    --Regen II
    spellTable[110] = function(targetId)
        return CalculateRegenDuration(60, targetId);
    end

    --Regen III
    spellTable[111] = function(targetId)
        return CalculateRegenDuration(60, targetId);
    end

    --Rainstorm
    spellTable[113] = function(targetId)
        return CalculateStormDuration(targetId);
    end

    --Windstorm
    spellTable[114] = function(targetId)
        return CalculateStormDuration(targetId);
    end

    --Firestorm
    spellTable[115] = function(targetId)
        return CalculateStormDuration(targetId);
    end

    --Hailstorm
    spellTable[116] = function(targetId)
        return CalculateStormDuration(targetId);
    end

    --Thunderstorm
    spellTable[117] = function(targetId)
        return CalculateStormDuration(targetId);
    end

    --Voidstorm
    spellTable[118] = function(targetId)
        return CalculateStormDuration(targetId);
    end

    --Aurorastorm
    spellTable[119] = function(targetId)
        return CalculateStormDuration(targetId);
    end

    --Protectra
    spellTable[125] = function(targetId)
        return CalculateProtectDuration(targetId);
    end

    --Protectra II
    spellTable[126] = function(targetId)
        return CalculateProtectDuration(targetId);
    end

    --Protectra III
    spellTable[127] = function(targetId)
        return CalculateProtectDuration(targetId);
    end

    --Protectra IV
    spellTable[128] = function(targetId)
        return CalculateProtectDuration(targetId);
    end

    --Protectra V
    spellTable[129] = function(targetId)
        return CalculateProtectDuration(targetId);
    end

    --Shellra
    spellTable[130] = function(targetId)
        return CalculateProtectDuration(targetId);
    end

    --Shellra II
    spellTable[131] = function(targetId)
        return CalculateProtectDuration(targetId);
    end

    --Shellra III
    spellTable[132] = function(targetId)
        return CalculateProtectDuration(targetId);
    end

    --Shellra IV
    spellTable[133] = function(targetId)
        return CalculateProtectDuration(targetId);
    end

    --Shellra V
    spellTable[134] = function(targetId)
        return CalculateProtectDuration(targetId);
    end
    
     --Invisible
     spellTable[136] = function(targetId)
        return CalculateEnhancingDuration(300, targetId); --Random variation with guarantee of at least 5 minutes..
     end
 
      --Sneak
     spellTable[137] = function(targetId)
        return CalculateEnhancingDuration(300, targetId); --Random variation with guarantee of at least 5 minutes..
     end
 
      --Deodorize
     spellTable[138] = function(targetId)
        return CalculateEnhancingDuration(300, targetId); --Random variation with guarantee of at least 5 minutes..
     end

    --Blaze Spikes
    spellTable[249] = function(targetId)
        return CalculateSpikesDuration(targetId);
    end

    --Ice Spikes
    spellTable[250] = function(targetId)
        return CalculateSpikesDuration(targetId);
    end

    --Shock Spikes
    spellTable[251] = function(targetId)
        return CalculateSpikesDuration(targetId);
    end

    --Animus Augeo
    spellTable[308] = function(targetId)
        return CalculateEnhancingDuration(180, targetId);
    end

    --Animus Minuo
    spellTable[309] = function(targetId)
        return CalculateEnhancingDuration(180, targetId);
    end

    --Enfire II
    spellTable[312] = function(targetId)
        return CalculateEnspellDuration(targetId);
    end

    --Enblizzard II
    spellTable[313] = function(targetId)
        return CalculateEnspellDuration(targetId);
    end

    --Enaero II
    spellTable[314] = function(targetId)
        return CalculateEnspellDuration(targetId);
    end

    --Enstone II
    spellTable[315] = function(targetId)
        return CalculateEnspellDuration(targetId);
    end

    --Enthunder II
    spellTable[316] = function(targetId)
        return CalculateEnspellDuration(targetId);
    end

    --Enwater II
    spellTable[317] = function(targetId)
        return CalculateEnspellDuration(targetId);
    end

    --Refresh II
    spellTable[473] = function(targetId)
        return CalculateRefreshDuration(targetId);
    end

    --Crusade
    spellTable[476] = function(targetId)
        return CalculateEnhancingDuration(300, targetId);
    end

    --Regen IV
    spellTable[477] = function(targetId)
        return CalculateRegenDuration(60, targetId);
    end

    --Embrava
    spellTable[478] = function(targetId)
        return CalculateEnhancingDuration(90, targetId);
    end

    --Boost-STR
    spellTable[479] = function(targetId)
        return CalculateGainDuration(targetId);
    end

    --Boost-DEX
    spellTable[480] = function(targetId)
        return CalculateGainDuration(targetId);
    end

    --Boost-VIT
    spellTable[481] = function(targetId)
        return CalculateGainDuration(targetId);
    end

    --Boost-AGI
    spellTable[482] = function(targetId)
        return CalculateGainDuration(targetId);
    end

    --Boost-INT
    spellTable[483] = function(targetId)
        return CalculateGainDuration(targetId);
    end

    --Boost-MND
    spellTable[484] = function(targetId)
        return CalculateGainDuration(targetId);
    end

    --Boost-CHR
    spellTable[485] = function(targetId)
        return CalculateGainDuration(targetId);
    end

    --Gain-STR
    spellTable[486] = function(targetId)
        return CalculateGainDuration(targetId);
    end

    --Gain-DEX
    spellTable[487] = function(targetId)
        return CalculateGainDuration(targetId);
    end

    --Gain-VIT
    spellTable[488] = function(targetId)
        return CalculateGainDuration(targetId);
    end

    --Gain-AGI
    spellTable[489] = function(targetId)
        return CalculateGainDuration(targetId);
    end

    --Gain-INT
    spellTable[490] = function(targetId)
        return CalculateGainDuration(targetId);
    end

    --Gain-MND
    spellTable[491] = function(targetId)
        return CalculateGainDuration(targetId);
    end

    --Gain-CHR
    spellTable[492] = function(targetId)
        return CalculateGainDuration(targetId);
    end

    --Temper
    spellTable[493] = function(targetId)
        return CalculateEnhancingDuration(180, targetId);
    end

    --Adloquium
    spellTable[495] = function(targetId)
        return CalculateEnhancingDuration(180, targetId);
    end

    --Regen V
    spellTable[504] = function(targetId)
        return CalculateRegenDuration(60, targetId);
    end

    --Haste II
    spellTable[511] = function(targetId)
        return CalculateEnhancingDuration(180, targetId);
    end

    --Foil
    spellTable[840] = function(targetId)
        return CalculateEnhancingDuration(30, targetId);
    end

    --Flurry
    spellTable[845] = function(targetId)
        return CalculateEnhancingDuration(180, targetId);
    end

    --Flurry II
    spellTable[846] = function(targetId)
        return CalculateEnhancingDuration(180, targetId);
    end

    --Sandstorm II
    spellTable[857] = function(targetId)
        return CalculateStormDuration(targetId);
    end

    --Rainstorm II
    spellTable[858] = function(targetId)
        return CalculateStormDuration(targetId);
    end

    --Windstorm II
    spellTable[859] = function(targetId)
        return CalculateStormDuration(targetId);
    end

    --Firestorm II
    spellTable[860] = function(targetId)
        return CalculateStormDuration(targetId);
    end

    --Hailstorm II
    spellTable[861] = function(targetId)
        return CalculateStormDuration(targetId);
    end

    --Thunderstorm II
    spellTable[862] = function(targetId)
        return CalculateStormDuration(targetId);
    end

    --Voidstorm II
    spellTable[863] = function(targetId)
        return CalculateStormDuration(targetId);
    end

    --Aurorastorm II
    spellTable[864] = function(targetId)
        return CalculateStormDuration(targetId);
    end

    --Refresh III
    spellTable[894] = function(targetId)
        return CalculateRefreshDuration(targetId);
    end

    --Temper II
    spellTable[895] = function(targetId)
        return CalculateEnhancingDuration(180, targetId);
    end
end

return FillSpellTable;
