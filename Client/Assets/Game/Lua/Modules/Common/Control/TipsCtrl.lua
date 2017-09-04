-- TipsCtrl.lua
-- Author : Dzq
-- Date : 2017-08-18
-- Last modification : 2017-08-18
-- Desc: TipsCtrl

TipsCtrl = Class(BaseCtrl);

function TipsCtrl:Ctor()
	--自动会走基类的Ctor构造函数
	self.m_id = "TipsCtrl"
	self.m_panelName = "TipsPanel"
	-- logWarn("TipsCtrl Ctor---->>>")
end

function TipsCtrl:OnInit()

end

