local _M = { }

_M.Cfg = 
{
    {id = 1001,	name = "role_1",	model = "roleModel_1",	icon = "guoyang",	},
    {id = 1002,	name = "role_2",	model = "roleModel_2",	icon = "guoyang",	},
    {id = 1003,	name = "role_3",	model = "roleModel_3",	icon = "guoyang",	},
    {id = 1004,	name = "role_4",	model = "roleModel_4",	icon = "guoyang",	},
    {id = 1005,	name = "role_5",	model = "roleModel_5",	icon = "guoyang",	},
}

function _M.Get(id)
	for i=1, #_M.Cfg do
		if _M.Cfg[i].id == id then
			return _M.Cfg[i]
		end
	end
end


return _M