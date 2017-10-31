
local _M = { }

--  游戏类型 ID 必须与 GameCfg id  一致
_M.ruleCfg = 
{
	  {id = 1,	name = "血战", 		shareDesc = "血战", 		icon = "xuezhan",    	ruleType = 1,    serverID="xuezhan" ,     childRuleID={101,102,201,202}  },
	  {id = 2,	name = "红中", 		shareDesc = "红中", 		icon = "hongzhong", 	ruleType = 1,   serverID="hongzhong" ,    childRuleID={}  },
    {id = 101,	name = "点炮胡",    shareDesc = "点炮胡", 		icon = "",          	ruleType = 2,   serverID="2" ,            childRuleID={}  },
    {id = 102,	name = "自摸胡",    shareDesc = "自模胡", 		icon = "", 	            ruleType = 2,   serverID="1" ,            childRuleID={}  },
    {id = 201,	name = "4局", 		shareDesc = "4局", 		    icon = "",           	ruleType = 3,   serverID="3" ,            childRuleID={}  },
    {id = 202,	name = "8局", 		shareDesc = "8局", 		    icon = "",          	ruleType = 3,   serverID="4" ,            childRuleID={}  },
}

function _M.GetById(ID)
	-- body
   for k,v in pairs(ruleCfg) do
	    -- print(k,#v.childRuleID)
	   if v.id==ID then
          return v
	   end
   end
   return nil
   -- log("  GetById   "..ID)
end

return _M

