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
	log("退出房间 将房间id置为0")
	self.m_info.roomId = 0
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
	-- log("myself on action "..tbl.opt)
end

function Player:OnOperate(tbl)
	self.m_curOpt = tbl
	Event.Brocast(Msg.OnOperate, self.m_curOpt)
end

function Player:OnActionChu(tbl)
	-- log("my OnActionChu--")
	self.m_container[ContainerType.PUT]:AddCard(self.m_curChuCardItem:GetCard())
	self.m_container[ContainerType.HAND]:RemoveCard(self.m_curChuCardItem)
end

function Player:OnActionMo(tbl)
	-- log("my OnActionMo--")
	self.m_container[ContainerType.HAND]:AddCard(tbl.cid)
end

function Player:OnActionChi(tbl)
	log("my OnActionChi--")
end

function Player:OnActionPeng(tbl)
	log("my OnActionPeng--")
	local cardData = {
		cards = {tbl.cid, tbl.cid, tbl.cid},
		showType = CardShowType.PENG,
		otherId = tbl.fuserId
	}
	local target = PlayerMgr.Get(tbl.fuserId)
	if not target then
		util.LogError("没找到碰的人--fuserId--"..tostring(tbl.fuserId))
	else
		target:GetContainer(ContainerType.PUT):RemoveCardsEx()
	end

	self.m_container[ContainerType.CHI]:AddCardGroup(cardData)
	self.m_container[ContainerType.HAND]:RemoveCardsEx(tbl.cid, 2)	--碰牌需要扣除两个手牌
end

function Player:OnActionAn(tbl)
	log("my OnActionAn--")
	local cardData = {
		cards = {tbl.cid, tbl.cid, tbl.cid, tbl.cid},
		showType = CardShowType.ANGANG,
		otherId = 0
	}

	self.m_container[ContainerType.CHI]:AddCardGroup(cardData)
	self.m_container[ContainerType.HAND]:RemoveCardsEx(tbl.cid, 4)	--暗杠需要扣除四个手牌
end

function Player:OnActionJie(tbl)
	log("my OnActionJie--")
	local cardData = {
		cards = {tbl.cid, tbl.cid, tbl.cid, tbl.cid},
		showType = CardShowType.MINGGANG,
		otherId = tbl.fuserId
	}
	
	local target = PlayerMgr.Get(tbl.fuserId)
	if not target then
		util.LogError("没找到接杠的人--fuserId--"..tostring(tbl.fuserId))
	else
		target:GetContainer(ContainerType.PUT):RemoveCardsEx()
	end

	self.m_container[ContainerType.CHI]:AddCardGroup(cardData)
	self.m_container[ContainerType.HAND]:RemoveCardsEx(tbl.cid, 3)	--接杠需要扣除三个手牌
end

function Player:OnActionGong(tbl) 	--要把碰的牌去掉 改成杠牌
	log("my OnActionGong--")
	local cardData = {
		cards = {tbl.cid, tbl.cid, tbl.cid, tbl.cid},
		showType = CardShowType.MINGGANG,
		otherId = 0
	}

	self.m_container[ContainerType.CHI]:RemoveCardGroup(CardShowType.PENG, tbl.cid*3) 	--去掉原有碰的牌
	self.m_container[ContainerType.CHI]:AddCardGroup(cardData)
	self.m_container[ContainerType.HAND]:RemoveCardsEx(tbl.cid, 1)	--公杠需要扣除一个手牌
end

function Player:OnActionHu(tbl)
	log("my OnActionHu--")
	local target = PlayerMgr.Get(tbl.fuserId)
	if not target then
		util.LogError("没找到接杠的人--fuserId--"..tostring(tbl.fuserId))
		return
	end

	target:GetContainer(ContainerType.PUT):RemoveCardsEx()
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
	self.m_curChuCardItem = card
	self:OnSendAction(Operation.CHU.name, self.m_curChuCardItem:GetCard())
end

function Player:OnSendAction(aid, cid, cids)
	
	cids = cids or {}
	coroutine.start(function()
		local data = {}
		data.opt = aid
		if not cid then
			local selOpt = self:GetOperate(aid)
			data.cid = selOpt.cid
		else
			data.cid = cid
		end
		data.cids = cids

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

function Player:GetOperate(optType)
	log("optType -- "..optType)
	local curOpt = self:GetCurOpt()
	for i=1, #curOpt do
		log(" cur opt i -- "..curOpt[i].opt)
		if curOpt[i].opt == optType then
			return curOpt[i]
		end
	end
	return false
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

