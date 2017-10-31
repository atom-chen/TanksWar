-- CtrlMgr.lua
-- Author : Dzq
-- Date : 2017-08-28
-- Last modification : 2017-08-28
-- Desc: 自己玩家类


Player = Class(BasePlayer);

function Player:Ctor()
	self.m_curChuCardItem = {}
	self.m_curOpt = {}
	-- log('Player:Ctor ------ ')
end

function Player:OnInit()
	-- log('Player:OnInit ------ ')
end

function Player:GetSit()
	return 1
end

function Player:OnEnterRoom()
	log("Player:OnEnterRoom -- ")
end

function Player:OnLeaveRoom()
	log("Player:OnLeaveRoom -- ")
end

function Player:OnReady(tbl)
	log("Player:OnReady ---- ")
end

function Player:OnLeave(tbl)
	log("Player:OnLeave ---- ")
end

function Player:OnOffline(tbl)
	self.m_info.bOnline = false
	log("Player:OnOffline ---- ")
end

function Player:OnOnLine(tbl)
	self.m_info.bOnline = true
	log("Player:OnOnLine ---- ")
end

function Player:OnAction(tbl)
	log("myself on action "..tbl.opt)
end

function Player:OnOperate(tbl)
	log("myself OnOperate ---- "..cjson.encode(tbl))
	self.m_curOpt = tbl

	local tablePanel = UIMgr.Get(_G[Game.CurMod.."_Panel"].TablePanel)
	tablePanel:ShowOpt(self.m_curOpt)
end

function Player:OnActionChu(tbl)
	log("my OnActionChu--")
	self.m_container[ContainerType.PUT]:AddCard(self.m_curChuCardItem:GetCard())
	self.m_container[ContainerType.HAND]:RemoveCard(self.m_curChuCardItem)
end

function Player:OnActionMo(tbl)
	log("my OnActionMo--")
	self.m_container[ContainerType.HAND]:AddCard(tbl.cid)
end

function Player:OnActionChi(tbl)
	log("my OnActionChi--")
end

function Player:OnActionPeng(tbl)
	log("my OnActionPeng--")
end

function Player:OnActionAn(tbl)
	log("my OnActionAn--")
end

function Player:OnActionJie(tbl)
	log("my OnActionJie--")
end

function Player:OnActionGong(tbl)
	log("my OnActionGong--")
end

function Player:OnChat(tbl)
	log("Player:OnChat ---- ")
end

function Player:OnRespondDeaprt(tbl)
	log("Player:OnRespondDeaprt ---- ")
end

function Player:OnUpdate(tbl)

end

function Player:ChuCard(card)
	coroutine.start(function()
		local data = {}
		data.opt = OperationType.CHU
		data.cid = card:GetCard()
		data.cids = {}
	    local res = NetWork.Request(proto.fy_action, data)
	    if res.code == 0 then
	        log("出牌----")
	        self.m_curChuCardItem = card
	    else
	        UIMgr.Open(Common_Panel.TipsPanel, res.msg)
	    end
	end)
end

function Player:OnSendAction(aid)
	coroutine.start(function()
		local data = {}
		data.opt = aid
	    local res = NetWork.Request(proto.fy_action, data)
	    if res.code == 0 then
	    	log("send action aid -- "..aid)
	    else
	        UIMgr.Open(Common_Panel.TipsPanel, res.msg)
	    end
	end)
end

function Player:GetCurOpt()
	return self.m_curOpt
end

function Player:HasOprate(optType)
	local curOpt = self:GetCurOpt()
	for i=1, #curOpt do
		if curOpt[i].opt == optType then
			return true
		end
	end
	return false
end

----初始化牌
function Player:OnInitCards()

end

