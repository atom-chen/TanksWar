-- TableCtrl.lua
-- Author : Dzq
-- Date : 2017-10-11
-- Last modification : 2017-10-11
-- Desc: 模块启动必须的Ctrl

TableCtrl = Class(BaseCtrl);

function TableCtrl:Ctor()
	self.m_id = "TableCtrl"
	self.m_panelName = "TablePanel"
	log("TableCtrl Ctor---->>>")

	self.playerList = {}
	self.m_roomInfo = false
end

function TableCtrl:OnInit()
	logWarn("TableCtrl:OnInit")	

	self:AddEvent(Msg.PlayerInfoUpdate, self.UpdatePlayerInfo, self)
	self:AddEvent(Msg.RemovePlayer, self.OnPlayerLeave, self)
	self:AddEvent(Msg.RoomInfoUpdate, self.UpdateRoomInfo, self)
end

function TableCtrl:LoadEnd()
	logWarn("TableCtrl:LoadEnd")
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

function TableCtrl:StartPlay()
	self.m_panel:OnStartPlay()

	-- local my = PlayerMgr.GetMyself()
	-- local handContainer = my:GetContainer(ContainerType.HAND)
	-- handContainer:OnShowCards()

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
            log("退出----")
            RoomMgr.OnExitRoom()
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
	self.m_panel:SetRoomInfo(roomInfo)
	log("update room info -- "..cjson.encode(self.m_roomInfo))
end

function TableCtrl:OnSubCardNum()
	log("OnSubCardNum-- "..cjson.encode(self.m_roomInfo))
	self.m_roomInfo.lastCardNum = self.m_roomInfo.lastCardNum - 1
	self.m_panel:SetRoomInfo(self.m_roomInfo)
end
