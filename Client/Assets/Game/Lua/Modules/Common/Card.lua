-- Card.lua
-- Author : Dzq
-- Date : 2017-10-09
-- Last modification : 2017-10-09
-- Desc: 牌


Card = Class();
  
function Card:Ctor(go)
	-- log("Card:Ctor --- ")
	self.m_go = go
	self.m_tran = self.m_go.transform
	self.m_rectTran = self.m_go:GetComponent("RectTransform")
	self.m_uv = false
	self.m_stateHandle = false
	self.m_curState = CardState.Normal
	self.m_type = ContainerType.NONE
	self.m_parent = false
	self.m_num = false
	self.m_isVaild = false
end

function Card:Init(contanier)
	-- self.m_go.gameObject.name = "card"..id
	self.m_parent = contanier
	self.m_type = contanier.m_type
	self.m_tran.localPosition = Vector3.zero
	self.m_tran.localRotation = Quaternion.Euler(0,0,0)

	--自己手牌需要多设置一层 用于控制牌
	if self.m_parent:IsMyHandsCard() then
		-- logWarn("自己手牌--")
		local cardUV = self.m_go.transform:Find("p/card")
		if cardUV ~= nil then
			self.m_uv =  util.AddComponentIfNoExist(cardUV.gameObject, typeof(UVTools))
		end
		self.m_stateHandle = util.AddComponentIfNoExist(self.m_go, typeof(StateHandle))

		self.m_stateHandle:AddLuaClick(self.OnClick, self)
		self.m_stateHandle:AddLuaDragBegin(self.OnDragBegin, self, false)
		self.m_stateHandle:AddLuaDrag(self.OnDrag, self, false)
		self.m_stateHandle:AddLuaDragEnd(self.OnDragEnd, self, false)
	else
		-- logWarn("其他牌--")
		self.m_uv =  util.AddComponentIfNoExist(self.m_go, typeof(UVTools))
		-- self.m_stateHandle = util.AddComponentIfNoExist(self.m_go, typeof(StateHandle))
	end

	self.m_tran.localScale = Vector3.one
	if not self.m_go.activeSelf then
		self:SetActive(true)
	end
end

function Card:SetScale(scale)
	self.m_tran.localScale = scale
end

function Card:SetActive(bShow)
	self.m_go:SetActive(bShow)
end

function Card:IsActive()
	return self.m_go.activeSelf
end

function Card:SetPos(pos)
	self.m_tran.localPosition = pos
end

function Card:SetRot(rot)
	self.m_tran.localEulerAngles = rot
end

function Card:SetRect(rect)
	if self.m_rectTran then
		self.m_rectTran.sizeDelta = rect
	end
end

function Card:SetVaild(isVaild)
	self.m_isVaild = isVaild
end

function Card:IsVaild()
	return self.m_isVaild
end

function Card:GetPos()
	return self.m_tran.localPosition
end

function Card:GetGameObject()
	return self.m_go
end

function Card:Destroy()
	destroy(self.m_go)
end

--设置牌值
function Card:SetCard(num)
	if not num or num == 0 then	----牌可以没值
		return
	end
	self.m_num = num
	local ny, nx = util.GetUVPosByCard(self.m_num)
	-- log(self:GetCardName()..' ny -- '..ny..' nx -- '..nx)

	-- log("SetCard -- type : "..self.m_type.." num : "..num.." ny : "..ny.." nx : "..nx)

	----角度不一样 偏移也不一样
	-- if self.m_type == ContainerType.HAND then
	-- 	self.m_uv.startX = 10
	-- 	self.m_uv.startY = -3
	-- elseif self.m_type == ContainerType.PUT then
	-- 	self.m_uv.startX = 7
	-- 	self.m_uv.startY = 2
	-- elseif self.m_type == ContainerType.CHI then
	-- 	self.m_uv.startX = 10
	-- 	self.m_uv.startY = -3
	-- end

	self.m_uv:SetData(ny, nx)
	self:SetVaild(true)
end

function Card:GetCard()
	return self.m_num
end

function Card:GetCardName()
	return CommonUtil.get_card_name(self.m_num)
end

--设置选中
function Card:SetState(state)
	self.m_curState = state
	self.m_stateHandle:SetStateEx(state)
end

function Card:GetState()
	return self.m_curState
end

function Card:OnClick()
	local state = self:GetState() + math.random(1,2)
	-- logWarn("card click -- "..self.m_num..' state - '..self.m_curState)
	if state > CardState.Lock then
		state = CardState.Normal
	end
	self.m_parent:OnClick(self)
	self:SetState(state)
end

function Card:OnDragBegin(eventData)
	-- logWarn("OnDragBegin- x="..eventData.position.x..' y='..eventData.position.y)

	self.m_parent:OnDragBegin(self, eventData)
end

function Card:OnDrag(eventData)
	-- logWarn("OnDraging- x="..eventData.position.x..' y='..eventData.position.y)

	self.m_parent:OnDrag(self, eventData)
end

function Card:OnDragEnd(eventData)
	-- logWarn("OnDragEnd- x="..eventData.position.x..' y='..eventData.position.y)

	self.m_parent:OnDragEnd(self, eventData)
end