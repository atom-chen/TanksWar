-- ChiContainer.lua
-- Author : Dzq
-- Date : 2017-10-10
-- Last modification : 2017-10-10
-- Desc: 吃碰杠牌的容器


ChiContainer = Class(BaseContainer)
  
function ChiContainer:Ctor()
	self.m_type = ContainerType.CHI
	self.m_datasItem = {}
	self.m_cardsItemGroup = {}
end

--此处传入的应该是吃碰杠牌数据的数组
-- cardDataItem 数据结构
-- {
-- 	cards = {0x31,0x32,0x33},
-- 	shwoType = CardShowType.CHI,
-- 	otherId = 1234
-- }
function ChiContainer:OnInit(cards)
	
	-- log("吃碰杠牌数据需根据类型处理")

	self.m_vCfg = ViewCfg[self.m_owner:GetSit()]

	self.m_datasItem = {}
	self.m_cardsItemGroup = {}

	self.m_cardsItem = {}

	for i=1, #cards do
		local dataItem = cards[i]
		if type(dataItem) ~= "table" then
			logError("吃碰杠牌数据错误--"..tostring(dataItem))
		else
			self.m_datasItem[#self.m_datasItem+1] =	dataItem
			self:AddCardGroup(dataItem)
		end
	end

end

-- 刷新
function ChiContainer:OnFresh()

	self.m_tran.localPosition = self.m_vCfg.chiPos
	self.m_tran.localEulerAngles = self.m_vCfg.chiAngle
	self.m_tran.localScale = self.m_vCfg.chiScale

end

function ChiContainer:OnAddCard(cardItem)
	-- log("ChiContainer:OnAddCard -- ")
end

function ChiContainer:OnAddCardGroup(cardData, cardItemGroup)
	log("OnAddCardGroup --- "..#cardItemGroup)

	local splitDis = 0
	--每组牌有间隔		
	if #self.m_cardsItemGroup > 0 then
		splitDis = (#self.m_cardsItemGroup)*self.m_vCfg.chiSplit
	end

	logWarn("add group splitDis --"..splitDis.." group num -- "..#self.m_cardsItemGroup)

	for i=1, #cardItemGroup do

		local posX = self.m_vCfg.chiDistant*(i-1)
		local posY = 0
		local posZ = 0

		local rotX = 0
		local rotY = 0
		local rotZ = 0

		if cardData.showType == CardShowType.CHI then
			-- logWarn("chi --- ")
		elseif cardData.showType == CardShowType.PENG then
			-- logWarn("peng --- ")
		elseif cardData.showType == CardShowType.ANGANG then
			if i <= 3 then
				rotX = 180
			else
				posX = self.m_vCfg.chiDistant
				posY = self.m_vCfg.chiUpHight
			end
			-- logWarn("angang --- ")
		elseif cardData.showType == CardShowType.MINGGANG then
			if i == 4 then
				posX = self.m_vCfg.chiDistant
				posY = self.m_vCfg.chiUpHight
			end
			-- logWarn("minggang --- ")
		end

		--一组牌统一偏移
		posX = posX + splitDis

		-- log("posx - "..posX..' | posy - '..posY)
		cardItemGroup[i]:SetPos(Vector3.New(posX, posY, posZ))
		cardItemGroup[i]:SetRot(Vector3.New(rotX, rotY, rotZ))
	end

	self.m_cardsItemGroup[#self.m_cardsItemGroup+1] = cardItemGroup
end