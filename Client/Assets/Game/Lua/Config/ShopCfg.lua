local _M = { }

--   麻将的ID 需写定
_M.ShopCfg = 
{
    {id = 1,	name = "商品1",    icon = "zuan1",    	pice    = "12",   count = "12"   ,giveDes="多送0%"  },
    {id = 2,	name = "商品2",    icon = "zuan2",    	pice    = "30",   count = "31"   ,giveDes="多送1%"}, 
    {id = 3,	name = "商品3",    icon = "zuan3",    	pice    = "88",   count = "94"    ,giveDes="多送2%" }, 
    {id = 4,	name = "商品4",    icon = "zuan4",    	pice    = "188",   count = "206"  ,giveDes="多送10%" }, 
}

function _M.GetById(ID)
	-- body
   for k,v in pairs(_M.ShopCfg) do
	   if v.id==ID then
	   	  -- log(v.name)
          return v
	   end
   end
   return nil
   -- log("  GetById   "..ID)
end

function _M.GetShopCount()
	-- body
	-- log(#GameCfg)
	return #_M.ShopCfg
end

return _M