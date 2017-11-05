-- MainCtrl.lua
-- Author : Dzq
-- Date : 2017-05-23
-- Last modification : 2017-05-23
-- Desc: MainCtrl

MainCtrl = Class(BaseCtrl);

function MainCtrl:Ctor()
	--自动会走基类的Ctor构造函数
	self.m_id = "MainCtrl"
	self.m_panelName = "MainPanel"
	--log("MainCtrl Ctor---->>>")
end

function MainCtrl:StartModule(tbl)
	-- log("start module -------------------->> "..self.m_modName)
	local ctrl = nil
	if tbl and tbl.isBackLobby then
		ctrl = CtrlMgr.Get(Main_Ctrl.LobbyCtrl)
	else
		ctrl = CtrlMgr.Get(Main_Ctrl.LoginCtrl)
	end
	ctrl:OnStart()
end

function MainCtrl:OnShowLoginPanel()
	UIMgr.Open(Main_Panel.LoginPanel)
end

function MainCtrl:OnChangeScreen()
end

