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
	log("OnAction--name-"..self:GetName().." opt-"..tbl.opt)
end

function PlayerOther:OnActionChu(tbl)
	log(self:GetName().." OnActionChu--")
	self.m_container[ContainerType.PUT]:AddCard(tbl.cid)
	self.m_container[ContainerType.HAND]:RemoveCardsEx()
end

function PlayerOther:OnActionMo(tbl)
	log(self:GetName().." OnActionMo--")
	self.m_container[ContainerType.HAND]:AddCard(tbl.cid)
end

function PlayerOther:OnActionChi(tbl)
	log(self:GetName().." OnActionChi--")
end

function PlayerOther:OnActionPeng(tbl)
	log(self:GetName().." OnActionPeng--")
end

function PlayerOther:OnActionAn(tbl)
	log(self:GetName().." OnActionAn--")
end

function PlayerOther:OnActionJie(tbl)
	log(self:GetName().." OnActionJie--")
end

function PlayerOther:OnActionGong(tbl)
	log(self:GetName().." OnActionGong--")
end

function PlayerOther:OnChat(tbl)
	log("OnChat-----"..self:GetName())
end

function PlayerOther:OnRespondDeaprt(tbl)
	log("OnRespondDeaprt-----"..self:GetName())
end

function PlayerOther:OnUpdate()
	log("OnUpdate-----"..self:GetName())
end

----初始化牌
function PlayerOther:OnInitCards()

end