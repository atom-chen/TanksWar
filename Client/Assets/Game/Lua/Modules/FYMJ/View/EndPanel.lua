-- Author : Dzq
-- Date : 2017-11-11
-- Last modification : 2017-11-11
-- Desc: 结算界面信息

require 'Modules/FYMJ/View/Item/EndItem'

EndPanel = Class(BasePanel)

function EndPanel:Ctor()
	self.m_openAniName = ""
	self.m_closeAniName = ""

	self.m_comp.infoView = GameObject
	self.m_comp.bottomGo = GameObject
	self.m_comp.btnRestart = ButtonEx
	self.m_comp.btnShowTable = ButtonEx
	self.m_comp.btnShowScore = ButtonEx

	self.m_comp.player1Go = GameObject
	self.m_comp.player2Go = GameObject
	self.m_comp.player3Go = GameObject
	self.m_comp.player4Go = GameObject

	self.m_itemList = {}

	-- logWarn("EndPanel:Ctor ---- ")
end

function EndPanel:OnInit()
	self.m_comp.btnRestart:AddLuaClick(self.OnRestartClick, self)
	self.m_comp.btnShowTable:AddLuaClick(self.OnShowTableClick, self)
	self.m_comp.btnShowScore:AddLuaClick(self.OnShowScoreClick, self)

	self:AddEvent(Msg.OnEndShow, self.OnGameEnd, self)

	-- logWarn("EndPanel:OnInit ---- ")
end

function EndPanel:OnGameEnd(tbl)

	for k,v in pairs(tbl.score) do
		local p = PlayerMgr.Get(k)
		if p then
			log("显示结算界面 item--"..p:GetName())
			local item = EndItem.New(self.m_comp["player"..p:GetSit().."Go"])
			self.m_itemList[k] = item
			item:Init(v)
		else
			logError("未找到玩家--"..k)
		end
	end
end
function EndPanel:OnRestartClick()
	log("OnRestartClick --- ")
	self:Close()
	coroutine.start(function()
		local res = NetWork.Request(proto.fy_ready)
		if res.code == 0 then
			log("发送准备成功")
		else
			UIMgr.Open(Common_Panel.TipsPanel, res.msg)
		end
	end)
end

function EndPanel:OnShowTableClick()
	log("OnShowTableClick --- ")
end

function EndPanel:OnShowScoreClick()
	log("OnShowScoreClick --- ")
end

function EndPanel:OnOpen()

end

function EndPanel:OnClose()
	-- log("EndPanel OnClose---->>>")
end

function EndPanel:OnUpdate()
	-- log("EndPanel OnUpdate---->>>")
end

function EndPanel:OnFresh()
	-- log("EndPanel OnFresh---->>>")
end

function EndPanel:OnDestroy()
	-- log("EndPanel OnDestroy---->>>")
end
