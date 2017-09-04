-- MainPanel.lua
-- Author : Dzq
-- Date : 2017-05-25
-- Last modification : 2017-05-26
-- Desc: 模块开始启动必须的界面

MainPanel = Class(BasePanel);

function MainPanel:Ctor()
	----定义组件 都存在self.m_comp中
	
	self.m_comp.desc = UITextEx
	self.m_comp.icon = UIImageEx
	self.m_comp.btnWeChat = UIButtonEx
	self.m_comp.btnLogin = UIButtonEx
	--log("MainPanel Ctor---->>>")
end

function MainPanel:OnInit()
	self.m_comp.desc.text = tostring('初始化------设置text')
	self.m_comp.btnWeChat:AddLuaClick(self.OnWechatClick, self)
	self.m_comp.btnLogin:AddLuaClick(self.m_ctrl.OnShowLoginPanel, self.m_ctrl)
end

function MainPanel:OnWechatClick()
	--logWarn("on click wechat btn")
	self.m_comp.icon:Set("ui_Main_bangzhu")
end

function MainPanel:OnOpen()
	--log("MainPanel OnOpen---->>>")
end

function MainPanel:OnClose()
	--log("MainPanel OnClose---->>>")
end

function MainPanel:OnUpdate()
	--log("MainPanel OnUpdate---->>>")
end

function MainPanel:OnFresh()
	--log("MainPanel OnFresh---->>>")
end

function MainPanel:OnDestroy()
	--log("MainPanel OnDestroy---->>>")
end

function MainPanel.OnBtnClick()
	--log("微信按钮点击----")
end
