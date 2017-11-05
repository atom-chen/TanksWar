-- BaseItem.lua
-- Author : Dzq
-- Date : 2017-07-25
-- Last modification : 2017-10-23
-- Desc: BaseItem
BaseItem = Class();
  
function BaseItem:Ctor(go)
	self.m_go = go
	self.m_comp = {}
	self.msgIdList = {}
end

function BaseItem:Init(param)
	local itemDefine = util.Clone(self.m_comp)
	util.GetMonoTable(self.m_go,itemDefine,self.m_comp)
	self:OnInit(param)
end

function BaseItem:SetActive(bShow)
	self.m_go:SetActive(bShow)
end

function BaseItem:IsActive()
	return self.m_go.activeSelf
end

function BaseItem:GetComponent(comp)
	return self.m_go:GetComponent(comp)
end

function BaseItem:AddEvent(msgID, callback, tbl)
	if (type(msgID) == "number") then
		msgID = tostring(msgID)
	end
	Event.AddListener(msgID, callback, tbl);
	local data = {}
	data.msgID = msgID
	data.callback = callback
	self.msgIdList[#self.msgIdList + 1] = data
end

function BaseItem:RemoveEvent(msgID)
	for i=1, #self.msgIdList do
		if self.msgIdList[i].msgID == msgID then
			Event.RemoveListener(self.msgIdList[i].msgID, self.msgIdList[i].callback)
			self.msgIdList[i] = nil
			break
		end
	end
end


function BaseCtrl:UnLoad( )
	for i=1, #self.msgIdList do
		Event.RemoveListener(self.msgIdList[i].msgID, self.msgIdList[i].callback)
	end
	self.msgIdList = {}
end
