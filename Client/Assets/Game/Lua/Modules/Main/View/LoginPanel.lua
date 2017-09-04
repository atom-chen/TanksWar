-- LoginPanel.lua
-- Author : Dzq
-- Date : 2017-05-19
-- Last modification : 2017-05-18
-- Desc: 登录Panel

require 'Modules/Main/View/Item/LoginItem1'
require 'Modules/Main/View/Item/LoginItem2'

LoginPanel = Class(BasePanel);

function LoginPanel:Ctor()
	self.m_comp.btnGuest = UIButtonEx
	self.m_comp.btnChat = UIButtonEx
	self.m_comp.btnDeal = UIButtonEx
	self.m_comp.togDeal = UIButtonEx
end

function LoginPanel:OnInit()
	self.m_comp.btnGuest:AddLuaClick(self.OnGuestClick, self)
	self.m_comp.btnChat:AddLuaClick(self.OnWechatClick, self)
	self.m_comp.btnDeal:AddLuaClick(self.OnShowDeal, self)
end

function LoginPanel:OnShowDeal()
	log("LoginPanel:OnShowDeal -- ")
end

function LoginPanel:CanLogin()
	local state = self.m_comp.togDeal.CurStateIdx
	if state == 0 then
		logError(Lang.agreeProto)
		return false
	end
	return true;
end

function LoginPanel:OnWechatClick()
	if self:CanLogin() then
		self.m_ctrl:OnWechatLogin()	
	end
end

function LoginPanel:OnGuestClick()
	if self:CanLogin() then
		self.m_ctrl:OnGuestLogin()
	end
end

