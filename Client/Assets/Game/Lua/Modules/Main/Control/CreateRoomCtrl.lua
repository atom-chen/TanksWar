
CreateRoomCtrl = Class(BaseCtrl);

function CreateRoomCtrl:Ctor()
	--自动会走基类的Ctor构造函数
	self.m_id = "CreateRoomCtrl"
	self.m_panelName = "CreateRoomPanel"
	--log("LobbyCtrl Ctor---->>>")
end

function CreateRoomCtrl:OnInit()
     
end

function CreateRoomCtrl:OnStart(data)
	UIMgr.Open(Main_Panel.CreateRoomPanel)
end

-- function CreateRoomCtrl:OnUpdate( ... )
-- 	-- body
-- end
