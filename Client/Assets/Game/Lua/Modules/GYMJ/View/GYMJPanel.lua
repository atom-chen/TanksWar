-- GYMJPanel.lua
-- Author : Dzq
-- Date : 2017-05-25
-- Last modification : 2017-05-25
-- Desc: 模块开始启动必须的界面

GYMJPanel = Class(BasePanel);

function GYMJPanel:Ctor()
	log("GYMJPanel Ctor---->>>")
end

function GYMJPanel:OnOpen()
	log("GYMJPanel OnOpen---->>>")
end

function GYMJPanel:OnClose()
	log("GYMJPanel OnClose---->>>")
end

function GYMJPanel:OnUpdate()
	log("GYMJPanel OnUpdate---->>>")
end

function GYMJPanel:OnFresh()
	log("GYMJPanel OnFresh---->>>")
end

function GYMJPanel:OnDestroy()
	log("GYMJPanel OnDestroy---->>>")
end
