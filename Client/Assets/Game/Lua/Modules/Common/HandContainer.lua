-- HandContainer.lua
-- Author : Dzq
-- Date : 2017-10-09
-- Last modification : 2017-10-09
-- Desc: 手牌容器


HandContainer = Class(BaseContainer)
  
function HandContainer:Ctor()
	self.m_type = ContainerType.HAND
	self.m_dragCard = false 		--用于拖动显示的牌
	self.m_dragPos = false
	self.m_cardPos = false

	self.m_showCo = false
end
	
function HandContainer:OnInit(cards)
	self.m_showCo = false

	self.m_vCfg = ViewCfg[self.m_owner:GetSit()]
	
	self:SetCount(#cards)
	self.m_cards = cards
	-- log("cards count  -- "..#cards..' | #self.m_cards -- '..#self.m_cards)
	for i=1, #self.m_cards do
		self.m_cardsItem[i]:SetCard(self.m_cards[i])
		self.m_cardsItem[i]:SetActive(false)
	end

	--初始化拖动的牌
	if self:IsMyHandsCard() then
		self.m_dragCard = self:CreateCardItem(self.m_cardsItem[#self.m_cardsItem]:GetGameObject(), -1)
		self.m_dragCard:SetState(CardState.Lock)
		self.m_dragCard:SetActive(false)
	end
end

function HandContainer:OnShowCards(bAni)
	if bAni then
		for i=1, #self.m_cardsItem do
			if self:IsMyHandsCard() then	--自己的手牌有多一层 
				self.m_cardsItem[i]:SetChildRot(Vector3.New(-90,0,0))
			else
				self.m_cardsItem[i]:SetRot(Vector3.New(-90,0,0))
			end
			self.m_cardsItem[i]:SetActive(false)
		end
		self.m_showCo = coroutine.start(self.CoShowCards, self)
	else
		for i=1, #self.m_cardsItem do
			self.m_cardsItem[i]:SetActive(true)
		end	
	end
	
end

function HandContainer:CoShowCards()
	
	for i=1, #self.m_cardsItem do
		self.m_cardsItem[i]:SetActive(true)
		self.m_cardsItem[i]:PlayDealAni()
		if i%4 == 0 then
			coroutine.wait(ViewCfg.DealCardTime)
		end
		Event.Brocast(Msg.ActionMo, self.m_owner)
	end

	self.m_showCo = false
end

function HandContainer:OnClick(card)
	if card:IsVaild() and card:GetState() == CardState.Select then
		log("click card -- "..card:GetCard())
		self:ChuCard(card)
	end
end

function HandContainer:OnDragBegin(card, eventData)
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

function HandContainer:OnDrag(card, eventData)
	local movePos = eventData.position - self.m_dragPos
	self.m_dragCard:SetPos(Vector3.New(self.m_cardPos.x+movePos.x/self.m_vCfg.handScale.x,self.m_cardPos.y+movePos.y/self.m_vCfg.handScale.y,self.m_cardPos.z))
end

function HandContainer:OnDragEnd(card, eventData)
	self.m_dragCard:SetActive(false)
	self:ChuCard(card)
end

function HandContainer:ChuCard(card)
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
function HandContainer:OnFresh()

	local startPos = Vector3.zero

	--自己手牌特殊设置
	if self:IsMyHandsCard() then
		startPos = self.m_vCfg.cardStartPos

		self.m_dragCard:SetPos(startPos)
		self.m_dragCard:SetScale(Vector3.one)
		self.m_dragCard:SetRect(self.m_vCfg.handSizeDelta)

		self:SortItem()
	end

	local offsetX
	local idx = 0

	for i=1, #self.m_cardsItem do
		local item = self.m_cardsItem[i]
		-- if item:IsActive() then --隐藏的跳过
		idx = idx + 1
		offsetX = startPos.x + self.m_vCfg.handDistant*(idx-1)
		local newPos = Vector3.New(offsetX, startPos.y, startPos.z)
		item:SetPos(newPos)
		item:SetScale(Vector3.one)
		item:SetRect(self.m_vCfg.handSizeDelta)
		-- end
	end

end

function HandContainer:OnRemoveCard(removeCards)
	for k, v in pairs(removeCards) do
		v:Destroy()
	end

	self:Fresh()
	-- log("删除牌 整理牌---- ")
end


function HandContainer:OnAddCard(cardItem)
	self:Fresh()
end


function HandContainer:OnResetState()
	for _,v in pairs(self.m_cardsItem) do
		v:ResetState()
	end
	
end

function HandContainer:OnAddCardGroup(cardData, cardItemGroup)
	
end