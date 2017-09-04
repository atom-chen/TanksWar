-- NoticeCtrl.lua
-- Author : Dzq
-- Date : 2017-08-18
-- Last modification : 2017-08-18
-- Desc: NoticeCtrl

NoticeCtrl = Class(BaseCtrl);

function NoticeCtrl:Ctor()
	--自动会走基类的Ctor构造函数
	self.m_id = "NoticeCtrl"
	self.m_panelName = "NoticePanel"
	-- log("NoticeCtrl Ctor---->>>")
end

function NoticeCtrl:OnInit()

end
