local _M = {
	round = { 4, 8, 12 },
	-- 房主开房局数所需要要的钻石
	ownerDiamond = {
		[4] = 0,
		[8] = 0,
		[12] = 0
	},
	-- AA开房所需要的钻石数
	aaDiamond = {
		[4] = 0,
		[8] = 0,
		[12] = 0
	},
	rules = {
		{name = "带吃",		key = "chi",	options = {{ name = "带吃", val = 1}, { name = "不带吃", val = 2}}},
		{name = "庄家翻倍",	key = "fanbei",	options = {{ name = "翻倍", val = 1}, { name = "不翻倍", val = 2}}},
	}
}


return _M
