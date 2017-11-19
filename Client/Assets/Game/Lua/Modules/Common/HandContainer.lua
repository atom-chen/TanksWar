-- HandContainer.lua
-- Author : Dzq
-- Date : 2017-10-09
-- Last modification : 2017-11-10
-- Desc: 桌上手牌容器


HandContainer = Class(BaseContainer)
  
function HandContainer:Ctor()
	self.m_type = ContainerType.HAND

	self.m_showCo = false
	self.m_addCard = false
end
	
function HandContainer:OnInit(cards)
	self.m_showCo = false

	self.m_vCfg = ViewCfg[self.m_owner:GetSit()]
	
	self:SetCount(#cards)
	-- log("cards count  -- "..#cards..' | #self.m_cards -- '..#self.m_cards)
	for i=1, #cards do
		self.m_cardsItem[i]:SetCard(cards[i])
		self.m_cardsItem[i]:SetActive(false)
	end

end

-- 这里是初始化完牌 在RoomMgr里调用的 播放显示动画
function HandContainer:OnShowCards(bAni)
	-- 发牌开始时广播个消息吧
	if bAni then
		RoomMgr.SetPlayState(PlayState.Dealing)
		for i=1, #self.m_cardsItem do
			self.m_cardsItem[i]:SetActive(false)
		end
		self.m_showCo = coroutine.start(self.CoShowCards, self)
	else
		for i=1, #self.m_cardsItem do
			if self.m_cardsItem[i] ~= self.m_addCard then	-- 多的那张牌不马上显示
				self.m_cardsItem[i]:SetActive(true)
			end
		end

		--发送消息 通知显示完牌
		self:SetMoCard()
		Event.Brocast(Msg.ShowCardsEnd, self.m_owner)
	end
end

function HandContainer:CoShowCards()
	
	local idx = 0
	for i=1, #self.m_cardsItem do
		if self.m_cardsItem[i] ~= self.m_addCard then	-- 多的那张牌不马上显示
			self.m_cardsItem[i]:SetActive(true)
			idx = idx + 1
		end
		self.m_cardsItem[i]:PlayDealAni()
		if idx%4 == 0 then
			coroutine.wait(ViewCfg.DealCardTime)
		end
		Event.Brocast(Msg.ActionMo, self.m_owner)
	end
	coroutine.wait(ViewCfg.DealEndWaitTime)

	self:CoSortCards()
end

function HandContainer:CoSortCards()

	for i=1, #self.m_cardsItem do
		if self.m_cardsItem[i] ~= self.m_addCard then	-- 多的那张牌不马上显示
			self.m_cardsItem[i]:SetActive(true)
			self.m_cardsItem[i]:PlaySortAni1()
		end
	end

	coroutine.wait(ViewCfg.SortCardTime)

	for i=1, #self.m_cardsItem do
		self.m_cardsItem[i]:PlaySortAni2()
	end

	coroutine.wait(ViewCfg.SortAni2Time)
	-- 设置的偏移可能不准 重新设置下
	for i=1, #self.m_cardsItem do
		self.m_cardsItem[i]:SetRot(Vector3.New(0, 0, 0))
	end

	self.m_showCo = false
	
	self:SetMoCard()
	--发送消息 通知显示完牌
	RoomMgr.SetPlayState(PlayState.Playing)
	Event.Brocast(Msg.ShowCardsEnd, self)

end

function HandContainer:OnClick(card)
	if not self:IsMyHandsCard() then
		return
	end

	if card:IsVaild() and card:GetState() == CardState.Select then
		log("click card -- "..card:GetCard())
		self:ChuCard(card)
	end
end

-- 刷新
function HandContainer:OnFresh()

	local startPos = Vector3.zero

	local offsetX
	local idx = 0
	-- log("设置手牌---"..self.m_owner:GetName())
	if #self.m_cardsItem%3 == 2 then	--非自己的手牌都是值都是0 所以直接取最后一张
		self.m_addCard = self.m_cardsItem[#self.m_cardsItem]
		self.m_addCard:SetActive(false)
	end

	for i=1, #self.m_cardsItem do
		local item = self.m_cardsItem[i]
		-- if item:IsActive() then --隐藏的跳过
		if item ~= self.m_addCard then	--非添加的item排序排列
			idx = idx + 1
			item:SetIdx(idx)
			offsetX = startPos.x + self.m_vCfg.handDistant*(idx-1)
			local newPos = Vector3.New(offsetX, startPos.y, startPos.z)
			item:SetPos(newPos)
			item:SetScale(Vector3.one)
			item:SetRect(self.m_vCfg.handSizeDelta)
		end
		-- end
	end
end

--设置多的那张牌
function HandContainer:SetMoCard(cardItem)
	local startPos = Vector3.zero
	self.m_addCard = self.m_addCard or cardItem

	if self.m_addCard then
		self.m_addCard:SetActive(true)
		local offsetX = startPos.x + self.m_vCfg.handDistant*(#self.m_cardsItem-2) + self.m_vCfg.handAddDis
		local newPos = Vector3.New(offsetX, startPos.y, startPos.z)
		self.m_addCard:SetIdx(#self.m_cardsItem)
		self.m_addCard:SetPos(newPos)
		self.m_addCard:SetScale(Vector3.one)
		self.m_addCard:SetRect(self.m_vCfg.handSizeDelta)
		self.m_addCard:PlayMoAni()
	end
end

function HandContainer:OnRemoveCard(removeCards)
	local rCard 	                --移除的牌
	local aCard = self.m_addCard 	--添加的牌
	if #removeCards == 1 then
		rCard = removeCards[1]
	else
		-- log("删除的是多张牌")
		self:Fresh()
		return
	end

	if rCard == aCard then
		-- logWarn("删掉的是新摸到的牌")
		return
	end

	if not rCard or not aCard then
		util.LogError("rCard 或 aCard 是空 rCard--"..tostring(rCard).." aCard -- "..tostring(aCard))
		return
	end

	--将最后的牌随机插入中间
	local tempCard = self.m_cardsItem[#self.m_cardsItem]
	table.remove(self.m_cardsItem, #self.m_cardsItem)
	local tempNum = math.random(1,#self.m_cardsItem)
	-- log("随机插入的位置--"..tempNum)
	table.insert(self.m_cardsItem, tempNum, tempCard)
	
	for i=1, #self.m_cardsItem do
		self.m_cardsItem[i]:SetIdx(i)
	end

	local startPos = Vector3.zero
	local offsetX

	-- logWarn("rIdx--"..rIdx.."| rName--"..rCard:GetName().."  aIdx--"..aIdx.."| aName--"..aCard:GetName())
	for i=1, #self.m_cardsItem do
		local card = self.m_cardsItem[i]
		--应该在的位置X坐标
		offsetX = startPos.x + self.m_vCfg.handDistant*(card:GetIdx()-1)
		--和现在相隔距离
		local dis = math.abs(card:GetPos().x - offsetX)
		local part1 = self.m_vCfg.handDistant - 0.001 -- 会有偏差
		local part2 = 2*self.m_vCfg.handDistant - 0.001 -- 会有偏差
		if dis >= part1 and dis < part2 then ----距离相隔一个牌
			card:MoveTo(offsetX)
		elseif dis >= part2 then	---- 距离相隔多张牌
			coroutine.start(card.PlayMoveAni, card, offsetX)
		else
			-- log(card:GetName().." 不用移动")
		end
	end
	-- log("删除牌 整理牌---- ")
end


function HandContainer:OnAddCard(cardItem)
	self.m_addCard = cardItem
	self.m_addCard:SetActive(false)
	self:SetMoCard()
	-- self:Fresh()
end

function HandContainer:OpenCard()
	for _,v in pairs(self.m_cardsItem) do
		v:SetActive(true)	--先显示 因为自己的桌上手牌开始是不显示的
		v:PlayOpenAni()
	end
end


function HandContainer:OnResetState()
	for _,v in pairs(self.m_cardsItem) do
		v:ResetState()
	end
	
end

function HandContainer:OnAddCardGroup(cardData, cardItemGroup)
	
end