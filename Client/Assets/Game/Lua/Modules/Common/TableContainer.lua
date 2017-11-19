-- TableContainer.lua
-- Author : Dzq
-- Date : 2017-10-23
-- Last modification : 2017-10-23
-- Desc: 出的牌的容器


TableContainer = Class(BaseContainer)
  
function TableContainer:Ctor()
	self.m_type = ContainerType.TABLE
	self.m_bankerSit = PlayerSit.Bottom
	self.m_dice = 0

	self.m_sitItems = {
		[PlayerSit.Bottom] = {},
		[PlayerSit.Up] = {},
		[PlayerSit.Left] = {},
		[PlayerSit.Right] = {},
	}
end
	
function TableContainer:OnInit(cards)

	self.m_vCfg = ViewCfg.tableCards

	self:SetCount(#cards)
	
	if not self.m_vCfg[self.m_bankerSit] then
		util.LogError("tableContainer 没有找到座位 "..self.m_bankerSit.." 对应的配置")
		return
	end

	-- log("cards count  -- "..#cards..' | #self.m_cards -- '..#self.m_cards)
	-- for i=1, #self.m_cards do
	-- 	self.m_cardsItem[i]:SetCard(self.m_cards[i])
	-- end
end

--设置庄家位置
function TableContainer:SetBankerSit(playerSit)
	self.m_bankerSit = playerSit
end

--设置从第几堆牌开始
function TableContainer:SetDiceNum(diceNum)
	self.m_dice = diceNum
end

function TableContainer:ShowUpAni()
	local oldPos = self.m_go.transform.localPosition
	self.m_go.transform.localPosition = Vector3.New(oldPos.x, oldPos.y-0.1, oldPos.z)
	iTween.MoveTo(self.m_go, iTween.Hash("y", oldPos.y, "islocal", true, "time", ViewCfg.TableUpTime))

	local tableLeft = find("3d/Desk/Table/MahjongTable_Lift_LR")
	local tableRight = find("3d/Desk/Table/MahjongTable_Lift_TB")

	local oldLeftPos = tableLeft.transform.localPosition
	local oldRightPos = tableRight.transform.localPosition

	tableLeft.transform.localPosition = Vector3.New(oldLeftPos.x, oldLeftPos.y-0.1, oldLeftPos.z)
	tableRight.transform.localPosition = Vector3.New(oldRightPos.x, oldRightPos.y-0.1, oldRightPos.z)

	iTween.MoveTo(tableLeft, iTween.Hash("y", 0, "islocal", true, "time", ViewCfg.TableUpTime))
	iTween.MoveTo(tableRight, iTween.Hash("y", 0, "islocal", true, "time", ViewCfg.TableUpTime))
end

-- 刷新
function TableContainer:OnFresh()

	local itemIdx = 1
	for sit=1, 4 do
		-- sit = (self.m_bankerSit + sit)%3
		local cfg = self.m_vCfg[sit]
		local items = self.m_sitItems[sit]
		-- logWarn("sit -- "..sit)
		for i=1, cfg.num*2 do
			if itemIdx > #self.m_cardsItem then
				break
			end
			local item = self.m_cardsItem[itemIdx]

			local rowOffset = math.floor(((i-1)/2))*cfg.distant
			local colOffset = ((i)%2)*cfg.hight
			-- log("itemIdx -- "..itemIdx..' rowOffset -- '..rowOffset..' colOffset -- '..colOffset)
			local newPos
			if sit == PlayerSit.Bottom then
				newPos = Vector3.New(cfg.pos.x, colOffset, cfg.pos.z+rowOffset)
			elseif sit == PlayerSit.Right then
				newPos = Vector3.New(cfg.pos.x+rowOffset, colOffset, cfg.pos.z)
			elseif sit == PlayerSit.Left then
				newPos = Vector3.New(cfg.pos.x-rowOffset, colOffset, cfg.pos.z)
			elseif sit == PlayerSit.Up then
				newPos = Vector3.New(cfg.pos.x, colOffset, cfg.pos.z-rowOffset)
			end

			item:SetPos(newPos)
			item:SetRot(cfg.angle)
			item:SetScale(cfg.scale)
			items[#items+1] = item
			itemIdx = itemIdx + 1
		end
	end

	-- for k,v in pairs(self.m_sitItems) do
	-- 	log("k -- "..k..' items num -- '..#v)
	-- end

end

function TableContainer:OnAddCard(cardItem)
	util.LogError("TableContainer:OnAddCard--")
end

function TableContainer:OnAddCardGroup(cardData, cardItemGroup)
	util.LogError("TableContainer:OnAddCardGroup--")
end

function TableContainer:OnRemoveCard(cardsItem)
	log("TableContainer:OnRemoveCard num -- "..#cardsItem)
end