-- TableCtrl.lua
-- Author : Dzq
-- Date : 2017-10-11
-- Last modification : 2017-10-11
-- Desc: 模块启动必须的Ctrl

TableCtrl = Class(BaseCtrl);

function TableCtrl:Ctor()
	self.m_id = "TableCtrl"
	self.m_panelName = "TablePanel"
	-- log("TableCtrl Ctor---->>>")

	self.playerList = {}
	self.m_roomInfo = false
	self.m_gameInfo = false
end

function TableCtrl:OnInit()
	-- logWarn("TableCtrl:OnInit")	

	self:AddEvent(Msg.PlayerInfoUpdate, self.UpdatePlayerInfo, self)
	self:AddEvent(Msg.RemovePlayer, self.OnPlayerLeave, self)
	self:AddEvent(Msg.RoomInfoUpdate, self.UpdateRoomInfo, self)
	self:AddEvent(Msg.GameInfoUpdate, self.UpdateGameInfo, self)
	self:AddEvent(Msg.ChangeState, self.OnChangeState, self)
	self:AddEvent(Msg.ActionMo, self.OnActionMo, self)
	self:AddEvent(Msg.ShowScore, self.OnShowScore, self)
end

function TableCtrl:LoadEnd()
	-- logWarn("TableCtrl:LoadEnd")
	self.m_panel:Open()
	local my = PlayerMgr.GetMyself()
	self.m_panel:SetPlayerInfo(my)
	self.playerList[#self.playerList+1] = my
end

function TableCtrl:AddPlayer(pInfo)
	if pInfo:IsMyself() then
		log("自己---")
	else
		self.m_panel:SetPlayerInfo(pInfo)
	end
	
end

function TableCtrl:OnExit()
	log("TableCtrl:OnExit ----- ")
	local protoId
	if PlayState.Ready == RoomMgr.curState then 	--准备阶段
		protoId = proto.fy_leave
	elseif PlayState.Playing == RoomMgr.curState then	--打牌阶段
		protoId = proto.fy_applyDepart
	end

    coroutine.start(function()
        local res = NetWork.Request(protoId)
        if res.code == 0 then
            logWarn("退出----")
        else
            UIMgr.Open(Common_Panel.TipsPanel, res.msg)
        end
    end)

end

function TableCtrl:UpdatePlayerInfo(player)
	self.m_panel:SetPlayerInfo(player)
end

function TableCtrl:OnPlayerLeave(player)
	self.m_panel:HidePlayer(player)
end

function TableCtrl:UpdateRoomInfo(roomInfo)
	self.m_roomInfo = roomInfo
	self.m_panel:SetRoomInfo(self.m_roomInfo)
	-- log("update room info -- "..cjson.encode(self.m_roomInfo))
end

function TableCtrl:UpdateGameInfo(gameInfo)
	self.m_gameInfo = gameInfo
	self.m_panel:SetGameInfo(self.m_gameInfo)
	-- log("update room info -- "..cjson.encode(self.m_roomInfo))
end

function TableCtrl:OnChangeState(tbl)
	-- logWarn("TableCtrl:OnChangeState-----"..tbl)
end

function TableCtrl:SetCardNum(num)
	self.m_roomInfo.lastCardNum = num
	self.m_panel:SetRoomInfo(self.m_roomInfo)
end

function TableCtrl:OnActionMo(player)
	local tableContainer = RoomMgr.GetTableContainer()
	tableContainer:HideCardByIdx(1)
	self:OnSubCardNum()
end

function TableCtrl:OnShowScore(player, score)
	self.m_panel:ShowScore(player, score)
end

function TableCtrl:OnSubCardNum()
	self.m_gameInfo.lastCardNum = self.m_gameInfo.lastCardNum - 1
	self.m_panel:SetGameInfo(self.m_gameInfo)
end
