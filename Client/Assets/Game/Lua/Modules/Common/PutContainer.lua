-- PutContainer.lua
-- Author : Dzq
-- Date : 2017-10-10
-- Last modification : 2017-10-10
-- Desc: 出的牌的容器


PutContainer = Class(BaseContainer)
  
function PutContainer:Ctor()
	self.m_type = ContainerType.PUT
end
	
function PutContainer:OnInit(cards)

	self.m_vCfg = ViewCfg[self.m_owner:GetSit()]
	
	self:SetCount(#cards)
	self.m_cards = cards
	-- log("cards count  -- "..#cards..' | #self.m_cards -- '..#self.m_cards)
	for i=1, #self.m_cards do
		self.m_cardsItem[i]:SetCard(self.m_cards[i])
	end
end

-- 刷新
function PutContainer:OnFresh()

	self.m_tran.localPosition = self.m_vCfg.putPos
	self.m_tran.localEulerAngles = self.m_vCfg.putAngle
	self.m_tran.localScale = self.m_vCfg.putScale

	local row
	local col
	local newPos
	local item
	for i=1, #self.m_cardsItem do
		item = self.m_cardsItem[i]
		row = (i-1)%self.m_vCfg.putRowNum
		col = math.floor((i-1)/self.m_vCfg.putRowNum)
		newPos = Vector3.New(row*self.m_vCfg.putDistant, 0, col*self.m_vCfg.putHight)
		item:SetPos(newPos)
	end

end

function PutContainer:OnAddCard(cardItem)
	local idx = #self.m_cardsItem-1
	local col = math.floor(idx/self.m_vCfg.putRowNum)
	local row = idx%self.m_vCfg.putRowNum
	newPos = Vector3.New(row*self.m_vCfg.putDistant, 0, col*self.m_vCfg.putHight)
	cardItem:SetPos(newPos)
end

function PutContainer:OnAddCardGroup(cardData, cardItemGroup)
	util.LogError("PutContainer:OnAddCardGroup--")
end

function PutContainer:OnRemoveCard()
	-- body
end