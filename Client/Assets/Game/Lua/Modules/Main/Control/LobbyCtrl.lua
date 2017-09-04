-- LobbyCtrl.lua
-- Author : Dzq
-- Date : 2017-08-17
-- Last modification : 2017-08-17
-- Desc: LobbyCtrl

LobbyCtrl = Class(BaseCtrl);

function LobbyCtrl:Ctor()
	--自动会走基类的Ctor构造函数
	self.m_id = "LobbyCtrl"
	self.m_panelName = "LobbyPanel"
	--log("LobbyCtrl Ctor---->>>")
end

function LobbyCtrl:OnInit()

end

function LobbyCtrl:OnStart(data)
	UIMgr.Open(Main_Panel.LobbyPanel)
end

