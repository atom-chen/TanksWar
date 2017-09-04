
module(..., package.seeall)

 GameCfg = 
{
    {id = 1,	name = "血战", 			icon = "xuezhan",    	lock    = 0,    short=1     },
	{id = 2,	name = "红中", 		    icon = "hongzhong", 	lock     = 1,   short=2     },   
}

function GetById(ID)
	-- body
   for k,v in pairs(GameCfg) do
	   if v.id==ID then
	   	  -- log(v.name)
          return v
	   end
   end
   return nil
   -- log("  GetById   "..ID)
end

function GetGameCount()
	-- body
	-- log(#GameCfg)
	return #GameCfg
end