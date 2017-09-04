-- TipsPanel.lua
-- Author : Dzq
-- Date : 2017-08-18
-- Last modification : 2017-08-18
-- Desc: 提示消息界面

TipsPanel = Class(BasePanel);

local showTime = 1

local co = nil

function TipsPanel:Ctor()
	self.m_comp.txtContext = UITextEx
	self.m_comp.goCenter = GameObject
	self.m_openAniName = ""
	self.m_closeAniName = ""
	self.m_canTop = false
	-- logWarn("TipsPanel:Ctor----------")
end

function TipsPanel:OnInit()
end

function TipsPanel:OnOpen(param)
	--log("TipsPanel OnOpen---->>>")
	if type(param) ~= "string" then
		logError("传入内容非字符串，无法显示")
		self:Close()
		return
	end

	if co ~= nil then
		coroutine.stop(co)
	end

	self.m_comp.goCenter:SetActive(false)
	self.m_comp.txtContext.text = param
	self.m_comp.goCenter:SetActive(true)
	co = coroutine.start(self.CoClose, self)
end

function TipsPanel:CoClose()
	coroutine.wait(showTime)
	self.m_comp.goCenter:SetActive(false)
	co = nil
	self:Close()
end

function TipsPanel:OnClose()
	self.m_comp.goCenter:SetActive(false)
	if co ~= nil then
		coroutine.stop(co)
	end
	co = nil
end
