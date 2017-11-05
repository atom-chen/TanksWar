HelpCtrl = Class(BaseCtrl);

function HelpCtrl:Ctor()
	--自动会走基类的Ctor构造函数
	self.m_id = "HelpCtrl"
	self.m_panelName = "HelpPanel"
	--log("LobbyCtrl Ctor---->>>")
end

function HelpCtrl:OnInit()
     
end
