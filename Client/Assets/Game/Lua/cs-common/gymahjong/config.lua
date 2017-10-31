local _M = {
	round = { 4, 8, 12 },
	-- 房主开房局数所需要要的钻石
	ownerDiamond = {
		[4] = 4,
		[8] = 6,
		[12] = 8
	},
	-- AA开房所需要的钻石数
	aaDiamond = {
		[4] = 1,
		[8] = 2,
		[12] = 3
	},
	rules = {
		{name = "带吃",		key = "chi",	options = {{ name = "带吃", val = 1}, { name = "不带吃", val = 2}}},
		{name = "庄家翻倍",	key = "fanbei",	options = {{ name = "翻倍", val = 1}, { name = "不翻倍", val = 2}}},
	}
}


return _M
