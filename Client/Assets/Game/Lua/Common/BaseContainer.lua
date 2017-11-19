-- BaseContainer.lua
-- Author : Dzq
-- Date : 2017-10-10
-- Last modification : 2017-10-10
-- Desc: BaseContainer 牌容器基类
BaseContainer = Class();
  
function BaseContainer:Ctor(go)
	if go == nil or go == "null" then
		util.LogError("创建失败 go 为空")
		return
	end
	self.m_type = ContainerType.NONE
	self.m_go = go
	self.m_tran = self.m_go.transform
	self.m_cardsItem = {}
	self.m_cardsItemGroup = {}
	self.m_cached = false
	self.m_owner = false
	self.m_vCfg = false
end

function BaseContainer:Cache()
	if self.m_cached then
		return
	end

	-- util.LogError("cache -----"..self.m_type)

	local num = self.m_tran.childCount-1
	for i=0, num do
		local go = self.m_tran:GetChild(i).gameObject
		go.name = "card"..(i+1)
		local c = Card.New(go)
		c:Init(self)
		c:SetIdx(i+1)
		self:AddItem(c)
	end

	self.m_cached = true
end

function BaseContainer:GetItemByIdx(idx)
	self:Cache()

	for i=1, #self.m_cardsItem do
		if idx == self.m_cardsItem[i]:GetIdx() then
			return self.m_cardsItem[i]
		end
	end
end

function BaseContainer:GetItemByNum(num)
	self:Cache()
	for i=1, #self.m_cardsItem do
		if self.m_cardsItem[i]:GetCard()== num then
			return self.m_cardsItem[i]
		end
	end
end

function BaseContainer:GetItemCount()
	return #self.m_cardsItem
end

function BaseContainer:SetCount( count )
	if count == 0 then
		self.m_go.gameObject:SetActive(false)
		return
	else
		self.m_go.gameObject:SetActive(true)
	end

	self:Cache()

	local curCount = #self.m_cardsItem
	local s
	-- log("curCount -- "..curCount..' | count -- '..count)
	if count < curCount then
		-- log("self.m_cardsItem count -- "..#self.m_cardsItem)
		for i = curCount, count+1, -1 do
			s = self.m_cardsItem[i]
			destroy(s:GetGameObject())
			table.remove(self.m_cardsItem, i)
		end
		-- log("self.m_cardsItem count 2 -- "..#self.m_cardsItem)
	elseif count > curCount then
		for i = curCount, count-1 do
			-- log("curCount--"..curCount..' #self.m_cardsItem--'..#self.m_cardsItem)
			-- util.Log("curCount--"..curCount.." totalCount -- "..#self.m_cardsItem)
			local tempGo = self.m_cardsItem[curCount]:GetGameObject()
			local c = self:CreateCardItem(tempGo, i)
			self:AddItem(c)
		end
	end

end

--创建牌item
function BaseContainer:CreateCardItem(tempGo, idx)
	local g = GameObject.Instantiate(tempGo)
	g.transform:SetParent(self.m_go.transform)
	g.name = "card"..(idx+1)
	local c = Card.New(g)
	c:Init(self)
	c:SetScale(tempGo.transform.localScale)	
	return c
end

--添加牌item
function BaseContainer:AddItem(cardItem)
	if not self.m_cardsItem then
		self.m_cardsItem = {}
	end
	self.m_cardsItem[#self.m_cardsItem+1] = cardItem
end

--移除牌item
function BaseContainer:RemoveItem(item)
	for i=1, #self.m_cardsItem do
		if item == self.m_cardsItem[i] then
			self.m_cardsItem[i]:Destroy()
			table.remove(self.m_cardsItem, i)
			break
		end
	end
end

--添加一个牌
function BaseContainer:AddCard(cardNum)

	--开始没牌时要处理下 使用的是第一个已有的牌 之后在新创建
	local cardItem 
	-- util.Log("self.m_cardsItem -- "..#self.m_cardsItem..' type -- '..self.m_type)
	if not self.m_cardsItem or #self.m_cardsItem == 0 then
		--显示牌
		if self.m_cardsItem then
			log("m_cardsItem num -- "..#self.m_cardsItem)
		end
		-- logWarn("Addcard type -- "..self.m_type.." --- ")
		self:SetCount(1)
		self:GetItemByIdx(1)
		cardItem = self:GetItemByIdx(1)
	else
		-- log("add card create ---- ")
		cardItem = self:CreateCardItem(self:GetItemByIdx(1):GetGameObject(), self:GetItemCount())
		self:AddItem(cardItem)
	end
	
	cardItem:SetCard(cardNum)

	self:OnAddCard(cardItem)

	return cardItem
end

-- 移除一张指定的牌
function BaseContainer:RemoveCard(cardItem)
	local tempRemove = {}

	for k,v in pairs(self.m_cardsItem) do
		if cardItem == v then
			tempRemove[#tempRemove+1] = v
			break
		end
	end

	for i=1, #tempRemove do
		self:RemoveItem(tempRemove[i])
	end

	self:OnRemoveCard(tempRemove)
end

-- 随机移除一张牌
function BaseContainer:RemoveCardRandom()
	local tempRemove = {}

	tempRemove[#tempRemove+1] = self.m_cardsItem[math.random(1,#self.m_cardsItem)]

	for i=1, #tempRemove do
		self:RemoveItem(tempRemove[i])
	end

	self:OnRemoveCard(tempRemove)
end

--删除牌 cardData table数组或number bKind 是否一种牌
-- 可 
-- 默认删除最后一张
-- 删除一个数组里的牌 各一张
-- 删除一个数组里的牌 各一种
-- 删除指定的一张牌
-- 删除指定的一种牌 
-- bKind 可传number 删除牌个数
function BaseContainer:RemoveCardsEx(cardData, bKind)
	local tempRemove = {}

	if not cardData then	--没参数 默认移除最后一张
		tempRemove[#tempRemove+1] = self.m_cardsItem[#self.m_cardsItem]
	elseif type(cardData) == "table" then	--移除多张
		for i=1, #cardData do
			local cardId = cardData[i]
			for j=1, #self.m_cardsItem do
				if self.m_cardsItem[j] == cardId then
					tempRemove[#tempRemove+1] = self.m_cardsItem[j]
					if not bKind then
						break
					end

					if type(bKind) == "number" and #tempRemove >= bKind then
						break
					end
				end
			end
		end
	elseif type(cardData) == "number" then	--移除指定牌
		for i=1, #self.m_cardsItem do
			if self.m_cardsItem[i]:GetCard() == cardData then
				tempRemove[#tempRemove+1] = self.m_cardsItem[i]
				if not bKind then
					break
				end

				if type(bKind) == "number" and #tempRemove >= bKind then
					break
				end
			end
		end
	end
	-- log("tempRemove num -- "..#tempRemove)

	for i=1, #tempRemove do
		self:RemoveItem(tempRemove[i])
	end

	self:OnRemoveCard(tempRemove)
end

function BaseContainer:RemoveCardsInEnd(num)
	
	local tempRemove = {}

	if type(num) == "number" then
		for i=1, num do
			if i <= #self.m_cardsItem then
				tempRemove[#tempRemove+1] = self.m_cardsItem[#self.m_cardsItem-(i-1)]
			end
		end
	end

	for i=1, #tempRemove do
		self:RemoveItem(tempRemove[i])
	end

	self:OnRemoveCard(tempRemove)
end

function BaseContainer:HideCardByIdx(idx)
	local tempItems = {}
	for i=1, #self.m_cardsItem do
		if self.m_cardsItem[i]:IsActive() then
			tempItems[#tempItems+1] = self.m_cardsItem[i]	--得到没有隐藏的
		end
	end
	idx = idx or #tempItems
	if idx > #tempItems then
		util.LogError("HideCardByIdx idx 超出范围 idx:"..idx)
		return
	end

	tempItems[idx]:SetActive(false)
end

--添加一组牌
-- cardData 数据结构
-- {
-- 	cards = {0x31,0x32,0x33},
-- 	shwoType = CardShowType.CHI,
-- 	otherId = 1234
-- }
function BaseContainer:AddCardGroup(cardData)
	local Group = {}
	-- log("addCardGroup -- cards num - "..#cardData.cards.." showType - "..tostring(cardData.showType).." cardOtherId - "..cardData.otherId)
	Group.itemGroup = {}
	for i=1, #cardData.cards do
		-- log("AddCard -- "..cardData.cards[i])
		local cardItem = self:AddCard(cardData.cards[i])
		-- log("cardItem -- "..tostring(cardItem))
		-- log("cardItem name -- "..cardItem:GetName().." go name --"..cardItem:GetGameObject().name)
		Group.itemGroup[#(Group.itemGroup)+1] = cardItem
	end
	Group.showType = cardData.showType
	Group.otherId = cardData.otherId

	self:OnAddCardGroup(cardData, Group.itemGroup)
	return Group
end

--删除一组牌
-- data 为num 删除的一组牌的和为num
-- data 为table 计算出table里面值的和 删除与其相等的一组牌
function BaseContainer:RemoveCardGroup(cardShowType, data)
	local totalNum = data
	if type(data) == "table" then
		totalNum = 0
		for _,v in pairs(data) do
			totalNum = totalNum + v
		end
	end
	local findGroup = false
	for i=1, #self.m_cardsItemGroup do
		if self.m_cardsItemGroup[i].showType == cardShowType then
			local group = self.m_cardsItemGroup[i].itemGroup
			local tempNum = 0
			for j=1, #group do
				tempNum = tempNum + group[j]:GetCard()
			end

			if tempNum == totalNum then
				findGroup = self.m_cardsItemGroup[i]
				table.remove(self.m_cardsItemGroup, i)
				break
			end
		end
	end

	if not findGroup then
		util.LogError("没找到这组牌--"..cardShowType.." data -- "..tostring(data))
		return
	end

	for k, v in pairs(findGroup.itemGroup) do
		self:RemoveCard(v)
	end

end

function BaseContainer:SetOwner(player)
	self.m_owner = player
end

function BaseContainer:Init(param)
	----处理传入参数
	local cards = {}
	if type(param) == "table" then
		cards = param
	elseif type(param) == "number" then
		for i=1, param do
			cards[#cards+1] = 0
		end
	else
		util.LogError("初始化牌错误 传入类型不对")
	end
	self:OnInit(cards)
	self:Fresh()
end

function BaseContainer:IsMyHandsCard()
	if PlayerMgr.IsMyself(self.m_owner) then
		return true
	end
	return false
end

function BaseContainer:IsMySelfCard()
	if self.m_type == ContainerType.SELF then
		return true
	end
	return false
end

function BaseContainer:SetActive(bActive)
	self.m_go:SetActive(bActive)
end

function BaseContainer:ResetState()
	self:OnResetState()
end

function BaseContainer:GetType()
	return self.m_type
end

function BaseContainer:Update()
	return self:OnUpdate()
end

function BaseContainer:Fresh()
	-- log("BaseContainer:OnFresh ----- ")
	if not self.m_vCfg then
		logError("没找到sit["..sit.."]对应配置")
		return
	end

	return self:OnFresh()
end

-- 排序时会设置idx
function BaseContainer:SortItem()
	local fun = function(a, b)
		if b:GetCard() == a:GetCard() then
			return b:GetIdx() > a:GetIdx()
		end
		return b:GetCard() > a:GetCard()
	end

	table.sort(self.m_cardsItem, fun)

	for i=1, #self.m_cardsItem do
		self.m_cardsItem[i]:SetIdx(i)
	end
end

--如果多一张最后一张牌不动 只排前面的
function BaseContainer:SortItemEx()
	local fun = function(a, b)
		if b:GetCard() == a:GetCard() then
			return b:GetIdx() > a:GetIdx()
		end
		return b:GetCard() > a:GetCard()
	end

	if #self.m_cardsItem%3 == 2 then
		local tempCard = self.m_cardsItem[#self.m_cardsItem]
		table.remove(self.m_cardsItem, #self.m_cardsItem)
		table.sort(self.m_cardsItem, fun)
		self.m_cardsItem[#self.m_cardsItem+1] = tempCard
	else
		self:SortItem()
	end

	for i=1, #self.m_cardsItem do
		self.m_cardsItem[i]:SetIdx(i)
	end

	self:Fresh()
end

function BaseContainer:OnInit()
end

function BaseContainer:OnAddCard(cardItem)
end

function BaseContainer:OnAddCardGroup(cardData, cardItemGroup)
end

function BaseContainer:OnRemoveCard(removeCards)
	
end

function BaseContainer:OnShowCards(bAni)
end

function BaseContainer:OnUpdate()
end

function BaseContainer:OnFresh()
end

function BaseContainer:OnResetState()
	
end

function BaseContainer:UnLoad()
end