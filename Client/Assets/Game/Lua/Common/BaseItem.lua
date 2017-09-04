-- BaseItem.lua
-- Author : Dzq
-- Date : 2017-07-25
-- Last modification : 2017-08-29
-- Desc: BaseItem
BaseItem = Class();
  
function BaseItem:Ctor(go)
	self.m_go = go
	self.m_comp = {}
end

function BaseItem:Init(param)
	local itemDefine = util.Clone(self.m_comp)
	util.GetMonoTable(self.m_go,itemDefine,self.m_comp)
	self:OnInit(param)
end

function BaseItem:Panel()
	local parent = Util.GetRoot(self.m_go.transform.parent, "MonoTable")
	local panel = UIMgr.Get(parent.name)
	return panel
end
