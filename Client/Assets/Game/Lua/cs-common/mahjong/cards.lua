-- local function print_r ( t )
--     local print_r_cache={}
--         local function sub_print_r(t,indent)
--         if (print_r_cache[tostring(t)]) then
--             print(indent.."*"..tostring(t))
--         else
--             print_r_cache[tostring(t)]=true
--             if (type(t)=="table") then
--                 local tLen = #t
--                 for i = 1, tLen do
--                     local val = t[i]
--                     if (type(val)=="table") then
--                         print(indent.."#["..i.."] => "..tostring(t).." {")
--                         sub_print_r(val,indent..string.rep(" ",string.len(i)+8))
--                         print(indent..string.rep(" ",string.len(i)+6).."}")
--                     elseif (type(val)=="string") then
--                         print(indent.."#["..i..'] => "'..val..'"')
--                     else
--                         print(indent.."#["..i.."] => "..tostring(val))
--                     end
--                 end
--                 for pos,val in pairs(t) do
--                     if type(pos) ~= "number" or math.floor(pos) ~= pos or (pos < 1 or pos > tLen) then
--                         if (type(val)=="table") then
--                             print(indent.."["..pos.."] => "..tostring(t).." {")
--                             sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
--                             print(indent..string.rep(" ",string.len(pos)+6).."}")
--                         elseif (type(val)=="string") then
--                             print(indent.."["..pos..'] => "'..val..'"')
--                         else
--                             print(indent.."["..pos.."] => "..tostring(val))
--                         end
--                     end
--                 end
--             else
--                 print(indent..tostring(t))
--             end
--         end
--     end

--    if (type(t)=="table") then
--         print(tostring(t).." {")
--         sub_print_r(t,"  ")
--         print("}")
--     else
--         sub_print_r(t,"  ")
--     end

--    print()
-- end



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

_M.cardNameDefine = {
	[0x10] = "万",
	[0x20] = "筒",
	[0x30] = "条",
	[0x41] = "东",
	[0x42] = "南",
	[0x43] = "西",
	[0x44] = "北",
	[0x45] = "中",
	[0x46] = "发",
	[0x47] = "白",
	[0x51] = "春",
	[0x52] = "夏",
	[0x53] = "秋",
	[0x54] = "冬",
	[0x55] = "梅",
	[0x56] = "兰",
	[0x57] = "竹",
	[0x58] = "菊",
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

	--------------------- mock , 每行为一个人，多的都变成底牌 ----------------
	line = {
		0x11, 0x11, 0x11, 0x12, 0x12, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x22, 0x19,
		0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x19, 0x15, 0x15, 0x15,
		0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x21, 0x22, 0x23, 0x25,
		0x21, 0x22, 0x23, 0x24, 0x25, 0x36, 0x37, 0x38, 0x39, 0x31, 0x32, 0x33, 0x35,
		0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x21, 0x22, 0x23, 0x25, 0x21, 0x22, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x21, 0x22, 0x23, 0x25
	}

	local palyerNum = #playerUserIds
	local data = {
		line = line,
		lineIndex = 0,
		cards = { hand = {}, chi = {}, peng = {}, an = {}, jie = {}, gong = {}, used = {}, hu = {}, zimo = {}}
	}

	for i=1, palyerNum do
		local len = i == 1 and 14 or 13
		data.cards.hand[playerUserIds[i]] = {}
		data.cards.chi[playerUserIds[i]] = {}
		data.cards.peng[playerUserIds[i]] = {}
		data.cards.an[playerUserIds[i]] = {}
		data.cards.jie[playerUserIds[i]] = {}
		data.cards.gong[playerUserIds[i]] = {}
		data.cards.used[playerUserIds[i]] = {}
		data.cards.hu[playerUserIds[i]] = {}
		data.cards.zimo[playerUserIds[i]] = {}

		for j = data.lineIndex + 1, data.lineIndex + len do
			table.insert(data.cards.hand[playerUserIds[i]], data.line[j])
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


function _M.peng(cid, cards)
	local times = 0
	for _, hcid in ipairs(cards) do
		if hcid == cid then
			times = times + 1
			if times == 2 then
				return true
			end
		end
	end
	return false
end


function _M.gang(cards)
	local timesMap = {}
	local result = {}
	for _, hcid in ipairs(cards) do
		if timesMap[hcid] then
			timesMap[hcid] = timesMap[hcid] + 1
		else
			 timesMap[hcid] = 1
		end
		if timesMap[hcid] == 4 then
			table.insert( result, hcid)
		end
	end
	return result
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

-- @desc 输入3n 张牌， 判断是否满铺
function _M.full(cards)
	if #cards % 3 ~= 0 then
		return false
	end

	if cards[1] == cards[2] and cards[2] == cards[3] then
		if #cards == 3 then
			return true
		end
		local ncards = {}
		for k, v in ipairs(cards) do
			if k > 3 then
				table.insert( ncards, v)
			end
		end
		return _M.full(ncards)
	elseif cards[1] + 1 == cards[2] and cards[2] + 1 == cards[3] then
		if #cards == 3 then
			return true
		end
		local ncards = {}
		for k, v in ipairs(cards) do
			if k > 3 then
				table.insert( ncards, v)
			end
		end
		return _M.full(ncards)
	end

	-- 走到这里，后面的都是只能是下面两种顺子，只是怎么顺的问题， 可能情况如下
	-- 铺里两对：1,2,2,3,3,4
	-- 铺里一对：1,2,3,3,4,5
	local last = 1
	local idxs = {[1] = true}
	local len = 1
	for i = 2, #cards do
		-- print(cards[i], cards[last] + 1, cards[i] == cards[last] + 1)
		if cards[i] == cards[last] + 1 then
			idxs[i] = true
			last = i
			len = len + 1

			if len == 3 then
				local ncards = {}
				for k, v in ipairs(cards) do
					if not idxs[k] then
						table.insert( ncards, v )
					end
				end
				return _M.full(ncards)
			end
		end
	end
	return false
end

function _M.pureHu( cards )
	if #cards == 2 then
		if cards[1] ~= cards[2] then
			return false
		end
	elseif #cards % 3 == 0 then
		if not _M.full(cards) then
			return false
		end
	elseif #cards == 5 or #cards == 8 or #cards == 11 or #cards == 14 then
		-- 顺序取一对，再进行满铺判断
		local pairMatch
		pairMatch = function(j)
			if j > #cards - 1 then
				return false
			end
			for jj = j, #cards do
				-- 当前两张相同的情况
				if cards[jj] == cards[jj + 1] then
					-- 前面两张相同，说明已经测试过了不能胡，直接跳过这两张做为将牌的判断，以提升性能
					if jj == 1 or cards[jj - 1] ~= cards[jj] then
						local tmpCards = {}
						for ii, vv in ipairs(cards) do
							if ii ~= jj and ii ~= jj + 1 then
								table.insert( tmpCards, vv )
							end
						end
						if _M.full(tmpCards) then
							-- 这个只是 return pairMatch 的
							return true
						end
					end
				end
				return pairMatch(jj + 1)
			end
		end
		if not pairMatch(1) then
			return false
		end
	else
		return false
	end
	return true
end

function _M.hu(cards)
	if #cards == 2 then
		return cards[1] == cards[2]
	end

	-- clone array
	local cc = {}
	for i, v in ipairs(cards) do
		cc[i] = v
	end
	table.sort(cc)


	local map = {}
	for _, c in ipairs(cc) do
		local ct = bit.andOp(c, 0xF0)
		if not map[ct] then
			map[ct] = {}
		end
		table.insert(map[ct], c)
	end

	for _, list in pairs(map) do
		if not _M.pureHu(list) then
			return false
		end
	end
	return true
end


return _M
