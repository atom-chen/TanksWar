
module(..., package.seeall)

--  游戏类型 ID 必须与 GameCfg id  一致
ruleCfg = 
{
	{id = 1,	  name = "血战", 		shareDesc = "血战", 		icon = "xuezhan",    	ruleType = 1,   serverID = "xuezhan",     childRuleID={101,102,201,202}  },
}

function GetById(ID)
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


