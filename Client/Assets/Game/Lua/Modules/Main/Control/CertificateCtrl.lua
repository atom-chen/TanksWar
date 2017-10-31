CertificateCtrl = Class(BaseCtrl);

function CertificateCtrl:Ctor()
	--自动会走基类的Ctor构造函数
	self.m_id = "CertificateCtrl"
	self.m_panelName = "CertificatePanel"
	--log("LobbyCtrl Ctor---->>>")
end

function CertificateCtrl:OnInit()
     
end

function CertificateCtrl:OnStart(data)
	UIMgr.Open(Main_Panel.CertificatePanel)
end