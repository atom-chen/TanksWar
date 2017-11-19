-- SelfContainer.lua
-- Author : Dzq
-- Date : 2017-11-10
-- Last modification : 2017-11-10
-- Desc: 自己手牌容器


SelfContainer = Class(BaseContainer)
  
function SelfContainer:Ctor()
	self.m_type = ContainerType.SELF
	self.m_dragCard = false 		--用于拖动显示的牌
	self.m_dragPos = false
	self.m_cardPos = false

	self.m_showCo = false
	self.m_addCard = false

	-- self.m_addCardNum = false
end
	
function SelfContainer:OnInit(cards)
	self.m_showCo = false

	self.m_vCfg = ViewCfg[self.m_owner:GetSit()]
	
	self:SetCount(#cards)

	for i=1, #cards do
		self.m_cardsItem[i]:SetCard(cards[i])
		self.m_cardsItem[i]:SetActive(false)
	end

	-- if #cards%3 == 2 then
	-- 	self.m_addCardNum = cards[#cards]
	-- end

	self.m_dragCard = self:CreateCardItem(self.m_cardsItem[#self.m_cardsItem]:GetGameObject(), -1)
	-- util.LogError("SetState(CardState.Lock) 1 "..self.m_type.." name -- "..self.m_owner:GetName())
	self.m_dragCard:SetState(CardState.Lock)
	self.m_dragCard:SetActive(false)
end

-- 这里是初始化完牌 在RoomMgr里调用的 播放显示动画
function SelfContainer:OnShowCards(bAni)
	-- 发牌开始时广播个消息吧
	if bAni then
		--开始发牌动画
		RoomMgr.SetPlayState(PlayState.Dealing)
		--先把所有牌都隐藏
		for i=1, #self.m_cardsItem do
			-- log("on show card -- "..self.m_cardsItem[i]:GetName())
			self.m_cardsItem[i]:SetActive(false)
		end

		self.m_showCo = coroutine.start(self.CoShowCards, self)
	else
		for i=1, #self.m_cardsItem do
			if self.m_cardsItem[i] ~= self.m_addCard then	-- 多的那张牌不马上显示
				self.m_cardsItem[i]:SetActive(true)
			end
		end	
		
		self:SortItemEx()

		--发送消息 通知显示完牌
		self:SetMoCard()
		Event.Brocast(Msg.ShowCardsEnd, self.m_owner)
	end
end

function SelfContainer:CoShowCards()

	local idx = 0
	-- 除了多的那张牌 没四张牌一组播放发牌动画
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

function SelfContainer:CoSortCards()

	-- 整理牌时扣上的动画
	for i=1, #self.m_cardsItem do
		if self.m_cardsItem[i] ~= self.m_addCard then	-- 多的那张牌不马上显示
			self.m_cardsItem[i]:SetActive(true)
			self.m_cardsItem[i]:PlaySortAni1()
		end
	end

	-- 等待整理
	coroutine.wait(ViewCfg.SortCardTime)
	
	self:SortItemEx()

	-- 整理完的翻牌动画
	for i=1, #self.m_cardsItem do
		self.m_cardsItem[i]:PlaySortAni2()
	end

	coroutine.wait(ViewCfg.SortAni2Time)
	-- 动画播完的偏移可能不准 重新设置下
	for i=1, #self.m_cardsItem do
		self.m_cardsItem[i]:SetRot(Vector3.New(0, 0, 0))
	end

	self.m_showCo = false
	
	self:SetMoCard()
	--发送消息 通知显示完牌
	RoomMgr.SetPlayState(PlayState.Playing)
	Event.Brocast(Msg.ShowCardsEnd, self)

end

function SelfContainer:OnClick(card)
	if card:IsVaild() and card:GetState() == CardState.Select then
		log("click card -- "..card:GetCard())
		self:ChuCard(card)
	end
end

function SelfContainer:OnDragBegin(card, eventData)
	if card:GetState() == CardState.Lock then
		return
	end

	self.m_cardPos = card:GetPos()
	self.m_dragPos = eventData.position
	self.m_dragCard:SetPos(self.m_cardPos)
	self.m_dragCard:SetCard(card:GetCard())
	card:SetState(CardState.Lock)
	self.m_dragCard:SetActive(true)
end

function SelfContainer:OnDrag(card, eventData)
	-- 非游戏状态不能拖动
	if RoomMgr.curState ~= PlayState.Playing then
		return
	end

	local movePos = eventData.position - self.m_dragPos
	self.m_dragCard:SetPos(Vector3.New(self.m_cardPos.x+movePos.x/self.m_vCfg.selfScale.x,self.m_cardPos.y+movePos.y/self.m_vCfg.selfScale.y,self.m_cardPos.z))
end

function SelfContainer:OnDragEnd(card, eventData)
	-- 非游戏状态不能拖动
	if RoomMgr.curState ~= PlayState.Playing then
		return
	end

	self.m_dragCard:SetActive(false)
	self:ChuCard(card)
end

function SelfContainer:ChuCard(card)

	local opt = self.m_owner:GetCurOpt()
	card:SetState(CardState.Normal)

	local hasOp = self.m_owner:HasOprate(Operation.CHU.name)
	
	if not hasOp then	--没有出牌权限
		log("当前没有出牌权限 ---")
		return
	end
	
	self.m_owner:ChuCard(card)
end

-- 刷新
function SelfContainer:OnFresh()
	local startPos = self.m_vCfg.cardStartPos
	self.m_dragCard:SetPos(startPos)
	self.m_dragCard:SetScale(Vector3.one)
	self.m_dragCard:SetRect(self.m_vCfg.selfSizeDelta)
	-- util.LogError("设置手牌---"..self.m_owner:GetName())
	-- logWarn("self.m_addCard -- "..tostring(self.m_addCard))
	if not self.m_addCard and #self.m_cardsItem%3 == 2 then
		self.m_addCard = self.m_cardsItem[#self.m_cardsItem] -- self:GetItemByNum(self.m_addCardNum)
		-- logWarn("设置手牌 add card ---"..tostring(self.m_addCard).." "..self.m_addCard:GetName()..' cardItem '..self.m_cardsItem[#self.m_cardsItem]:GetCard())
		self.m_addCard:SetActive(false)
	end

	-- log("self.m_addCard -- "..tostring(self.m_addCard))
	local offsetX
	local idx = 0
	for i=1, #self.m_cardsItem do
		local item = self.m_cardsItem[i]
		-- log("item---"..tostring(item).." addCard -- "..tostring(self.m_addCard))
		if item ~= self.m_addCard then	--非添加的item排序排列
			idx = idx + 1
			item:SetIdx(idx)
			offsetX = startPos.x + self.m_vCfg.selfDistant*(idx-1)
			local newPos = Vector3.New(offsetX, startPos.y, startPos.z)
			item:SetPos(newPos)
			item:SetScale(Vector3.one)
			item:SetRect(self.m_vCfg.selfSizeDelta)
		end
		-- end
	end
end

--设置多的那张牌
function SelfContainer:SetMoCard(cardItem)
	local startPos = self.m_vCfg.cardStartPos
	self.m_addCard = self.m_addCard or cardItem
	
	-- log("是否多手牌---"..tostring(self.m_addCard))
	if self.m_addCard then
		self.m_addCard:SetActive(true)
		local offsetX = startPos.x + self.m_vCfg.selfDistant*(#self.m_cardsItem-2) + self.m_vCfg.selfAddDis
		local newPos = Vector3.New(offsetX, startPos.y, startPos.z)
		self.m_addCard:SetIdx(#self.m_cardsItem)
		self.m_addCard:SetPos(newPos)
		self.m_addCard:SetScale(Vector3.one)
		self.m_addCard:SetRect(self.m_vCfg.selfSizeDelta)
		self.m_addCard:PlayMoAni()
	end
end

function SelfContainer:OnRemoveCard(removeCards)
	local rCard 	                --移除的牌
	local aCard = self.m_addCard 	--添加的牌
	if #removeCards == 1 then
		rCard = removeCards[1]
	else
		-- log("删除的是多张牌")
		self:SortItem()
		self:Fresh()
		return
	end

	if rCard == aCard then
		-- logWarn("删掉的是新摸到的牌")
		return
	end

	if not rCard or not aCard then
		util.LogError("rCard 或 aCard 是空")
		return
	end

	--排完后idx会改变
	self:SortItem()

	local startPos = self.m_vCfg.cardStartPos
	local offsetX

	-- logWarn("rIdx--"..rIdx.."| rName--"..rCard:GetName().."  aIdx--"..aIdx.."| aName--"..aCard:GetName())
	for i=1, #self.m_cardsItem do
		local card = self.m_cardsItem[i]
		--应该在的位置X坐标
		offsetX = startPos.x + self.m_vCfg.selfDistant*(card:GetIdx()-1)
		--和现在相隔距离
		local dis = math.abs(card:GetPos().x - offsetX)
		local part1 = self.m_vCfg.selfDistant - 0.001 -- 会有偏差
		local part2 = 2*self.m_vCfg.selfDistant - 0.001 -- 会有偏差
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

function SelfContainer:ResetCards()
	for i=1, #self.m_cardsItem do
		self.m_cardsItem[i]:GetGameObject().name = "card"..self.m_cardsItem[i]:GetIdx()
	end
	self:Fresh()

end

function SelfContainer:OnAddCard(cardItem)
	-- if self.m_addCard then
	-- 	logWarn("oldCard -- "..self.m_addCard:GetName().." curAddCard -- "..cardItem:GetName())
	-- end
	self.m_addCard = cardItem
	self.m_addCard:SetActive(false)
	self:SetMoCard()
	self:SortItemEx()
	self:Fresh()
end


function SelfContainer:OnResetState()
	for _,v in pairs(self.m_cardsItem) do
		v:ResetState()
	end
	
end

function SelfContainer:OnAddCardGroup(cardData, cardItemGroup)
	
end
