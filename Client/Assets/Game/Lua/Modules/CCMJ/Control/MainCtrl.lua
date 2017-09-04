-- MainCtrl.lua
-- Author : Dzq
-- Date : 2017-05-23
-- Last modification : 2017-05-25
-- Desc: 模块启动必须的Ctrl

MainCtrl = Class(BaseCtrl);

function MainCtrl:Ctor()
	Super:Ctor()
	self.m_id = "MainCtrl"
	self.m_panelName = "MainPanel"
	log("MainCtrl Ctor---->>>")
end

function MainCtrl:StartModule()
	log("start module -------------------->> "..self.m_modName)
end
