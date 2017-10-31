-- LobbyPanel.lua
-- Author : Dzq
-- Date : 2017-08-17
-- Last modification : 2017-08-17
-- Desc: 模块开始启动必须的界面
require 'Modules/Main/View/Item/LobbyItem'
LobbyPanel = Class(BasePanel);

function LobbyPanel:Ctor()
	
	--log("LobbyPanel Ctor---->>>")
	self.m_comp.imgHead = ImageEx
	self.m_comp.txtName = TextEx
	self.m_comp.txtGold = TextEx
	self.m_comp.txtDiamond = TextEx
	self.m_comp.btnAddDiamond = ButtonEx
	self.m_comp.btnReferer = ButtonEx
	self.m_comp.btnReality = ButtonEx
	self.m_comp.btnInvite = ButtonEx
	self.m_comp.btnShop = ButtonEx
	self.m_comp.btnShare = ButtonEx
	self.m_comp.btnRule = ButtonEx
	self.m_comp.btnScore = ButtonEx
	self.m_comp.btnActivity = ButtonEx
	self.m_comp.btnMsg = ButtonEx
	self.m_comp.btnSetting = ButtonEx
	self.m_comp.btnEntter = ButtonEx
	self.m_comp.btnHead = ButtonEx
	self.m_comp.groupGame = UIGroup

end

function LobbyPanel:OnInit()
	self.m_comp.btnAddDiamond:AddLuaClick(self.ClickAddDiamond, self)
	self.m_comp.btnReferer:AddLuaClick(self.ClickReferer, self)
	self.m_comp.btnReality:AddLuaClick(self.ClickReality, self)
	self.m_comp.btnInvite:AddLuaClick(self.ClickInvite, self)
	self.m_comp.btnShop:AddLuaClick(self.ClickShop, self)
	self.m_comp.btnShare:AddLuaClick(self.ClickShare, self)
	self.m_comp.btnRule:AddLuaClick(self.ClickRule, self)
	self.m_comp.btnScore:AddLuaClick(self.ClickScore, self)
	self.m_comp.btnActivity:AddLuaClick(self.ClickActivity, self)
	self.m_comp.btnMsg:AddLuaClick(self.ClickMsg, self)
	self.m_comp.btnSetting:AddLuaClick(self.ClickSetting, self)
	self.m_comp.btnEntter:AddLuaClick(self.ClickEntter, self)
	self.m_comp.btnHead:AddLuaClick(self.ClickHead, self)

	-- 开启模块设置
	self.m_comp.btnAddDiamond.gameObject:SetActive(OpenCfg.Shop)
	self.m_comp.btnReferer.gameObject:SetActive(OpenCfg.Referer)
	self.m_comp.btnReality.gameObject:SetActive(OpenCfg.Reality)
	self.m_comp.btnInvite.gameObject:SetActive(OpenCfg.Invite)
	self.m_comp.btnShop.gameObject:SetActive(OpenCfg.Shop)
	self.m_comp.btnShare.gameObject:SetActive(OpenCfg.Share)
	self.m_comp.btnRule.gameObject:SetActive(OpenCfg.Rule)
	self.m_comp.btnScore.gameObject:SetActive(OpenCfg.Score)
	self.m_comp.btnActivity.gameObject:SetActive(OpenCfg.Activity)
	self.m_comp.btnMsg.gameObject:SetActive(OpenCfg.Msg)
	self.m_comp.btnSetting.gameObject:SetActive(OpenCfg.Setting)
	--  游戏玩法配置
	
end

function LobbyPanel:ClickAddDiamond()
	-- local cxt = {
	-- 	msgType = 2,
	-- 	okTxt = "@确定",
	-- 	cancelTxt = "#取消",
	-- 	onOk = self.OnMsgOk,
	-- 	onCancel = self.OnMsgCancel,
	-- 	title = "#标题#",
	-- 	content = "功能暂未开放",
	-- 	tbl = self,
	-- }
	-- UIMgr.Open(Common_Panel.MsgPanel, cxt)
	UIMgr.Open(Main_Panel.ShopPanel)
end

function LobbyPanel:OnMsgOk()
	UIMgr.Open(Common_Panel.TipsPanel, "点击了OK按钮")
end

function LobbyPanel:OnMsgCancel()
	UIMgr.Open(Common_Panel.TipsPanel, "点击了Cancel按钮")
end

function LobbyPanel:ClickReferer()
	UIMgr.Open(Main_Panel.ReferrerPanel)
end

function LobbyPanel:ClickReality()
    UIMgr.Open(Main_Panel.CertificatePanel)
end

function LobbyPanel:ClickInvite()
	UIMgr.Open(Main_Panel.InvitePanel)
end

function LobbyPanel:ClickShop()
	-- UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
	UIMgr.Open(Main_Panel.ShopPanel)
end

function LobbyPanel:ClickShare()
	-- UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
	UIMgr.Open(Main_Panel.SharePanel)
end

--打开玩法界面
function LobbyPanel:ClickRule()
	UIMgr.Open(Main_Panel.HelpPanel)
end

function LobbyPanel:ClickScore()
	UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
end

function LobbyPanel:ClickActivity()
	-- UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
	UIMgr.Open(Main_Panel.ActivityPanel)
end

function LobbyPanel:ClickMsg()
	UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
end

function LobbyPanel:ClickSetting()
	UIMgr.Open(Main_Panel.SettingPanel)
end

function LobbyPanel:ClickEntter()
	UIMgr.Open(Main_Panel.JoinPanel)
end

function LobbyPanel:ClickHead()
	UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
end

function LobbyPanel:OnOpen()
	local itemCount = GameCfg.GetGameCount()
	self.m_comp.groupGame:SetCount(itemCount)
	for i = 0, itemCount-1 do 
		local go = self.m_comp.groupGame:Get(i)
		local data = GameCfg.Cfg[i+1]
		item = LobbyItem.New(go)
		item:Init(data)
	end

	local myself = PlayerMgr.GetMyself()
	if myself then
		self.m_comp.txtName.text = myself:GetName()
		self.m_comp.txtGold.text = myself:GetGold()
		self.m_comp.txtDiamond.text = myself:GetDiamond()
	end
end

function LobbyPanel:OnClose()
	--log("LobbyPanel OnClose---->>>")
end
