JoinRoomCtrl = Class(BaseCtrl);

function JoinRoomCtrl:Ctor()
	--自动会走基类的Ctor构造函数
	self.m_id = "JoinRoomCtrl"
	self.m_panelName = "JoinRoomPanel"
	--log("LobbyCtrl Ctor---->>>")
end

function JoinRoomCtrl:OnInit()
     
end

function JoinRoomCtrl:OnStart(data)
	UIMgr.Open(Main_Panel.JoinRoomPanel)
end