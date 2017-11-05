-- SettingCtrl.lua
-- Author : Dzq
-- Date : 2017-08-29
-- Last modification : 2017-08-29
-- Desc: SettingCtrl 设置管理

SettingCtrl = Class(BaseCtrl);

function SettingCtrl:Ctor()
	self.m_id = "SettingCtrl"
	self.m_modName = "Main"
	self.m_panelName = "SettingPanel"

	--log("SettingCtrl Ctor---->>>")
end

function SettingCtrl:OnInit()
end
