-- GYMJCtrl.lua
-- Author : Dzq
-- Date : 2017-05-23
-- Last modification : 2017-05-25
-- Desc: 模块启动必须的Ctrl

GYMJCtrl = Class(BaseCtrl);

function GYMJCtrl:Ctor()
	Super:Ctor()
	self.m_id = "GYMJCtrl"
	self.m_panelName = "MainPanel"
	log("GYMJCtrl Ctor---->>>")
end

function GYMJCtrl:StartModule()
	log("start module -------------------->> "..self.m_modName)
end
