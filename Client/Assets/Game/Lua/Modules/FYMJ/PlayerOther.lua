-- CtrlMgr.lua
-- Author : Dzq
-- Date : 2017-08-28
-- Last modification : 2017-08-28
-- Desc: 其他玩家类


PlayerOther = Class(BasePlayer);


function PlayerOther:Ctor()
	-- log('PlayerOther:Ctor ------ ') 
	--{"nick":"游客_8693","avatar":"","openId":"","userId":37594,"ip":"",
	--"rounds":0,"gold":0,"guestId":"6528942485568575383638898","diamond":100,
	--"identityNum":"","createtime":1508830235,"phone":"","gender":1,"parentId":0,
	--"token":"44d79cd88a8e4ce02735ff1a2ade8e69","fresh":0,"name":"",
	--"roomId":778721,"pos":""}
end

function PlayerOther:GetSit()
	local my = PlayerMgr.GetMyself()
	local res = self:GetDir() - my:GetDir()
	if  res < 0 then
		res = res + 4
	end
	return (res+1)
end

function PlayerOther:OnEnterRoom()
	log("OnEnterRoom-----"..self:GetName())
end

function PlayerOther:OnLeaveRoom()
	log("OnLeaveRoom---"..self:GetName())
end

function PlayerOther:OnReady(tbl)
	log("OnReady-----"..self:GetName())
end

function PlayerOther:OnLeave(tbl)
	log("OnLeave-----"..self:GetName())
end

function PlayerOther:OnOffline(tbl)
	self.m_info.bOnline = false
	log("OnOffline-----"..self:GetName())
end

function PlayerOther:OnOnLine(tbl)
	self.m_info.bOnline = true
	log("OnOnLine-----"..self:GetName())
end

function PlayerOther:OnAction(tbl)
	-- log("OnAction--name-"..self:GetName().." opt-"..tbl.opt)
end

function PlayerOther:OnActionChu(tbl)
	log(self:GetName().." OnActionChu--"..tbl.cid)
	self.m_container[ContainerType.PUT]:AddCard(tbl.cid)
	-- self.m_container[ContainerType.HAND]:RemoveCardsEx()
	--随机出一张
	self.m_container[ContainerType.HAND]:RemoveCardRandom()
end

function PlayerOther:OnActionMo(tbl)
	-- log(self:GetName().." OnActionMo--")
	self.m_container[ContainerType.HAND]:AddCard(tbl.cid)
end

function PlayerOther:OnActionChi(tbl)
	log(self:GetName().." OnActionChi--")
end

function PlayerOther:OnActionPeng(tbl)
	log(self:GetName().." OnActionPeng--")
	local cardData = {
		cards = {tbl.cid, tbl.cid, tbl.cid},
		showType = CardShowType.PENG,
		otherId = 1234
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

function PlayerOther:OnActionAn(tbl)
	log(self:GetName().." OnActionAn--")
	local cardData = {
		cards = {tbl.cid, tbl.cid, tbl.cid, tbl.cid},
		showType = CardShowType.ANGANG,
		otherId = 1234
	}

	self.m_container[ContainerType.CHI]:AddCardGroup(cardData)
	self.m_container[ContainerType.HAND]:RemoveCardsEx(tbl.cid, 4)	--暗杠需要扣除四个手牌
end

function PlayerOther:OnActionJie(tbl)
	log(self:GetName().." OnActionJie--")
	local cardData = {
		cards = {tbl.cid, tbl.cid, tbl.cid, tbl.cid},
		showType = CardShowType.MINGGANG,
		otherId = 1234
	}

	local target = PlayerMgr.Get(tbl.fuserId)
	if not target then
		util.LogError("没找到接杠的人--fuserId--"..tostring(tbl.fuserId))
	else
		target:GetContainer(ContainerType.PUT):RemoveCardsEx()
	end


	self.m_container[ContainerType.CHI]:AddCardGroup(cardData)
	self.m_container[ContainerType.HAND]:RemoveCardsEx(tbl.cid, 3)	--接杠需要扣除两个手牌
end

function PlayerOther:OnActionGong(tbl)	--要把碰的牌去掉 改成杠牌
	log(self:GetName().." OnActionGong--")
	local cardData = {
		cards = {tbl.cid, tbl.cid, tbl.cid, tbl.cid},
		showType = CardShowType.MINGGANG,
		otherId = 1234
	}

	self.m_container[ContainerType.CHI]:RemoveCardGroup(CardShowType.PENG, tbl.cid*3) 	--去掉原有碰的牌
	self.m_container[ContainerType.CHI]:AddCardGroup(cardData)
	self.m_container[ContainerType.HAND]:RemoveCardsEx(tbl.cid, 1)	--公杠需要扣除一个手牌
end

function PlayerOther:OnActionHu(tbl)
	log(self:GetName().." OnActionHu--")
	for k,v in pairs(tbl.score) do
		local p = PlayerMgr.Get(k)
		Event.Brocast(Msg.ShowScore, p, v)
	end
	-- target:GetContainer(ContainerType.PUT):RemoveCardsEx()
end

function PlayerOther:OnChat(tbl)
	log("OnChat-----"..self:GetName())
end

function PlayerOther:OnRespondDeaprt(tbl)
	log("OnRespondDeaprt-----"..self:GetName())
end

function PlayerOther:OnUpdate()
	-- log("OnUpdate-----"..self:GetName())
end

----初始化牌
function PlayerOther:OnInitCards()

end