-- FYMJCtrl.lua
-- Author : Dzq
-- Date : 2017-05-23
-- Last modification : 2017-05-25
-- Desc: 模块启动必须的Ctrl

FYMJCtrl = Class(BaseCtrl);

function FYMJCtrl:Ctor()
	self.m_id = "FYMJCtrl"
	self.m_panelName = "FYMJPanel"
	-- log("FYMJCtrl Ctor---->>>")
end

function FYMJCtrl:StartModule(modInfo)
	-- log("start module -------------------->> "..self.m_modName.." modInfo -- "..tostring(modInfo))
	local roomInfo = modInfo
	RoomMgr.Init(roomInfo)
end
