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

local rollDuration = {
    [11220] = 20, --Nvrch. Gants +1
    [11120] = 40, --Nvrch. Gants +2
    [27084] = 45, --Chasseur's Gants
    [27085] = 50, --Chasseur's Gants +1
    [26038] = 20, --Regal Necklace
    [26262] = 30, --Camulus's Mantle
    [21482] = 20, --Compensator
};

local function CalculateBloodPactDuration(base)
    local skill = gData.GetCombatSkill(38);
    if skill > 300 then
        return base + (skill - 300);
    end
    return base;
end

local function CalculateManeuverDuration()
    --This can be calculated but not necessarily straightforward.
    return 60;
end

local function CalculateCorsairRollDuration()
    local duration = 300;
    local augments = gData.ParseAugments();
    duration = duration + gData.EquipSum(rollDuration);
    duration = duration + augments.PhantomRoll;
    if (gData.GetMainJob() == 17) and (gData.GetMainJobLevel() >= 75) then
        local merits = gData.GetMeritCount(0xC04);
        local multiplier = 20;
        if augments.Generic[0x590] then
            multiplier = 26;
        end
        duration = duration + (merits * multiplier);
        if (gData.GetMainJobLevel() == 99) then
            duration = duration + (gData.GetJobPoints(17, 2) * 2);
        end
    end
    return duration;
end

local function CalculateStepDuration(targetId, abilityId)
    -- Stub Base Duration
    return 60
end

local function FillAbilityTable(abilityTable)
    --Mighty Strikes
    abilityTable[16] = function(targetId)
        local duration = 45;
        if gData.ParseAugments().Generic[0x500] then
            duration = duration + 15;
        end
        return duration;
    end

    --Hundred Fists
    abilityTable[17] = function(targetId)
        local duration = 45;
        if gData.ParseAugments().Generic[0x501] then
            duration = duration + 15;
        end
        return duration;
    end

    --Manafont
    abilityTable[19] = function(targetId)
        local duration = 60;
        if gData.ParseAugments().Generic[0x503] then
            duration = duration + 30;
        end
        return duration;
    end

    --Chainspell
    abilityTable[20] = function(targetId)
        local duration = 60;
        if gData.ParseAugments().Generic[0x504] then
            duration = duration + 20;
        end
        return duration;
    end

    --Perfect Dodge
    abilityTable[21] = function(targetId)
        local duration = 30;
        if gData.ParseAugments().Generic[0x505] then
            duration = duration + 10;
        end
        return duration;
    end

    --Invincible
    abilityTable[22] = function(targetId)
        local duration = 30;
        if gData.ParseAugments().Generic[0x506] then
            duration = duration + 10;
        end
        return duration;
    end

    --Blood Weapon
    abilityTable[23] = function(targetId)
        local duration = 30;
        if gData.ParseAugments().Generic[0x507] then
            duration = duration + 40;
        end
        return duration;
    end

    --Familiar
    abilityTable[24] = function(targetId)
        local duration = 1800;
        if gData.ParseAugments().Generic[0x508] then
            duration = duration + 600;
        end
        return duration;
    end

    --Soul Voice
    abilityTable[25] = function(targetId)
        local duration = 180;
        if gData.ParseAugments().Generic[0x509] then
            duration = duration + 30;
        end
        return duration;
    end

    --Meikyo Shisui
    abilityTable[27] = function(targetId)
        local duration = 30;
        return duration;
    end

    --Spirit Surge
    abilityTable[29] = function(targetId)
        local duration = 60;
        if gData.ParseAugments().Generic[0x50D] then
            duration = duration + 20;
        end
        return duration;
    end

    --Astral Flow
    abilityTable[30] = function(targetId)
        local duration = 180;
        if gData.ParseAugments().Generic[0x50E] then
            duration = duration + 30;
        end
        return duration;
    end

    --Berserk
    abilityTable[31] = function(targetId)
        local additiveModifiers = {
            [10730] = 10, --War. Calligae +2
            [27328] = 15, --Agoge Calligae
            [27329] = 20, --Agoge Calligae +1
            [23331] = 25, --Agoge Calligae +2
            [23666] = 30, --Agoge Calligae +3
            [27807] = 10, --Pummeler's Lorica
            [27828] = 14, --Pumm. Lorica +1
            [23107] = 16, --Pumm. Lorica +2
            [23442] = 18, --Pumm. Lorica +3
            [26246] = 15, --Cichol's Mantle
            [20678] = 15, --Firangi
            [20842] = 15, --Reikiono
            [20845] = 20 --Instigator
        };
        local duration = 180;
        duration = duration + gData.EquipSum(additiveModifiers);
        return duration;
    end

    --Warcry
    abilityTable[32] = function(targetId)
        local additiveModifiers = {
            [15072] = 10, --Warrior's Mask
            [15245] = 10, --War. Mask +1
            [10650] = 20, --War. Mask +2
            [26624] = 25, --Agoge Mask
            [26625] = 30, --Agoge Mask +1
            [23063] = 30, --Agoge Mask +2
            [23398] = 30 --Agoge Mask +3
        };
        local duration = 30;
        duration = duration + gData.EquipSum(additiveModifiers);
        return duration;
    end

    --Defender
    abilityTable[33] = function(targetId)
        return 180;
    end

    --Aggressor
    abilityTable[34] = function(targetId)
        local additiveModifiers = {
            [10670] = 10, --War. Lorica +2
            [26800] = 15, --Agoge Lorica
            [26801] = 20, --Agoge Lorica +1
            [23130] = 25, --Agoge Lorica +2
            [23465] = 30, --Agoge Lorica +3
            [27663] = 10, --Pummeler's Mask
            [27684] = 14, --Pumm. Mask +1
            [23040] = 16, --Pummeler's Mask +2
            [23375] = 18, --Pummeler's Mask +3
            [20845] = 20 --Instigator
        };
        local duration = 180;
        duration = duration + gData.EquipSum(additiveModifiers);
        return duration;
    end

    --Focus
    abilityTable[36] = function(targetId)
        return 30;
    end

    --Dodge
    abilityTable[37] = function(targetId)
        return 30;
    end

    --Boost
    abilityTable[39] = function(targetId)
        --NOTE: This varies with delay and could technically be calculated.  I don't think it's a priority since you can get duration from statustimers/etc.
        return nil;
    end

    --Counterstance
    abilityTable[40] = function(targetId)
        return 300;
    end

    --Flee
    abilityTable[42] = function(targetId)
        local additiveModifiers = {
            [14094] = 15, --Rogue's Poulaines
            [15357] = 15, --Rog. Poulaines +1
            [28228] = 15, --Pillager's Poulaines
            [28249] = 16, --Pill. Poulaines +1
            [23313] = 17, --Pill. Poulaines +2
            [23648] = 18 --Pill. Poulaines +3
        };
        local duration = 30;
        duration = duration + gData.EquipSum(additiveModifiers);
        return duration;
    end

    --Hide
    abilityTable[43] = function(targetId)
        --NOTE: No available data on how this is calculated, and it varies.
        return nil;
    end

    --Sneak Attack
    abilityTable[44] = function(targetId)
        return 60;
    end

    --Holy Circle
    abilityTable[47] = function(targetId)
        local multipliers = {
            [14095] = 0.5, --Gallant Leggings
            [15358] = 0.5, --Glt. Leggings +1
            [28229] = 0.5, --Rev. Leggings
            [28250] = 0.5, --Rev. Leggings +1
            [23314] = 0.5, --Rev. Leggings +2
            [23649] = 0.5 --Rev. Leggings +3
        };
        local duration = 180;
        duration = duration * (1.0 + gData.EquipSum(multipliers));
        return duration;
    end

    --Sentinel
    abilityTable[48] = function(targetId)
        local duration = 30;
        local augments = gData.ParseAugments();
        if gData.GetMainJob() == 7 and gData.GetMainJobLevel() >= 75 then
            local merits = gData.GetMeritCount(0x986);
            if merits > 0 and augments.Generic[0x557] then
                duration = duration + (2 * merits);
            end
        end
        return duration;
    end

    --Souleater
    abilityTable[49] = function(targetId)
        return 60;
    end

    --Arcane Circle
    abilityTable[50] = function(targetId)
        local multipliers = {
            [14096] = 0.5, --Chaos Sollerets
            [15359] = 0.5, --Chs. Sollerets +1
            [28230] = 0.5, --Igno. Sollerets
            [28251] = 0.5, --Igno. Sollerets +1
            [23315] = 0.5, --Ig. Sollerets +2
            [23650] = 0.5 --Ig. Sollerets +3
        };
        local duration = 180;
        duration = duration * (1.0 + gData.EquipSum(multipliers));
        return duration;
    end

    --Last Resort
    abilityTable[51] = function(targetId)
        local additiveModifiers = {
            [26253] = 15 --Ankou's Mantle
        };
        local duration = 180;
        duration = duration + gData.EquipSum(additiveModifiers);
        return duration;
    end

    --Shadowbind
    abilityTable[57] = function(targetId)
        local additiveModifiers = {
            [13971] = 10, --Hunter's Bracers
            [14900] = 10, --Htr. Bracers +1
            [27953] = 10, --Orion Bracers
            [27974] = 12, --Orion Bracers +1
            [23184] = 14, --Orion Bracers +2
            [23519] = 16 --Orion Bracers +3
        };
        local duration = 30;
        duration = duration + gData.EquipSum(additiveModifiers);
        if gData.GetMainJob() == 11 and gData.GetMainJobLevel() == 99 then
            duration = duration + gData.GetJobPoints(11, 5);
        end
        return duration;
    end

    --Camouflage
    abilityTable[58] = function(targetId)
        return nil;
    end

    --Sharpshot
    abilityTable[59] = function(targetId)
        return 60;
    end

    --Barrage
    abilityTable[60] = function(targetId)
        return 60;
    end

    --Third Eye
    abilityTable[62] = function(targetId)
        return 30;
    end

    --Meditate
    abilityTable[63] = function(targetId)
        local additiveModifiers = {
            [15113] = 4, --Saotome Kote
            [14920] = 4, --Saotome Kote +1
            [10701] = 8, --Sao. Kote +2
            [26998] = 8, --Sakonji Kote
            [26999] = 8, --Sakonji Kote +1
            [23208] = 8, --Sakonji Kote +2
            [23543] = 12, --Sakonji Kote +3
            [26257] = 8, --Smertrios's Mantle
            [21979] = 4 --Gekkei
        };
        local duration = 15;
        local augments = gData.ParseAugments().Generic[0x4F0];
        if augments then
            for _,v in pairs(augments) do
                duration = duration + (v + 1);
            end
        end
        duration = duration + gData.EquipSum(additiveModifiers);
        return nil;
    end

    --Warding Circle
    abilityTable[64] = function(targetId)
        local multipliers = {
            [13868] = 0.5, --Myochin Kabuto
            [15236] = 0.5, --Myn. Kabuto +1
            [27674] = 0.5, --Wakido Kabuto
            [27695] = 0.5, --Wakido Kabuto +1
            [23051] = 0.5, --Wakido Kabuto +2
            [23386] = 0.5 --Wakido Kabuto +3
        };
        local duration = 180;
        duration = duration * (1.0 + gData.EquipSum(multipliers));
        return duration;
    end

    --Ancient Circle
    abilityTable[65] = function(targetId)
        local multipliers = {
            [14227] = 0.5, --Drachen Brais
            [15574] = 0.5, --Drn. Brais +1
            [28103] = 0.5, --Vishap Brais
            [28124] = 0.5, --Vishap Brais +1
            [23254] = 0.5, --Vishap Brais +2
            [23589] = 0.5 --Vishap Brais +3
        };
        local duration = 180;
        duration = duration * (1.0 + gData.EquipSum(multipliers));
        return duration;
    end

    --Divine Seal
    abilityTable[74] = function(targetId)
        return 60;
    end

    --Elemental Seal
    abilityTable[75] = function(targetId)
        return 60;
    end

    --Trick Attack
    abilityTable[76] = function(targetId)
        return 60;
    end

    --Reward
    abilityTable[78] = function(targetId)
        return 180;
    end

    --Cover
    abilityTable[79] = function(targetId)
        local additiveModifiers = {
            [12515] = 5, --Gallant Coronet
            [15231] = 5, --Gallant Coronet +1
            [27669] = 7, --Rev. Coronet
            [27690] = 9, --Rev. Coronet +1
            [23046] = 9, --Rev. Coronet +2
            [23381] = 10, --Rev. Coronet +3
            [16604] = 5, --Save The Queen
            [21641] = 30, --Save The Queen III
            [20728] = 8 --Kheshig Blade
        };
        local duration = 15;
        duration = duration + gData.EquipSum(additiveModifiers);
        return duration;
    end

    --Chi Blast
    abilityTable[82] = function(targetId)
        if gData.GetMainJob() == 2 and gData.GetMainJobLevel() >= 75 then
            local penanceMerits = gData.GetMeritCount(0x846);
            if penanceMerits > 0 then
                return penanceMerits * 20;
            end
        end
        return nil;
    end

    --Unlimited Shot
    abilityTable[86] = function(targetId)
        return 60;
    end

    --Rampart
    abilityTable[92] = function(targetId)
        local additiveModifiers = {
            [15078] = 15, --Valor Coronet
            [15251] = 15, --Vlr. Coronet +1
            [10656] = 30, --Vlr. Coronet +2
            [26636] = 30, --Cab. Coronet
            [26637] = 30, --Cab. Coronet +1
            [23069] = 30, --Cab. Coronet +2
            [23404] = 30 --Cab. Coronet +3
        };
        local duration = 30;
        duration = duration + gData.EquipSum(additiveModifiers);
        return duration;
    end

    --Azure Lore
    abilityTable[93] = function(targetId)
        local duration = 30;
        if gData.ParseAugments().Generic[0x50F] then
            duration = duration + 10;
        end
        return duration;
    end

    --Chain Affinity
    abilityTable[94] = function(targetId)
        return 30;
    end

    --Burst Affinity
    abilityTable[95] = function(targetId)
        return 30;
    end

    --Fighter's Roll
    abilityTable[98] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Monk's Roll
    abilityTable[99] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Healer's Roll
    abilityTable[100] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Wizard's Roll
    abilityTable[101] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Warlock's Roll
    abilityTable[102] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Rogue's Roll
    abilityTable[103] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Gallant's Roll
    abilityTable[104] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Chaos Roll
    abilityTable[105] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Beast Roll
    abilityTable[106] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Choral Roll
    abilityTable[107] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Hunter's Roll
    abilityTable[108] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Samurai Roll
    abilityTable[109] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Ninja Roll
    abilityTable[110] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Drachen Roll
    abilityTable[111] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Evoker's Roll
    abilityTable[112] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Magus's Roll
    abilityTable[113] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Corsair's Roll
    abilityTable[114] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Puppet Roll
    abilityTable[115] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Dancer's Roll
    abilityTable[116] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Scholar's Roll
    abilityTable[117] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Bolter's Roll
    abilityTable[118] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Caster's Roll
    abilityTable[119] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Courser's Roll
    abilityTable[120] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Blitzer's Roll
    abilityTable[121] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Tactician's Roll
    abilityTable[122] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Light Shot
    abilityTable[131] = function(targetId)
        return 60;
    end

    --Overdrive
    abilityTable[135] = function(targetId)
        local duration = 180;
        if gData.ParseAugments().Generic[0x511] then
            duration = duration + 20;
        end
        return duration;
    end

    --Activate
    abilityTable[136] = function(targetId)
        return nil;
    end

    --Repair
    abilityTable[137] = function(targetId)
        local oilDuration = {
            [18731] = 15, --Automaton Oil
            [18732] = 30, --Automat. Oil +1
            [18733] = 45, --Automat. Oil +2
            [19185] = 60 --Automat. Oil +3
        };
        local oil = gData.GetEquipmentTable()[4].Id;
        return oilDuration[oil]; --This is nil if no oil because we can't calculate a duration.
    end
    
    --Fire Maneuver
    abilityTable[141] = function(targetId)
        return CalculateManeuverDuration();
    end

    --Ice Maneuver
    abilityTable[142] = function(targetId)
        return CalculateManeuverDuration();
    end

    --Wind Maneuver
    abilityTable[143] = function(targetId)
        return CalculateManeuverDuration();
    end

    --Earth Maneuver
    abilityTable[144] = function(targetId)
        return CalculateManeuverDuration();
    end

    --Thunder Maneuver
    abilityTable[145] = function(targetId)
        return CalculateManeuverDuration();
    end

    --Water Maneuver
    abilityTable[146] = function(targetId)
        return CalculateManeuverDuration();
    end

    --Light Maneuver
    abilityTable[147] = function(targetId)
        return CalculateManeuverDuration();
    end

    --Dark Maneuver
    abilityTable[148] = function(targetId)
        return CalculateManeuverDuration();
    end

    --Warrior's Charge
    abilityTable[149] = function(targetId)
        return 60;
    end

    --Tomahawk
    abilityTable[150] = function(targetId)
        local duration = 15 + (15 * gData.GetMeritCount(0x802));
        return duration;
    end

    --Mantra
    abilityTable[151] = function(targetId)
        return 180;
    end

    --Formless Strikes
    abilityTable[152] = function(targetId)
        local duration = 180;
        if gData.ParseAugments().Generic[0x537] then
            duration = duration + (6 * gData.GetMeritCount(0x842));
        end
        return duration;
    end

    --Assassin's Charge
    abilityTable[155] = function(targetId)
        return 60;
    end

    --Feint
    abilityTable[156] = function(targetId)
        return 60;
    end

    --Fealty
    abilityTable[157] = function(targetId)
        local duration = 60;
        if gData.ParseAugments().Generic[0x555] then
            duration = duration + (4 * gData.GetMeritCount(0x980));
        end
        return duration;
    end

    --Dark Seal
    abilityTable[159] = function(targetId)
        return 60;
    end

    --Diabolic Eye
    abilityTable[160] = function(targetId)
        local duration = 180;
        if gData.ParseAugments().Generic[0x55B] then
            duration = duration + (6 * gData.GetMeritCount(0x9C2));
        end
        return duration;
    end

    --Killer Instinct
    abilityTable[162] = function(targetId)
        local duration = 170;
        local meritCount = gData.GetMeritCount(0xA02);
        duration = duration + (10 * meritCount);
        if gData.ParseAugments().Generic[0x560] then
            duration = duration + (4 * meritCount);
        end
        return duration;
    end

    --Nightingale
    abilityTable[163] = function(targetId)
        local duration = 60;
        if gData.ParseAugments().Generic[0x569] then
            duration = duration + (4 * gData.GetMeritCount(0xA40));
        end
        return duration;
    end

    --Troubadour
    abilityTable[164] = function(targetId)
        local duration = 60;
        if gData.ParseAugments().Generic[0x567] then
            duration = duration + (4 * gData.GetMeritCount(0xA42));
        end
        return duration;
    end

    --Stealth Shot
    abilityTable[165] = function(targetId)
        return 60;
    end

    --Flashy Shot
    abilityTable[166] = function(targetId)
        return 60;
    end

    --Deep Breathing
    abilityTable[169] = function(targetId)
        return 180;
    end

    --Angon
    abilityTable[170] = function(targetId)
        local duration = 15 + (15 * gData.GetMeritCount(0xB42));
        return duration;
    end

    --Sange
    abilityTable[171] = function(targetId)
        return 60;
    end

    --Hasso
    abilityTable[173] = function(targetId)
        return 300;
    end

    --Seigan
    abilityTable[174] = function(targetId)
        return 300;
    end

    --Convergence
    abilityTable[175] = function(targetId)
        return 60;
    end

    --Diffusion
    abilityTable[176] = function(targetId)
        return 60;
    end

    --Snake Eye
    abilityTable[177] = function(targetId)
        return 60;
    end

    --Trance
    abilityTable[181] = function(targetId)
        local duration = 60;
        if gData.ParseAugments().Generic[0x512] then
            duration = duration + 20;
        end
        return duration;
    end

    --Drain Samba
    abilityTable[184] = function(targetId)        
        local duration = 120;
        if gData.GetMainJob() == 19 and gData.GetMainJobLevel() == 99 then
            duration = duration + (2 * gData.GetJobPoints(19, 3));
        end
        return duration;
    end

    --Drain Samba II
    abilityTable[185] = function(targetId) 
        local duration = 90;
        if gData.GetMainJob() == 19 and gData.GetMainJobLevel() == 99 then
            duration = duration + (2 * gData.GetJobPoints(19, 3));
        end
        return duration;
    end

    --Drain Samba III
    abilityTable[186] = function(targetId) 
        local duration = 90;
        if gData.GetMainJob() == 19 and gData.GetMainJobLevel() == 99 then
            duration = duration + (2 * gData.GetJobPoints(19, 3));
        end
        return duration;
    end

    --Aspir Samba
    abilityTable[187] = function(targetId) 
        local duration = 120;
        if gData.GetMainJob() == 19 and gData.GetMainJobLevel() == 99 then
            duration = duration + (2 * gData.GetJobPoints(19, 3));
        end
        return duration;
    end

    --Aspir Samba II
    abilityTable[188] = function(targetId) 
        local duration = 120;
        if gData.GetMainJob() == 19 and gData.GetMainJobLevel() == 99 then
            duration = duration + (2 * gData.GetJobPoints(19, 3));
        end
        return duration;
    end

    --Haste Samba
    abilityTable[189] = function(targetId) 
        local duration = 90;
        if gData.GetMainJob() == 19 and gData.GetMainJobLevel() == 99 then
            duration = duration + (2 * gData.GetJobPoints(19, 3));
        end
        return duration;
    end

    --Spectral Jig
    abilityTable[196] = function(targetId)
        local multipliers = {
            [15747] = 0.35, --Dancer's Shoes(female)
            [11394] = 0.35, --Dancer's Shoes +1(female)
            [28242] = 0.4, --Maxixi Shoes(female)
            [28263] = 0.4, --Maxixi Shoes +1(female)
            [23327] = 0.45, --Maxixi Toe Shoes +2(female)
            [23662] = 0.5, --Maxixi Toe Shoes +3(female)            
            [15746] = 0.35, --Dancer's Shoes(male)
            [11393] = 0.35, --Dancer's Shoes +1(male)
            [28241] = 0.4, --Maxixi Shoes(male)
            [28262] = 0.4, --Maxixi Shoes +1(male)
            [23326] = 0.45, --Maxixi Toe Shoes +2(male)
            [23661] = 0.5, --Maxixi Toe Shoes +3(male)
            [16360] = 0.35, --Etoile Tights
            [16361] = 0.35, --Etoile Tights +1
            [10728] = 0.35, --Etoile Tights +2
            [27188] = 0.4, --Horos Tights
            [27189] = 0.45, --Horos Tights +1
            [23282] = 0.5, --Horos Tights +2
            [23617] = 0.5 --Horos Tights +3
        };
        local duration = 180;
        duration = duration * (1 + gData.EquipSum(multipliers));
        return duration;
    end

    --Chocobo Jig
    abilityTable[197] = function(targetId)
        local multipliers = {
            [15747] = 0.35, --Dancer's Shoes(female)
            [11394] = 0.35, --Dancer's Shoes +1(female)
            [28242] = 0.4, --Maxixi Shoes(female)
            [28263] = 0.4, --Maxixi Shoes +1(female)
            [23327] = 0.45, --Maxixi Toe Shoes +2(female)
            [23662] = 0.5, --Maxixi Toe Shoes +3(female)            
            [15746] = 0.35, --Dancer's Shoes(male)
            [11393] = 0.35, --Dancer's Shoes +1(male)
            [28241] = 0.4, --Maxixi Shoes(male)
            [28262] = 0.4, --Maxixi Shoes +1(male)
            [23326] = 0.45, --Maxixi Toe Shoes +2(male)
            [23661] = 0.5, --Maxixi Toe Shoes +3(male)
            [16360] = 0.35, --Etoile Tights
            [16361] = 0.35, --Etoile Tights +1
            [10728] = 0.35, --Etoile Tights +2
            [27188] = 0.4, --Horos Tights
            [27189] = 0.45, --Horos Tights +1
            [23282] = 0.5, --Horos Tights +2
            [23617] = 0.5 --Horos Tights +3
        };
        local duration = 120;
        duration = duration * (1 + gData.EquipSum(multipliers));
        return duration;
    end
    
    --Quickstep
    abilityTable[201] = function(targetId)
        return CalculateStepDuration(targetId, 201);
    end

    --Box Step
    abilityTable[202] = function(targetId)
        return CalculateStepDuration(targetId, 202);
    end

    --Stutter Step
    abilityTable[203] = function(targetId)
        return CalculateStepDuration(targetId, 203);
    end

    --Deperate Flourish
    abilityTable[205] = function(targetId)
        return 120; -- FIXME: Stub duration
    end

    --Building Flourish
    abilityTable[208] = function(targetId)
        return 60;
    end

    --Tabula Rasa
    abilityTable[210] = function(targetId)
        local duration = 180;
        if gData.ParseAugments().Generic[0x513] then
            duration = duration + 30;
        end
        return duration;
    end

    --Light Arts
    abilityTable[211] = function(targetId)
        return 7200;
    end

    --Dark Arts
    abilityTable[212] = function(targetId)
        return 7200;
    end

    --Penury
    abilityTable[215] = function(targetId)
        return 60;
    end

    --Celerity
    abilityTable[216] = function(targetId)
        return 60;
    end

    --Rapture
    abilityTable[217] = function(targetId)
        return 60;
    end

    --Accession
    abilityTable[218] = function(targetId)
        return 60;
    end

    --Parsimony
    abilityTable[219] = function(targetId)
        return 60;
    end

    --Alacrity
    abilityTable[220] = function(targetId)
        return 60;
    end

    --Ebullience
    abilityTable[221] = function(targetId)
        return 60;
    end

    --Manifestation
    abilityTable[222] = function(targetId)
        return 60;
    end

    --Velocity Shot
    abilityTable[224] = function(targetId)
        return 7200;
    end

    --Retaliation
    abilityTable[226] = function(targetId)
        return 180;
    end

    --Footwork
    abilityTable[227] = function(targetId)
        return 60;
    end

    --Pianissimo
    abilityTable[229] = function(targetId)
        return 60;
    end

    --Sekkanoki
    abilityTable[230] = function(targetId)
        return 60;
    end

    --Sublimation
    abilityTable[233] = function(targetId)
        return 7200;
    end

    --Addendum: White
    abilityTable[234] = function(targetId)
        return 7200;
    end

    --Addendum: Black
    abilityTable[235] = function(targetId)
        return 7200;
    end

    --Saber Dance
    abilityTable[237] = function(targetId)
        return 300;
    end

    --Fan Dance
    abilityTable[238] = function(targetId)
        return 300;
    end

    --No Foot Rise
    abilityTable[239] = function(targetId)
        return nil;
    end

    --Altruism
    abilityTable[240] = function(targetId)
        return 60;
    end

    --Focalization
    abilityTable[241] = function(targetId)
        return 60;
    end

    --Tranquility
    abilityTable[242] = function(targetId)
        return 60;
    end

    --Equanimity
    abilityTable[243] = function(targetId)
        return 60;
    end

    --Enlightenment
    abilityTable[244] = function(targetId)
        return 60;
    end

    --Afflatus Solace
    abilityTable[245] = function(targetId)
        return 7200;
    end

    --Afflatus Misery
    abilityTable[246] = function(targetId)
        return 7200;
    end

    --Composure
    abilityTable[247] = function(targetId)
        return 7200;
    end

    --Yonin
    abilityTable[248] = function(targetId)
        return 300;
    end

    --Innin
    abilityTable[249] = function(targetId)
        return 300;
    end

    --Avatar's Favor
    abilityTable[250] = function(targetId)
        return 7200;
    end

    --Restraint
    abilityTable[252] = function(targetId)
        return 300;
    end

    --Perfect Counter
    abilityTable[253] = function(targetId)
        return 30;
    end

    --Mana Wall
    abilityTable[254] = function(targetId)
        return 300;
    end

    --Divine Emblem
    abilityTable[255] = function(targetId)
        return 60;
    end

    --Nether Void
    abilityTable[256] = function(targetId)
        return 60;
    end

    --Double Shot
    abilityTable[257] = function(targetId)
        return 90;
    end

    --Sengikori
    abilityTable[258] = function(targetId)
        return 60;
    end

    --Futae
    abilityTable[259] = function(targetId)
        return 60;
    end

    --Presto
    abilityTable[261] = function(targetId)
        return 30;
    end

    --Climactic Flourish
    abilityTable[264] = function(targetId)
        return 60;
    end

    --Blood Rage
    abilityTable[267] = function(targetId)
    
        local additiveModifiers = {
            [11184] = 15, --Rvg. Lorica +1
            [11084] = 30, --Rvg. Lorica +2
            [26898] = 32, --Boii Lorica
            [26899] = 34 --Boii Lorica +1            
        };
        local duration = 30;
        duration = duration + gData.EquipSum(additiveModifiers);
        return duration;
    end

    --Impetus
    abilityTable[269] = function(targetId)
        return 180;
    end

    --Divine Caress
    abilityTable[270] = function(targetId)
        return 60;
    end

    --Sacrosanctity
    abilityTable[271] = function(targetId)
        return 60;
    end

    --Manawell
    abilityTable[273] = function(targetId)
        return 60;
    end

    --Saboteur
    abilityTable[274] = function(targetId)
        return 60;
    end

    --Spontaneity
    abilityTable[275] = function(targetId)
        return 60;
    end

    --Conspirator
    abilityTable[276] = function(targetId)
        return 60;
    end

    --Sepulcher
    abilityTable[277] = function(targetId)
        return 180;
    end

    --Palisade
    abilityTable[278] = function(targetId)
        return 60;
    end

    --Arcane Crest
    abilityTable[279] = function(targetId)
        return 180;
    end

    --Scarlet Delirium
    abilityTable[280] = function(targetId)
        return 90;
    end

    --Spur
    abilityTable[281] = function(targetId)
        return 90;
    end

    --Run Wild
    abilityTable[282] = function(targetId)
        local duration = 300;
        if gData.GetMainJob() == 9 and gData.GetMainJobLevel() == 99 then
            duration = duration + (2 * gData.GetJobPoints(9, 8));
        end
        return duration;
    end

    --Tenuto
    abilityTable[283] = function(targetId)
        return 60;
    end

    --Marcato
    abilityTable[284] = function(targetId)
        return 60;
    end

    --Decoy Shot
    abilityTable[286] = function(targetId)
        return 180;
    end

    --Hamanoha
    abilityTable[287] = function(targetId)
        return 180;
    end

    --Hagakure
    abilityTable[288] = function(targetId)
        return 60;
    end

    --Issekigan
    abilityTable[291] = function(targetId)
        return 60;
    end

    --Dragon Breaker
    abilityTable[292] = function(targetId)
        return 180;
    end

    --Soul Jump
    abilityTable[293] = function(targetId)
        return nil;
    end

    --Steady Wing
    abilityTable[295] = function(targetId)
        return 180;
    end

    --Efflux
    abilityTable[297] = function(targetId)
        return 60;
    end

    --Unbridled Learning
    abilityTable[298] = function(targetId)
        return 60;
    end

    --Triple Shot
    abilityTable[301] = function(targetId)
        return 90;
    end

    --Allies' Roll
    abilityTable[302] = function(targetId)
        return nil;
    end

    --Miser's Roll
    abilityTable[303] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Companion's Roll
    abilityTable[304] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Avenger's Roll
    abilityTable[305] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Feather Step
    abilityTable[312] = function(targetId)
        return CalculateStepDuration(targetId, 312);
    end

    --Striking Flourish
    abilityTable[313] = function(targetId)
        return 60;
    end

    --Ternary Flourish
    abilityTable[314] = function(targetId)
        return 60;
    end

    --Perpetuance
    abilityTable[316] = function(targetId)
        return 60;
    end

    --Immanence
    abilityTable[317] = function(targetId)
        return 60;
    end

    --Konzen-ittai
    abilityTable[320] = function(targetId)
        return 60;
    end

    --Bully
    abilityTable[321] = function(targetId)
        return 30;
    end

    --Brazen Rush
    abilityTable[323] = function(targetId)
        return 30;
    end

    --Inner Strength
    abilityTable[324] = function(targetId)
        return 30;
    end

    --Asylum
    abilityTable[325] = function(targetId)
        return 30;
    end

    --Subtle Sorcery
    abilityTable[326] = function(targetId)
        return 60;
    end

    --Stymie
    abilityTable[327] = function(targetId)
        return 60;
    end

    --Intervene
    abilityTable[329] = function(targetId)
        return 30;
    end

    --Soul Enslavement
    abilityTable[330] = function(targetId)
        return 30;
    end

    --Unleash
    abilityTable[331] = function(targetId)
        return 60;
    end

    --Clarion Call
    abilityTable[332] = function(targetId)
        return 180;
    end

    --Overkill
    abilityTable[333] = function(targetId)
        return 60;
    end

    --Yaegasumi
    abilityTable[334] = function(targetId)
        return 45;
    end

    --Mikage
    abilityTable[335] = function(targetId)
        return 45;
    end

    --Fly High
    abilityTable[336] = function(targetId)
        return 30;
    end

    --Astral Conduit
    abilityTable[337] = function(targetId)
        return 30;
    end

    --Unbridled Wisdom
    abilityTable[338] = function(targetId)
        return 60;
    end

    --Cutting Cards
    abilityTable[339] = function(targetId)
        return nil;
    end

    --Heady Artifice
    abilityTable[340] = function(targetId)
        --TODO: Find automaton head to determine length... (maybe pet uses command and can do it that way?)
        return 0;
    end

    --Grand Pas
    abilityTable[341] = function(targetId)
        return 30;
    end

    --Bolster
    abilityTable[343] = function(targetId)
        local duration = 180;
        if gData.ParseAugments().Generic[0x514] then
            duration = 210;
        end
        return duration;
    end

    --Collimated Fervor
    abilityTable[348] = function(targetId)
        return 60;
    end

    --Blaze of Glory
    abilityTable[350] = function(targetId)
        return 60;
    end

    --Dematerialize
    abilityTable[351] = function(targetId)
        local duration = 60;
        if gData.GetMainJob() == 21 and gData.GetMainJobLevel() == 99 then
            duration = duration + gData.GetJobPoints(21, 6);
        end
        return duration;
    end

    --Theurgic Focus
    abilityTable[352] = function(targetId)
        return 60;
    end

    --Concentric Pulse
    abilityTable[353] = function(targetId)
        return nil;
    end

    --Mending Halation
    abilityTable[354] = function(targetId)
        return nil;
    end

    --Radial Arcana
    abilityTable[355] = function(targetId)
        return nil;
    end

    --Elemental Sforzo
    abilityTable[356] = function(targetId)
        local duration = 30;
        if gData.ParseAugments().Generic[0x515] then
            duration = 40;
        end
        return duration;
    end

    --Ignis
    abilityTable[358] = function(targetId)
        return 300;
    end

    --Gelus
    abilityTable[359] = function(targetId)
        return 300;
    end

    --Flabra
    abilityTable[360] = function(targetId)
        return 300;
    end

    --Tellus
    abilityTable[361] = function(targetId)
        return 300;
    end

    --Sulpor
    abilityTable[362] = function(targetId)
        return 300;
    end

    --Unda
    abilityTable[363] = function(targetId)
        return 300;
    end

    --Lux
    abilityTable[364] = function(targetId)
        return 300;
    end

    --Tenebrae
    abilityTable[365] = function(targetId)
        return 300;
    end

    --Vallation
    abilityTable[366] = function(targetId)
        local duration = 120;
        local additiveModifiers = {
            [27927] = 15, --Runeist Coat
            [27850] = 15, --Runeist Coat +1
            [23129] = 17, --Runeist's Coat +2
            [23464] = 19, --Runeist's Coat +3
            [26267] = 15 --Ogma's Cape
        };
        duration = duration + gData.EquipSum(additiveModifiers);
        if gData.GetMainJob() == 22 and gData.GetMainJobLevel() == 99 then
            duration = duration + gData.GetJobPoints(22, 3);
        end
        return duration;
    end

    --Swordplay
    abilityTable[367] = function(targetId)
        return 120;
    end

    --Pflug
    abilityTable[369] = function(targetId)
        return 120;
    end

    --Embolden
    abilityTable[370] = function(targetId)
        return 60;
    end

    --Valiance
    abilityTable[371] = function(targetId)
        local duration = 180;
        local additiveModifiers = {
            [27927] = 15, --Runeist Coat
            [27850] = 15, --Runeist Coat +1
            [23129] = 17, --Runeist's Coat +2
            [23464] = 19, --Runeist's Coat +3
            [26267] = 15 --Ogma's Cape
        };
        duration = duration + gData.EquipSum(additiveModifiers);
        if gData.GetMainJob() == 22 and gData.GetMainJobLevel() == 99 then
            duration = duration + gData.GetJobPoints(22, 3);
        end
        return duration;
    end

    --Gambit
    abilityTable[372] = function(targetId)
        local duration = 60;
        local additiveModifiers = {
            [28067] = 10, --Runeist Mitons
            [27986] = 12, --Runeist Mitons +1
            [23196] = 14, --Runeist's Mitons +2
            [23531] = 16 --Runeist's Mitons +3
        };
        duration = duration + gData.EquipSum(additiveModifiers);
        if gData.GetMainJob() == 22 and gData.GetMainJobLevel() == 99 then
            duration = duration + gData.GetJobPoints(22, 9);
        end
        return duration;
    end

    --Liement
    abilityTable[373] = function(targetId)
        local duration = 10;
        local additiveModifiers = {
            [26842] = 2, --Futhark Coat
            [26843] = 3, --Futhark Coat +1
            [23151] = 4, --Futhark Coat +2
            [23486] = 5, --Futhark Coat +3
            [21698] = 3 --Bidenhander
        };
        duration = duration + gData.EquipSum(additiveModifiers);
        return duration;
    end

    --One for All
    abilityTable[374] = function(targetId)
        local duration = 30;
        if gData.GetMainJob() == 22 and gData.GetMainJobLevel() == 99 then
            duration = duration + gData.GetJobPoints(22, 8);
        end
        return duration;
    end

    --Rayke
    abilityTable[375] = function(targetId)
        local merits = gData.GetMeritCount(0xD82);
        local duration = 27 + (merits * 3);
        if gData.ParseAugments().Generic[0x515] then
            duration = duration + merits;
        end
        return duration;
    end

    --Battuta
    abilityTable[376] = function(targetId)
        return 90;
    end

    --Widened Compass
    abilityTable[377] = function(targetId)
        return 60;
    end

    --Odyllic Subterfuge
    abilityTable[378] = function(targetId)
        return 30;
    end

    --Chocobo Jig II
    abilityTable[381] = function(targetId)
        local multipliers = {
            [15747] = 0.35, --Dancer's Shoes(female)
            [11394] = 0.35, --Dancer's Shoes +1(female)
            [28242] = 0.4, --Maxixi Shoes(female)
            [28263] = 0.4, --Maxixi Shoes +1(female)
            [23327] = 0.45, --Maxixi Toe Shoes +2(female)
            [23662] = 0.5, --Maxixi Toe Shoes +3(female)            
            [15746] = 0.35, --Dancer's Shoes(male)
            [11393] = 0.35, --Dancer's Shoes +1(male)
            [28241] = 0.4, --Maxixi Shoes(male)
            [28262] = 0.4, --Maxixi Shoes +1(male)
            [23326] = 0.45, --Maxixi Toe Shoes +2(male)
            [23661] = 0.5, --Maxixi Toe Shoes +3(male)
            [16360] = 0.35, --Etoile Tights
            [16361] = 0.35, --Etoile Tights +1
            [10728] = 0.35, --Etoile Tights +2
            [27188] = 0.4, --Horos Tights
            [27189] = 0.45, --Horos Tights +1
            [23282] = 0.5, --Horos Tights +2
            [23617] = 0.5 --Horos Tights +3
        };
        local duration = 120;
        duration = duration * (1 + gData.EquipSum(multipliers));
        return duration;
    end

    --Contradance
    abilityTable[384] = function(targetId)
        return 60;
    end

    --Apogee
    abilityTable[385] = function(targetId)
        return 60;
    end

    --Entrust
    abilityTable[386] = function(targetId)
        return 60;
    end

    --Cascade
    abilityTable[388] = function(targetId)
        return 60;
    end

    --Consume Mana
    abilityTable[389] = function(targetId)
        return 60;
    end

    --Naturalist's Roll
    abilityTable[390] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Runeist's Roll
    abilityTable[391] = function(targetId)
        return CalculateCorsairRollDuration();
    end

    --Crooked Cards
    abilityTable[392] = function(targetId)
        return 60;
    end

    --Spirit Bond
    abilityTable[393] = function(targetId)
        return 180;
    end

    --Majesty
    abilityTable[394] = function(targetId)
        return 180;
    end

    --Hover Shot
    abilityTable[395] = function(targetId)
        return 3600;
    end

    --Shining Ruby
    abilityTable[514] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Glittering Ruby
    abilityTable[515] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --[[UNKNOWN
    --Mewing Lullaby
    abilityTable[522] = function(targetId)
        return nil;
    end
    ]]--

    --[[UNKNOWN
    --Eerie Eye
    abilityTable[523] = function(targetId)
        return nil;
    end
    ]]--

    --Reraise II
    abilityTable[526] = function(targetId)
        return 3600;
    end

    --Ecliptic Growl
    abilityTable[532] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Ecliptic Howl
    abilityTable[533] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Heavenward Howl
    abilityTable[538] = function(targetId)
        return CalculateBloodPactDuration(60);
    end

    --Crimson Howl
    abilityTable[548] = function(targetId)
        return CalculateBloodPactDuration(60);
    end

    --Inferno Howl
    abilityTable[553] = function(targetId)
        return CalculateBloodPactDuration(60);
    end

    --Conflag Strike
    abilityTable[554] = function(targetId)
        return 60;
    end

    --[[UNKNOWN
    --Rock Throw
    abilityTable[560] = function(targetId)
        return nil;
    end
    ]]--
    
    --Rock Buster
    abilityTable[562] = function(targetId)
        return 30;
    end

    --[[UNKNOWN
    --Megalith Throw
    abilityTable[563] = function(targetId)
        return nil;
    end
    ]]--

    --Earthen Ward
    abilityTable[564] = function(targetId)
        return 900;
    end

    --Stone IV
    abilityTable[565] = function(targetId)
        return nil;
    end

    --[[UNKNOWN
    --Mountain Buster
    abilityTable[566] = function(targetId)
        return nil;
    end
    ]]--

    --Earthen Armor
    abilityTable[569] = function(targetId)
        return CalculateBloodPactDuration(60);
    end

    --Crag Throw
    abilityTable[570] = function(targetId)
        return 120;
    end

    --[[UNKNOWN
    --Tail Whip
    abilityTable[578] = function(targetId)
        return nil;
    end
    ]]--

    --[[UNKNOWN
    --Slowga
    abilityTable[580] = function(targetId)
        return nil;
    end
    ]]--

    --Tidal Roar
    abilityTable[585] = function(targetId)
        return 90;
    end

    --Soothing Current
    abilityTable[586] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Hastega
    abilityTable[595] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Aerial Armor
    abilityTable[596] = function(targetId)
        return 900;
    end

    --Fleet Wind
    abilityTable[601] = function(targetId)
        return CalculateBloodPactDuration(120);
    end

    --Hastega II
    abilityTable[602] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Frost Armor
    abilityTable[610] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Sleepga
    abilityTable[611] = function(targetId)
        return 90;
    end

    --Diamond Storm
    abilityTable[617] = function(targetId)
        return 180;
    end

    --Crystal Blessing
    abilityTable[618] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Rolling Thunder
    abilityTable[626] = function(targetId)
        return CalculateBloodPactDuration(120);
    end

    --Lightning Armor
    abilityTable[628] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Shock Squall
    abilityTable[633] = function(targetId)
        return 15;
    end

    --Volt Strike
    abilityTable[634] = function(targetId)
        return 15;
    end

    --Nightmare
    abilityTable[658] = function(targetId)
        return 90;
    end
    
    --Noctoshield
    abilityTable[660] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Dream Shroud
    abilityTable[661] = function(targetId)
        return CalculateBloodPactDuration(180);
    end

    --Perfect Defense
    abilityTable[671] = function(targetId)
        return 30 + math.floor(gData.GetCombatSkill(38) / 20);
    end

    --Secretion
    abilityTable[688] = function(targetId)
        return nil;
    end

    --Lamb Chop
    abilityTable[689] = function(targetId)
        return nil;
    end

    --Rage
    abilityTable[690] = function(targetId)
        return nil;
    end

    --Sheep Charge
    abilityTable[691] = function(targetId)
        return nil;
    end

    --Sheep Song
    abilityTable[692] = function(targetId)
        return nil;
    end

    --Bubble Shower
    abilityTable[693] = function(targetId)
        return nil;
    end

    --Bubble Curtain
    abilityTable[694] = function(targetId)
        return nil;
    end

    --Big Scissors
    abilityTable[695] = function(targetId)
        return nil;
    end

    --Scissor Guard
    abilityTable[696] = function(targetId)
        return nil;
    end

    --Metallic Body
    abilityTable[697] = function(targetId)
        return nil;
    end

    --Needleshot
    abilityTable[698] = function(targetId)
        return nil;
    end

    --??? Needles
    abilityTable[699] = function(targetId)
        return nil;
    end

    --Frogkick
    abilityTable[700] = function(targetId)
        return nil;
    end

    --Spore
    abilityTable[701] = function(targetId)
        return nil;
    end

    --Queasyshroom
    abilityTable[702] = function(targetId)
        return nil;
    end

    --Numbshroom
    abilityTable[703] = function(targetId)
        return nil;
    end

    --Shakeshroom
    abilityTable[704] = function(targetId)
        return nil;
    end

    --Silence Gas
    abilityTable[705] = function(targetId)
        return nil;
    end

    --Dark Spore
    abilityTable[706] = function(targetId)
        return nil;
    end

    --Power Attack
    abilityTable[707] = function(targetId)
        return nil;
    end

    --Hi-Freq Field
    abilityTable[708] = function(targetId)
        return nil;
    end

    --Rhino Attack
    abilityTable[709] = function(targetId)
        return nil;
    end

    --Rhino Guard
    abilityTable[710] = function(targetId)
        return nil;
    end

    --Spoil
    abilityTable[711] = function(targetId)
        return nil;
    end

    --Cursed Sphere
    abilityTable[712] = function(targetId)
        return nil;
    end

    --Venom
    abilityTable[713] = function(targetId)
        return nil;
    end

    --Sandblast
    abilityTable[714] = function(targetId)
        return nil;
    end

    --Sandpit
    abilityTable[715] = function(targetId)
        return nil;
    end

    --Venom Spray
    abilityTable[716] = function(targetId)
        return nil;
    end

    --Mandibular Bite
    abilityTable[717] = function(targetId)
        return nil;
    end

    --Soporific
    abilityTable[718] = function(targetId)
        return nil;
    end

    --Gloeosuccus
    abilityTable[719] = function(targetId)
        return nil;
    end

    --Palsy Pollen
    abilityTable[720] = function(targetId)
        return nil;
    end

    --Geist Wall
    abilityTable[721] = function(targetId)
        return nil;
    end

    --Numbing Noise
    abilityTable[722] = function(targetId)
        return nil;
    end

    --Nimble Snap
    abilityTable[723] = function(targetId)
        return nil;
    end

    --Cyclotail
    abilityTable[724] = function(targetId)
        return nil;
    end

    --Toxic Spit
    abilityTable[725] = function(targetId)
        return nil;
    end

    --Double Claw
    abilityTable[726] = function(targetId)
        return nil;
    end

    --Grapple
    abilityTable[727] = function(targetId)
        return nil;
    end

    --Spinning Top
    abilityTable[728] = function(targetId)
        return nil;
    end

    --Filamented Hold
    abilityTable[729] = function(targetId)
        return nil;
    end

    --Chaotic Eye
    abilityTable[730] = function(targetId)
        return nil;
    end

    --Blaster
    abilityTable[731] = function(targetId)
        return nil;
    end

    --Suction
    abilityTable[732] = function(targetId)
        return nil;
    end

    --Drainkiss
    abilityTable[733] = function(targetId)
        return nil;
    end

    --Snow Cloud
    abilityTable[734] = function(targetId)
        return nil;
    end

    --Wild Carrot
    abilityTable[735] = function(targetId)
        return nil;
    end

    --Sudden Lunge
    abilityTable[736] = function(targetId)
        return nil;
    end

    --Spiral Spin
    abilityTable[737] = function(targetId)
        return nil;
    end

    --Noisome Powder
    abilityTable[738] = function(targetId)
        return nil;
    end

    --Acid Mist
    abilityTable[740] = function(targetId)
        return nil;
    end

    --TP Drainkiss
    abilityTable[741] = function(targetId)
        return nil;
    end

    --Scythe Tail
    abilityTable[743] = function(targetId)
        return nil;
    end

    --Ripper Fang
    abilityTable[744] = function(targetId)
        return nil;
    end

    --Chomp Rush
    abilityTable[745] = function(targetId)
        return nil;
    end

    --Charged Whisker
    abilityTable[746] = function(targetId)
        return nil;
    end

    --Purulent Ooze
    abilityTable[747] = function(targetId)
        return nil;
    end

    --Corrosive Ooze
    abilityTable[748] = function(targetId)
        return nil;
    end

    --Back Heel
    abilityTable[749] = function(targetId)
        return nil;
    end

    --Jettatura
    abilityTable[750] = function(targetId)
        return nil;
    end

    --Choke Breath
    abilityTable[751] = function(targetId)
        return nil;
    end

    --Fantod
    abilityTable[752] = function(targetId)
        return nil;
    end

    --Tortoise Stomp
    abilityTable[753] = function(targetId)
        return nil;
    end

    --Harden Shell
    abilityTable[754] = function(targetId)
        return nil;
    end

    --Aqua Breath
    abilityTable[755] = function(targetId)
        return nil;
    end

    --Wing Slap
    abilityTable[756] = function(targetId)
        return nil;
    end

    --Beak Lunge
    abilityTable[757] = function(targetId)
        return nil;
    end

    --Intimidate
    abilityTable[758] = function(targetId)
        return nil;
    end

    --Recoil Dive
    abilityTable[759] = function(targetId)
        return nil;
    end

    --Water Wall
    abilityTable[760] = function(targetId)
        return nil;
    end

    --Sensilla Blades
    abilityTable[761] = function(targetId)
        return nil;
    end

    --Tegmina Buffet
    abilityTable[762] = function(targetId)
        return nil;
    end

    --Molting Plumage
    abilityTable[763] = function(targetId)
        return nil;
    end

    --Swooping Frenzy
    abilityTable[764] = function(targetId)
        return nil;
    end

    --Sweeping Gouge
    abilityTable[765] = function(targetId)
        return nil;
    end

    --Zealous Snort
    abilityTable[766] = function(targetId)
        return nil;
    end

    --Pentapeck
    abilityTable[767] = function(targetId)
        return nil;
    end

    --Tickling Tendrils
    abilityTable[768] = function(targetId)
        return nil;
    end

    --Stink Bomb
    abilityTable[769] = function(targetId)
        return nil;
    end

    --Nectarous Deluge
    abilityTable[770] = function(targetId)
        return nil;
    end

    --Nepenthic Plunge
    abilityTable[771] = function(targetId)
        return nil;
    end

    --Somersault
    abilityTable[772] = function(targetId)
        return nil;
    end

    --Pacifying Ruby
    abilityTable[773] = function(targetId)
        return nil;
    end

    --Foul Waters
    abilityTable[774] = function(targetId)
        return nil;
    end

    --Pestilent Plume
    abilityTable[775] = function(targetId)
        return nil;
    end

    --Pecking Flurry
    abilityTable[776] = function(targetId)
        return nil;
    end

    --Sickle Slash
    abilityTable[777] = function(targetId)
        return nil;
    end

    --Acid Spray
    abilityTable[778] = function(targetId)
        return nil;
    end

    --Spider Web
    abilityTable[779] = function(targetId)
        return nil;
    end

    --Regal Gash
    abilityTable[780] = function(targetId)
        return nil;
    end

    --Infected Leech
    abilityTable[781] = function(targetId)
        return nil;
    end

    --Gloom Spray
    abilityTable[782] = function(targetId)
        return nil;
    end

    --Disembowel
    abilityTable[786] = function(targetId)
        return nil;
    end

    --Extirpating Salvo
    abilityTable[787] = function(targetId)
        return nil;
    end

    --Venom Shower
    abilityTable[788] = function(targetId)
        return nil;
    end

    --Mega Scissors
    abilityTable[789] = function(targetId)
        return nil;
    end

    --Frenzied Rage
    abilityTable[790] = function(targetId)
        return nil;
    end

    --Rhinowrecker
    abilityTable[791] = function(targetId)
        return nil;
    end

    --Fluid Toss
    abilityTable[792] = function(targetId)
        return nil;
    end

    --Fluid Spread
    abilityTable[793] = function(targetId)
        return nil;
    end

    --Digest
    abilityTable[794] = function(targetId)
        return nil;
    end

    --Crossthrash
    abilityTable[795] = function(targetId)
        return nil;
    end

    --Predatory Glare
    abilityTable[796] = function(targetId)
        return nil;
    end

    --Hoof Volley
    abilityTable[797] = function(targetId)
        return nil;
    end

    --Nihility Song
    abilityTable[798] = function(targetId)
        return nil;
    end

    --Clarsach Call
    abilityTable[960] = function(targetId)
        return nil;
    end

    --Welt
    abilityTable[961] = function(targetId)
        return nil;
    end

    --Katabatic Blades
    abilityTable[962] = function(targetId)
        return nil;
    end

    --Lunatic Voice
    abilityTable[963] = function(targetId)
        return nil;
    end

    --Roundhouse
    abilityTable[964] = function(targetId)
        return nil;
    end

    --Chinook
    abilityTable[965] = function(targetId)
        return nil;
    end

    --Bitter Elegy
    abilityTable[966] = function(targetId)
        return nil;
    end

    --Sonic Buffet
    abilityTable[967] = function(targetId)
        return nil;
    end

    --Tornado II
    abilityTable[968] = function(targetId)
        return nil;
    end

    --Wind's Blessing
    abilityTable[969] = function(targetId)
        return nil;
    end

    --Hysteric Assault
    abilityTable[970] = function(targetId)
        return nil;
    end
end

return FillAbilityTable;
