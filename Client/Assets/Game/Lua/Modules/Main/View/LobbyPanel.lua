-- LobbyPanel.lua
-- Author : Dzq
-- Date : 2017-08-17
-- Last modification : 2017-08-17
-- Desc: 模块开始启动必须的界面
require 'Modules/Main/View/Item/LobbyItem'
LobbyPanel = Class(BasePanel);

function LobbyPanel:Ctor()
	
	--log("LobbyPanel Ctor---->>>")
	self.m_comp.imgHead = UIImageEx
	-- self.m_comp.txtName = UITextEx
	-- self.m_comp.txtGold = UITextEx
	-- self.m_comp.txtDiamond = UITextEx
	-- self.m_comp.btnSetting = UIButtonEx
	self.m_comp.btnEntter = UIButtonEx
	-- self.m_comp.btnHead = UIButtonEx
	-- self.m_comp.groupGame = UIGroup

end

function LobbyPanel:OnInit()
	-- self.m_comp.btnAddDiamond:AddLuaClick(self.ClickAddDiamond, self)
	-- self.m_comp.btnReferer:AddLuaClick(self.ClickReferer, self)
	-- self.m_comp.btnReality:AddLuaClick(self.ClickReality, self)
	-- self.m_comp.btnInvite:AddLuaClick(self.ClickInvite, self)
	-- self.m_comp.btnShop:AddLuaClick(self.ClickShop, self)
	-- self.m_comp.btnShare:AddLuaClick(self.ClickShare, self)
	-- self.m_comp.btnRule:AddLuaClick(self.ClickRule, self)
	-- self.m_comp.btnScore:AddLuaClick(self.ClickScore, self)
	-- self.m_comp.btnActivity:AddLuaClick(self.ClickActivity, self)
	-- self.m_comp.btnMsg:AddLuaClick(self.ClickMsg, self)
	-- self.m_comp.btnSetting:AddLuaClick(self.ClickSetting, self)
	self.m_comp.btnEntter:AddLuaClick(self.ClickEntter, self)
	-- self.m_comp.btnHead:AddLuaClick(self.ClickHead, self)


	--  游戏玩法配置
	
end

function LobbyPanel:ClickAddDiamond()
	local cxt = {
		msgType = 2,
		okTxt = "@确定",
		cancelTxt = "#取消",
		onOk = self.OnMsgOk,
		onCancel = self.OnMsgCancel,
		title = "#标题#",
		content = "功能暂未开放",
		tbl = self,
	}
	UIMgr.Open(Common_Panel.MsgPanel, cxt)
end

function LobbyPanel:OnMsgOk()
	UIMgr.Open(Common_Panel.TipsPanel, "点击了OK按钮")
end

function LobbyPanel:OnMsgCancel()
	UIMgr.Open(Common_Panel.TipsPanel, "点击了Cancel按钮")
end

function LobbyPanel:ClickReferer()
	UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
end

function LobbyPanel:ClickReality()
	UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
end

function LobbyPanel:ClickInvite()
	UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
end

function LobbyPanel:ClickShop()
	UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
end

function LobbyPanel:ClickShare()
	UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
end

function LobbyPanel:ClickRule()
	UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
end

function LobbyPanel:ClickScore()
	UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
end

function LobbyPanel:ClickActivity()
	UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
end

function LobbyPanel:ClickMsg()
	UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
end

function LobbyPanel:ClickSetting()
	UIMgr.Open(Main_Panel.SettingPanel)
end

function LobbyPanel:ClickEntter()
	local sceneId = 1000
	SceneMgr.ChangeScene(sceneId)
end

function LobbyPanel:ClickHead()
	UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
end

function LobbyPanel:OnOpen()
    
	-- local itemCount = GameCfg.GetGameCount()
	-- self.m_comp.groupGame:SetCount(itemCount)
	-- for i = 0, itemCount-1 do 
	-- 	local go = self.m_comp.groupGame:Get(i)
	-- 	local data = GameCfg.GetById(i+1)
	-- 	item = LobbyItem.New(go)
	-- 	item:Init(data)
	-- end

end

function LobbyPanel:OnClose()
	--log("LobbyPanel OnClose---->>>")
end
