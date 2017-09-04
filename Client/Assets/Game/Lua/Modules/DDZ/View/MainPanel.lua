-- MainPanel.lua
-- Author : Dzq
-- Date : 2017-05-25
-- Last modification : 2017-05-25
-- Desc: 模块开始启动必须的界面

MainPanel = Class(BasePanel);

function MainPanel:Ctor()
	log("MainPanel Ctor---->>>")
end

function MainPanel:OnOpen()
	log("MainPanel OnOpen---->>>")
end

function MainPanel:OnClose()
	log("MainPanel OnClose---->>>")
end

function MainPanel:OnUpdate()
	log("MainPanel OnUpdate---->>>")
end

function MainPanel:OnFresh()
	log("MainPanel OnFresh---->>>")
end

function MainPanel:OnDestroy()
	log("MainPanel OnDestroy---->>>")
end
