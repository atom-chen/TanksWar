-- RoleCfg.lua
-- Author : Dzq
-- Date : 2017-09-10
-- Last modification : 2017-09-10
-- Desc: 角色配置

_M = {}

_M.BloodType = 
{
	none = 0,
	small = 1,
	big = 2,
	building = 3,
	npc = 4,
}


_M.RolePropType = 
{
    role = 1,
    monster = 2,
    pet = 3,
}

_M.RoleType = 
{
    min = 0,
    hero = 1,
    pet = 2,
    monster = 3,
    boss = 4,
    special = 5,
    box = 6,
    trap = 7,
}

_M.RoleCfg = {
	{id = "1000", name = "", mod = "", propType = false, propValue = false, propDistribute = false, roleType = _M.RoleType.monster, addBuffType = 0, subType = 0, behitRate = 1.0, beiHitFxs = {},	bornBuffs = {}, flags = {}, deadFx = "", skillFile = "", skill = {}, uniqueSkill = ""},
	{id = "1001", name = "", mod = "", propType = false, propValue = false, propDistribute = false, roleType = _M.RoleType.monster, addBuffType = 0, subType = 0, behitRate = 1.0, beiHitFxs = {},	bornBuffs = {}, flags = {}, deadFx = "", skillFile = "", skill = {}, uniqueSkill = ""},
	{id = "1002", name = "", mod = "", propType = false, propValue = false, propDistribute = false, roleType = _M.RoleType.monster, addBuffType = 0, subType = 0, behitRate = 1.0, beiHitFxs = {},	bornBuffs = {}, flags = {}, deadFx = "", skillFile = "", skill = {}, uniqueSkill = ""},
	{id = "1003", name = "", mod = "", propType = false, propValue = false, propDistribute = false, roleType = _M.RoleType.monster, addBuffType = 0, subType = 0, behitRate = 1.0, beiHitFxs = {},	bornBuffs = {}, flags = {}, deadFx = "", skillFile = "", skill = {}, uniqueSkill = ""},
	{id = "1004", name = "", mod = "", propType = false, propValue = false, propDistribute = false, roleType = _M.RoleType.monster, addBuffType = 0, subType = 0, behitRate = 1.0, beiHitFxs = {},	bornBuffs = {}, flags = {}, deadFx = "", skillFile = "", skill = {}, uniqueSkill = ""},
	{id = "1005", name = "", mod = "", propType = false, propValue = false, propDistribute = false, roleType = _M.RoleType.monster, addBuffType = 0, subType = 0, behitRate = 1.0, beiHitFxs = {},	bornBuffs = {}, flags = {}, deadFx = "", skillFile = "", skill = {}, uniqueSkill = ""},
}

_M.RoleIds = function ()
	return 
end

_M.RoleNames = function ()
	
end

_M.Get = function ()
	
end

return _M