local _M = { }

_M.Cfg = 
{
    {id = 1,	name = "oo麻将", 			icon = "notice_1",    url="https://www.baidu.com/"  },
    {id = 2,	name = "xx麻将", 			icon = "notice_2",    url="http://www.qq.com/"  },
	-- {id = 2,	name = "红中", 		    icon = "hongzhong", 	lock     = 1,   short=2     },   
}

function _M.GetCfgCount()
	-- body
	-- log(#GameCfg)
	return #_M.Cfg
end

return _M