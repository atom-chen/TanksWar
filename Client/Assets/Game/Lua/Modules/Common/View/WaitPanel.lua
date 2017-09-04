-- WaitPanel.lua
-- Author : Dzq
-- Date : 2017-08-18
-- Last modification : 2017-08-18
-- Desc: 等待界面

WaitPanel = Class(BasePanel);

local showTime = 1

local co = nil
local waitTime = 5

function WaitPanel:Ctor()
	self.m_comp.goCenter = GameObject
	self.m_openAniName = ""
	self.m_closeAniName = ""
	-- logWarn("WaitPanel:Ctor----------")
end

function WaitPanel:OnInit()
end

function WaitPanel:OnOpen(param)
	--log("WaitPanel OnOpen---->>>")
	if not param then
		waitTime = 5
	else
		if type(param) ~= "number" then
			logWarn("WaitPanel参数不正确，应为number类型")
			waitTime = 5
		else
			waitTime = param
		end
	end
	
	if co ~= nil then
		coroutine.stop(co)
	end

	self.m_comp.goCenter:SetActive(false)
	co = coroutine.start(self.CoClose, self)
end

function WaitPanel:CoClose()
	coroutine.wait(0.3)	--延迟一下显示 可能网络消息非常快
	self.m_comp.goCenter:SetActive(true)
	coroutine.wait(waitTime)
	co = nil
	self:Close()
end

function WaitPanel:OnClose()
	self.m_comp.goCenter:SetActive(false)
	if co ~= nil then
		coroutine.stop(co)
	end
	co = nil
end
