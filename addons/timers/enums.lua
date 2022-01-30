--[[
* Ashita - Copyright (c) 2014 - 2017 atom0s [atom0s@live.com]
*
* This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
* To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to
* Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*
* By using Ashita, you agree to the above license and its terms.
*
*      Attribution - You must give appropriate credit, provide a link to the license and indicate if changes were
*                    made. You must do so in any reasonable manner, but not in any way that suggests the licensor
*                    endorses you or your use.
*
*   Non-Commercial - You may not use the material (Ashita) for commercial purposes.
*
*   No-Derivatives - If you remix, transform, or build upon the material (Ashita), you may not distribute the
*                    modified material. You are, however, allowed to submit the modified works back to the original
*                    Ashita project in attempt to have it added to the original project.
*
* You may not apply legal terms or technological measures that legally restrict others
* from doing anything the license permits.
*
* No warranties are given.
]]--

----------------------------------------------------------------------------------------------------
-- Holds various definitions, enumerations, etc. specific to FFXI data.
----------------------------------------------------------------------------------------------------

AbilityType =
{
    General = 0,
    Job = 1,
    Pet = 2,
    Weapon = 3,
    Trait = 4,
    BloodPactRage = 5,
    Corsair = 6,
    CorsairShot = 7,
    BloodPactWard = 8,
    Samba = 9,
    Waltz = 10,
    Step = 11,
    Florish1 = 12,
    Scholar = 13,
    Jig = 14,
    Flourish2 = 15,
    Monster = 16,
    Flourish3 = 17,
    Weaponskill = 18,
    Rune = 19,
    Ward = 20,
    Effusion = 21
};

CraftRank =
{
    Amateur = 0,
    Recruit = 1,
    Initiate = 2,
    Novice = 3,
    Apprentice = 4,
    Journeyman = 5,
    Craftsman = 6,
    Artisan = 7,
    Adept = 8,
    Veteran = 9
};

CombatType =
{
    Magic = 0x1000,
    Combat = 0x2000
};

Containers =
{
    Inventory = 0,
    Safe = 1,
    Storage = 2,
    Temporary = 3,
    Locker = 4,
    Satchel = 5,
    Sack = 6,
    Case = 7,
    Wardrobe = 8,
    Safe2 = 9,
    Wardrobe2 = 10,
    Wardrobe3 = 11,
    Wardrobe4 = 12,
};

EquipmentSlotMask =
{
    None = 0x0000,
    Main = 0x0001,
    Sub = 0x0002,
    Range = 0x0004,
    Ammo = 0x0008,
    Head = 0x0010,
    Body = 0x0020,
    Hands = 0x0040,
    Legs = 0x0080,
    Feet = 0x0100,
    Neck = 0x0200,
    Waist = 0x0400,
    LEar = 0x0800,
    REar = 0x1000,
    LRing = 0x2000,
    RRing = 0x4000,
    Back = 0x8000,

    -- Slot Groups
    Ears = 0x1800,
    Rings = 0x6000,

    -- All Slots
    All = 0xFFFF
};

EquipmentSlots = 
{
    Main = 0,
    Sub = 1,
    Range = 2,
    Ammo = 3,
    Head = 4,
    Body = 5,
    Hands = 6,
    Legs = 7,
    Feet = 8,
    Neck = 9,
    Waist = 10,
    Ear1 = 11,
    Ear2 = 12,
    Ring1 = 13,
    Ring2 = 14,
    Back = 15,
};

ElementColor =
{
    Red = 0,
    Clear = 1,
    Green = 2,
    Yellow = 3,
    Purple = 4,
    Blue = 5,
    White = 6,
    Black = 7
};

ElementType =
{
    Fire = 0,
    Ice = 1,
    Air = 2,
    Earth = 3,
    Thunder = 4,
    Water = 5,
    Light = 6,
    Dark = 7,
    Special = 0x0F,
    Unknown = 0xFF
};

EntityHair =
{
    Hair1A = 0,
    Hair1B = 1,
    Hair2A = 2,
    Hair2B = 3,
    Hair3A = 4,
    Hair3B = 5,
    Hair4A = 6,
    Hair4B = 7,
    Hair5A = 8,
    Hair5B = 9,
    Hair6A = 10,
    Hair6B = 11,
    Hair7A = 12,
    Hair7B = 13,
    Hair8A = 14,
    Hair8B = 15,

    -- Non-Player Hair Styles
    Fomar = 29,
    Mannequin = 30,
};

EntityRace =
{
    Invalid = 0,
    HumeMale = 1,
    HumeFemale = 2,
    ElvaanMale = 3,
    ElvaanFemale = 4,
    TarutaruMale = 5,
    TarutaruFemale = 6,
    Mithra = 7,
    Galka = 8,

    -- Non-PC Races
    MithraChild = 29,
    HumeChildFemale = 30,
    HumeChildMale = 31,
    GoldChocobo = 32,
    BlackChocobo = 33,
    BlueChocobo = 34,
    RedChocobo = 35,
    GreenChocobo = 36
};

EntitySpawnFlags = 
{
    Player = 0x0001,
    Npc = 0x0002,
    PartyMember = 0x0004,
    AllianceMember = 0x0008,
    Monster = 0x0010,
    Object = 0x0020,
    LocalPlayer = 0x0200,
};

EntityType = 
{
    Player = 0,
    Npc1 = 1,
    Npc2 = 2,
    Npc3 = 3,
    Elevator = 4,
    Airship = 5,
};

ItemFlags =
{
    None = 0x0000,
    WallHanging = 0x0001,
    Flag1 = 0x0002,
    Flag2 = 0x0004,
    Flag3 = 0x0008,
    DeliveryInner = 0x0010,
    Inscribable = 0x0020,
    NoAuction = 0x0040,
    Scroll = 0x0080,
    Linkshell = 0x0100,
    CanUse = 0x0200,
    CanTradeNpc = 0x0400,
    CanEquip = 0x0800,
    NoSale = 0x1000,
    NoDelivery = 0x2000,
    NoTrade = 0x4000,
    Rare = 0x8000,
    Exclusive = 0x6040,
    Nothing = 0xF140
};

ItemType =
{
    None = 0x0000,
    Item = 0x0001,
    QuestItem = 0x0002,
    Fish = 0x0003,
    Weapon = 0x0004,
    Armor = 0x0005,
    Linkshell = 0x0006,
    UsableItem = 0x0007,
    Crystal = 0x0008,
    Currency = 0x0009,
    Furnishing = 0x000A,
    Plant = 0x000B,
    Flowerpot = 0x000C,
    PuppetItem = 0x000D,
    Mannequin = 0x000E,
    Book = 0x000F,
    RacingForm = 0x0010,
    BettingSlip = 0x0011,
    SoulPlate = 0x0012,
    Reflector = 0x0013,
    Logs = 0x0014,
    LotteryTicket = 0x0015,
    TabulaM = 0x0016,
    TabulaR = 0x0017,
    Voucher = 0x0018,
    Rune = 0x0019,
    Evolith = 0x001A,
    StorageSlip = 0x001B,
    Type1 = 0x001C
};

JobMask =  
{
    None = 0x00000000,
    WAR = 0x00000002,
    MNK = 0x00000004,
    WHM = 0x00000008,
    BLM = 0x00000010,
    RDM = 0x00000020,
    THF = 0x00000040,
    PLD = 0x00000080,
    DRK = 0x00000100,
    BST = 0x00000200,
    BRD = 0x00000400,
    RNG = 0x00000800,
    SAM = 0x00001000,
    NIN = 0x00002000,
    DRG = 0x00004000,
    SMN = 0x00008000,
    BLU = 0x00010000,
    COR = 0x00020000,
    PUP = 0x00040000,
    DNC = 0x00080000,
    SCH = 0x00100000,
    GEO = 0x00200000,
    RUN = 0x00400000,
    MON = 0x00800000,
    JOB24 = 0x01000000,
    JOB25 = 0x02000000,
    JOB26 = 0x04000000,
    JOB27 = 0x08000000,
    JOB28 = 0x10000000,
    JOB29 = 0x20000000,
    JOB30 = 0x40000000,
    JOB31 = 0x80000000,
    AllJobs = 0x007FFFFE,
};

Jobs =
{
    None = 0,
    Warrior = 1,
    Monk = 2,
    WhiteMage = 3,
    BlackMage = 4,
    RedMage = 5,
    Thief = 6,
    Paladin = 7,
    DarkKnight = 8,
    Beastmaster = 9,
    Bard = 10,
    Ranger = 11,
    Samurai = 12,
    Ninja = 13,
    Dragoon = 14,
    Summoner = 15,
    BlueMage = 16,
    Corsair = 17,
    Puppetmaster = 18,
    Dancer = 19,
    Scholar = 20,
    Geomancer = 21,
    RuneFencer = 22
};

Language =
{
    Default = 0,
    Japanese = 1,
    English = 2,
    French = 3, -- No longer used.
    Deutsch = 4 -- No longer used.
};

LoginStatus =
{
    LoginScreen = 0,
    Loading = 1,
    LoggedIn = 2
};

MagicType =
{
    None = 0,
    WhiteMagic = 1,
    BlackMagic = 2,
    Summon = 3,
    Ninjutsu = 4,
    Song = 5,
    BlueMagic = 6,
    Geomancy = 7,
    Trust = 8
};

MoonPhase =
{
    New = 0,
    WaxingCrescent = 1,
    WaxingCrescent2 = 2,
    FirstQuarter = 3,
    WaxingGibbous = 4, 
    WaxingGibbous2 = 5,
    Full = 6,
    WaningGibbous = 7, 
    WaningGibbous2 = 8,
    LastQuarter = 9,
    WaningCrescent = 10,
    WaningCrescent2 = 11
};

Nation =
{
    SandOria = 0,
    Bastok = 1,
    Windurst = 2
};

PuppetSlot =
{
    None = 0,
    Head = 1,
    Body = 2,
    Attachment = 3
};

RaceMask =
{
    None = 0x0000,
    HumeMale = 0x0002,
    HumeFemale = 0x0004,
    ElvaanMale = 0x0008,
    ElvaanFemale = 0x0010,
    TarutaruMale = 0x0020,
    TarutaruFemale = 0x0040,
    Mithra = 0x0080,
    Galka = 0x0100,
    Hume = 0x0006,
    Elvaan = 0x0018,
    Tarutaru = 0x0060,

    Male = 0x012A,
    Female = 0x00D4,

    All = 0x01FE,
};

SkillTypes =
{
    -- Weapon Skills
    HandToHand = 1,
    Dagger = 2,
    Sword = 3,
    GreatSword = 4,
    Axe = 5,
    GreatAxe = 6,
    Scythe = 7,
    Polarm = 8,
    Katana = 9,
    GreatKatana = 10,
    Club = 11,
    Staff = 12,
    -- Combat Skills
    Archery = 25,
    Marksmanship = 26,
    Throwing = 27,
    Guard = 28,
    Evasion = 29,
    Shield = 30,
    Parry = 31,
    Divine = 32,
    Healing = 33,
    Enhancing = 34,
    Enfeebling = 35,
    Elemental = 36,
    Dark = 37,
    Summoning = 38,
    Ninjutsu = 39,
    Singing = 40,
    String = 41,
    Wind = 42,
    BlueMagic = 43,
    -- Crafting Skills
    Fishing = 48,
    Woodworking = 49,
    Smithing = 50,
    Goldsmithing = 51,
    Clothcraft = 52,
    Leathercraft = 53,
    Bonecraft = 54,
    Alchemy = 55,
    Cooking = 56,
    Synergy = 57,
    ChocoboDigging = 58,
};

TargetType =
{
    None = 0x00,
    Self = 0x01,
    Player = 0x02,
    PartyMember = 0x04,
    AllianceMember = 0x08,
    Npc = 0x10,
    Enemy = 0x20,
    Unknown = 0x40,
    CorpseOnly = 0x80,
    Corpse = 0x9D
};

TreasureStatus =
{
    None = 0,
    Pass = 1,
    Lot = 2
};

WeatherType =
{
    Clear = 0,
    Sunny = 1,
    Cloudy = 2,
    Fog = 3,
    Fire = 4,
    Fire2 = 5,
    Water = 6,
    Water2 = 7,
    Earth = 8,
    Earth2 = 9,
    Wind = 10,
    Wind2 = 11,
    Ice = 12,
    Ice2 = 13,
    Lightning = 14, 
    Lightning2 = 15,
    Light = 16,
    Light2 = 17,
    Dark = 18,
    Dark2 = 19
};

WeekDay =
{
    Firesday = 0,
    Earthsday = 1,
    Watersday = 2,
    Windsday = 3,
    Iceday = 4,
    Lightningday = 5,
    Lightsday = 6,
    Darksday = 7
};