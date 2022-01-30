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

return T{
    [24]  = { name="Dia II", overwrites=T{23,230} },
    [25]  = { name="Dia III", overwrites=T{23,24,230,231} },
    [26]  = { name="Dia IV", overwrites=T{23,24,25,230,231,232} },
    [98]  = { name="Repose", overwrites=T{253} },
    [230] = { name="Bio", overwrites=T{23} },
    [231] = { name="Bio II", overwrites=T{23,24,230} },
    [232] = { name="Bio III", overwrites=T{23,24,25,230,231} },
    [235] = { name="Burn", overwrites=T{236} },
    [236] = { name="Frost", overwrites=T{237} },
    [237] = { name="Choke", overwrites=T{238} },
    [238] = { name="Rasp", overwrites=T{239} },
    [239] = { name="Shock", overwrites=T{240} },
    [240] = { name="Drown", overwrites=T{235} },
    [342] = { name="Jubaku: Ni", overwrites=T{341} },
    [343] = { name="Jubaku: San", overwrites=T{341,342} },
    [345] = { name="Hojo: Ni", overwrites=T{344} },
    [346] = { name="Hojo: San", overwrites=T{344,345} },
    [348] = { name="Kurayami: Ni", overwrites=T{347} },
    [349] = { name="Kurayami: San", overwrites=T{347,348} },
    [351] = { name="Dokumori: Ni", overwrites=T{350} },
    [352] = { name="Dokumori: San", overwrites=T{350,351} },
    [369] = { name="Foe Requiem II", overwrites=T{368} },
    [370] = { name="Foe Requiem III", overwrites=T{368,369} },
    [371] = { name="Foe Requiem IV", overwrites=T{368,369,370} },
    [372] = { name="Foe Requiem V", overwrites=T{368,369,370,371} },
    [373] = { name="Foe Requiem VI", overwrites=T{368,369,370,371,372} },
    [374] = { name="Foe Requiem VII", overwrites=T{368,369,370,371,372,373} },
    [375] = { name="Foe Requiem VIII", overwrites=T{368,369,370,371,372,373,374} },
    [377] = { name="Horde Lullaby II", overwrites=T{376,463} },
    [422] = { name="Carnage Elegy", overwrites=T{421} },
    [423] = { name="Massacre Elegy", overwrites=T{421,422} },
    [471] = { name="Foe Lullaby II", overwrites=T{376,463} },
    [728] = { name="Tnameebral Crush", overwrites=T{717} },
    [740] = { name="Tourbillion", overwrites=T{717,728} },
    [871] = { name="Fire Thrnameody II", overwrites=T{454,455,456,457,458,459,460,461,872,873,874,875,876,877,878} },
    [872] = { name="Ice Thrnameody II", overwrites=T{454,455,456,457,458,459,460,461,871,873,874,875,876,877,878} },
    [873] = { name="Wind Thrnameody II", overwrites=T{454,455,456,457,458,459,460,461,871,872,874,875,876,877,878} },
    [874] = { name="Earth Thrnameody II", overwrites=T{454,455,456,457,458,459,460,461,871,872,873,875,876,877,878} },
    [875] = { name="Ltng. Thrnameody II", overwrites=T{454,455,456,457,458,459,460,461,871,872,873,874,876,877,878} },
    [876] = { name="Water Thrnameody II", overwrites=T{454,455,456,457,458,459,460,461,871,872,873,874,875,877,878} },
    [877] = { name="Light Thrnameody II", overwrites=T{454,455,456,457,458,459,460,461,871,872,873,874,875,876,878} },
    [878] = { name="Dark Thrnameody II", overwrites=T{454,455,456,457,458,459,460,461,871,872,873,874,875,876,877} },
    [885] = { name="Geohelix II", overwrites=T{278,279,280,281,282,283,284,285} },
    [886] = { name="Hydrohelix II", overwrites=T{278,279,280,281,282,283,284,285} },
    [887] = { name="Anemohelix II", overwrites=T{278,279,280,281,282,283,284,285} },
    [888] = { name="Pyrohelix II", overwrites=T{278,279,280,281,282,283,284,285} },
    [889] = { name="Cryohelix II", overwrites=T{278,279,280,281,282,283,284,285} },
    [890] = { name="Ionohelix II", overwrites=T{278,279,280,281,282,283,284,285} },
    [891] = { name="Noctohelix II", overwrites=T{278,279,280,281,282,283,284,285} },
    [892] = { name="Luminohelix II", overwrites=T{278,279,280,281,282,283,284,285} },
}, {"name", "overwrites"}
