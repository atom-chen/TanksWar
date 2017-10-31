ShopCtrl = Class(BaseCtrl);

function ShopCtrl:Ctor()
	--自动会走基类的Ctor构造函数
	self.m_id = "ShopCtrl"
	self.m_panelName = "ShopPanel"
	--log("LobbyCtrl Ctor---->>>")
end

function ShopCtrl:OnInit()
     
end

function ShopCtrl:OnStart(data)
	UIMgr.Open(Main_Panel.ShopPanel)
end