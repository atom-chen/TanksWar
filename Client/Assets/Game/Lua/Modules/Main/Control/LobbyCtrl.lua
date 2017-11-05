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
	Game.IsReconnect = false
	local my = PlayerMgr.GetMyself()
	if my then
		local roomId = my:Get("roomId")
		if roomId and roomId ~= 0 then
			UIMgr.Open(Common_Panel.WaitPanel)
			logWarn("已加入房间 ："..roomId)
			Game.IsReconnect = true
			local joinCtrl = CtrlMgr.Get(Main_Ctrl.JoinCtrl)
			joinCtrl:JoinRoom(roomId)
		end
	end

	-- log("LobbyCtrl:OnStart------------"..type(data))
end

