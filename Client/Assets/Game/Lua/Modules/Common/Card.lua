-- Card.lua
-- Author : Dzq
-- Date : 2017-10-09
-- Last modification : 2017-10-09
-- Desc: 牌


Card = Class();
  
function Card:Ctor(go)
	-- util.Log("Card:Ctor --- "..tostring(go))
	self.m_go = go
	self.m_tran = self.m_go.transform
	self.m_rectTran = self.m_go:GetComponent("RectTransform")
	self.m_uv = false
	self.m_stateHandle = false
	self.m_simpleHandle = false
	self.m_curState = CardState.Normal
	self.m_type = ContainerType.NONE
	self.m_parent = false
	self.m_num = false
	self.m_isVaild = false
	self.m_childGo = false
	self.m_idx = false	--排序 整理牌是用
end

function Card:Init(contanier)
	-- self.m_go.gameObject.name = "card"..id
	self.m_parent = contanier
	self.m_type = contanier.m_type
	self.m_tran.localPosition = Vector3.zero
	self.m_tran.localRotation = Quaternion.Euler(0,0,0)
	
	--自己手牌需要多设置一层 用于控制牌
	local cardUV = self.m_go.transform:Find("p/card")
	if cardUV ~= nil then
		self.m_childGo = cardUV.gameObject
		self.m_uv = util.AddComponentIfNoExist(self.m_childGo, typeof(UVTools))
	end

	if self.m_parent:IsMyHandsCard() then
		-- logWarn("自己手牌--")
		self.m_stateHandle = util.AddComponentIfNoExist(self.m_go, typeof(StateHandle))

		self.m_stateHandle:AddLuaClick(self.OnClick, self)
		self.m_stateHandle:AddLuaDragBegin(self.OnDragBegin, self, false)
		self.m_stateHandle:AddLuaDrag(self.OnDrag, self, false)
		self.m_stateHandle:AddLuaDragEnd(self.OnDragEnd, self, false)
	end

	self.m_simpleHandle = self.m_go:GetComponent(typeof(SimpleHandle))
	self.m_simpleHandle.enabled = false

	-- util.Log("self.m_uv---"..tostring(self.m_uv).." type -- "..self.m_parent:GetType())

	self.m_tran.localScale = Vector3.one
	if not self.m_go.activeSelf then
		self:SetActive(true)
	end
end

function Card:SetScale(scale)
	if self.m_go then
		self.m_tran.localScale = scale
	end
end

function Card:SetActive(bShow)
	self.m_go:SetActive(bShow)
end

function Card:IsActive()
	if self.m_simpleHandle then
		self.m_simpleHandle.enabled = false
	end
	return self.m_go.activeSelf
end

function Card:SetPos(pos)
	if self.m_go then
		self.m_tran.localPosition = pos
	end
end

function Card:SetRot(rot)
	if self.m_go then
		self.m_tran.localEulerAngles = rot
	end
end

function Card:SetRect(rect)
	if self.m_go and self.m_rectTran then
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

function Card:GetRot()
	return self.m_tran.localEulerAngles
end

function Card:GetRect()
	if self.m_rectTran then
		return self.m_rectTran.sizeDelta
	end
end

function Card:GetGameObject()
	return self.m_go
end

function Card:SetIdx(idx)
	self.m_idx = idx
end

function Card:GetIdx()
	return self.m_idx
end

function Card:MoveTo(posX)
	if not self.m_go or not self:IsActive() then
		return
	end
	iTween.MoveTo(self.m_go, iTween.Hash("x", posX, "islocal", true, "time", ViewCfg.CardMoveTime))
end

function Card:PlayMoveAni(x)
	if not self.m_go or not self:IsActive() then
		return
	end

	local oldPos = self:GetPos()

	if self.m_parent:IsMySelfCard() then
		iTween.MoveTo(self.m_go, iTween.Hash("y", oldPos.y+ViewCfg.CardUpHight, "islocal", true, "time", ViewCfg.CardUpAniTime))
		coroutine.wait(ViewCfg.CardUpWaitTime)
		self:SetRot(Vector3.New(0, 0, -15))
		iTween.MoveTo(self.m_go, iTween.Hash("x", x, "islocal", true, "time", ViewCfg.CardCrossAniTime))
		coroutine.wait(ViewCfg.CardCrossWaitTime)
		self:SetRot(Vector3.New(0, 0, 0))
		iTween.MoveTo(self.m_go, iTween.Hash("y", oldPos.y, "islocal", true, "time", ViewCfg.CardDownTime))
	else
		iTween.MoveTo(self.m_go, iTween.Hash("z", oldPos.y+ViewCfg.CardUpHight, "islocal", true, "time", ViewCfg.CardUpAniTime))
		coroutine.wait(ViewCfg.CardUpWaitTime)
		self:SetRot(Vector3.New(0, 15, 0))
		iTween.MoveTo(self.m_go, iTween.Hash("x", x, "islocal", true, "time", ViewCfg.CardCrossAniTime))
		coroutine.wait(ViewCfg.CardCrossWaitTime)
		self:SetRot(Vector3.New(0, 0, 0))
		iTween.MoveTo(self.m_go, iTween.Hash("z", oldPos.y, "islocal", true, "time", ViewCfg.CardDownTime))
	end
end

--播放发牌动画
function Card:PlayDealAni()
	if not self.m_go or not self:IsActive() then
		return
	end
	-- 简单动画直接用iTween播
	self:SetRot(Vector3.New(-90, 0, 0))	---设为初始牌背
	iTween.RotateBy(self.m_go, iTween.Hash("x", 0.25, "delay", ViewCfg.DealPlayAniTime))
end

--播放整理牌动画
function Card:PlaySortAni1()
	if not self.m_go or not self:IsActive() then
		return
	end
	iTween.RotateBy(self.m_go, Vector3.New(-0.25, 0, 0), ViewCfg.SortAni1Time)
end

function Card:PlaySortAni2()
	if not self.m_go or not self:IsActive() then
		return
	end
	iTween.RotateBy(self.m_go, Vector3.New(0.25, 0, 0), ViewCfg.SortAni2Time)
end

function Card:PlayOpenAni()
	if not self.m_go or not self:IsActive() then
		return
	end
	self:SetRot(Vector3.New(0, 0, 0))
	iTween.RotateBy(self.m_go, iTween.Hash("x", 0.25, "delay", ViewCfg.DealPlayAniTime))
end

--播放摸牌动画
function Card:PlayMoAni()
	if not self.m_go or not self:IsActive() then
		return
	end

	if self.m_simpleHandle then
		self.m_simpleHandle:ResetStop()
		self.m_simpleHandle.enabled = true
		self.m_simpleHandle:ResetPlay()
	end
end

function Card:Destroy()
	destroy(self.m_go)
	self.m_go = false
end

--设置牌值
function Card:SetCard(num)
	-- util.Log("SetCard -- "..num)
	if not num or num == 0 then	----牌可以没值
		return
	end
	self.m_num = num
	local ny, nx = util.GetUVPosByCard(self.m_num)
	-- log(self:GetName()..' ny -- '..ny..' nx -- '..nx)

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

function Card:GetName()
	return CommonUtil.get_card_name(self.m_num)
end

--设置选中
function Card:SetState(state)
	self.m_parent:ResetState()
	self.m_curState = state
	self.m_stateHandle:SetStateEx(state)
end

function Card:GetState()
	return self.m_curState
end

function Card:ResetState()
	self.m_curState = CardState.Normal
	self.m_stateHandle:SetStateEx(CardState.Normal)
end

function Card:OnClick()
	
	if self.m_curState == CardState.Select then
		self.m_parent:OnClick(self)
		return
	end
	self:SetState(CardState.Select)
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