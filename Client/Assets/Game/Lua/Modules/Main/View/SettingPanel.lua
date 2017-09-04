-- SettingPanel.lua
-- Author : Dzq
-- Date : 2017-08-29
-- Last modification : 2017-08-29
-- Desc: 设置界面

SettingPanel = Class(BasePanel);

function SettingPanel:Ctor()
	-- self.m_comp.btnGuest = UIButtonEx
	-- self.m_comp.btnChat = UIButtonEx
end

function SettingPanel:OnInit()
	-- self.m_comp.btnGuest:AddLuaClick(self.OnGuestClick, self)
	-- self.m_comp.btnChat:AddLuaClick(self.OnWechatClick, self)
end

function SettingPanel:OnShowDeal()
	log("SettingPanel:OnShowDeal -- ")
end

