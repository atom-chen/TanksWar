
local bit =  require "cs-common.bit"
local _M = {}


_M.colorFeature = {
    [0x10] = {min = 0x11, max = 0x19, num = 4, chi = true},
    [0x20] = {min = 0x21, max = 0x29, num = 4, chi = true},
    [0x30] = {min = 0x31, max = 0x39, num = 4, chi = true},
    [0x40] = {min = 0x41, max = 0x47, num = 4, chi = false},
    [0x50] = {min = 0x51, max = 0x58, num = 1, chi = false},
}

_M.cardDefine = {
	0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 	-- 万
	0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 	-- 筒
	0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 	-- 条
	0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 				-- 东、南、西、北、中、发、白
	0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58			-- 春、夏、秋、冬、梅、兰、竹、菊
}


-- @desc 生成牌型， lackTbl 代表不需要生成的牌
function _M.create(lackTbl)
	local lackMap = {}
	if lackTbl and next(lackTbl) then
		for _, cid in ipairs(lackTbl) do
			lackMap[cid] = true
		end
	end

	-- 生成牌
	local cards = {}
	for _, cid in ipairs(_M.cardDefine) do
		if not lackMap[cid] then
			local color = _M.colorFeature[bit.andOp(cid, 0xF0)]
			for i=1, color.num do
				table.insert(cards, cid)
			end
		end
	end

	return cards
end


-- @desc 发牌
function _M.deal(lackTbl, playerUserIds)
	local line = _M.create(lackTbl)

	_M.shuffle(line)

	local palyerNum = #playerUserIds
	local data = {
		line = line,
		lineIndex = 0,
		cards = {}
	}

	for i=1, palyerNum do
		local len = i == 1 and 14 or 13
		data.cards[playerUserIds[i]] = { hand = {} }
		for j = data.lineIndex + 1, data.lineIndex + len do
			table.insert(data.cards[playerUserIds[i]].hand, data.line[j])
		end
		data.lineIndex = data.lineIndex + len
	end
	return data
end


function _M.shuffle(t)
	for i=#t,2,-1 do
        local tmp = t[i]
        local index = math.random(1, i - 1)
        t[i] = t[index]
        t[index] = tmp
    end
end


function _M.peng(cid, handCards)
	local times = 0
	for _, hcid in ipairs(handCards) do
		if hcid == cid then
			times = times + 1
			if times == 2 then
				return true
			end
		end
	end
	return false
end


function _M.gang(cid, handCards)
	local times = 0
	for _, hcid in ipairs(handCards) do
		if hcid == cid then
			times = times + 1
			if times == 2 then
				return true
			end
		end
	end
	return true
end


function _M.chi(cid, handCards)
	local color = _M.colorFeature[bit.andOp(cid, 0xF0)]
	if not color.chi then
		return false
	end

	local mbb, mb, ma, maa;
	for _, hcid in ipairs(handCards) do
		if hcid - 2 == cid then mbb = true end
		if hcid - 1 == cid then mb = true end
		if hcid + 1 == cid then ma = true end
		if hcid + 2 == cid then maa = true end
	end

	if mbb and mb then return true end
	if mb and ma then return true end
	if ma and maa then return true end

	return false
end


-- local myCards = _M.create()

-- _M.shuffle(myCards)

-- for _, cid in ipairs(myCards) do
-- 	print(cid&0x0F)
-- end

return _M