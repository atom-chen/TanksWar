local _M = { }

-- 麻将的ID 需写定
_M.Cfg = 
{
    {id = 1,	name = "涡阳麻将",	icon = "guoyang",	lock = 0,    short = 1},
    {id = 3,	name = "阜阳麻将",	icon = "fuyang",	lock = 0,    short = 1},
}

function _M.GetById(ID)
   for k,v in pairs(_M.Cfg) do
	   if v.id == ID then
          return v
	   end
   end

   return nil
end

function _M.GetGameCount()
	return #_M.Cfg
end

return _M